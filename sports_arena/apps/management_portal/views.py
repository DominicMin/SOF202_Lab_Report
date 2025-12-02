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
from .models import Equipment, Facility, Maintenance, VisitorApplication, ExternalVisitor


@role_required(ROLE_MANAGER)
def dashboard(request):
    context = {
        "facility_count": Facility.objects.count(),
        "equipment_count": Equipment.objects.count(),
        "maintenance_open": Maintenance.objects.filter(status__in=["scheduled", "in_progress"]).count(),
        "pending_visitors": VisitorApplication.objects.filter(status="pending").count(),
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
    equipments = Equipment.objects.select_related("facility")
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
    records = Maintenance.objects.select_related("facility")
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
    applications = VisitorApplication.objects.all()
    return render(request, "management/visitor_list.html", {"applications": applications})


@role_required(ROLE_MANAGER)
def visitor_review(request, pk: int):
    application = get_object_or_404(VisitorApplication, pk=pk)
    if request.method == "POST":
        form = VisitorDecisionForm(request.POST, instance=application)
        if form.is_valid():
            app = form.save(commit=False)
            app.reviewed_by = request.user
            app.reviewed_at = timezone.now()
            app.save()
            if app.status == "approved" and not hasattr(app, "external_visitor"):
                ExternalVisitor.objects.create(
                    application=app,
                    temp_member_id=f"EV{app.pk:05d}",
                    email=f"visitor{app.pk}@example.com",
                )
            messages.success(request, "Visitor application updated.")
            return redirect("management:applications")
    else:
        form = VisitorDecisionForm(instance=application)
    return render(
        request,
        "management/visitor_review.html",
        {"form": form, "application": application},
    )


def visitor_apply(request):
    if request.method == "POST":
        form = VisitorApplicationForm(request.POST)
        if form.is_valid():
            form.save()
            messages.success(request, "Your visitor application has been submitted.")
            return redirect("home")
    else:
        form = VisitorApplicationForm()
    return render(request, "management/visitor_apply.html", {"form": form})
