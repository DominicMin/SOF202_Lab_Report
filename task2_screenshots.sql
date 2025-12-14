/*
Task 2: SQL Implementation - Screenshot Generation Script
=========================================================
此脚本用于生成 Lab Report Task 2 (SQL) 所需的所有截图。
每个部分对应 report 中的一张 Figure。

Pre-requisites:
1. 确保已运行 run_init_db.ps1 (或 executed sports_arena_with_data.sql) 并填充了数据。
*/

USE sports_arena;

-- ======================================================
-- FIGURE 2.1: Table Creation - Member Types
-- [截图要求]: 截取 Result Grid 中显示的 Create Table 语句 (或者分别在 Output 窗口显示执行结果)
-- 也可以直接对每条语句使用 SHOW CREATE TABLE 并截图结果
-- ======================================================

SHOW CREATE TABLE Student;

SHOW CREATE TABLE Staff;

SHOW CREATE TABLE External_Visitor;

-- ======================================================
-- FIGURE 2.2: Table Creation - Contact Info
-- ======================================================

SHOW CREATE TABLE Member_Email;

SHOW CREATE TABLE Member_Phone;

SHOW CREATE TABLE Coach_Email;

SHOW CREATE TABLE Coach_Phone;

-- ======================================================
-- FIGURE 2.3: Table Creation - Facility, Coach, Maintenance
-- ======================================================

SHOW CREATE TABLE Facility;

SHOW CREATE TABLE Coach;

SHOW CREATE TABLE Maintenance;

-- ======================================================
-- FIGURE 2.4: Table Creation - Applications & Transactions
-- ======================================================

SHOW CREATE TABLE Visitor_Application;

SHOW CREATE TABLE Training_Session;

SHOW CREATE TABLE Session_Enrollment;

SHOW CREATE TABLE Reservation_Equipments;

-- ======================================================
-- FIGURE 2.5: Data Population Verification
-- [截图要求]: 截取查询结果，证明每张表都有数据 (>6行)
-- ======================================================

SELECT (
        SELECT COUNT(*)
        FROM Member
    ) AS Member_Count,
    (
        SELECT COUNT(*)
        FROM Facility
    ) AS Facility_Count,
    (
        SELECT COUNT(*)
        FROM Equipment
    ) AS Equipment_Count,
    (
        SELECT COUNT(*)
        FROM Reservation
    ) AS Reservation_Count,
    (
        SELECT COUNT(*)
        FROM Booking
    ) AS Booking_Count,
    (
        SELECT COUNT(*)
        FROM Training_Session
    ) AS Session_Count;

-- ======================================================
-- FIGURE 2.6: Filtering (LIKE, BETWEEN, IN)
-- [截图要求]: 截取 Result Grid (可分三次执行拼接，或一次执行看 Output)
-- ======================================================

-- Query 1: Filtering by Pattern (LIKE)
SELECT Facility_Name, Type, Status
FROM Facility
WHERE
    Type LIKE '%Tennis%'
    AND Status = 'Available';

-- Query 2: Filtering by Range (BETWEEN)
SELECT
    Reservation_ID,
    Reservation_Date
FROM Reservation
WHERE
    Reservation_Date BETWEEN '2025-12-01' AND '2025-12-31';

-- Query 3: Filtering by Set (IN)
SELECT Reservation_ID, Booking_Status
FROM Booking
WHERE
    Booking_Status IN ('Pending', 'Confirmed');

-- ======================================================
-- FIGURE 2.7: Aggregate Functions (COUNT, SUM, AVG)
-- ======================================================

-- Query 4: Counting Records (COUNT)
SELECT Type, COUNT(*) AS facility_count
FROM Facility
GROUP BY
    Type;

-- Query 5: Summing Values (SUM)
SELECT
    Reservation_ID,
    SUM(Quantity) AS total_equipment
FROM Reservation_Equipments
GROUP BY
    Reservation_ID;

-- Query 6: Averaging Values (AVG)
SELECT Coach_ID, AVG(Max_Capacity) AS avg_capacity
FROM Training_Session
GROUP BY
    Coach_ID;

-- ======================================================
-- FIGURE 2.8: Limit / Sorting
-- ======================================================

-- Query 7: Ordering and Limiting
SELECT Facility_Name, Capacity
FROM Facility
WHERE
    Status = 'Available'
ORDER BY Capacity DESC
LIMIT 3;

-- Query 8: Multi-level Sorting
SELECT
    Reservation_ID,
    Reservation_Date,
    Start_Time
FROM Reservation
ORDER BY Reservation_Date DESC, Start_Time DESC
LIMIT 5;

-- Query 9: Sorting Applications
SELECT
    Application_ID,
    First_Name,
    Status
FROM Visitor_Application
ORDER BY Application_Date DESC
LIMIT 5;

-- ======================================================
-- FIGURE 2.9: Join Operators
-- ======================================================

-- Query 10: Inner Join
SELECT b.Reservation_ID, m.First_Name, f.Facility_Name, b.Booking_Status
FROM
    Booking b
    JOIN Member m ON b.Member_ID = m.Member_ID
    JOIN Reservation r ON b.Reservation_ID = r.Reservation_ID
    JOIN Facility f ON r.Facility_ID = f.Facility_ID;

-- Query 11: Left Join
SELECT ts.Reservation_ID, c.First_Name, f.Facility_Name, ts.Max_Capacity
FROM
    Training_Session ts
    LEFT JOIN Coach c ON ts.Coach_ID = c.Coach_ID
    LEFT JOIN Reservation r ON ts.Reservation_ID = r.Reservation_ID
    LEFT JOIN Facility f ON r.Facility_ID = f.Facility_ID;

-- Query 12: Right Join
SELECT e.Equipment_Name, re.Reservation_ID, re.Quantity
FROM
    Equipment e
    RIGHT JOIN Reservation_Equipments re ON e.Equipment_ID = re.Equipment_ID;

-- ======================================================
-- FIGURE 2.10: String / Arithmetic Operations
-- ======================================================

-- Query 13: Arithmetic Expression (Duration)
SELECT
    Reservation_ID,
    TIMESTAMPDIFF(MINUTE, Start_Time, End_Time) / 60 AS duration_hours
FROM Reservation;

-- Query 14: String Concatenation (Name)
SELECT
    CONCAT(First_Name, ' ', Last_Name) AS member_name,
    Membership_Status
FROM Member;

-- Query 15: Complex Calculation (Remaining Qty)
SELECT re.Reservation_ID, re.Quantity, e.Total_Quantity, (
        e.Total_Quantity - re.Quantity
    ) AS remaining_theoretical
FROM
    Reservation_Equipments re
    JOIN Equipment e ON re.Equipment_ID = e.Equipment_ID;

-- ======================================================
-- FIGURE 2.11: Formatting
-- ======================================================

-- Query 16: Column Aliasing
SELECT
    Facility_ID AS ID,
    Facility_Name AS Name,
    CONCAT(
        Building,
        '-',
        Floor,
        '-',
        Room_Number
    ) AS Location
FROM Facility;

-- Query 17: Date Formatting
SELECT b.Reservation_ID AS BookingID, CONCAT(
        m.First_Name, ' ', m.Last_Name
    ) AS Member, DATE_FORMAT(
        r.Reservation_Date, '%Y-%m-%d'
    ) AS Date
FROM
    Booking b
    JOIN Member m ON b.Member_ID = m.Member_ID
    JOIN Reservation r ON b.Reservation_ID = r.Reservation_ID;

-- Query 18: Session Formatting
SELECT
    ts.Reservation_ID AS SessionID,
    CONCAT(
        c.First_Name,
        ' ',
        c.Last_Name
    ) AS CoachName,
    CONCAT(r.Start_Time, '-', r.End_Time) AS TimeSlot
FROM
    Training_Session ts
    JOIN Coach c ON ts.Coach_ID = c.Coach_ID
    JOIN Reservation r ON ts.Reservation_ID = r.Reservation_ID;