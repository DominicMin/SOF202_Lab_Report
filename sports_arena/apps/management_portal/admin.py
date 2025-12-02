from django.contrib import admin

from .models import Equipment, ExternalVisitor, Facility, Maintenance, VisitorApplication

admin.site.register(Facility)
admin.site.register(Equipment)
admin.site.register(Maintenance)
admin.site.register(VisitorApplication)
admin.site.register(ExternalVisitor)
