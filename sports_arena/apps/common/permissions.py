from functools import wraps
from typing import Iterable

from django.contrib.auth.decorators import login_required
from django.core.exceptions import PermissionDenied

# 统一维护角色常量，方便视图和模板引用
ROLE_DBA = "dba_role"
ROLE_MANAGER = "manager_role"
ROLE_BOOKING_OFFICER = "booking_officer_role"
ROLE_COACH = "coach_role"
ROLE_MEMBER = "member_role"


def _has_role(user, roles: Iterable[str]) -> bool:
    if not user.is_authenticated:
        return False
    if user.is_superuser:
        return True
    return user.groups.filter(name__in=list(roles)).exists()


def role_required(*roles: str):

    def decorator(view_func):
        @login_required
        @wraps(view_func)
        def _wrapped(request, *args, **kwargs):
            target_roles = roles or []
            if not _has_role(request.user, target_roles):
                raise PermissionDenied("The current account does not have permission to access this page.")
            return view_func(request, *args, **kwargs)

        return _wrapped

    return decorator


class RoleRequiredMixin:

    required_roles: Iterable[str] = tuple()

    def dispatch(self, request, *args, **kwargs):  # type: ignore[override]
        if not _has_role(request.user, self.required_roles):
            raise PermissionDenied("The current account does not have permission to access this page.")
        return super().dispatch(request, *args, **kwargs)
