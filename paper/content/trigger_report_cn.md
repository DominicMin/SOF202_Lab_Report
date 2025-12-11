# 触发器报告（Task 3 – Triggering）

Task 3 需要选择两种触发事件（INSERT/UPDATE/DELETE），给出 MySQL 触发器代码，并展示触发前后的效果。本仓库的 `trigger.sql` 已按 sports_arena 场景实现 INSERT、DELETE 两类触发器。

## 触发器 1：`reservation_bi_guardrails`（`reservation` 表 BEFORE INSERT）
- 业务规则：防止无效预订（开始时间不早于结束时间、场地不可用）、阻止同一场地同一天的时间段重叠；验证通过后将场地状态置为 `Occupied`。
- 位置：仓库根目录 `trigger.sql`。
- 演示步骤（截屏用）：
  1) 查看场地状态和已存在的预约：  
     `SELECT Facility_ID, Status FROM facility WHERE Facility_ID = 4;`  
     `SELECT Reservation_ID, Reservation_Date, Start_Time, End_Time FROM reservation WHERE Facility_ID = 4;`
  2) 尝试插入重叠时间段（期望触发器抛错并显示错误信息）：  
     ```sql
     INSERT INTO reservation (Reservation_Date, Start_Time, End_Time, Facility_ID)
     VALUES ('2025-12-11', '12:02:00', '12:30:00', 4);
     ```
  3) 插入不冲突的预约（应成功并将场地改为 `Occupied`）：  
     ```sql
     INSERT INTO reservation (Reservation_Date, Start_Time, End_Time, Facility_ID)
     VALUES ('2025-12-12', '10:00:00', '11:00:00', 4);
     ```
  4) 再次查询，展示新预约及场地状态变更。

## 触发器 2：`reservation_ad_release_facility`（`reservation` 表 AFTER DELETE）
- 业务规则：当某场地的最后一条预约被删除时，自动把该场地状态恢复为 `Available`（不会改动其他状态）。
- 位置：`trigger.sql`。
- 演示步骤（截屏用）：
  1) 确认场地当前为 `Occupied` 且至少有一条预约（复用上面的查询）。
  2) 删除预约：`DELETE FROM reservation WHERE Reservation_ID = <id>;`
  3) 再查该场地剩余预约和状态，验证最后一条删除后状态恢复为 `Available`。

## 报告所需证据清单
- 触发器定义截图：可用 `SHOW TRIGGERS LIKE 'reservation%';`。
- 每个触发器的“前/后”数据截图：成功插入/删除后的结果，以及重叠插入被阻止时的错误提示。
- 简述每个触发器对应的业务规则，以及如何满足 sports_arena 预订场景的要求。 
