# Task 1 数据完整性提纲（基于 sports_arena.sql ＋ Django）
面向 description.md 与 rubric.md 的“Database Integrity”要求，结合现有 schema 与前端校验，确保语句准确、截图清晰、解释到位。

## 目标与评分要点对齐
- 以 Assignment 场景为蓝本，给出 3 类完整性（Domain / Entity / Referential）各 ≥1 个带约束的 `CREATE TABLE` 示例。
- SQL 语句执行成功的截图 + 触发约束时报错的证据；解释要清楚约束如何设计、如何被应用层保持。
- 选择 sports_arena 中已存在且有代表性的表，减少无关新表。

## 任务 1A：按三类完整性给出 CREATE TABLE 示例
- **Domain Integrity（字段取值约束）**
  - 例：`Equipment` 的数量非负、`Reservation` 的起止时间合法、`Training_Session` 的 `Max_Capacity` 非负。
  - 示意 SQL（与现有 schema 一致，可直接执行/展示）：
    ```sql
    CREATE TABLE Equipment (
      Equipment_ID INT AUTO_INCREMENT PRIMARY KEY,
      Equipment_Name VARCHAR(100) NOT NULL,
      Type VARCHAR(50) NOT NULL,
      Status VARCHAR(20) NOT NULL,
      Total_Quantity INT UNSIGNED NOT NULL,
      CONSTRAINT equipment_chk_1 CHECK (Total_Quantity >= 0)
    ) ENGINE=InnoDB;
    ```
    ```sql
    CREATE TABLE Reservation (
      Reservation_ID INT AUTO_INCREMENT PRIMARY KEY,
      Reservation_Date DATE NOT NULL,
      Start_Time TIME NOT NULL,
      End_Time TIME NOT NULL,
      Facility_ID INT NOT NULL,
      UNIQUE KEY uq_facility_slot (Facility_ID, Reservation_Date, Start_Time),
      CONSTRAINT chk_reservation_time CHECK (Start_Time < End_Time),
      CONSTRAINT fk_reservation_facility FOREIGN KEY (Facility_ID)
        REFERENCES Facility(Facility_ID) ON DELETE RESTRICT ON UPDATE RESTRICT
    ) ENGINE=InnoDB;
    ```
- **Entity Integrity（行级唯一性/非空）**
  - 例：`Member` / `Coach` 的主键自增，`Reservation` 的复合唯一约束防止双重预订，`Member_Phone` / `Coach_Email` 的 `UNIQUE (外键, 值)`。
  - 示意 SQL：
    ```sql
    CREATE TABLE Member (
      Member_ID INT AUTO_INCREMENT PRIMARY KEY,
      First_Name VARCHAR(50) NOT NULL,
      Last_Name VARCHAR(50) NOT NULL,
      Registration_Date DATE NOT NULL,
      Membership_Status VARCHAR(20) NOT NULL,
      user_id INT UNIQUE
    );
    ```
- **Referential Integrity（外键依赖）**
  - 例：`Booking` 依赖 `Reservation` + `Member`，`Training_Session` 依赖 `Reservation` + `Coach`，`Reservation_Equipments` 依赖 `Reservation` + `Equipment`。
  - 示意 SQL（与 sports_arena.sql 对齐）：
    ```sql
    CREATE TABLE Booking (
      Reservation_ID INT PRIMARY KEY,
      Booking_Status VARCHAR(20) NOT NULL,
      Member_ID INT NOT NULL,
      CONSTRAINT fk_booking_member FOREIGN KEY (Member_ID) REFERENCES Member(Member_ID) ON DELETE RESTRICT ON UPDATE RESTRICT,
      CONSTRAINT fk_booking_reservation FOREIGN KEY (Reservation_ID) REFERENCES Reservation(Reservation_ID) ON DELETE RESTRICT ON UPDATE RESTRICT
    ) ENGINE=InnoDB;
    ```

## 任务 1B：约束应用与维护说明
- **Domain**：CHECK 约束 + 合理数据类型；Django 表单二次校验（如 `ReservationForm.clean` 检查 `End_Time > Start_Time`，`BookingForm` 校验 3 小时上限 / 1 周内预约，`ReservationEquipmentForm` 校验可用库存）。
- **Entity**：PK/UNIQUE 确保一行一义；多值属性表（Phone/Email）用 `unique_together`；Django Model 一致映射，Admin/表单自动阻止重复。
- **Referential**：外键 `ON DELETE/UPDATE RESTRICT` 防止孤儿记录；Django `select_related` / form 下拉限制只允许已存在的外键值；必要时举例“删除 Member 被 FK 拒绝”的报错。

## 截图计划（SQL ＋ Django 前端）
- **SQL 截图**
  - MySQL 终端/Workbench 执行上述 `CREATE TABLE` 语句的成功输出。
  - `SHOW CREATE TABLE Equipment / Reservation / Booking` 高亮 CHECK、PK、FK。
  - 违规示例：插入 `Total_Quantity = -1` 或 `Start_Time >= End_Time` 被 CHECK 拒绝；插入不存在的 `Member_ID` 触发 FK 报错。
- **Django 前端（辅助展示约束生效，可选但推荐）**
  - `management/training_session_form` 或 `bookings/booking_form` 中填写结束时间早于开始时间的错误提示截图。
  - `bookings/booking_form` 超过 3 小时/1 周后的表单报错；`reservation_form` 重叠时段冲突的 ValidationError。
  - `bookings/booking_list` / `management/training_session_list` 展示外键成功关联（Facility/Member/Coach 信息同时出现），佐证引用完整性。
