from datetime import date, timedelta

from django.db import models


# ============================================================
# Reservation Superclass and Subclasses
# ============================================================

class Reservation(models.Model):
    """
    Reservation superclass entity matching init_db.sql schema.
    Represents a time slot reservation for a facility.
    """
    reservation_id = models.AutoField(primary_key=True, db_column='Reservation_ID')
    facility = models.ForeignKey(
        'management_portal.Facility',
        on_delete=models.PROTECT,
        db_column='Facility_ID',
        related_name='reservations'
    )
    reservation_date = models.DateField(db_column='Reservation_Date')
    start_time = models.TimeField(db_column='Start_Time')
    end_time = models.TimeField(db_column='End_Time')

    class Meta:
        db_table = 'Reservation'
        # Unique constraint to prevent double bookings
        unique_together = [['facility', 'reservation_date', 'start_time']]
        indexes = [
            models.Index(fields=['facility', 'reservation_date']),
        ]
        constraints = [
            models.CheckConstraint(
                check=models.Q(start_time__lt=models.F('end_time')),
                name='chk_reservation_time'
            ),
        ]

    def __str__(self) -> str:
        return f"Reservation {self.reservation_id}: {self.facility} on {self.reservation_date}"


class Booking(models.Model):
    """Booking subclass - member reservations. Adopts superclass primary key pushdown."""
    reservation = models.OneToOneField(
        Reservation,
        on_delete=models.CASCADE,
        primary_key=True,
        db_column='Reservation_ID',
        related_name='booking'
    )
    member = models.ForeignKey(
        'accounts.Member',
        on_delete=models.PROTECT,
        db_column='Member_ID',
        related_name='bookings'
    )
    booking_status = models.CharField(
        max_length=20,
        choices=[
            ('Pending', 'Pending'),
            ('Confirmed', 'Confirmed'),
            ('Cancelled', 'Cancelled'),
        ],
        db_column='Booking_Status'
    )

    class Meta:
        db_table = 'Booking'
        indexes = [
            models.Index(fields=['member']),
        ]

    def __str__(self) -> str:
        return f"Booking {self.reservation.reservation_id}: {self.member}"


class TrainingSession(models.Model):
    """Training Session subclass - coach-led sessions. Adopts superclass primary key pushdown."""
    reservation = models.OneToOneField(
        Reservation,
        on_delete=models.CASCADE,
        primary_key=True,
        db_column='Reservation_ID',
        related_name='training_session'
    )
    coach = models.ForeignKey(
        'accounts.Coach',
        on_delete=models.RESTRICT,
        db_column='Coach_ID',
        related_name='training_sessions'
    )
    max_capacity = models.PositiveIntegerField(db_column='Max_Capacity')

    class Meta:
        db_table = 'Training_Session'
        indexes = [
            models.Index(fields=['coach']),
        ]

    def __str__(self) -> str:
        return f"Training Session {self.reservation.reservation_id}: {self.coach}"


# ============================================================
# Weak Entity: Reservation Equipment
# ============================================================

class Reservation_Equipments(models.Model):
    """
    Weak entity linking Reservation with Equipment.
    Represents equipment reserved for a specific reservation.
    """
    reservation = models.ForeignKey(
        Reservation,
        on_delete=models.CASCADE,
        db_column='Reservation_ID',
        related_name='equipment_reservations'
    )
    equipment = models.ForeignKey(
        'management_portal.Equipment',
        on_delete=models.RESTRICT,
        db_column='Equipment_ID',
        related_name='reservations'
    )
    quantity = models.PositiveIntegerField(db_column='Quantity')

    class Meta:
        db_table = 'Reservation_Equipments'
        unique_together = [['reservation', 'equipment']]
        constraints = [
            models.CheckConstraint(
                check=models.Q(quantity__gt=0),
                name='chk_re_quantity'
            ),
        ]

    def __str__(self) -> str:
        return f"{self.equipment} x{self.quantity} for Reservation {self.reservation.reservation_id}"


# ============================================================
# Weak Entity: Session Enrollment
# ============================================================

class Session_Enrollment(models.Model):
    """
    Weak entity linking Member with Training_Session.
    Represents member enrollment in a training session.
    """
    training_session = models.ForeignKey(
        TrainingSession,
        on_delete=models.CASCADE,
        db_column='Reservation_ID',
        related_name='enrollments'
    )
    member = models.ForeignKey(
        'accounts.Member',
        on_delete=models.RESTRICT,
        db_column='Member_ID',
        related_name='session_enrollments'
    )

    class Meta:
        db_table = 'Session_Enrollment'
        unique_together = [['training_session', 'member']]
        indexes = [
            models.Index(fields=['member']),
        ]

    def __str__(self) -> str:
        return f"{self.member} enrolled in {self.training_session}"
