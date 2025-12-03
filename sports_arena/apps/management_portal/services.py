"""
Service layer for handling visitor application approvals.
"""
from datetime import date
from typing import Optional

from django.db import transaction
from django.utils import timezone

from accounts.models import External_Visitor, Member
from management_portal.models import Visitor_Application


def approve_visitor_application(
    application_id: int,
    approved_by_staff_id: int,
    create_user_account: bool = False
) -> tuple[Member, External_Visitor]:
    """
    Approve a visitor application and create corresponding Member and External_Visitor records.
    
    This implements the business logic from init_db.sql and thesis requirements:
    1. Update application status to 'Approved'
    2. Create Member record with visitor's information
    3. Create External_Visitor record linked to the Member
    4. Link created Member back to application via created_member_id
    
    Args:
        application_id: ID of the visitor application to approve
        approved_by_staff_id: ID of the staff member approving the application
        create_user_account: Whether to create a Django User account (optional, for future expansion)
    
    Returns:
        Tuple of (Member, External_Visitor) instances created
    
    Raises:
        ValueError: If application doesn't exist, is not pending, or validation fails
    """
    try:
        application = Visitor_Application.objects.select_for_update().get(
            application_id=application_id
        )
    except Visitor_Application.DoesNotExist:
        raise ValueError(f"Visitor application {application_id} not found.")
    
    if application.status != 'Pending':
        raise ValueError(
            f"Cannot approve application {application_id}: "
            f"current status is '{application.status}', must be 'Pending'."
        )
    
    with transaction.atomic():
        # Create Member record
        member = Member.objects.create(
            first_name=application.first_name,
            last_name=application.last_name,
            registration_date=date.today(),
            membership_status='Active',
            user=None  # External visitors don't have User accounts initially
        )
        
        # Copy contact information from application to member
        # Multi-valued phone numbers
        for app_phone in application.phone_numbers.all():
            from accounts.models import Member_Phone
            Member_Phone.objects.create(
                member=member,
                phone_number=app_phone.phone_number
            )
        
        # Multi-valued email addresses
        for app_email in application.email_addresses.all():
            from accounts.models import Member_Email
            Member_Email.objects.create(
                member=member,
                email_address=app_email.email_address
            )
        
        # Create External_Visitor record
        external_visitor = External_Visitor.objects.create(
            member=member,
            ic_number=application.ic_number
        )
        
        # Update application status
        application.status = 'Approved'
        application.approved_by_id = approved_by_staff_id
        application.approval_date = date.today()
        application.created_member = member
        application.save()
    
    return member, external_visitor


def reject_visitor_application(
    application_id: int,
    rejected_by_staff_id: int,
    reject_reason: str
) -> Visitor_Application:
    """
    Reject a visitor application with a reason.
    
    Args:
        application_id: ID of the visitor application to reject
        rejected_by_staff_id: ID of the staff member rejecting the application
        reject_reason: Reason for rejection
    
    Returns:
        Updated Visitor_Application instance
    
    Raises:
        ValueError: If application doesn't exist or is not pending
    """
    try:
        application = Visitor_Application.objects.select_for_update().get(
            application_id=application_id
        )
    except Visitor_Application.DoesNotExist:
        raise ValueError(f"Visitor application {application_id} not found.")
    
    if application.status != 'Pending':
        raise ValueError(
            f"Cannot reject application {application_id}: "
            f"current status is '{application.status}', must be 'Pending'."
        )
    
    with transaction.atomic():
        application.status = 'Rejected'
        application.approved_by_id = rejected_by_staff_id
        application.approval_date = date.today()
        application.reject_reason = reject_reason
        application.save()
    
    return application
