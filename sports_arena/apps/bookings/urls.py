from django.urls import path

from . import views

app_name = "bookings"

urlpatterns = [
    path("dashboard/", views.bo_dashboard, name="bo_dashboard"),
    path("bookings/", views.booking_list, name="booking_list"),
    path("bookings/new/", views.booking_create, name="booking_create"),
    path("bookings/<int:booking_id>/reservation/", views.reservation_create, name="reservation_create"),
    path("reservations/", views.reservation_list, name="reservation_list"),
]
