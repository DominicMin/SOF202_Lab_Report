from django import forms

from accounts.models import Member


class MemberProfileForm(forms.ModelForm):
    class Meta:
        model = Member
        fields = ("first_name", "last_name")

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        for field in self.fields.values():
            css = field.widget.attrs.get("class", "").strip()
            field.widget.attrs["class"] = f"{css} form-control".strip()
