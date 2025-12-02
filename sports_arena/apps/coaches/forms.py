from django import forms

from accounts.models import CoachProfile
from bookings.models import TrainingSession


class CoachProfileForm(forms.ModelForm):
    class Meta:
        model = CoachProfile
        fields = ("phone", "specialty", "bio")

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        for field in self.fields.values():
            existing = field.widget.attrs.get("class", "")
            field.widget.attrs["class"] = f"{existing} form-control".strip()


class SessionNoteForm(forms.ModelForm):
    class Meta:
        model = TrainingSession
        fields = ("description",)
        widgets = {
            "description": forms.Textarea(
                attrs={"rows": 4, "class": "form-control", "placeholder": "Add coaching notes..."}
            )
        }
