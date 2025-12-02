from django.contrib import admin

from .models import CoachProfile, MemberProfile


@admin.register(MemberProfile)
class MemberProfileAdmin(admin.ModelAdmin):
    list_display = ("member_id", "user", "status", "affiliation")
    search_fields = ("member_id", "user__username", "user__first_name", "user__last_name")
    list_filter = ("status",)


@admin.register(CoachProfile)
class CoachProfileAdmin(admin.ModelAdmin):
    list_display = ("coach_id", "user", "specialty")
    search_fields = ("coach_id", "user__username", "user__first_name", "user__last_name")
