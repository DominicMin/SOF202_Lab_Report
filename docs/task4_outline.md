# Task 4 访问控制提纲（对应 main.tex Task 5，只含 RBAC＋行级约束）
本提纲严格对齐论文 main.tex 的 Task 5：论文只描述了基于角色的权限分级（RBAC），并通过“自己的行/自己的场次”视图来做行级约束。因此两种机制分别写作：
1) RBAC（角色/权限分级）；2) 行级访问控制（基于视图的“own-row/own-session”过滤）。两种都需给出 SQL 和 Django 前端展示，并准备截图。

## 机制一：RBAC（角色/权限分级）
### SQL 展示
- 参照 main.tex 中的角色：`dba_role`、`manager_role`、`booking_officer_role`、`coach_role`、`member_role`。
- GRANT 示例（论文已有）：对 `Booking`/`Training_Session`/`Reservation` 等表按角色授予 R/I/U/D；Member 角色仅通过视图访问。
- 验证：以 `coach1` 或 `member1` 登录，执行被允许的查询/更新成功；尝试超权限操作（如 DELETE）返回拒绝报错。
### Django 展示
- Django Admin 中创建对应 Group/Permission，映射到模型（Booking、SessionEnrollment、TrainingSession 等）。
- 视图层用 `PermissionRequiredMixin` 或 `@permission_required`；模板用 `if perms.app_label.change_model` 控制按钮显隐。
- 验证：Member 只看到自己的操作入口；Coach 不能删除会话；Manager/Admin 全部可见。
### 截图清单
- MySQL GRANT/SHOW GRANTS 成功信息。
- 被授权操作成功输出；越权操作的错误提示。
- Django Admin 组权限界面。
- 前端按钮显隐：Member/Coach/Manager 或 Admin 三个视角。

## 机制二：行级访问控制（own-row/own-session 视图）
### SQL 展示
- 论文示例视图：`Member_Booking` 过滤 `Member_ID = CURRENT_USER`；`Coach_Session_Enrollment` 过滤为自己的场次。
- 对底表 REVOKE，改对视图 GRANT（SELECT/UPDATE/INSERT）。
- 验证：member 通过视图仅能看到/改自己的行；跨用户 UPDATE/SELECT 被拒；Admin 直接查底表看到全量。
### Django 展示
- `get_queryset` 只返回 `user` 关联的记录；`form_valid` 强制 `obj.member = request.user` 或 `obj.coach = request.user`。
- 访问他人记录返回 403/404；Admin 账号可查看全部。
### 截图清单
- 视图查询结果：成员只见自有行；跨用户操作被拒绝的错误。
- Admin 直接查底表全量数据。
- 前端列表/详情：成员只见自有记录；访问他人被拦截；Admin 看到全部。

## 汇总截图与交付要求
- SQL：RBAC 授权与拒绝各 1 张；行级视图允许与拒绝各 1 张。
- Django：组权限界面 1 张；三种身份（Member/Coach/Manager|Admin）界面至少各 1 张，体现按钮显隐与 403 拦截。
- 文字说明紧贴截图，明确“能/不能编辑、删除、更新”对应的角色和对象，满足 rubric 对“清晰验证”的要求。