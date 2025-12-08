# 体育场馆预约管理系统（Sports Arena Reservation System）

基于 Django + MySQL 的场馆预约管理项目，按论文数据模型实现会员/教练/访客全流程，带角色门户、业务校验和自定义 403/404 页面。

## 项目概览
- 角色与入口：DBA/Manager/Booking Officer/Coach/Member 分别对应 `admin/`、`/manager/dashboard/`、`/bo/dashboard/`、`/coach/dashboard/`、`/member/dashboard/`；`/accounts/dashboard/` 会按角色重定向。
- 注册登录：前台 `/accounts/register/` 支持 Student/Staff/Coach 自注册并自动分配 Group 与基础档案；`/accounts/login/` 登录。
- 会员门户：查看/更新个人信息、创建或取消预约、浏览培训课程并报名/退选。
- 教练门户：维护个人资料、查看自己开设的培训班及报名名单。
- Booking Officer：新建会员预约、查看预约与器材分配、处理审批/拒绝。
- 管理员：场地、器材、维护记录、访客申请审批，以及访客自助申请入口 `/manager/visitors/apply/`。

## 主要数据模型与业务规则
- Member 超类 + Student/Staff/External_Visitor 子类；Member_Phone/Member_Email 多值属性。
- Coach 及其多值联系信息；Visitor_Application（含多值联系方式）审批后自动生成 Member + External_Visitor 并回填关联。
- Facility、Equipment、Maintenance（XOR：维护记录必须且只能指向场地或器材）。
- Reservation 超类 + Booking（会员预约）+ TrainingSession（教练课程）；Reservation_Equipments 预约-器材弱实体；Session_Enrollment 培训报名。
- 关键校验：时间段不重叠、结束晚于开始、单次预约不超过 3 小时、仅可提前 1 周预约、会员最多 2 条 Pending、器材可用数量=库存-重叠预约-维护占用。

## 目录结构
```
.
├─ README.md
├─ init_db.sql                  # 论文版 DDL + 触发器（执行会 DROP/CREATE DB）
├─ docs/description.pdf
└─ sports_arena/
   ├─ manage.py
   ├─ requirements.txt
   ├─ config.example.yaml       # 配置文件示例
   ├─ apps/
   │  ├─ accounts/             # 注册/登录、Group 初始化、Member/Coach 档案
   │  ├─ bookings/             # Reservation/Booking/Training 及 BO 视图
   │  ├─ members/              # 会员门户
   │  ├─ coaches/              # 教练门户
   │  ├─ management_portal/    # 场地/器材/维护/访客审批
   │  └─ common/               # 权限装饰器、首页与 403/404 处理
   ├─ templates/               # base/home/403/404 及各模块模板
   └─ static/                  # 样式与资源
```

## 快速开始
依赖：Python 3.11+、MySQL 8+（需安装 `mysqlclient` 编译依赖）。

```bash
cd sports_arena
python -m venv .venv
.venv\Scripts\activate          # PowerShell
pip install -r requirements.txt
cp .env.example .env            # 填写 DB 连接与 DJANGO_SECRET_KEY
```

数据库初始化（两种方式二选一）：
- 推荐：`python manage.py migrate` 直接用 Django 迁移创建表结构。
- 若需论文版触发器/DDL：在空库运行 `mysql -uUSER -p < ../init_db.sql`（会删除同名库），随后在项目中执行 `python manage.py migrate --fake-initial` 以同步迁移状态。

初始数据与账号：
```bash
python manage.py seed_roles     # 创建角色 Group：dba_role / manager_role / booking_officer_role / coach_role / member_role
python manage.py createsuperuser
python manage.py runserver
```
- 会员/教练可通过 `/accounts/register/` 自助注册。
- Manager/Booking Officer 需在 admin 中创建用户、分配对应 Group；Manager 需在 admin 为该用户建立 Member + Staff 记录以便审批访客。

## 常用入口
- 登录/注册：`/accounts/login/`、`/accounts/register/`
- 角色跳转：`/accounts/dashboard/`
- 会员：`/member/dashboard/`、预约 `/member/bookings/new/`、培训 `/member/trainings/`
- 教练：`/coach/dashboard/`
- Booking Officer：`/bo/dashboard/`
- 管理员：`/manager/dashboard/`、访客申请 `/manager/visitors/apply/`

## 后续工作
- 增加测试
