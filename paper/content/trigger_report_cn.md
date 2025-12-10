# 触发器报告（Triggering）
基于 Django 端的校验逻辑重写了触发器，统一放在仓库根目录的 `trigger.sql`。旧的仅检查场地冲突的触发器已移除/覆盖，新增了成员预约上限、设备占用校验、课程容量与维护 XOR 约束等规则，确保直接 SQL 操作与应用层约束一致。

## 触发器概览
- `reservation_bi_guardrails` / `reservation_bu_guardrails`（BEFORE INSERT/UPDATE on `reservation`）  
  锁定场地行，要求时段合法、场地状态为 `Available`，当天无维护（`Scheduled`/`In_Progress`）且无时间重叠的其他预约。
- `booking_bi_guardrails` / `booking_bu_guardrails`（BEFORE INSERT/UPDATE on `booking`）  
  会员最多 2 个 `Pending` 预约；关联的 `reservation` 时长不超过 3 小时，且预约日期不得早于今天、不得超过 7 天后（与 Django 表单一致）。
- `reservation_equipments_bi_guardrails` / `_bu_guardrails`（BEFORE INSERT/UPDATE on `reservation_equipments`）  
  锁定设备与预约行，要求设备状态为 `Available`、数量大于 0，且请求数量不超过「总量 - 当天维护占用 - 同时段其他预约占用」。
- `session_enrollment_bi_capacity` / `_bu_capacity`（BEFORE INSERT/UPDATE on `session_enrollment`）  
  读取对应 `training_session.Max_Capacity`，若达到上限则拒绝报名。
- `maintenance_bi_xor` / `maintenance_bu_xor`（BEFORE INSERT/UPDATE on `maintenance`）  
  强制 XOR：`Facility_ID` 与 `Equipment_ID` 必须且只能填一个。

## 设计要点
- **与 Django 校验对齐**：成员 Pending 上限、3 小时时长、7 天窗口、设备可用库存、课程容量、维护 XOR 均与表单/模型逻辑保持一致，避免绕过应用层写入脏数据。
- **并发安全**：对关键行（场地、设备、课程）使用 `FOR UPDATE` 锁，结合时间窗口交集判定，避免并发插入导致的重叠或超量占用。
- **兼容原数据**：仍保留原有场地冲突与维护检查，额外删除了过时的 `trg_check_pending_bookings`，由新的 booking 触发器统一实现。

## 使用与验证
1. 先导入基础结构（`sports_arena.sql`），再运行 `trigger.sql`。
2. 用 `SHOW TRIGGERS WHERE \`Table\` IN ('reservation','booking','reservation_equipments','session_enrollment','maintenance');` 确认触发器已加载。
3. 验证示例  
   - 场地重叠/维护：对同一 `Facility_ID`、同日、重叠时段插入 `reservation` 应触发拒绝。  
   - 会员 Pending 上限：同一 `Member_ID` 创建第 3 条 `Booking` 且状态为 `Pending` 应被拒绝。  
   - 设备占用：在同日同时间段内，累积数量超出设备总量或维护数量时应被拒绝。  
   - 课程容量：当 `session_enrollment` 报名数达到 `Max_Capacity` 后，新增报名应被拒绝。  
   - 维护 XOR：`maintenance` 同时填/同时不填 `Facility_ID` 与 `Equipment_ID` 都应报错。
