"""
Business logic utilities for booking validations.
"""
from datetime import date, datetime, time, timedelta
from typing import Optional

from django.db.models import Count, Q, Sum
from django.utils import timezone


def check_reservation_conflict(
    facility_id: int,
    reservation_date: date,
    start_time: time,
    end_time: time,
    exclude_reservation_id: Optional[int] = None
) -> bool:
    """
    Check if there's a conflicting reservation for the given facility and time slot.
    
    Args:
        facility_id: ID of the facility
        reservation_date: Date of the reservation
        start_time: Start time of the reservation
        end_time: End time of the reservation
        exclude_reservation_id: Optional reservation ID to exclude from conflict check (for updates)
    
    Returns:
        True if there's a conflict, False otherwise
    """
    from .models import Reservation
    
    # Check for overlapping reservations
    # Two time slots overlap if:
    # (StartA < EndB) AND (EndA > StartB)
    conflicts = Reservation.objects.filter(
        facility_id=facility_id,
        reservation_date=reservation_date
    ).filter(
        # Overlap condition: requested start_time < existing end_time AND requested end_time > existing start_time
        start_time__lt=end_time,
        end_time__gt=start_time
    )
    
    if exclude_reservation_id:
        conflicts = conflicts.exclude(reservation_id=exclude_reservation_id)
    
    return conflicts.exists()


def get_equipment_availability(
    equipment_id: int,
    reservation_date: date,
    start_time: time,
    end_time: time
) -> int:
    """
    Calculate available equipment quantity for a specific time slot.
    
    Formula: Total_Quantity - SUM(reserved in overlapping time slots) - COUNT(active maintenance)
    
    Args:
        equipment_id: ID of the equipment
        reservation_date: Date of the reservation
        start_time: Start time
        end_time: End time
    
    Returns:
        Available quantity
    """
    from management_portal.models import Equipment, Maintenance
    from .models import Reservation_Equipments, Reservation
    
    try:
        equipment = Equipment.objects.get(equipment_id=equipment_id)
    except Equipment.DoesNotExist:
        return 0
    
    total_quantity = equipment.total_quantity
    
    # Calculate reserved quantity in overlapping time slots
    reserved_quantity = Reservation_Equipments.objects.filter(
        equipment_id=equipment_id,
        reservation__reservation_date=reservation_date,
        # Overlap condition
        reservation__start_time__lt=end_time,
        reservation__end_time__gt=start_time
    ).aggregate(
        total_reserved=Sum('quantity')
    )['total_reserved'] or 0
    
    # Count active maintenance records for this equipment
    # Note: Each maintenance record represents one equipment instance
    maintenance_count = Maintenance.objects.filter(
        equipment_id=equipment_id,
        status__in=['Scheduled', 'In_Progress'],
        scheduled_date=reservation_date
    ).count()
    
    available = total_quantity - reserved_quantity - maintenance_count
    
    return max(0, available)  # Ensure non-negative


def check_member_pending_bookings_count(member_id: int) -> int:
    """
    Count the number of pending bookings for a member.
    
    Args:
        member_id: ID of the member
    
    Returns:
        Count of pending bookings
    """
    from .models import Booking
    
    return Booking.objects.filter(
        member_id=member_id,
        booking_status='Pending'
    ).count()


def calculate_duration_hours(start_time: time, end_time: time) -> float:
    """
    Calculate duration in hours between start and end time.
    
    Args:
        start_time: Start time
        end_time: End time
    
    Returns:
        Duration in hours
    """
    # Convert to datetime for calculation
    ref_date = date.today()
    start_dt = datetime.combine(ref_date, start_time)
    end_dt = datetime.combine(ref_date, end_time)
    
    duration = end_dt - start_dt
    return duration.total_seconds() / 3600
