from django.contrib.auth.models import User
from django.db import models


class TimeStampedModel(models.Model):
    """Abstract base class that provides created_at/updated_at fields."""

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        abstract = True


class MemberProfile(TimeStampedModel):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="member_profile")
    member_id = models.CharField("Member ID", max_length=20, unique=True)
    phone = models.CharField("Phone", max_length=20, blank=True)
    affiliation = models.CharField("Affiliation", max_length=100, blank=True)
    membership_type = models.CharField("Membership Type", max_length=50, blank=True)
    status = models.CharField(
        "Status",
        max_length=20,
        choices=[("pending", "Pending"), ("active", "Active")],
        default="pending",
    )

    def __str__(self) -> str:
        return f"{self.member_id}-{self.user.get_full_name() or self.user.username}"


class CoachProfile(TimeStampedModel):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="coach_profile")
    coach_id = models.CharField("Coach ID", max_length=20, unique=True)
    phone = models.CharField("Phone", max_length=20, blank=True)
    specialty = models.CharField("Specialty", max_length=100, blank=True)
    bio = models.TextField("Bio", blank=True)

    def __str__(self) -> str:
        return f"{self.coach_id}-{self.user.get_full_name() or self.user.username}"
