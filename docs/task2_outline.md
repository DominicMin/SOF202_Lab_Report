# Task 2 SQL 实现提纲（sports_arena）
覆盖 rubric 对“SQL Implementation”的要求：完整表创建截图、每表 6–10 行数据、六类语法各 3 条查询（含输出），必要时辅以 Django 前端页面证明数据落地。

## 评分要点对齐
- 除 Task1A 的示例外，其余 `CREATE TABLE` 均要有清晰截图；SQL 语句正确无误。
- 每张表 ≥6–10 行有效数据，提供插入/验证截图。
- 六个语法类别每类 3 条查询 + 运行结果截图；适当使用算术/字符串/别名。
- 如前端能直观呈现（列表/仪表盘/过滤），补一张 Django 页面截图强化可视化。

## 文档结构建议
1. 表创建截图汇总（Task1A 之外的表）。
2. 数据填充与验证（插入脚本 + `COUNT(*)`/抽样查询）。
3. 六类查询演示（SQL 语句 + 输出 + 可选前端佐证）。
4. 小结：与场景/评分点的对应关系。

## 1) 表创建（Task1A 以外）
- 重点表：`Member / Student / Staff / External_Visitor / Member_Email / Member_Phone / Coach / Coach_Email / Coach_Phone / Facility / Equipment / Maintenance / Visitor_Application (+ Email/Phone) / Reservation / Training_Session / Session_Enrollment / Reservation_Equipments / Booking`。
- 操作：在 MySQL 终端执行或 `source sports_arena.sql` 后，`SHOW CREATE TABLE <table>` 截图，高亮 PK/UNIQUE/FK/CHECK。

## 2) 数据填充与验证
- 参考 `sports_arena_with_data.sql` 的插入模式，为每表准备 6–10 行 INSERT；可直接 `source sports_arena_with_data.sql` 或自定义插入脚本。
- 验证截图：`SELECT COUNT(*) FROM <table>;` + 抽样 `SELECT * FROM <table> LIMIT 5;`，确保外键引用存在。
- 可用 Django Admin/列表页截图展示数据已落地（例如 Facility/Equipment 列表）。

## 3) 六类查询与示例（每类 3 条）
- **Filtering（LIKE / BETWEEN / IN）**
  - `SELECT Facility_Name, Type, Status FROM Facility WHERE Type LIKE '%Tennis%' AND Status='Available';`
  - `SELECT Reservation_ID, Reservation_Date FROM Reservation WHERE Reservation_Date BETWEEN '2025-12-01' AND '2025-12-31';`
  - `SELECT Reservation_ID, Booking_Status FROM Booking WHERE Booking_Status IN ('Pending','Confirmed');`
  - 前端佐证：`bookings/booking_list?status=Confirmed` 过滤界面。
- **Aggregate Functions（SUM / COUNT / AVG|MIN|MAX）**
  - `SELECT Type, COUNT(*) AS facility_count FROM Facility GROUP BY Type;`
  - `SELECT Reservation_ID, SUM(Quantity) AS total_equipment FROM Reservation_Equipments GROUP BY Reservation_ID;`
  - `SELECT Coach_ID, AVG(Max_Capacity) AS avg_capacity FROM Training_Session GROUP BY Coach_ID;`
  - 前端佐证：`management/dashboard` 的设施/设备/维护计数卡片。
- **Limit / Sorting**
  - `SELECT Facility_Name, Capacity FROM Facility WHERE Status='Available' ORDER BY Capacity DESC LIMIT 3;`
  - `SELECT Reservation_ID, Reservation_Date, Start_Time FROM Reservation ORDER BY Reservation_Date DESC, Start_Time DESC LIMIT 5;`
  - `SELECT Application_ID, First_Name, Status FROM Visitor_Application ORDER BY Application_Date DESC LIMIT 5;`
  - 前端佐证：`management/training_session_list`（按日期排序）或 `management/visitor_list`。
- **Join Operators（INNER / LEFT / RIGHT）**
  - INNER: `SELECT b.Reservation_ID, m.First_Name, f.Facility_Name, b.Booking_Status FROM Booking b JOIN Member m ON b.Member_ID=m.Member_ID JOIN Reservation r ON b.Reservation_ID=r.Reservation_ID JOIN Facility f ON r.Facility_ID=f.Facility_ID;`
  - LEFT: `SELECT ts.Reservation_ID, c.First_Name, f.Facility_Name, ts.Max_Capacity FROM Training_Session ts LEFT JOIN Coach c ON ts.Coach_ID=c.Coach_ID LEFT JOIN Reservation r ON ts.Reservation_ID=r.Reservation_ID LEFT JOIN Facility f ON r.Facility_ID=f.Facility_ID;`
  - RIGHT: `SELECT e.Equipment_Name, re.Reservation_ID, re.Quantity FROM Equipment e RIGHT JOIN Reservation_Equipments re ON e.Equipment_ID=re.Equipment_ID;`
  - 前端佐证：`management/training_session_detail` 展示教练+场地+报名列表（天然多表 JOIN）。
- **String / Arithmetic**
  - `SELECT Reservation_ID, TIMESTAMPDIFF(MINUTE, Start_Time, End_Time)/60 AS duration_hours FROM Reservation;`
  - `SELECT CONCAT(First_Name, ' ', Last_Name) AS member_name, Membership_Status FROM Member;`
  - `SELECT re.Reservation_ID, re.Quantity, e.Total_Quantity, (e.Total_Quantity - re.Quantity) AS remaining_theoretical FROM Reservation_Equipments re JOIN Equipment e ON re.Equipment_ID=e.Equipment_ID;`
  - 前端佐证：`members/dashboard` 或 `bookings/bo_dashboard` 展示拼接后的姓名/统计。
- **Formatting（AS / 拼接输出）**
  - `SELECT Facility_ID AS ID, Facility_Name AS Name, CONCAT(Building,'-',Floor,'-',Room_Number) AS Location FROM Facility;`
  - `SELECT b.Reservation_ID AS BookingID, CONCAT(m.First_Name,' ',m.Last_Name) AS Member, DATE_FORMAT(r.Reservation_Date,'%Y-%m-%d') AS Date FROM Booking b JOIN Member m ON b.Member_ID=m.Member_ID JOIN Reservation r ON b.Reservation_ID=r.Reservation_ID;`
  - `SELECT ts.Reservation_ID AS SessionID, CONCAT(c.First_Name,' ',c.Last_Name) AS CoachName, CONCAT(r.Start_Time,'-',r.End_Time) AS TimeSlot FROM Training_Session ts JOIN Coach c ON ts.Coach_ID=c.Coach_ID JOIN Reservation r ON ts.Reservation_ID=r.Reservation_ID;`
  - 前端佐证：`members/training_list`/`enrollment_list` 中的拼接展示。

## 4) 截图清单
- **SQL**：`SHOW CREATE TABLE`（所有表）、批量 INSERT 执行结果、`COUNT(*)` 验证、18 条查询的语句与输出（可按类别成组截图）。
- **Django**：Dashboard 计数（对应聚合）、列表页过滤/排序（对应 Filtering/Sorting）、Training Session 详情（对应 JOIN + 格式化），如页面与 SQL 结果一致即可。
