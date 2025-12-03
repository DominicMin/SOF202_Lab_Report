from django.contrib.auth.models import User
from django.core.exceptions import ValidationError
from django.db import models


class TimeStampedModel(models.Model):
    """Abstract base class that provides created_at/updated_at fields."""

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        abstract = True


# ============================================================
# Member Superclass and Subclasses (Multi-table Inheritance)
# ============================================================

class Member(models.Model):
    """
    Member superclass entity matching init_db.sql schema.
    Uses multi-table inheritance for Student/Staff/External_Visitor subclasses.
    """
    member_id = models.AutoField(primary_key=True, db_column='Member_ID')
    user = models.OneToOneField(
        User, 
        on_delete=models.CASCADE, 
        related_name="member",
        null=True,
        blank=True
    )
    first_name = models.CharField(max_length=50, db_column='First_Name')
    last_name = models.CharField(max_length=50, db_column='Last_Name')
    registration_date = models.DateField(db_column='Registration_Date')
    membership_status = models.CharField(
        max_length=20,
        choices=[
            ('Active', 'Active'),
            ('Inactive', 'Inactive'),
            ('Pending_Approval', 'Pending Approval'),
        ],
        db_column='Membership_Status'
    )

    class Meta:
        db_table = 'Member'

    def __str__(self) -> str:
        return f"{self.first_name} {self.last_name} (ID: {self.member_id})"


class Student(models.Model):
    """Student subclass - adopts superclass primary key pushdown strategy."""
    member = models.OneToOneField(
        Member,
        on_delete=models.CASCADE,
        primary_key=True,
        db_column='Member_ID',
        related_name='student_profile'
    )
    student_id = models.CharField(max_length=20, unique=True, db_column='Student_ID')

    class Meta:
        db_table = 'Student'

    def __str__(self) -> str:
        return f"Student {self.student_id}: {self.member}"


class Staff(models.Model):
    """Staff subclass - adopts superclass primary key pushdown strategy."""
    member = models.OneToOneField(
        Member,
        on_delete=models.CASCADE,
        primary_key=True,
        db_column='Member_ID',
        related_name='staff_profile'
    )
    staff_id = models.CharField(max_length=20, unique=True, db_column='Staff_ID')

    class Meta:
        db_table = 'Staff'

    def __str__(self) -> str:
        return f"Staff {self.staff_id}: {self.member}"


class External_Visitor(models.Model):
    """External Visitor subclass - adopts superclass primary key pushdown strategy."""
    member = models.OneToOneField(
        Member,
        on_delete=models.CASCADE,
        primary_key=True,
        db_column='Member_ID',
        related_name='external_visitor_profile'
    )
    ic_number = models.CharField(max_length=30, unique=True, db_column='IC_Number')

    class Meta:
        db_table = 'External_Visitor'

    def __str__(self) -> str:
        return f"Visitor {self.ic_number}: {self.member}"


# ============================================================
# Multi-valued Contact Attributes for Member
# ============================================================

class Member_Phone(models.Model):
    """Multi-valued phone numbers for Member."""
    member = models.ForeignKey(
        Member,
        on_delete=models.CASCADE,
        db_column='Member_ID',
        related_name='phone_numbers'
    )
    phone_number = models.CharField(max_length=20, db_column='Phone_Number')

    class Meta:
        db_table = 'Member_Phone'
        unique_together = [['member', 'phone_number']]

    def __str__(self) -> str:
        return f"{self.member.first_name} {self.member.last_name}: {self.phone_number}"


class Member_Email(models.Model):
    """Multi-valued email addresses for Member."""
    member = models.ForeignKey(
        Member,
        on_delete=models.CASCADE,
        db_column='Member_ID',
        related_name='email_addresses'
    )
    email_address = models.CharField(max_length=100, db_column='Email_Address')

    class Meta:
        db_table = 'Member_Email'
        unique_together = [['member', 'email_address']]

    def __str__(self) -> str:
        return f"{self.member.first_name} {self.member.last_name}: {self.email_address}"


# ============================================================
# Coach Entity and Multi-valued Contact Attributes
# ============================================================

class Coach(models.Model):
    """Coach entity matching init_db.sql schema."""
    coach_id = models.AutoField(primary_key=True, db_column='Coach_ID')
    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        related_name="coach",
        null=True,
        blank=True
    )
    first_name = models.CharField(max_length=50, db_column='First_Name')
    last_name = models.CharField(max_length=50, db_column='Last_Name')
    sport_type = models.CharField(max_length=50, db_column='Sport_Type')
    level = models.CharField(max_length=20, db_column='Level')

    class Meta:
        db_table = 'Coach'

    def __str__(self) -> str:
        return f"{self.first_name} {self.last_name} - {self.sport_type} ({self.level})"


class Coach_Phone(models.Model):
    """Multi-valued phone numbers for Coach."""
    coach = models.ForeignKey(
        Coach,
        on_delete=models.CASCADE,
        db_column='Coach_ID',
        related_name='phone_numbers'
    )
    phone_number = models.CharField(max_length=20, db_column='Phone_Number')

    class Meta:
        db_table = 'Coach_Phone'
        unique_together = [['coach', 'phone_number']]

    def __str__(self) -> str:
        return f"{self.coach.first_name} {self.coach.last_name}: {self.phone_number}"


class Coach_Email(models.Model):
    """Multi-valued email addresses for Coach."""
    coach = models.ForeignKey(
        Coach,
        on_delete=models.CASCADE,
        db_column='Coach_ID',
        related_name='email_addresses'
    )
    email_address = models.CharField(max_length=100, db_column='Email_Address')

    class Meta:
        db_table = 'Coach_Email'
        unique_together = [['coach', 'email_address']]

    def __str__(self) -> str:
        return f"{self.coach.first_name} {self.coach.last_name}: {self.email_address}"


# ============================================================
# Legacy Models (Kept for backward compatibility during migration)
# TODO: Remove after complete migration
# ============================================================

class MemberProfile(TimeStampedModel):
    """DEPRECATED: Use Member model instead."""
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
    """DEPRECATED: Use Coach model instead."""
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="coach_profile")
    coach_id = models.CharField("Coach ID", max_length=20, unique=True)
    phone = models.CharField("Phone", max_length=20, blank=True)
    specialty = models.CharField("Specialty", max_length=100, blank=True)
    bio = models.TextField("Bio", blank=True)

    def __str__(self) -> str:
        return f"{self.coach_id}-{self.user.get_full_name() or self.user.username}"
