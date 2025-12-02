from django import forms

from accounts.models import MemberProfile

from .models import Booking, Reservation, ReservationEquipment

DATETIME_INPUT_FORMATS = ["%Y-%m-%dT%H:%M", "%Y-%m-%d %H:%M"]


def _apply_form_control(fields):
    for field in fields.values():
        existing = field.widget.attrs.get("class", "")
        field.widget.attrs["class"] = f"{existing} form-control".strip()


def _configure_datetime(field):
    field.widget = forms.DateTimeInput(
        attrs={"type": "datetime-local", "class": "form-control"},
        format="%Y-%m-%dT%H:%M",
    )
    field.input_formats = DATETIME_INPUT_FORMATS


class BookingForm(forms.ModelForm):
    class Meta:
        model = Booking
        fields = ("facility", "requested_start", "requested_end", "purpose")

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        _apply_form_control(self.fields)
        for name in ("requested_start", "requested_end"):
            _configure_datetime(self.fields[name])
        self.fields["facility"].empty_label = "Select a facility"

    def clean(self):
        cleaned = super().clean()
        start = cleaned.get("requested_start")
        end = cleaned.get("requested_end")
        if start and end and end <= start:
            self.add_error("requested_end", "End time must be later than start time.")
        return cleaned


class OfficerBookingForm(BookingForm):
    member = forms.ModelChoiceField(queryset=MemberProfile.objects.none(), label="Member")

    class Meta:
        model = Booking
        fields = ("member", "facility", "requested_start", "requested_end", "purpose")

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fields["member"].queryset = MemberProfile.objects.filter(status="active")
        existing = self.fields["member"].widget.attrs.get("class", "")
        self.fields["member"].widget.attrs["class"] = f"{existing} form-control".strip()


class ReservationForm(forms.ModelForm):
    class Meta:
        model = Reservation
        fields = ("facility", "start_time", "end_time", "notes")

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        _apply_form_control(self.fields)
        for name in ("start_time", "end_time"):
            _configure_datetime(self.fields[name])
        self.fields["facility"].empty_label = "Select a facility"

    def clean(self):
        cleaned = super().clean()
        start = cleaned.get("start_time")
        end = cleaned.get("end_time")
        if start and end and end <= start:
            self.add_error("end_time", "End time must be later than start time.")
        return cleaned


class ReservationEquipmentForm(forms.ModelForm):
    class Meta:
        model = ReservationEquipment
        fields = ("equipment", "quantity")

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        _apply_form_control(self.fields)
