import uuid

from django.contrib import messages
from django.contrib.auth import views as auth_views
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.auth.models import Group
from django.shortcuts import redirect, render
from django.urls import reverse_lazy
from django.views import View

from common.permissions import (
    ROLE_BOOKING_OFFICER,
    ROLE_COACH,
    ROLE_DBA,
    ROLE_MANAGER,
    ROLE_MEMBER,
)

from .forms import UserRegistrationForm


def _assign_role(user, role_name: str) -> None:
    group, _ = Group.objects.get_or_create(name=role_name)
    user.groups.add(group)


def _generate_identifier(prefix: str) -> str:
    return f"{prefix}{uuid.uuid4().hex[:6].upper()}"


class RegisterView(View):
    template_name = "accounts/register.html"

    def get(self, request):
        form = UserRegistrationForm()
        return render(request, self.template_name, {"form": form})

    def post(self, request):
        form = UserRegistrationForm(request.POST)
        if form.is_valid():
            user = form.save()
            role = form.cleaned_data.get("role")
            phone = form.cleaned_data.get("phone")
            specialization = form.cleaned_data.get("specialization")
            
            from django.utils import timezone
            from .models import (
                Coach,
                Coach_Email,
                Coach_Phone,
                Member,
                Member_Email,
                Member_Phone,
                Staff,
                Student,
            )

            if role == "coach":
                _assign_role(user, ROLE_COACH)
                # Create new Coach model
                coach = Coach.objects.create(
                    user=user,
                    first_name=user.first_name,
                    last_name=user.last_name,
                    sport_type=specialization or "General",
                    level="Junior" # Default level
                )
                if phone:
                    Coach_Phone.objects.create(coach=coach, phone_number=phone)
                if user.email:
                    Coach_Email.objects.create(coach=coach, email_address=user.email)
                    
                messages.success(request, "Coach account created successfully. Please wait for the administrator to assign courses.")
            else:
                # Both Student and Staff are Members
                _assign_role(user, ROLE_MEMBER)
                
                # Create new Member model (Superclass)
                member = Member.objects.create(
                    user=user,
                    first_name=user.first_name,
                    last_name=user.last_name,
                    registration_date=timezone.now().date(),
                    membership_status="Active"
                )
                
                # Create Subclass based on role
                if role == "student":
                    Student.objects.create(member=member, student_id=_generate_identifier("S"))
                elif role == "staff":
                    Staff.objects.create(member=member, staff_id=_generate_identifier("ST"))
                
                if phone:
                    Member_Phone.objects.create(member=member, phone_number=phone)
                if user.email:
                    Member_Email.objects.create(member=member, email_address=user.email)
                    
                messages.success(request, f"{role.capitalize()} account registered successfully.")
            return redirect("accounts:login")
        return render(request, self.template_name, {"form": form})


class CustomLoginView(auth_views.LoginView):
    template_name = "accounts/login.html"


class CustomLogoutView(auth_views.LogoutView):
    next_page = reverse_lazy("accounts:login")


class DashboardRedirectView(LoginRequiredMixin, View):
    """Redirect to the corresponding portal based on the role."""

    def get(self, request):
        user = request.user
        if user.is_superuser or user.groups.filter(name=ROLE_DBA).exists():
            return redirect("admin:index")
        if user.groups.filter(name=ROLE_MANAGER).exists():
            return redirect("management:dashboard")
        if user.groups.filter(name=ROLE_BOOKING_OFFICER).exists():
            return redirect("bookings:bo_dashboard")
        if user.groups.filter(name=ROLE_COACH).exists():
            return redirect("coaches:dashboard")
        if user.groups.filter(name=ROLE_MEMBER).exists():
            return redirect("members:dashboard")
        messages.info(request, "The current account has not been assigned a role. Please contact the administrator.")
        return redirect("accounts:login")
