from django.contrib import admin

from .models import (
    Coach,
    Coach_Email,
    Coach_Phone,
    External_Visitor,
    Member,
    Member_Email,
    Member_Phone,
    Staff,
    Student,
)

# ============================================================
# New Models Admin
# ============================================================


class Member_PhoneInline(admin.TabularInline):
    model = Member_Phone
    extra = 1


class Member_EmailInline(admin.TabularInline):
    model = Member_Email
    extra = 1


@admin.register(Member)
class MemberAdmin(admin.ModelAdmin):
    list_display = ("member_id", "first_name", "last_name", "membership_status", "registration_date")
    search_fields = ("first_name", "last_name", "member_id")
    list_filter = ("membership_status",)
    inlines = [Member_PhoneInline, Member_EmailInline]


@admin.register(Student)
class StudentAdmin(admin.ModelAdmin):
    list_display = ("member", "student_id")
    search_fields = ("student_id", "member__first_name", "member__last_name")


@admin.register(Staff)
class StaffAdmin(admin.ModelAdmin):
    list_display = ("member", "staff_id")
    search_fields = ("staff_id", "member__first_name", "member__last_name")


@admin.register(External_Visitor)
class ExternalVisitorAdmin(admin.ModelAdmin):
    list_display = ("member", "ic_number")
    search_fields = ("ic_number", "member__first_name", "member__last_name")


class Coach_PhoneInline(admin.TabularInline):
    model = Coach_Phone
    extra = 1


class Coach_EmailInline(admin.TabularInline):
    model = Coach_Email
    extra = 1


@admin.register(Coach)
class CoachAdmin(admin.ModelAdmin):
    list_display = ("coach_id", "first_name", "last_name", "sport_type", "level")
    search_fields = ("first_name", "last_name", "sport_type")
    list_filter = ("sport_type", "level")
    inlines = [Coach_PhoneInline, Coach_EmailInline]
