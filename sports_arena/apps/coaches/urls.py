from django.urls import path

from . import views

app_name = "coaches"

urlpatterns = [
    path("dashboard/", views.dashboard, name="dashboard"),
    path("profile/", views.profile_view, name="profile"),
    path("sessions/", views.sessions, name="sessions"),
    path("sessions/<int:session_id>/", views.session_detail, name="session_detail"),
]
