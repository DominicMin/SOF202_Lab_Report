/*
Task 1: Database Integrity - Screenshot Generation Script
=========================================================
此脚本用于生成 Lab Report Task 1 (Database Integrity) 所需的截图。
每个部分对应 report 中的一张 Figure。

Pre-requisites:
1. 确保已运行 run_init_db.ps1 (或 executed init_db.sql)。
*/

USE sports_arena;

-- ======================================================
-- FIGURE 1.1: Domain Integrity (Domain Constraints)
-- [截图内容 1]: SHOW CREATE TABLE 展示 CHECK 约束
-- [截图内容 2]: 触发 CHECK 约束的错误信息
-- ======================================================

-- 1. 展示约束定义
SHOW CREATE TABLE Equipment;

SHOW CREATE TABLE Reservation;

-- 2. 测试 Equipment 数量非负约束 (应该失败)
-- Expected Error: Check constraint 'equipment_chk_1' is violated.
INSERT INTO
    Equipment (
        Equipment_Name,
        Type,
        Status,
        Total_Quantity
    )
VALUES (
        'Negative Ball',
        'Ball',
        'Available',
        -5
    );

-- 3. 测试 Reservation 开始时间早于结束时间约束 (应该失败)
-- Expected Error: Check constraint 'chk_reservation_time' is violated.
INSERT INTO
    Reservation (
        Facility_ID,
        Reservation_Date,
        Start_Time,
        End_Time
    )
VALUES (
        1,
        '2025-12-30',
        '10:00:00',
        '09:00:00'
    );

-- ======================================================
-- FIGURE 1.2: Entity Integrity (PK & Unique)
-- [截图内容 1]: SHOW CREATE TABLE 展示 PK 和 UNIQUE
-- [截图内容 2]: 触发 Entity Integrity 违规 (重复主键或唯一键)
-- ======================================================

-- 1. 展示约束定义
SHOW CREATE TABLE Member;

-- 2. 测试 UNIQUE 约束 (假设 user_id 101 已存在或尝试插入两次相同 Unique 值)
-- 这里我们尝试插入一个重复的 user_id (如果表中已有 user_id=1 的记录)
-- 或者我们可以直接测试主键冲突(虽然是 AI，但如果手动指定 ID):

-- 插入一条合法记录作为铺垫 (使用 INSERT IGNORE 防止重复)
INSERT IGNORE INTO
    Member (
        Member_ID,
        First_Name,
        Last_Name,
        Registration_Date,
        Membership_Status,
        user_id
    )
VALUES (
        999,
        'Test',
        'User',
        CURDATE(),
        'Active',
        9999
    );

-- 尝试再次插入相同的 Member_ID (主键冲突)
-- Expected Error: Duplicate entry '999' for key 'member.PRIMARY'
INSERT INTO
    Member (
        Member_ID,
        First_Name,
        Last_Name,
        Registration_Date,
        Membership_Status,
        user_id
    )
VALUES (
        999,
        'Duplicate',
        'User',
        CURDATE(),
        'Active',
        8888
    );

-- 尝试插入已存在的 user_id (唯一键冲突)
-- Expected Error: Duplicate entry '9999' for key 'member.user_id'
INSERT INTO
    Member (
        First_Name,
        Last_Name,
        Registration_Date,
        Membership_Status,
        user_id
    )
VALUES (
        'Another',
        'User',
        CURDATE(),
        'Active',
        9999
    );

-- ======================================================
-- FIGURE 1.3: Referential Integrity (Foreign Key)
-- [截图内容 1]: SHOW CREATE TABLE 展示 FK
-- [截图内容 2]: 触发 FK 违规 (插入不存在的外键值)
-- ======================================================

-- 1. 展示约束定义
SHOW CREATE TABLE Booking;

-- 2. 测试外键约束: 插入不存在的 Member_ID
-- Expected Error: Cannot add or update a child row: a foreign key constraint fails...
INSERT INTO
    Booking (
        Reservation_ID,
        Member_ID,
        Booking_Status
    )
VALUES (7, 99999, 'Confirmed');

-- 3. 测试外键约束: 插入不存在的 Reservation_ID
-- Expected Error: Cannot add or update a child row: a foreign key constraint fails...
INSERT INTO
    Booking (
        Reservation_ID,
        Member_ID,
        Booking_Status
    )
VALUES (99999, 1, 'Confirmed');