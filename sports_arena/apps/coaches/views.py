from django.contrib import messages
from django.http import Http404
from django.shortcuts import get_object_or_404, redirect, render

from accounts.models import Coach
from bookings.models import Session_Enrollment, TrainingSession
from common.permissions import ROLE_COACH, ROLE_MANAGER, role_required
from management_portal.models import Visitor_Application

from .forms import CoachProfileForm


def _get_coach_profile(request) -> Coach:
    try:
        return request.user.coach
    except Coach.DoesNotExist as exc:  # type: ignore[attr-defined]
        raise Http404("Your account is not linked to a coach profile yet") from exc

@role_required(ROLE_COACH, ROLE_MANAGER)
def dashboard(request):
    profile = _get_coach_profile(request)
    sessions = TrainingSession.objects.filter(coach=profile).select_related("reservation__facility")
    visitor_applications = Visitor_Application.objects.order_by("-application_date")[:5]
    return render(
        request,
        "coaches/dashboard.html",
        {
            "profile": profile,
            "sessions": sessions,
            "visitor_applications": visitor_applications,
        },
    )


@role_required(ROLE_COACH, ROLE_MANAGER)
def profile_view(request):
    profile = _get_coach_profile(request)
    if request.method == "POST":
        form = CoachProfileForm(request.POST, instance=profile)
        if form.is_valid():
            form.save()
            messages.success(request, "Profile updated successfully.")
            return redirect("coaches:profile")
    else:
        form = CoachProfileForm(instance=profile)
    return render(request, "coaches/profile_form.html", {"form": form})


@role_required(ROLE_COACH, ROLE_MANAGER)
def sessions(request):
    session_list = TrainingSession.objects.filter(coach=_get_coach_profile(request)).select_related("reservation__facility")
    return render(request, "coaches/session_list.html", {"sessions": session_list})


@role_required(ROLE_COACH, ROLE_MANAGER)
def session_detail(request, session_id: int):
    profile = _get_coach_profile(request)
    # Filter by coach to ensure they own the session
    session = get_object_or_404(
        TrainingSession, pk=session_id, coach=profile
    )
    enrollments = Session_Enrollment.objects.filter(training_session=session).select_related("member")
    
    # Note: Session notes functionality removed as per new schema
    
    return render(
        request,
        "coaches/session_detail.html",
        {"session": session, "enrollments": enrollments},
    )


@role_required(ROLE_COACH, ROLE_MANAGER)
def visitor_applications(request):
    applications = Visitor_Application.objects.all().order_by("-application_date")
    return render(
        request,
        "coaches/visitor_applications.html",
        {"applications": applications},
    )


@role_required(ROLE_COACH, ROLE_MANAGER)
def visitor_application_detail(request, application_id: int):
    application = get_object_or_404(
        Visitor_Application.objects.prefetch_related("phone_numbers", "email_addresses"),
        pk=application_id,
    )
    return render(
        request,
        "coaches/visitor_application_detail.html",
        {"application": application},
    )
