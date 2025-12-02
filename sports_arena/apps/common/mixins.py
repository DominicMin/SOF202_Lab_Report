from django.views.generic.list import MultipleObjectMixin


class MemberOwnedQuerysetMixin(MultipleObjectMixin):
    """过滤出当前会员拥有的数据，例如 Booking 或报名记录。"""

    def get_queryset(self):  # type: ignore[override]
        qs = super().get_queryset()
        member = getattr(self.request.user, "member_profile", None)
        if not member:
            return qs.none()
        return qs.filter(member=member)


class CoachOwnedQuerysetMixin(MultipleObjectMixin):
    """限制教练只能看到自己名下的课程及报名。"""

    def get_queryset(self):  # type: ignore[override]
        qs = super().get_queryset()
        coach = getattr(self.request.user, "coach_profile", None)
        if not coach:
            return qs.none()
        return qs.filter(coach=coach)


class RoleContextMixin:
    """在模板上下文中附加当前角色名，用于渲染导航。"""

    role_name: str = ""

    def get_context_data(self, **kwargs):  # type: ignore[override]
        context = super().get_context_data(**kwargs)
        context["current_role"] = self.role_name
        return context
