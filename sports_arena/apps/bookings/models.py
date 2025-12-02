from django.conf import settings
from django.db import models


class Booking(models.Model):
    member = models.ForeignKey("accounts.MemberProfile", on_delete=models.CASCADE, related_name="bookings")
    facility = models.ForeignKey("management_portal.Facility", on_delete=models.PROTECT)
    requested_start = models.DateTimeField()
    requested_end = models.DateTimeField()
    status = models.CharField(
        max_length=20,
        choices=[
            ("pending", "Pending"),
            ("approved", "Approved"),
            ("rejected", "Rejected"),
            ("cancelled", "Cancelled"),
        ],
        default="pending",
    )
    purpose = models.CharField(max_length=200, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-created_at"]

    def __str__(self) -> str:
        return f"Booking #{self.id} - {self.member}"


class Reservation(models.Model):
    booking = models.ForeignKey(Booking, on_delete=models.CASCADE, related_name="reservations")
    facility = models.ForeignKey("management_portal.Facility", on_delete=models.PROTECT)
    start_time = models.DateTimeField()
    end_time = models.DateTimeField()
    assigned_officer = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="assigned_reservations",
    )
    notes = models.TextField(blank=True)

    def __str__(self) -> str:
        return f"Reservation #{self.id} for {self.facility}"


class ReservationEquipment(models.Model):
    reservation = models.ForeignKey(Reservation, on_delete=models.CASCADE, related_name="equipments")
    equipment = models.ForeignKey("management_portal.Equipment", on_delete=models.PROTECT)
    quantity = models.PositiveIntegerField(default=1)

    def __str__(self) -> str:
        return f"{self.equipment} x {self.quantity}"


class TrainingSession(models.Model):
    title = models.CharField(max_length=100)
    coach = models.ForeignKey("accounts.CoachProfile", on_delete=models.CASCADE, related_name="sessions")
    facility = models.ForeignKey("management_portal.Facility", on_delete=models.PROTECT)
    start_time = models.DateTimeField()
    end_time = models.DateTimeField()
    capacity = models.PositiveIntegerField(default=20)
    description = models.TextField(blank=True)

    class Meta:
        ordering = ["start_time"]

    def __str__(self) -> str:
        return f"{self.title} ({self.start_time:%m/%d})"


class SessionEnrollment(models.Model):
    session = models.ForeignKey(TrainingSession, on_delete=models.CASCADE, related_name="enrollments")
    member = models.ForeignKey("accounts.MemberProfile", on_delete=models.CASCADE, related_name="enrollments")
    status = models.CharField(
        max_length=20,
        choices=[
            ("confirmed", "Confirmed"),
            ("cancelled", "Cancelled"),
        ],
        default="confirmed",
    )
    enrolled_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ("session", "member")

    def __str__(self) -> str:
        return f"{self.member} -> {self.session}"
