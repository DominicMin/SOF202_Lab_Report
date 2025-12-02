from django.contrib import admin
from django.urls import include, path

from apps.common.views import HomePageView

urlpatterns = [
    path("", HomePageView.as_view(), name="home"),
    path("admin/", admin.site.urls),
    path("accounts/", include("accounts.urls")),
    path("member/", include("members.urls")),
    path("coach/", include("coaches.urls")),
    path("bo/", include("bookings.urls")),
    path("manager/", include("management_portal.urls")),
]
