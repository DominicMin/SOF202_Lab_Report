from django import forms
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.models import User

ROLE_CHOICES = (
    ("member", "Member"),
    ("coach", "Coach"),
)


class UserRegistrationForm(UserCreationForm):
    first_name = forms.CharField(label="First Name", max_length=30)
    last_name = forms.CharField(label="Last Name", max_length=30)
    email = forms.EmailField(label="Email")
    role = forms.ChoiceField(label="Role", choices=ROLE_CHOICES, initial="member")
    phone = forms.CharField(label="Phone", max_length=20, required=False)
    affiliation = forms.CharField(label="Affiliation", max_length=100, required=False)
    specialty = forms.CharField(label="Specialty (for Coaches)", max_length=100, required=False)

    class Meta(UserCreationForm.Meta):
        model = User
        fields = ("username", "first_name", "last_name", "email")

    def save(self, commit: bool = True):
        user = super().save(commit=False)
        user.first_name = self.cleaned_data["first_name"]
        user.last_name = self.cleaned_data["last_name"]
        user.email = self.cleaned_data["email"]
        if commit:
            user.save()
        return user
