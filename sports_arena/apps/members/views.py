from django.contrib import messages
from django.http import Http404
from django.shortcuts import get_object_or_404, redirect, render
from django.utils import timezone

from accounts.models import MemberProfile
from bookings.forms import BookingForm
from bookings.models import Booking, SessionEnrollment, TrainingSession
from common.permissions import ROLE_MEMBER, role_required

from .forms import MemberProfileForm


def _get_profile(request) -> MemberProfile:
    try:
        return request.user.member_profile
    except MemberProfile.DoesNotExist as exc:  # type: ignore[attr-defined]
        messages.error(request, "Your account is not linked to a member profile yet.")
        raise Http404 from exc


@role_required(ROLE_MEMBER)
def dashboard(request):
    profile = _get_profile(request)
    bookings = profile.bookings.select_related("facility")[:5]
    enrollments = (
        profile.enrollments.select_related("session")
        .order_by("session__start_time")[:5]
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
    bookings = profile.bookings.select_related("facility")
    return render(request, "members/booking_list.html", {"bookings": bookings})


@role_required(ROLE_MEMBER)
def booking_create(request):
    profile = _get_profile(request)
    if request.method == "POST":
        form = BookingForm(request.POST)
        if form.is_valid():
            booking = form.save(commit=False)
            booking.member = profile
            booking.status = "pending"
            booking.save()
            messages.success(request, "Booking submitted successfully. Please wait for confirmation.")
            return redirect("members:bookings")
    else:
        form = BookingForm()
    return render(request, "members/booking_form.html", {"form": form})


@role_required(ROLE_MEMBER)
def booking_cancel(request, booking_id: int):
    profile = _get_profile(request)
    booking = get_object_or_404(Booking, pk=booking_id, member=profile)
    booking.status = "cancelled"
    booking.save(update_fields=["status"])
    messages.info(request, "Booking cancelled.")
    return redirect("members:bookings")


@role_required(ROLE_MEMBER)
def training_list(request):
    profile = _get_profile(request)
    sessions = TrainingSession.objects.select_related("coach", "facility").filter(
        start_time__gte=timezone.now()
    )
    existing_ids = set(
        profile.enrollments.filter(status="confirmed").values_list("session_id", flat=True)
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
    enrollment, created = SessionEnrollment.objects.get_or_create(
        session=session, member=profile
    )
    if not created and enrollment.status == "confirmed":
        messages.warning(request, "You have already enrolled in this session.")
    else:
        enrollment.status = "confirmed"
        enrollment.save()
        messages.success(request, "Enrollment confirmed.")
    return redirect("members:trainings")


@role_required(ROLE_MEMBER)
def training_drop(request, session_id: int):
    profile = _get_profile(request)
    enrollment = get_object_or_404(
        SessionEnrollment, session_id=session_id, member=profile
    )
    enrollment.status = "cancelled"
    enrollment.save(update_fields=["status"])
    messages.info(request, "Enrollment dropped.")
    return redirect("members:enrollments")


@role_required(ROLE_MEMBER)
def enrollment_list(request):
    enrollments = (
        _get_profile(request)
        .enrollments.select_related("session", "session__coach")
        .order_by("-enrolled_at")
    )
    return render(request, "members/enrollment_list.html", {"enrollments": enrollments})
