"""
Forms for booking management with business logic validations.
"""
from datetime import date, timedelta

from django import forms
from django.core.exceptions import ValidationError

from accounts.models import Member
from management_portal.models import Equipment, Facility

from .models import Booking, Reservation, Reservation_Equipments, TrainingSession
from .utils import (
    calculate_duration_hours,
    check_member_pending_bookings_count,
    check_reservation_conflict,
    get_equipment_availability,
)

DATETIME_INPUT_FORMATS = ["%Y-%m-%dT%H:%M", "%Y-%m-%d %H:%M", "%H:%M"]


def _apply_form_control(fields):
    """Apply Bootstrap form-control class to all fields."""
    for field in fields.values():
        existing = field.widget.attrs.get("class", "")
        field.widget.attrs["class"] = f"{existing} form-control".strip()


def _configure_datetime(field):
    """Configure datetime input widget."""
    field.widget = forms.DateTimeInput(
        attrs={"type": "datetime-local", "class": "form-control"},
        format="%Y-%m-%dT%H:%M",
    )
    field.input_formats = DATETIME_INPUT_FORMATS


def _configure_time(field):
    """Configure time input widget."""
    field.widget = forms.TimeInput(
        attrs={"type": "time", "class": "form-control"},
        format="%H:%M",
    )


# ============================================================
# New Forms with Business Logic Validations
# ============================================================

class ReservationForm(forms.ModelForm):
    """
    Form for creating reservations.
    Enforces business rules:
    - Time validation (end > start)
    - Conflict checking
    """
    
    class Meta:
        model = Reservation
        fields = ("facility", "reservation_date", "start_time", "end_time")

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        _apply_form_control(self.fields)
        _configure_time(self.fields["start_time"])
        _configure_time(self.fields["end_time"])
        self.fields["facility"].empty_label = "Select a facility"
        self.fields["reservation_date"].widget = forms.DateInput(
            attrs={"type": "date", "class": "form-control"}
        )

    def clean(self):
        cleaned = super().clean()
        facility = cleaned.get("facility")
        reservation_date = cleaned.get("reservation_date")
        start_time = cleaned.get("start_time")
        end_time = cleaned.get("end_time")

        if not all([facility, reservation_date, start_time, end_time]):
            return cleaned

        # Validate end time > start time
        if end_time <= start_time:
            self.add_error("end_time", "End time must be later than start time.")

        # Check for reservation conflicts
        exclude_id = self.instance.reservation_id if self.instance.pk else None
        if check_reservation_conflict(
            facility.facility_id,
            reservation_date,
            start_time,
            end_time,
            exclude_id
        ):
            raise ValidationError(
                "This time slot conflicts with an existing reservation. Please choose a different time."
            )

        return cleaned


class BookingForm(forms.ModelForm):
    """
    Form for creating member bookings.
    Enforces business rules:
    - Max 2 pending bookings per member
    - Max 3 hours duration
    - Max 1 week advance booking
    - Conflict checking (via Reservation creation)
    """
    
    # Additional fields for reservation details
    reservation_date = forms.DateField(
        widget=forms.DateInput(attrs={"type": "date", "class": "form-control"})
    )
    start_time = forms.TimeField(
        widget=forms.TimeInput(attrs={"type": "time", "class": "form-control"})
    )
    end_time = forms.TimeField(
        widget=forms.TimeInput(attrs={"type": "time", "class": "form-control"})
    )
    
    class Meta:
        model = Booking
        fields = ('member',)  # Only booking-specific fields, reservation fields are separate
    
    def __init__(self, *args, **kwargs):
        self.facility = kwargs.pop('facility', None)
        super().__init__(*args, **kwargs)
        _apply_form_control(self.fields)
        
    def clean_member(self):
        """Validate max 2 pending bookings rule."""
        member = self.cleaned_data.get('member')
        if member:
            pending_count = check_member_pending_bookings_count(member.member_id)
            if pending_count >= 2:
                raise ValidationError(
                    f"Member already has {pending_count} pending bookings. Maximum 2 pending bookings allowed."
                )
        return member
    
    def clean_reservation_date(self):
        """Validate 1 week advance booking limit."""
        reservation_date = self.cleaned_data.get('reservation_date')
        if reservation_date:
            today = date.today()
            max_advance_date = today + timedelta(days=7)
            
            if reservation_date < today:
                raise ValidationError("Cannot book for past dates.")
            
            if reservation_date > max_advance_date:
                raise ValidationError(
                    f"Bookings can only be made up to 1 week in advance. "
                    f"Latest allowed date: {max_advance_date.strftime('%Y-%m-%d')}"
                )
        return reservation_date
    
    def clean(self):
        cleaned = super().clean()
        start_time = cleaned.get("start_time")
        end_time = cleaned.get("end_time")
        reservation_date = cleaned.get("reservation_date")
        
        if not all([start_time, end_time, reservation_date]):
            return cleaned
        
        # Validate end time > start time
        if end_time <= start_time:
            self.add_error("end_time", "End time must be later than start time.")
            return cleaned
        
        # Validate 3-hour duration limit
        duration = calculate_duration_hours(start_time, end_time)
        if duration > 3:
            raise ValidationError(
                f"Single booking session cannot exceed 3 hours. "
                f"Requested duration: {duration:.2f} hours."
            )
        
        # Check for conflicts (if facility is provided)
        facility = self.facility or cleaned.get("facility")
        if facility:
            if check_reservation_conflict(
                facility.facility_id,
                reservation_date,
                start_time,
                end_time
            ):
                raise ValidationError(
                    "This time slot conflicts with an existing reservation. Please choose a different time."
                )
        
        return cleaned


class MemberBookingForm(BookingForm):
    """Booking form for members (pre-populated member field)."""
    
    facility = forms.ModelChoiceField(
        queryset=Facility.objects.filter(status='Available'),
        empty_label="Select a facility"
    )
    
    class Meta:
        model = Booking
        fields = ('facility', 'reservation_date', 'start_time', 'end_time')
    
    def __init__(self, member, *args, **kwargs):
        self.member = member
        super().__init__(*args, **kwargs)
        # Remove member field since it's pre-populated
        if 'member' in self.fields:
            del self.fields['member']
        _apply_form_control(self.fields)


class OfficerBookingForm(BookingForm):
    """Booking form for booking officers (can select member)."""
    
    facility = forms.ModelChoiceField(
        queryset=Facility.objects.filter(status='Available'),
        empty_label="Select a facility"
    )
    member = forms.ModelChoiceField(
        queryset=Member.objects.filter(membership_status='Active'),
        empty_label="Select a member"
    )
    
    class Meta:
        model = Booking
        fields = ('member', 'facility', 'reservation_date', 'start_time', 'end_time')
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        _apply_form_control(self.fields)


class ReservationEquipmentForm(forms.ModelForm):
    """
    Form for adding equipment to a reservation.
    Enforces equipment availability validation.
    """
    
    class Meta:
        model = Reservation_Equipments
        fields = ("equipment", "quantity")

    def __init__(self, reservation=None, *args, **kwargs):
        self.reservation = reservation
        super().__init__(*args, **kwargs)
        _apply_form_control(self.fields)
        self.fields["equipment"].queryset = Equipment.objects.filter(
            status='Available'
        )

    def clean(self):
        cleaned = super().clean()
        equipment = cleaned.get("equipment")
        quantity = cleaned.get("quantity")

        if not all([equipment, quantity]):
            return cleaned

        # Check equipment availability if reservation details are available
        if self.reservation:
            available = get_equipment_availability(
                equipment.equipment_id,
                self.reservation.reservation_date,
                self.reservation.start_time,
                self.reservation.end_time
            )
            
            if quantity > available:
                raise ValidationError(
                    f"Only {available} units of {equipment.equipment_name} are available for this time slot. "
                    f"You requested {quantity} units."
                )
        
        return cleaned


class TrainingSessionForm(forms.ModelForm):
    """Form for creating training sessions."""
    
    # Additional fields for reservation details
    facility = forms.ModelChoiceField(
        queryset=Facility.objects.filter(status='Available'),
        empty_label="Select a facility"
    )
    reservation_date = forms.DateField(
        widget=forms.DateInput(attrs={"type": "date", "class": "form-control"})
    )
    start_time = forms.TimeField(
        widget=forms.TimeInput(attrs={"type": "time", "class": "form-control"})
    )
    end_time = forms.TimeField(
        widget=forms.TimeInput(attrs={"type": "time", "class": "form-control"})
    )
    
    class Meta:
        model = TrainingSession
        fields = ('coach', 'max_capacity', 'facility', 'reservation_date', 'start_time', 'end_time')
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        _apply_form_control(self.fields)
    
    def clean(self):
        cleaned = super().clean()
        facility = cleaned.get("facility")
        reservation_date = cleaned.get("reservation_date")
        start_time = cleaned.get("start_time")
        end_time = cleaned.get("end_time")
        
        if not all([facility, reservation_date, start_time, end_time]):
            return cleaned
        
        # Validate end time > start time
        if end_time <= start_time:
            self.add_error("end_time", "End time must be later than start time.")
            return cleaned
        
        # Check for conflicts
        if check_reservation_conflict(
            facility.facility_id,
            reservation_date,
            start_time,
            end_time
        ):
            raise ValidationError(
                "This time slot conflicts with an existing reservation. Please choose a different time."
            )
        
        return cleaned
