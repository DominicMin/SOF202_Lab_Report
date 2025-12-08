from django import forms

from .models import Equipment, Facility, Maintenance, Visitor_Application


class BaseStyledModelForm(forms.ModelForm):
    """Apply Bootstrap form-control styling to each field."""

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        for field in self.fields.values():
            existing = field.widget.attrs.get("class", "")
            field.widget.attrs["class"] = f"{existing} form-control".strip()


class FacilityForm(BaseStyledModelForm):
    """Form for new Facility model."""
    class Meta:
        model = Facility
        fields = ("facility_name", "type", "building", "floor", "room_number", "capacity", "status")


class EquipmentForm(BaseStyledModelForm):
    """Form for new Equipment model."""
    class Meta:
        model = Equipment
        fields = ("equipment_name", "type", "total_quantity", "status")


class MaintenanceForm(BaseStyledModelForm):
    """Form for new Maintenance model."""
    class Meta:
        model = Maintenance
        fields = ("facility", "equipment", "description", "scheduled_date", "status")
        widgets = {"scheduled_date": forms.DateInput(attrs={"type": "date"})}
    
    def clean(self):
        """Ensure XOR constraint on facility/equipment."""
        cleaned = super().clean()
        facility = cleaned.get('facility')
        equipment = cleaned.get('equipment')
        
        if not facility and not equipment:
            raise forms.ValidationError("Please select either a facility OR equipment for maintenance.")
        if facility and equipment:
            raise forms.ValidationError("Cannot select both facility AND equipment. Choose only one.")
        
        return cleaned


class VisitorApplicationForm(BaseStyledModelForm):
    """Form for new Visitor_Application model."""
    phone_numbers = forms.CharField(
        required=False,
        help_text="Enter phone numbers separated by commas"
    )
    email_addresses = forms.CharField(
        required=False,
        help_text="Enter email addresses separated by commas"
    )
    
    class Meta:
        model = Visitor_Application
        fields = ("first_name", "last_name", "ic_number", "application_date")
        widgets = {
            "application_date": forms.DateInput(attrs={"type": "date"}),
        }
