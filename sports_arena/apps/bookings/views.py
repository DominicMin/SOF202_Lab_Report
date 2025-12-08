from django.contrib import messages
from django.shortcuts import get_object_or_404, redirect, render

from accounts.models import Member
from common.permissions import ROLE_BOOKING_OFFICER, ROLE_MANAGER, role_required
from management_portal.models import Visitor_Application

from .forms import OfficerBookingForm, ReservationEquipmentForm
from .models import Booking, Reservation, Reservation_Equipments


@role_required(ROLE_BOOKING_OFFICER, ROLE_MANAGER)
def bo_dashboard(request):
    recent_bookings = (
        Booking.objects.select_related("member", "reservation__facility")
        .order_by("-reservation__reservation_id")[:5]
    )
    # Recent reservations (could be bookings or training sessions)
    recent_reservations = Reservation.objects.select_related("facility").order_by("-reservation_id")[:5]
    member_count = Member.objects.count()
    pending_visitors = Visitor_Application.objects.filter(status="Pending").order_by("application_date")[:5]
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
    bookings = Booking.objects.select_related("member", "reservation__facility")
    if status:
        bookings = bookings.filter(booking_status=status)
    return render(request, "bookings/booking_list.html", {"bookings": bookings, "status": status})


@role_required(ROLE_BOOKING_OFFICER, ROLE_MANAGER)
def booking_create(request):
    if request.method == "POST":
        form = OfficerBookingForm(request.POST)
        if form.is_valid():
            reservation = Reservation.objects.create(
                facility=form.cleaned_data["facility"],
                reservation_date=form.cleaned_data["reservation_date"],
                start_time=form.cleaned_data["start_time"],
                end_time=form.cleaned_data["end_time"],
            )
            booking = form.save(commit=False)
            booking.reservation = reservation
            # Officers create confirmed bookings directly
            booking.booking_status = "Confirmed"
            booking.save()
            messages.success(request, f"Created a booking for {booking.member}.")
            return redirect("bookings:booking_list")
    else:
        form = OfficerBookingForm()
    return render(request, "bookings/booking_form.html", {"form": form})


@role_required(ROLE_BOOKING_OFFICER, ROLE_MANAGER)
def reservation_list(request):
    # List all reservations (Bookings + TrainingSessions)
    reservations = Reservation.objects.select_related("facility").order_by("-reservation_date", "-start_time")
    return render(request, "bookings/reservation_list.html", {"reservations": reservations})


@role_required(ROLE_BOOKING_OFFICER, ROLE_MANAGER)
def reservation_create(request, booking_id: int):
    # This view is now "Manage Booking" - add equipment or change status
    # We keep the name reservation_create for URL compatibility or rename it?
    # The URL is bookings/<id>/reservation/. 
    # Let's repurpose it to "Process Booking"
    booking = get_object_or_404(Booking, pk=booking_id)
    
    if request.method == "POST":
        # Handle equipment addition or status change
        if "add_equipment" in request.POST:
            eq_form = ReservationEquipmentForm(booking.reservation, request.POST)
            if eq_form.is_valid():
                eq_form.save()
                messages.success(request, "Equipment added to booking.")
                return redirect("bookings:reservation_create", booking_id=booking.pk)
        elif "confirm_booking" in request.POST:
            booking.booking_status = "Confirmed"
            booking.save(update_fields=["booking_status"])
            messages.success(request, "Booking confirmed.")
            return redirect("bookings:booking_list")
        elif "reject_booking" in request.POST:
            booking.booking_status = "Cancelled" # Or Rejected
            booking.save(update_fields=["booking_status"])
            messages.success(request, "Booking rejected/cancelled.")
            return redirect("bookings:booking_list")
            
    else:
        eq_form = ReservationEquipmentForm(booking.reservation)
        
    context = {
        "booking": booking,
        "eq_form": eq_form,
        "existing_equipment": booking.reservation.equipment_reservations.all()
    }
    return render(request, "bookings/reservation_form.html", context)
