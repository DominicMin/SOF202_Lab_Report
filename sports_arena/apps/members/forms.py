from django import forms

from accounts.models import MemberProfile


class MemberProfileForm(forms.ModelForm):
    class Meta:
        model = MemberProfile
        fields = ("phone", "affiliation", "membership_type")

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        for field in self.fields.values():
            css = field.widget.attrs.get("class", "").strip()
            field.widget.attrs["class"] = f"{css} form-control".strip()
