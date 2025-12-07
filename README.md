# 体育场馆预约管理系统（Sports Arena Reservation System）

## 功能亮点
- 角色模型（RBAC）：DBA/Manager/Booking Officer/Coach/Member，使用 `Group + 装饰器` 控制访问。
- 注册/登录：支持前台注册会员或教练账号，并自动分配 Group。
- 会员门户：个人资料维护、预约创建/取消、培训课程报名与退选。
- 教练门户：课程列表、报名名单、课程备注维护。
- Booking Officer：录入预约、将预约转为 Reservation 并管理器材分配。
- 管理员：场地/器材/维护/访客审批等核心主数据管理。

## 代码结构
```
sports_arena/
├─ manage.py
├─ requirements.txt
├─ .env.example
├─ sports_arena/                # 项目配置(settings/urls)
├─ apps/
│  ├─ accounts/                 # 用户、角色、注册视图、Group 初始化
│  ├─ bookings/                 # Booking/Reservation/Training 等模型与 BO 视图
│  ├─ members/                  # 会员门户视图与表单
│  ├─ coaches/                  # 教练门户视图与表单
│  ├─ management_portal/        # 管理员视图、Facility/Equipment 等模型
│  └─ common/                   # 权限装饰器、通用 mixin
├─ templates/                   # base.html、导航、各 app 模板
└─ static/                      # Bootstrap 辅助样式
```

## 环境准备

**必须先运行init_db.sql配置数据库**

```bash
python -m venv .venv
.venv\\Scripts\\activate  # PowerShell
pip install -r requirements.txt
cp .env.example .env  # 或自行设置环境变量
```
在 `.env` 中填写 MySQL 连接信息，然后执行：
```bash
python manage.py migrate
python manage.py seed_roles
python manage.py createsuperuser
python manage.py runserver
```

## 后续规划
- 增加“您无权限访问”页面
- 核对所有功能与论文对齐（已完成）
- 加入大模型问数功能