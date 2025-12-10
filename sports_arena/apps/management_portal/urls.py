from django.urls import path

from . import views

app_name = "management"

urlpatterns = [
    path("dashboard/", views.dashboard, name="dashboard"),
    path("llm/", views.llm_query, name="llm_query"),
    path("visitors/apply/", views.visitor_apply, name="visitor_apply"),
    path("facilities/", views.facility_list, name="facilities"),
    path("facilities/new/", views.facility_create, name="facility_create"),
    path("facilities/<int:pk>/edit/", views.facility_edit, name="facility_edit"),
    path("equipments/", views.equipment_list, name="equipments"),
    path("equipments/new/", views.equipment_create, name="equipment_create"),
    path("equipments/<int:pk>/edit/", views.equipment_edit, name="equipment_edit"),
    path("maintenance/", views.maintenance_list, name="maintenance"),
    path("maintenance/new/", views.maintenance_create, name="maintenance_create"),
    path("maintenance/<int:pk>/status/", views.maintenance_update_status, name="maintenance_update_status"),
    path("applications/", views.visitor_list, name="applications"),
    path("applications/<int:pk>/review/", views.visitor_review, name="application_review"),
    path("training-sessions/new/", views.training_session_create, name="training_session_create"),
]
