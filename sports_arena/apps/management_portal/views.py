from django.contrib import messages
from django.shortcuts import get_object_or_404, redirect, render
from django.utils import timezone

from common.permissions import ROLE_MANAGER, role_required

from .forms import (
    EquipmentForm,
    FacilityForm,
    MaintenanceForm,
    VisitorApplicationForm,
    VisitorDecisionForm,
)
from .models import Equipment, Facility, Maintenance, Visitor_Application
from .services import approve_visitor_application, reject_visitor_application


@role_required(ROLE_MANAGER)
def dashboard(request):
    context = {
        "facility_count": Facility.objects.count(),
        "equipment_count": Equipment.objects.count(),
        "maintenance_open": Maintenance.objects.filter(status__in=["Scheduled", "In_Progress"]).count(),
        "pending_visitors": Visitor_Application.objects.filter(status="Pending").count(),
    }
    return render(request, "management/dashboard.html", context)


@role_required(ROLE_MANAGER)
def facility_list(request):
    facilities = Facility.objects.all()
    return render(request, "management/facility_list.html", {"facilities": facilities})


@role_required(ROLE_MANAGER)
def facility_create(request):
    if request.method == "POST":
        form = FacilityForm(request.POST)
        if form.is_valid():
            form.save()
            messages.success(request, "Facility created successfully.")
            return redirect("management:facilities")
    else:
        form = FacilityForm()
    return render(request, "management/facility_form.html", {"form": form})


@role_required(ROLE_MANAGER)
def facility_edit(request, pk: int):
    facility = get_object_or_404(Facility, pk=pk)
    if request.method == "POST":
        form = FacilityForm(request.POST, instance=facility)
        if form.is_valid():
            form.save()
            messages.success(request, "Facility updated successfully.")
            return redirect("management:facilities")
    else:
        form = FacilityForm(instance=facility)
    return render(request, "management/facility_form.html", {"form": form, "facility": facility})


@role_required(ROLE_MANAGER)
def equipment_list(request):
    # New Equipment model doesn't have facility FK (equipment is independent)
    equipments = Equipment.objects.all()
    return render(request, "management/equipment_list.html", {"equipments": equipments})


@role_required(ROLE_MANAGER)
def equipment_create(request):
    if request.method == "POST":
        form = EquipmentForm(request.POST)
        if form.is_valid():
            form.save()
            messages.success(request, "Equipment created successfully.")
            return redirect("management:equipments")
    else:
        form = EquipmentForm()
    return render(request, "management/equipment_form.html", {"form": form})


@role_required(ROLE_MANAGER)
def maintenance_list(request):
    # Maintenance can be for facility OR equipment (XOR constraint)
    records = Maintenance.objects.select_related("facility", "equipment")
    return render(request, "management/maintenance_list.html", {"records": records})


@role_required(ROLE_MANAGER)
def maintenance_create(request):
    if request.method == "POST":
        form = MaintenanceForm(request.POST)
        if form.is_valid():
            form.save()
            messages.success(request, "Maintenance record created.")
            return redirect("management:maintenance")
    else:
        form = MaintenanceForm()
    return render(request, "management/maintenance_form.html", {"form": form})


@role_required(ROLE_MANAGER)
def visitor_list(request):
    applications = Visitor_Application.objects.all()
    return render(request, "management/visitor_list.html", {"applications": applications})


@role_required(ROLE_MANAGER)
def visitor_review(request, pk: int):
    application = get_object_or_404(Visitor_Application, pk=pk)
    if request.method == "POST":
        # Using VisitorDecisionForm but we need to adapt it or just handle logic here
        # Since VisitorDecisionForm is bound to legacy model, let's just get status/notes from POST
        status = request.POST.get("status")
        notes = request.POST.get("notes")
        
        if status == "Approved":
            try:
                # Assuming current user is a Staff member
                staff_member = request.user.member.staff_profile
                approve_visitor_application(application, staff_member)
                messages.success(request, "Visitor application approved and member account created.")
            except Exception as e:
                messages.error(request, f"Error approving application: {str(e)}")
                return redirect("management:visitor_review", pk=pk)
        elif status == "Rejected":
            try:
                staff_member = request.user.member.staff_profile
                reject_visitor_application(application, staff_member, notes)
                messages.success(request, "Visitor application rejected.")
            except Exception as e:
                messages.error(request, f"Error rejecting application: {str(e)}")
                return redirect("management:visitor_review", pk=pk)
        
        return redirect("management:applications")
    
    return render(
        request,
        "management/visitor_review.html",
        {"application": application},
    )


def visitor_apply(request):
    if request.method == "POST":
        form = VisitorApplicationForm(request.POST)
        if form.is_valid():
            app = form.save(commit=False)
            # Handle multi-valued attributes if needed, or just save basic info first
            app.save()
            
            # Save phone/emails if form handles them (it has fields but not model logic yet)
            # For now, let's assume basic save works
            
            messages.success(request, "Your visitor application has been submitted.")
            return redirect("home")
    else:
        form = VisitorApplicationForm()
    return render(request, "management/visitor_apply.html", {"form": form})

