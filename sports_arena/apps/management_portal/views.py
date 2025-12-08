import json
from urllib import error, request as urlrequest

from django.conf import settings
from django.contrib import messages
from django.db.models import Count
from django.shortcuts import get_object_or_404, redirect, render

from bookings.forms import TrainingSessionForm
from bookings.models import Reservation
from common.permissions import ROLE_MANAGER, role_required

from .forms import (
    EquipmentForm,
    FacilityForm,
    MaintenanceForm,
    VisitorApplicationForm,
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
def equipment_edit(request, pk: int):
    equipment = get_object_or_404(Equipment, pk=pk)
    if request.method == "POST":
        form = EquipmentForm(request.POST, instance=equipment)
        if form.is_valid():
            form.save()
            messages.success(request, "Equipment updated successfully.")
            return redirect("management:equipments")
    else:
        form = EquipmentForm(instance=equipment)
    return render(request, "management/equipment_form.html", {"form": form, "equipment": equipment})


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
def maintenance_update_status(request, pk: int):
    """Update maintenance status via POST. Handle completion_date logic."""
    from datetime import date
    
    if request.method != "POST":
        return redirect("management:maintenance")
    
    maintenance = get_object_or_404(Maintenance, pk=pk)
    new_status = request.POST.get("status")
    valid_statuses = ["In_Progress", "Completed", "Cancelled"]
    
    if new_status not in valid_statuses:
        messages.error(request, "Invalid status value.")
        return redirect("management:maintenance")
    
    old_status = maintenance.status
    maintenance.status = new_status
    
    # Handle completion_date logic
    if new_status == "Completed":
        maintenance.completion_date = date.today()
    elif old_status == "Completed" and new_status != "Completed":
        maintenance.completion_date = None
    
    maintenance.save()
    messages.success(request, f"Maintenance status updated to {maintenance.get_status_display()}.")
    return redirect("management:maintenance")


@role_required(ROLE_MANAGER)
def visitor_list(request):
    applications = Visitor_Application.objects.all()
    return render(request, "management/visitor_list.html", {"applications": applications})


@role_required(ROLE_MANAGER)
def visitor_review(request, pk: int):
    application = get_object_or_404(Visitor_Application, pk=pk)
    if request.method == "POST":
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


def _build_db_context() -> dict:
    """Prepare a small, read-only snapshot for the LLM prompt."""
    facility_status = (
        Facility.objects.values("status").annotate(total=Count("facility_id")).order_by("status")
    )
    equipment_status = (
        Equipment.objects.values("status").annotate(total=Count("equipment_id")).order_by("status")
    )
    recent_reservations = (
        Reservation.objects.select_related("facility")
        .order_by("-reservation_date", "-start_time")[:5]
    )
    return {
        "facility_status": list(facility_status),
        "equipment_status": list(equipment_status),
        "maintenance_open": Maintenance.objects.filter(status__in=["Scheduled", "In_Progress"]).count(),
        "pending_visitors": Visitor_Application.objects.filter(status="Pending").count(),
        "recent_reservations": [
            {
                "facility": r.facility.facility_name,
                "date": r.reservation_date.isoformat(),
                "start": r.start_time.isoformat(),
                "end": r.end_time.isoformat(),
            }
            for r in recent_reservations
        ],
    }


@role_required(ROLE_MANAGER)
def llm_query(request):
    """Lightweight LLM ask page for managers only."""
    question = ""
    answer = None
    error_message = None
    base_url = settings.LLM_BASE_URL
    api_key = settings.LLM_API_KEY
    model = settings.LLM_MODEL
    include_db = False
    db_context = None

    if request.method == "POST":
        question = request.POST.get("question", "").strip()
        include_db = bool(request.POST.get("include_db"))
        if not base_url or not api_key or not model:
            error_message = "Please provide the complete configuration."
        elif not question:
            error_message = "Please enter a question."
        else:
            messages_payload = [{"role": "system", "content": "You are a helpful assistant for the sports arena system."}]
            if include_db:
                db_context = _build_db_context()
                messages_payload.append(
                    {
                        "role": "system",
                        "content": (
                            "You are a fact-based data assistant. Answer strictly using the provided database snapshot. "
                            "If the answer is not in the data, say: 'The information is not available in the provided data.' "
                            "Format concise bullet points when listing multiple items. "
                            "Always answer in English."
                            f"Database snapshot (read-only): {json.dumps(db_context, ensure_ascii=False)}"
                        ),
                    }
                )
            messages_payload.append({"role": "user", "content": question})

            payload_dict = {"model": model, "messages": messages_payload}
            payload = json.dumps(payload_dict).encode("utf-8")
            headers = {
                "Content-Type": "application/json",
                "Authorization": f"Bearer {api_key}",
            }
            try:
                req = urlrequest.Request(base_url, data=payload, headers=headers, method="POST")
                with urlrequest.urlopen(req, timeout=15) as resp:
                    body = resp.read()
                try:
                    data = json.loads(body)
                    answer = data['choices'][0]['message']['content']
                except json.JSONDecodeError:
                    answer = body.decode("utf-8", errors="ignore")
            except (error.HTTPError, error.URLError, TimeoutError, OSError) as exc:
                error_message = f"LLM request failed: {exc}"

    context = {
        "question": question,
        "answer": answer,
        "error_message": error_message,
        "configured": bool(base_url and api_key),
        "llm_model": model,
        "include_db": include_db,
        "db_context": db_context,
    }
    return render(request, "management/llm_query.html", context)


@role_required(ROLE_MANAGER)
def training_session_create(request):
    """Create a new training session (Reservation + TrainingSession)."""
    if request.method == "POST":
        form = TrainingSessionForm(request.POST)
        if form.is_valid():
            reservation = Reservation.objects.create(
                facility=form.cleaned_data["facility"],
                reservation_date=form.cleaned_data["reservation_date"],
                start_time=form.cleaned_data["start_time"],
                end_time=form.cleaned_data["end_time"],
            )
            session = form.save(commit=False)
            session.reservation = reservation
            session.save()
            messages.success(request, "Training session created successfully.")
            return redirect("bookings:reservation_list")
    else:
        form = TrainingSessionForm()
    return render(request, "management/training_session_form.html", {"form": form})
