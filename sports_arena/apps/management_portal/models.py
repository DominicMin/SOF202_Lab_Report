from django.contrib.auth.models import User
from django.db import models


class Facility(models.Model):
    name = models.CharField(max_length=100)
    location = models.CharField(max_length=100)
    capacity = models.PositiveIntegerField(default=0)
    status = models.CharField(
        max_length=20,
        choices=[("available", "Available"), ("maintenance", "Under maintenance")],
        default="available",
    )
    description = models.TextField(blank=True)

    def __str__(self) -> str:
        return self.name


class Equipment(models.Model):
    name = models.CharField(max_length=100)
    facility = models.ForeignKey(Facility, on_delete=models.CASCADE, related_name="equipments")
    quantity = models.PositiveIntegerField(default=1)
    status = models.CharField(
        max_length=20,
        choices=[("available", "Available"), ("maintenance", "Under maintenance"), ("retired", "Retired")],
        default="available",
    )

    def __str__(self) -> str:
        return f"{self.name} ({self.facility.name})"


class Maintenance(models.Model):
    facility = models.ForeignKey(Facility, on_delete=models.CASCADE, related_name="maintenance_records")
    description = models.TextField()
    scheduled_date = models.DateField()
    status = models.CharField(
        max_length=20,
        choices=[("scheduled", "Scheduled"), ("in_progress", "In progress"), ("completed", "Completed")],
        default="scheduled",
    )

    def __str__(self) -> str:
        return f"{self.facility.name} - {self.get_status_display()}"


class VisitorApplication(models.Model):
    full_name = models.CharField(max_length=100)
    organization = models.CharField(max_length=100, blank=True)
    contact = models.CharField(max_length=50)
    visit_date = models.DateField()
    reason = models.TextField()
    status = models.CharField(
        max_length=20,
        choices=[("pending", "Pending"), ("approved", "Approved"), ("rejected", "Rejected")],
        default="pending",
    )
    reviewed_by = models.ForeignKey(User, null=True, blank=True, on_delete=models.SET_NULL)
    reviewed_at = models.DateTimeField(null=True, blank=True)
    notes = models.TextField(blank=True)

    def __str__(self) -> str:
        return f"Visitor {self.full_name} ({self.get_status_display()})"


class ExternalVisitor(models.Model):
    application = models.OneToOneField(VisitorApplication, on_delete=models.CASCADE, related_name="external_visitor")
    temp_member_id = models.CharField(max_length=20, unique=True)
    email = models.EmailField()

    def __str__(self) -> str:
        return f"{self.temp_member_id}-{self.application.full_name}"
