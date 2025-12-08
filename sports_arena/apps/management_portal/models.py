from django.core.exceptions import ValidationError
from django.db import models


# ============================================================
# Facility Entity
# ============================================================

class Facility(models.Model):
    """Facility entity matching init_db.sql schema."""
    facility_id = models.AutoField(primary_key=True, db_column='Facility_ID')
    facility_name = models.CharField(max_length=100, db_column='Facility_Name')
    type = models.CharField(max_length=50, db_column='Type')
    status = models.CharField(
        max_length=20,
        choices=[
            ('Available', 'Available'),
            ('Under_Maintenance', 'Under Maintenance'),
            ('Unavailable', 'Unavailable'),
        ],
        default='Available',
        db_column='Status'
    )
    capacity = models.PositiveIntegerField(db_column='Capacity')
    # Location composite attribute decomposed into:
    building = models.CharField(max_length=50, db_column='Building')
    floor = models.SmallIntegerField(db_column='Floor')
    room_number = models.CharField(max_length=20, db_column='Room_Number')

    class Meta:
        db_table = 'Facility'

    def __str__(self) -> str:
        return f"{self.facility_name} ({self.building}-{self.floor}-{self.room_number})"


# ============================================================
# Equipment Entity
# ============================================================

class Equipment(models.Model):
    """Equipment entity matching init_db.sql schema."""
    equipment_id = models.AutoField(primary_key=True, db_column='Equipment_ID')
    equipment_name = models.CharField(max_length=100, db_column='Equipment_Name')
    type = models.CharField(max_length=50, db_column='Type')
    status = models.CharField(
        max_length=20,
        choices=[
            ('Available', 'Available'),
            ('In_Use', 'In Use'),
            ('Under_Maintenance', 'Under Maintenance'),
            ('Damaged', 'Damaged'),
        ],
        default='Available',
        db_column='Status'
    )
    total_quantity = models.PositiveIntegerField(db_column='Total_Quantity')
    # Note: Available_Quantity is a derived attribute, calculated dynamically

    class Meta:
        db_table = 'Equipment'

    def __str__(self) -> str:
        return f"{self.equipment_name} (Total: {self.total_quantity})"


# ============================================================
# Maintenance Entity with XOR Constraint
# ============================================================

class Maintenance(models.Model):
    """Maintenance entity with XOR constraint - must maintain either Facility OR Equipment."""
    maintenance_id = models.AutoField(primary_key=True, db_column='Maintenance_ID')
    scheduled_date = models.DateField(db_column='Scheduled_Date')
    completion_date = models.DateField(null=True, blank=True, db_column='Completion_Date')
    status = models.CharField(
        max_length=20,
        choices=[
            ('Scheduled', 'Scheduled'),
            ('In_Progress', 'In Progress'),
            ('Completed', 'Completed'),
            ('Cancelled', 'Cancelled'),
        ],
        db_column='Status'
    )
    description = models.TextField(null=True, blank=True, db_column='Description')
    # XOR constraint: exactly one of facility_id or equipment_id must be set
    facility = models.ForeignKey(
        Facility,
        on_delete=models.RESTRICT,
        null=True,
        blank=True,
        db_column='Facility_ID',
        related_name='maintenance_records'
    )
    equipment = models.ForeignKey(
        Equipment,
        on_delete=models.RESTRICT,
        null=True,
        blank=True,
        db_column='Equipment_ID',
        related_name='maintenance_records'
    )

    class Meta:
        db_table = 'Maintenance'
        indexes = [
            models.Index(fields=['facility', 'scheduled_date']),
            models.Index(fields=['equipment', 'scheduled_date']),
        ]

    def clean(self):
        """Enforce XOR constraint: exactly one of facility or equipment must be set."""
        if not self.facility and not self.equipment:
            raise ValidationError(
                "Maintenance must be associated with either a Facility or Equipment."
            )
        if self.facility and self.equipment:
            raise ValidationError(
                "Maintenance cannot be associated with both Facility and Equipment."
            )

    def save(self, *args, **kwargs):
        self.full_clean()
        super().save(*args, **kwargs)

    def __str__(self) -> str:
        target = self.facility.facility_name if self.facility else self.equipment.equipment_name
        return f"Maintenance {self.maintenance_id}: {target} - {self.get_status_display()}"


# ============================================================
# Visitor Application and Multi-valued Contact Attributes
# ============================================================

class Visitor_Application(models.Model):
    """Visitor Application entity matching init_db.sql schema."""
    application_id = models.AutoField(primary_key=True, db_column='Application_ID')
    first_name = models.CharField(max_length=50, db_column='First_Name')
    last_name = models.CharField(max_length=50, db_column='Last_Name')
    ic_number = models.CharField(max_length=20, unique=True, db_column='IC_Number')
    application_date = models.DateField(db_column='Application_Date')
    status = models.CharField(
        max_length=20,
        choices=[
            ('Pending', 'Pending'),
            ('Approved', 'Approved'),
            ('Rejected', 'Rejected'),
        ],
        default='Pending',
        db_column='Status'
    )
    # FK to Staff who approved/rejected the application
    approved_by = models.ForeignKey(
        'accounts.Staff',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        db_column='Approved_By',
        related_name='approved_applications'
    )
    approval_date = models.DateField(null=True, blank=True, db_column='Approval_Date')
    reject_reason = models.TextField(null=True, blank=True, db_column='Reject_Reason')
    # Link to created Member upon approval
    created_member = models.ForeignKey(
        'accounts.Member',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        db_column='Created_Member_ID',
        related_name='visitor_application'
    )

    class Meta:
        db_table = 'Visitor_Application'
        indexes = [
            models.Index(fields=['status', 'application_date']),
        ]

    def __str__(self) -> str:
        return f"Application {self.application_id}: {self.first_name} {self.last_name} ({self.get_status_display()})"


class Visitor_Application_Phone(models.Model):
    """Multi-valued phone numbers for Visitor Application."""
    application = models.ForeignKey(
        Visitor_Application,
        on_delete=models.CASCADE,
        db_column='Application_ID',
        related_name='phone_numbers'
    )
    phone_number = models.CharField(max_length=20, db_column='Phone_Number')

    class Meta:
        db_table = 'Visitor_Application_Phone'
        unique_together = [['application', 'phone_number']]

    def __str__(self) -> str:
        return f"{self.application.first_name} {self.application.last_name}: {self.phone_number}"


class Visitor_Application_Email(models.Model):
    """Multi-valued email addresses for Visitor Application."""
    application = models.ForeignKey(
        Visitor_Application,
        on_delete=models.CASCADE,
        db_column='Application_ID',
        related_name='email_addresses'
    )
    email_address = models.CharField(max_length=100, db_column='Email_Address')

    class Meta:
        db_table = 'Visitor_Application_Email'
        unique_together = [['application', 'email_address']]

    def __str__(self) -> str:
        return f"{self.application.first_name} {self.application.last_name}: {self.email_address}"
