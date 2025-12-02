from django.contrib import admin

from .models import Booking, Reservation, ReservationEquipment, SessionEnrollment, TrainingSession


@admin.register(Booking)
class BookingAdmin(admin.ModelAdmin):
    list_display = ("id", "member", "facility", "requested_start", "status")
    list_filter = ("status", "facility")
    search_fields = ("member__member_id", "member__user__username")


@admin.register(Reservation)
class ReservationAdmin(admin.ModelAdmin):
    list_display = ("id", "facility", "start_time", "end_time")


admin.site.register(ReservationEquipment)
admin.site.register(TrainingSession)
admin.site.register(SessionEnrollment)
