from django.urls import path

from . import views

app_name = "members"

urlpatterns = [
    path("dashboard/", views.dashboard, name="dashboard"),
    path("profile/", views.profile_view, name="profile"),
    path("bookings/", views.booking_list, name="bookings"),
    path("bookings/new/", views.booking_create, name="booking_create"),
    path("bookings/<int:booking_id>/cancel/", views.booking_cancel, name="booking_cancel"),
    path("trainings/", views.training_list, name="trainings"),
    path("trainings/<int:session_id>/enroll/", views.training_enroll, name="training_enroll"),
    path("trainings/<int:session_id>/drop/", views.training_drop, name="training_drop"),
    path("trainings/enrollments/", views.enrollment_list, name="enrollments"),
]
