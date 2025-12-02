from django import forms

from .models import Equipment, Facility, Maintenance, VisitorApplication


class BaseStyledModelForm(forms.ModelForm):
    """Apply Bootstrap form-control styling to each field."""

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        for field in self.fields.values():
            existing = field.widget.attrs.get("class", "")
            field.widget.attrs["class"] = f"{existing} form-control".strip()


class FacilityForm(BaseStyledModelForm):
    class Meta:
        model = Facility
        fields = ("name", "location", "capacity", "status", "description")


class EquipmentForm(BaseStyledModelForm):
    class Meta:
        model = Equipment
        fields = ("name", "facility", "quantity", "status")


class MaintenanceForm(BaseStyledModelForm):
    class Meta:
        model = Maintenance
        fields = ("facility", "description", "scheduled_date", "status")
        widgets = {"scheduled_date": forms.DateInput(attrs={"type": "date"})}


class VisitorApplicationForm(BaseStyledModelForm):
    class Meta:
        model = VisitorApplication
        fields = ("full_name", "organization", "contact", "visit_date", "reason")
        widgets = {
            "visit_date": forms.DateInput(attrs={"type": "date"}),
            "reason": forms.Textarea(attrs={"rows": 4}),
        }


class VisitorDecisionForm(BaseStyledModelForm):
    class Meta:
        model = VisitorApplication
        fields = ("status", "notes")
