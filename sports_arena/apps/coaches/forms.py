from django import forms

from accounts.models import Coach


class CoachProfileForm(forms.ModelForm):
    class Meta:
        model = Coach
        fields = ("first_name", "last_name", "sport_type", "level")

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        for field in self.fields.values():
            existing = field.widget.attrs.get("class", "")
            field.widget.attrs["class"] = f"{existing} form-control".strip()

