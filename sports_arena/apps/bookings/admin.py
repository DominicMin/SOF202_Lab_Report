from django.contrib import admin

from .models import (
    Booking,
    Reservation,
    Reservation_Equipments,
    ReservationEquipment,
    Session_Enrollment,
    SessionEnrollment,
    TrainingSession,
)

# ============================================================
# New Models Admin
# ============================================================


class Reservation_EquipmentsInline(admin.TabularInline):
    model = Reservation_Equipments
    extra = 1


@admin.register(Reservation)
class ReservationAdmin(admin.ModelAdmin):
    list_display = ("reservation_id", "facility", "reservation_date", "start_time", "end_time")
    list_filter = ("reservation_date", "facility")
    search_fields = ("facility__facility_name",)
    inlines = [Reservation_EquipmentsInline]


@admin.register(Booking)
class BookingAdmin(admin.ModelAdmin):
    list_display = ("reservation", "member", "booking_status")
    list_filter = ("booking_status",)
    search_fields = ("member__first_name", "member__last_name", "reservation__facility__facility_name")


@admin.register(TrainingSession)
class TrainingSessionAdmin(admin.ModelAdmin):
    list_display = ("reservation", "coach", "max_capacity")
    search_fields = ("coach__first_name", "coach__last_name", "reservation__facility__facility_name")


@admin.register(Session_Enrollment)
class SessionEnrollmentAdmin(admin.ModelAdmin):
    list_display = ("training_session", "member")
    search_fields = ("member__first_name", "member__last_name")