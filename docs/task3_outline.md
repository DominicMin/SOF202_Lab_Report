# Task 3 触发器提纲（Triggering）
满足 rubric 对“两条触发器 + BEFORE/AFTER 证据 + 无语法错误”的要求，基于 sports_arena 现有表设计易演示的逻辑。

## 评分要点对齐
- 选择 2 个不同事件类型（建议 INSERT + UPDATE）触发器。
- 提供创建语句、`SHOW TRIGGERS` 确认、触发前后的数据快照/报错截图。
- 结合业务场景（容量/维护状态），解释触发效果与安全性。

## 触发器方案概览
1) **BEFORE INSERT ON Session_Enrollment（防超容/重复报名）**  
   - 逻辑：查 `Training_Session.Max_Capacity` 与当前报名数，若 `count >= Max_Capacity` 则 `SIGNAL SQLSTATE '45000'` 拒绝；若已存在同一 Member 报名也拒绝（兜底，尽管有 UNIQUE）。  
   - 价值：保护训练课程容量，保证实体/参照完整性在高并发下仍成立。
2) **AFTER UPDATE ON Maintenance（同步完工日期与资源状态）**  
   - 逻辑：当 `NEW.Status='Completed'` 时，自动填充 `Completion_Date = CURDATE()`；若维护对象是 Facility/Equipment，则将对应 `Status` 调整为 `Available`。当状态改为 `In_Progress`/`Scheduled` 时，将设施/设备状态设为 `Under_Maintenance`。  
   - 价值：确保维护工单与被维护资源状态一致，不依赖应用层遗忘更新。
> 如需覆盖 DELETE 事件，可拓展：AFTER DELETE ON Booking 将空闲场地恢复 `Available`（检查该 Facility 是否仍有未来 Reservation）。

## SQL 脚本草案（示意）
```sql
DELIMITER $$
CREATE TRIGGER trg_enroll_capacity
BEFORE INSERT ON Session_Enrollment
FOR EACH ROW
BEGIN
  DECLARE current_count INT;
  DECLARE max_cap INT;
  SELECT COUNT(*) INTO current_count FROM Session_Enrollment WHERE Reservation_ID = NEW.Reservation_ID;
  SELECT Max_Capacity INTO max_cap FROM Training_Session WHERE Reservation_ID = NEW.Reservation_ID;
  IF current_count >= max_cap THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Session is full';
  END IF;
END$$
DELIMITER ;
```
```sql
DELIMITER $$
CREATE TRIGGER trg_maintenance_status
AFTER UPDATE ON Maintenance
FOR EACH ROW
BEGIN
  IF NEW.Status = 'Completed' THEN
    UPDATE Maintenance SET Completion_Date = CURDATE() WHERE Maintenance_ID = NEW.Maintenance_ID;
    IF NEW.Facility_ID IS NOT NULL THEN
      UPDATE Facility SET Status='Available' WHERE Facility_ID = NEW.Facility_ID;
    ELSEIF NEW.Equipment_ID IS NOT NULL THEN
      UPDATE Equipment SET Status='Available' WHERE Equipment_ID = NEW.Equipment_ID;
    END IF;
  ELSEIF NEW.Status IN ('Scheduled','In_Progress') THEN
    IF NEW.Facility_ID IS NOT NULL THEN
      UPDATE Facility SET Status='Under_Maintenance' WHERE Facility_ID = NEW.Facility_ID;
    ELSEIF NEW.Equipment_ID IS NOT NULL THEN
      UPDATE Equipment SET Status='Under_Maintenance' WHERE Equipment_ID = NEW.Equipment_ID;
    END IF;
  END IF;
END$$
DELIMITER ;
```

## 演示与截图计划
- **创建确认**：执行触发器脚本 + `SHOW TRIGGERS LIKE '%Enrollment%' / '%Maintenance%'` 截图。
- **触发器 1（超容）**  
  1. `SELECT Max_Capacity, COUNT(*)` 查看目标 `Training_Session` 及现有报名数。  
  2. 插入至容量上限前一条（成功截图）。  
  3. 再插入一条超容记录，触发 `SIGNAL` 报错截图；`SELECT COUNT(*)` 证明未新增。  
  4. 可选 Django 前端：成员端 `training_enroll` 页面在超容后提示/无新增记录。
- **触发器 2（维护状态同步）**  
  1. `SELECT * FROM Maintenance JOIN Facility/Equipment` 查看原始状态与 `Completion_Date`。  
  2. `UPDATE Maintenance SET Status='In_Progress' ...`，截图目标 Facility/Equipment 状态变为 `Under_Maintenance`。  
  3. `UPDATE Maintenance SET Status='Completed' ...`，截图 `Completion_Date` 自动填充、Facility/Equipment 状态恢复 `Available`。  
  4. 可选 Django 前端：`management/maintenance_list` 与 `management/facility_list` 对比前后状态。

## 交付小结
- 两条触发器分别覆盖 INSERT / UPDATE 事件，语法与场景匹配，含错误与成功示例截图。
- 文字说明侧重“触发条件、执行逻辑、对业务的保护作用”，满足 rubric 对“清晰证据 + 正确性”的要求。
