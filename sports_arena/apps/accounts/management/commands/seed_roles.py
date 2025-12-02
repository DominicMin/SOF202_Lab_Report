from django.contrib.auth.models import Group
from django.core.management.base import BaseCommand

from common.permissions import (
    ROLE_BOOKING_OFFICER,
    ROLE_COACH,
    ROLE_DBA,
    ROLE_MANAGER,
    ROLE_MEMBER,
)


class Command(BaseCommand):
    help = "初始化项目所需的角色(Group)"

    def handle(self, *args, **options):
        for role in [
            ROLE_DBA,
            ROLE_MANAGER,
            ROLE_BOOKING_OFFICER,
            ROLE_COACH,
            ROLE_MEMBER,
        ]:
            group, created = Group.objects.get_or_create(name=role)
            if created:
                self.stdout.write(self.style.SUCCESS(f"创建角色: {role}"))
            else:
                self.stdout.write(self.style.WARNING(f"角色已存在: {role}"))

        self.stdout.write(self.style.SUCCESS("角色初始化完成，可在 admin 中继续配置权限"))
