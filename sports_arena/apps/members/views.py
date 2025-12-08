from django.contrib import messages
from django.http import Http404
from django.shortcuts import get_object_or_404, redirect, render
from django.utils import timezone

from accounts.models import Member
from bookings.forms import MemberBookingForm
from bookings.models import Booking, Session_Enrollment, TrainingSession
from common.permissions import ROLE_MEMBER, role_required

from .forms import MemberProfileForm


def _get_profile(request) -> Member:
    try:
        return request.user.member
    except Member.DoesNotExist as exc:  # type: ignore[attr-defined]
        raise Http404("Your account is not linked to a member profile yet") from exc


@role_required(ROLE_MEMBER)
def dashboard(request):
    profile = _get_profile(request)
    bookings = profile.bookings.select_related("reservation__facility")[:5]
    enrollments = (
        profile.session_enrollments.select_related("training_session__reservation__facility", "training_session__coach")
        .order_by("training_session__reservation__start_time")[:5]
    )
    return render(
        request,
        "members/dashboard.html",
        {"profile": profile, "bookings": bookings, "enrollments": enrollments},
    )


@role_required(ROLE_MEMBER)
def profile_view(request):
    profile = _get_profile(request)
    if request.method == "POST":
        form = MemberProfileForm(request.POST, instance=profile)
        if form.is_valid():
            form.save()
            messages.success(request, "Profile updated successfully.")
            return redirect("members:profile")
    else:
        form = MemberProfileForm(instance=profile)
    return render(request, "members/profile_form.html", {"form": form, "profile": profile})


@role_required(ROLE_MEMBER)
def booking_list(request):
    profile = _get_profile(request)
    bookings = profile.bookings.select_related("reservation__facility")
    return render(request, "members/booking_list.html", {"bookings": bookings})


@role_required(ROLE_MEMBER)
def booking_create(request):
    profile = _get_profile(request)
    if request.method == "POST":
        form = MemberBookingForm(profile, request.POST)
        if form.is_valid():
            booking = form.save(commit=False)
            booking.member = profile
            booking.booking_status = "Pending"
            
            # Manually set reservation fields from form cleaned_data
            # because BookingForm doesn't save them to the parent Reservation instance automatically
            booking.facility = form.cleaned_data['facility']
            booking.reservation_date = form.cleaned_data['reservation_date']
            booking.start_time = form.cleaned_data['start_time']
            booking.end_time = form.cleaned_data['end_time']
            
            booking.save()
            messages.success(request, "Booking submitted successfully. Please wait for confirmation.")
            return redirect("members:bookings")
    else:
        form = MemberBookingForm(profile)
    return render(request, "members/booking_form.html", {"form": form})


@role_required(ROLE_MEMBER)
def booking_cancel(request, booking_id: int):
    profile = _get_profile(request)
    # Booking PK is reservation_id
    booking = get_object_or_404(Booking, pk=booking_id, member=profile)
    booking.booking_status = "Cancelled"
    booking.save(update_fields=["booking_status"])
    messages.info(request, "Booking cancelled.")
    return redirect("members:bookings")


@role_required(ROLE_MEMBER)
def training_list(request):
    profile = _get_profile(request)
    # Filter sessions starting from now
    # TrainingSession inherits from Reservation, so we query via reservation fields
    sessions = TrainingSession.objects.select_related("coach", "reservation__facility").filter(
        reservation__start_time__gte=timezone.now().time(),
        reservation__reservation_date__gte=timezone.now().date()
    )
    
    # Get existing enrollment session IDs
    existing_ids = set(
        profile.session_enrollments.values_list("training_session_id", flat=True)
    )
    return render(
        request,
        "members/training_list.html",
        {"sessions": sessions, "existing_ids": existing_ids},
    )


@role_required(ROLE_MEMBER)
def training_enroll(request, session_id: int):
    profile = _get_profile(request)
    session = get_object_or_404(TrainingSession, pk=session_id)
    
    # Check if already enrolled
    if Session_Enrollment.objects.filter(training_session=session, member=profile).exists():
        messages.warning(request, "You have already enrolled in this session.")
    else:
        Session_Enrollment.objects.create(training_session=session, member=profile)
        messages.success(request, "Enrollment confirmed.")
        
    return redirect("members:trainings")


@role_required(ROLE_MEMBER)
def training_drop(request, session_id: int):
    profile = _get_profile(request)
    enrollment = get_object_or_404(
        Session_Enrollment, training_session_id=session_id, member=profile
    )
    enrollment.delete() 
    
    messages.info(request, "Enrollment dropped.")
    return redirect("members:enrollments")


@role_required(ROLE_MEMBER)
def enrollment_list(request):
    profile = _get_profile(request)
    enrollments = (
        profile.session_enrollments.select_related("training_session__reservation__facility", "training_session__coach")
    )
    return render(request, "members/enrollment_list.html", {"enrollments": enrollments})
