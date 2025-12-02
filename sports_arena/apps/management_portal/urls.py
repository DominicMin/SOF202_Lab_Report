from django.urls import path

from . import views

app_name = "management"

urlpatterns = [
    path("dashboard/", views.dashboard, name="dashboard"),
    path("visitors/apply/", views.visitor_apply, name="visitor_apply"),
    path("facilities/", views.facility_list, name="facilities"),
    path("facilities/new/", views.facility_create, name="facility_create"),
    path("facilities/<int:pk>/edit/", views.facility_edit, name="facility_edit"),
    path("equipments/", views.equipment_list, name="equipments"),
    path("equipments/new/", views.equipment_create, name="equipment_create"),
    path("maintenance/", views.maintenance_list, name="maintenance"),
    path("maintenance/new/", views.maintenance_create, name="maintenance_create"),
    path("applications/", views.visitor_list, name="applications"),
    path("applications/<int:pk>/review/", views.visitor_review, name="application_review"),
]
