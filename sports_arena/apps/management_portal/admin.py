from django.contrib import admin

from .models import (
    Equipment,
    Facility,
    Maintenance,
    Visitor_Application,
    Visitor_Application_Email,
    Visitor_Application_Phone,
)

# ============================================================
# New Models Admin
# ============================================================


@admin.register(Facility)
class FacilityAdmin(admin.ModelAdmin):
    list_display = ("facility_id", "facility_name", "type", "status", "capacity", "building", "floor")
    list_filter = ("status", "type", "building")
    search_fields = ("facility_name", "building", "room_number")


@admin.register(Equipment)
class EquipmentAdmin(admin.ModelAdmin):
    list_display = ("equipment_id", "equipment_name", "type", "status", "total_quantity")
    list_filter = ("status", "type")
    search_fields = ("equipment_name",)


@admin.register(Maintenance)
class MaintenanceAdmin(admin.ModelAdmin):
    list_display = ("maintenance_id", "get_target", "scheduled_date", "status", "completion_date")
    list_filter = ("status", "scheduled_date")
    search_fields = ("facility__facility_name", "equipment__equipment_name")
    
    def get_target(self, obj):
        """Display maintenance target (facility or equipment)."""
        if obj.facility:
            return f"Facility: {obj.facility.facility_name}"
        elif obj.equipment:
            return f"Equipment: {obj.equipment.equipment_name}"
        return "N/A"
    get_target.short_description = "Target"


class Visitor_Application_PhoneInline(admin.TabularInline):
    model = Visitor_Application_Phone
    extra = 1


class Visitor_Application_EmailInline(admin.TabularInline):
    model = Visitor_Application_Email
    extra = 1


@admin.register(Visitor_Application)
class VisitorApplicationAdmin(admin.ModelAdmin):
    list_display = ("application_id", "first_name", "last_name", "ic_number", "status", "application_date")
    list_filter = ("status", "application_date")
    search_fields = ("first_name", "last_name", "ic_number")
    inlines = [Visitor_Application_PhoneInline, Visitor_Application_EmailInline]
