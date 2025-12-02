from django.contrib import messages
from django.shortcuts import get_object_or_404, redirect, render

from accounts.models import MemberProfile
from common.permissions import ROLE_BOOKING_OFFICER, ROLE_MANAGER, role_required
from management_portal.models import VisitorApplication

from .forms import OfficerBookingForm, ReservationEquipmentForm, ReservationForm
from .models import Booking, Reservation


@role_required(ROLE_BOOKING_OFFICER, ROLE_MANAGER)
def bo_dashboard(request):
    recent_bookings = (
        Booking.objects.select_related("member", "facility")
        .order_by("-created_at")[:5]
    )
    recent_reservations = Reservation.objects.select_related("facility", "booking").order_by("-id")[:5]
    member_count = MemberProfile.objects.count()
    pending_visitors = VisitorApplication.objects.filter(status="pending").order_by("visit_date")[:5]
    context = {
        "recent_bookings": recent_bookings,
        "recent_reservations": recent_reservations,
        "member_count": member_count,
        "pending_visitors": pending_visitors,
    }
    return render(request, "bookings/bo_dashboard.html", context)


@role_required(ROLE_BOOKING_OFFICER, ROLE_MANAGER)
def booking_list(request):
    status = request.GET.get("status")
    bookings = Booking.objects.select_related("member", "facility")
    if status:
        bookings = bookings.filter(status=status)
    return render(request, "bookings/booking_list.html", {"bookings": bookings, "status": status})


@role_required(ROLE_BOOKING_OFFICER, ROLE_MANAGER)
def booking_create(request):
    if request.method == "POST":
        form = OfficerBookingForm(request.POST)
        if form.is_valid():
            booking = form.save()
            messages.success(request, f"Created a booking for {booking.member}.")
            return redirect("bookings:booking_list")
    else:
        form = OfficerBookingForm()
    return render(request, "bookings/booking_form.html", {"form": form})


@role_required(ROLE_BOOKING_OFFICER, ROLE_MANAGER)
def reservation_list(request):
    reservations = Reservation.objects.select_related("booking", "facility")
    return render(request, "bookings/reservation_list.html", {"reservations": reservations})


@role_required(ROLE_BOOKING_OFFICER, ROLE_MANAGER)
def reservation_create(request, booking_id: int):
    booking = get_object_or_404(Booking, pk=booking_id)
    if request.method == "POST":
        form = ReservationForm(request.POST)
        eq_form = ReservationEquipmentForm(request.POST)
        if form.is_valid() and eq_form.is_valid():
            reservation = form.save(commit=False)
            reservation.booking = booking
            reservation.assigned_officer = request.user
            reservation.save()
            equipment = eq_form.save(commit=False)
            equipment.reservation = reservation
            equipment.save()
            booking.status = "approved"
            booking.save(update_fields=["status"])
            messages.success(request, "Booking converted to reservation.")
            return redirect("bookings:reservation_list")
    else:
        form = ReservationForm(initial={
            "facility": booking.facility,
            "start_time": booking.requested_start,
            "end_time": booking.requested_end,
        })
        eq_form = ReservationEquipmentForm()
    context = {"form": form, "eq_form": eq_form, "booking": booking}
    return render(request, "bookings/reservation_form.html", context)
