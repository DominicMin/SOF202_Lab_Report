START TRANSACTION;

/*==================================================
  可选：创建数据库并切换
==================================================*/
DROP DATABASE IF EXISTS sports_arena;
CREATE DATABASE IF NOT EXISTS sports_arena
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE sports_arena;

/*==================================================
  1. 基础实体：Member 及三种子类型
==================================================*/

CREATE TABLE Member (
  Member_ID         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  First_Name        VARCHAR(50) NOT NULL,
  Last_Name         VARCHAR(50) NOT NULL,
  Registration_Date DATE        NOT NULL,
  Membership_Status ENUM('Active','Inactive','Pending_Approval') NOT NULL
) ENGINE=InnoDB;

/* ---- 子类：Student / Staff / External_Visitor ---- */
/* 采用“超类主键下推”，Member_ID 既是 PK 又是 FK → Member */

CREATE TABLE Student (
  Member_ID INT UNSIGNED PRIMARY KEY,
  Student_ID VARCHAR(20) NOT NULL UNIQUE,
  CONSTRAINT fk_student_member
    FOREIGN KEY (Member_ID)
    REFERENCES Member(Member_ID)
    ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Staff (
  Member_ID INT UNSIGNED PRIMARY KEY,
  Staff_ID  VARCHAR(20) NOT NULL UNIQUE,
  CONSTRAINT fk_staff_member
    FOREIGN KEY (Member_ID)
    REFERENCES Member(Member_ID)
    ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE External_Visitor (
  Member_ID INT UNSIGNED PRIMARY KEY,
  IC_Number VARCHAR(30) NOT NULL UNIQUE,
  CONSTRAINT fk_extvisitor_member
    FOREIGN KEY (Member_ID)
    REFERENCES Member(Member_ID)
    ON DELETE CASCADE
) ENGINE=InnoDB;

/*==================================================
  2. 多值属性：Member_Phone / Member_Email
==================================================*/

CREATE TABLE Member_Phone (
  Member_ID    INT UNSIGNED  NOT NULL,
  Phone_Number VARCHAR(20)   NOT NULL,
  PRIMARY KEY (Member_ID, Phone_Number),
  CONSTRAINT fk_member_phone_member
    FOREIGN KEY (Member_ID)
    REFERENCES Member(Member_ID)
    ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Member_Email (
  Member_ID    INT UNSIGNED  NOT NULL,
  Email_Address VARCHAR(100) NOT NULL,
  PRIMARY KEY (Member_ID, Email_Address),
  CONSTRAINT fk_member_email_member
    FOREIGN KEY (Member_ID)
    REFERENCES Member(Member_ID)
    ON DELETE CASCADE
) ENGINE=InnoDB;

/*==================================================
  3. Coach 及其联系方式
==================================================*/

CREATE TABLE Coach (
  Coach_ID   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  First_Name VARCHAR(50) NOT NULL,
  Last_Name  VARCHAR(50) NOT NULL,
  Sport_Type VARCHAR(50) NOT NULL,  -- 专项运动类别
  Level      VARCHAR(20) NOT NULL   -- 认证级别
) ENGINE=InnoDB;

CREATE TABLE Coach_Phone (
  Coach_ID     INT UNSIGNED NOT NULL,
  Phone_Number VARCHAR(20)  NOT NULL,
  PRIMARY KEY (Coach_ID, Phone_Number),
  CONSTRAINT fk_coach_phone_coach
    FOREIGN KEY (Coach_ID)
    REFERENCES Coach(Coach_ID)
    ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Coach_Email (
  Coach_ID      INT UNSIGNED  NOT NULL,
  Email_Address VARCHAR(100)  NOT NULL,
  PRIMARY KEY (Coach_ID, Email_Address),
  CONSTRAINT fk_coach_email_coach
    FOREIGN KEY (Coach_ID)
    REFERENCES Coach(Coach_ID)
    ON DELETE CASCADE
) ENGINE=InnoDB;

/*==================================================
  4. Facility & Equipment
==================================================*/

CREATE TABLE Facility (
  Facility_ID   INT UNSIGNED PRIMARY KEY,
  Facility_Name VARCHAR(100) NOT NULL,
  Type          VARCHAR(50)  NOT NULL,
  Status        ENUM('Available','Under_Maintenance','Unavailable') NOT NULL,
  Capacity      INT UNSIGNED NOT NULL,
  Building      VARCHAR(50)  NOT NULL,
  Floor         TINYINT      NOT NULL,
  Room_Number   VARCHAR(20)  NOT NULL,
  CONSTRAINT chk_facility_capacity
    CHECK (Capacity > 0)
) ENGINE=InnoDB;

CREATE TABLE Equipment (
  Equipment_ID   INT UNSIGNED PRIMARY KEY,
  Equipment_Name VARCHAR(100) NOT NULL,
  Type           VARCHAR(50)  NOT NULL,
  Status         ENUM('Available','In_Use','Under_Maintenance','Damaged') NOT NULL,
  Total_Quantity INT UNSIGNED NOT NULL,
  CONSTRAINT chk_equipment_total_qty
    CHECK (Total_Quantity >= 0)
  -- Available_Quantity 为派生属性，不在表内存储
) ENGINE=InnoDB;

/*==================================================
  5. Reservation（超类）+ Booking + Training_Session
==================================================*/

CREATE TABLE Reservation (
  Reservation_ID   INT UNSIGNED PRIMARY KEY,
  Facility_ID      INT UNSIGNED NOT NULL,
  Reservation_Date DATE         NOT NULL,
  Start_Time       TIME         NOT NULL,
  End_Time         TIME         NOT NULL,
  CONSTRAINT fk_reservation_facility
    FOREIGN KEY (Facility_ID)
    REFERENCES Facility(Facility_ID),
  CONSTRAINT chk_reservation_time
    CHECK (Start_Time < End_Time),
  -- 结构层唯一约束：同一场地、同一日期、相同开始时间只能有一条记录
  CONSTRAINT uq_facility_timeslot
    UNIQUE (Facility_ID, Reservation_Date, Start_Time)
) ENGINE=InnoDB;

CREATE INDEX idx_reservation_facility_date
  ON Reservation(Facility_ID, Reservation_Date);

/* ---- Booking: Reservation 的子类，会员普通预订 ---- */

CREATE TABLE Booking (
  Reservation_ID INT UNSIGNED PRIMARY KEY,
  Member_ID      INT UNSIGNED NOT NULL,
  Booking_Status ENUM('Pending','Confirmed','Cancelled') NOT NULL,
  CONSTRAINT fk_booking_reservation
    FOREIGN KEY (Reservation_ID)
    REFERENCES Reservation(Reservation_ID)
    ON DELETE CASCADE,
  CONSTRAINT fk_booking_member
    FOREIGN KEY (Member_ID)
    REFERENCES Member(Member_ID)
) ENGINE=InnoDB;

CREATE INDEX idx_booking_member
  ON Booking(Member_ID);

/* ---- Training_Session: Reservation 的子类，教练开课 ---- */

CREATE TABLE Training_Session (
  Reservation_ID INT UNSIGNED PRIMARY KEY,
  Coach_ID       INT UNSIGNED NOT NULL,
  Max_Capacity   INT UNSIGNED NOT NULL,
  CONSTRAINT fk_ts_reservation
    FOREIGN KEY (Reservation_ID)
    REFERENCES Reservation(Reservation_ID)
    ON DELETE CASCADE,
  CONSTRAINT fk_ts_coach
    FOREIGN KEY (Coach_ID)
    REFERENCES Coach(Coach_ID)
    ON DELETE RESTRICT,
  CONSTRAINT chk_ts_capacity
    CHECK (Max_Capacity > 0)
) ENGINE=InnoDB;

CREATE INDEX idx_ts_coach
  ON Training_Session(Coach_ID);

/*==================================================
  6. 预约-设备 关联（弱实体）：Reservation_Equipments
==================================================*/

CREATE TABLE Reservation_Equipments (
  Reservation_ID INT UNSIGNED NOT NULL,
  Equipment_ID   INT UNSIGNED NOT NULL,
  Quantity       INT UNSIGNED NOT NULL,
  PRIMARY KEY (Reservation_ID, Equipment_ID),
  CONSTRAINT fk_re_reservation
    FOREIGN KEY (Reservation_ID)
    REFERENCES Reservation(Reservation_ID)
    ON DELETE CASCADE,
  CONSTRAINT fk_re_equipment
    FOREIGN KEY (Equipment_ID)
    REFERENCES Equipment(Equipment_ID)
    ON DELETE RESTRICT,
  CONSTRAINT chk_re_quantity
    CHECK (Quantity > 0)
) ENGINE=InnoDB;

/*==================================================
  7. 课程报名（弱实体）：Session_Enrollment
==================================================*/

CREATE TABLE Session_Enrollment (
  Reservation_ID INT UNSIGNED NOT NULL,
  Member_ID      INT UNSIGNED NOT NULL,
  PRIMARY KEY (Reservation_ID, Member_ID),
  CONSTRAINT fk_se_session
    FOREIGN KEY (Reservation_ID)
    REFERENCES Training_Session(Reservation_ID)
    ON DELETE CASCADE,
  CONSTRAINT fk_se_member
    FOREIGN KEY (Member_ID)
    REFERENCES Member(Member_ID)
    ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE INDEX idx_se_member
  ON Session_Enrollment(Member_ID);

/*==================================================
  8. Maintenance（独立实体，带 XOR 约束）
==================================================*/

CREATE TABLE Maintenance (
  Maintenance_ID  INT UNSIGNED PRIMARY KEY,
  Scheduled_Date  DATE        NOT NULL,
  Completion_Date DATE        NULL,
  Status          ENUM('Scheduled','In_Progress','Completed','Cancelled') NOT NULL,
  Description     TEXT        NULL,
  Facility_ID     INT UNSIGNED NULL,
  Equipment_ID    INT UNSIGNED NULL,
  CONSTRAINT fk_maintenance_facility
    FOREIGN KEY (Facility_ID)
    REFERENCES Facility(Facility_ID)
    ON DELETE RESTRICT,
  CONSTRAINT fk_maintenance_equipment
    FOREIGN KEY (Equipment_ID)
    REFERENCES Equipment(Equipment_ID)
    ON DELETE RESTRICT,
  -- XOR 约束：必须且只能指向“设施”或“器材”中的一个
  CONSTRAINT chk_maintenance_target
    CHECK (
      (Facility_ID  IS NOT NULL AND Equipment_ID IS NULL) OR
      (Facility_ID  IS NULL     AND Equipment_ID IS NOT NULL)
    )
) ENGINE=InnoDB;

CREATE INDEX idx_maint_facility_date
  ON Maintenance(Facility_ID, Scheduled_Date);

CREATE INDEX idx_maint_equipment_date
  ON Maintenance(Equipment_ID, Scheduled_Date);

/*==================================================
  9. 外部访客申请：Visitor_Application 及其多值联系方式
  （draw.io 中实体名可能标为 Registration_Application，
   这里采用论文中的 Visitor_Application 命名）
==================================================*/

CREATE TABLE Visitor_Application (
  Application_ID    INT UNSIGNED PRIMARY KEY,
  First_Name        VARCHAR(50) NOT NULL,
  Last_Name         VARCHAR(50) NOT NULL,
  IC_Number         VARCHAR(20) NOT NULL UNIQUE,
  Application_Date  DATE        NOT NULL,
  Status            ENUM('Pending','Approved','Rejected') NOT NULL,
  Approved_By       INT UNSIGNED NULL,  -- FK → Staff(Member_ID)
  Approval_Date     DATE        NULL,
  Reject_Reason     TEXT        NULL,
  Created_Member_ID INT UNSIGNED NULL,  -- 通过审批后创建的 Member 记录
  CONSTRAINT fk_app_approved_by
    FOREIGN KEY (Approved_By)
    REFERENCES Staff(Member_ID)
    ON DELETE SET NULL,
  CONSTRAINT fk_app_created_member
    FOREIGN KEY (Created_Member_ID)
    REFERENCES Member(Member_ID)
    ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE INDEX idx_app_status_date
  ON Visitor_Application(Status, Application_Date);

/* ---- Visitor_Application 的多值联系方式 ---- */

CREATE TABLE Visitor_Application_Phone (
  Application_ID INT UNSIGNED NOT NULL,
  Phone_Number   VARCHAR(20)  NOT NULL,
  PRIMARY KEY (Application_ID, Phone_Number),
  CONSTRAINT fk_app_phone_application
    FOREIGN KEY (Application_ID)
    REFERENCES Visitor_Application(Application_ID)
    ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Visitor_Application_Email (
  Application_ID INT UNSIGNED  NOT NULL,
  Email_Address  VARCHAR(100)  NOT NULL,
  PRIMARY KEY (Application_ID, Email_Address),
  CONSTRAINT fk_app_email_application
    FOREIGN KEY (Application_ID)
    REFERENCES Visitor_Application(Application_ID)
    ON DELETE CASCADE
) ENGINE=InnoDB;

/*==================================================
  10. 业务规则示例触发器（来自论文建议，可选）
      - 每个会员最多 2 条 Pending 预订
==================================================*/

DELIMITER $$
CREATE TRIGGER trg_check_pending_bookings
BEFORE INSERT ON Booking
FOR EACH ROW
BEGIN
  DECLARE pending_count INT;

  SELECT COUNT(*)
    INTO pending_count
  FROM Booking
  WHERE Member_ID = NEW.Member_ID
    AND Booking_Status = 'Pending';

  IF pending_count >= 2 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Member already has 2 pending bookings';
  END IF;
END$$
DELIMITER ;

/* 说明：
   - 预约时的“时间段重叠检测”“最多提前一周”“单次预约不超过 3 小时”
     更适合在应用层或存储过程里按论文中的查询逻辑实现。
*/

COMMIT;