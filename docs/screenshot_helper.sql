/*
Screenshot Helper Script for SOF202 Lab Report
===============================================
Use this script to generate the screens output required for Task 1, 2, and 4.
Run each section in MySQL Workbench and take the screenshots as requested.
*/

-- ==========================================================
-- [TASK 1] PROOF OF CREATE TABLE EXECUTION (Task 1A)
-- ==========================================================
-- Instructions:
-- 1. If you need to show "Create Table Success" (Green Check), you may need to drop the tables first.
-- 2. UNCOMMENT the DROP commands below if you are ready to reset 'equipment' and 'reservation'.
-- 3. Run the block below and screenshot the "Output" tab showing "Create Table ... 0 rows affected ... Query OK".

/* 
-- WARNING: This will DELETE existing data in these tables!
DROP TABLE IF EXISTS `reservation_equipments`;
DROP TABLE IF EXISTS `maintenance`;
DROP TABLE IF EXISTS `booking`;
DROP TABLE IF EXISTS `session_enrollment`;
DROP TABLE IF EXISTS `training_session`;
DROP TABLE IF EXISTS `reservation`;
DROP TABLE IF EXISTS `equipment`;
*/

-- Run these to get the Green Checks for Task 1A Figure 1.x
CREATE TABLE IF NOT EXISTS `equipment` (
    `Equipment_ID` int NOT NULL AUTO_INCREMENT,
    `Equipment_Name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `Type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `Status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `Total_Quantity` int UNSIGNED NOT NULL,
    PRIMARY KEY (`Equipment_ID`),
    CONSTRAINT `equipment_chk_1` CHECK (`Total_Quantity` >= 0)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `reservation` (
    `Reservation_ID` int NOT NULL AUTO_INCREMENT,
    `Reservation_Date` date NOT NULL,
    `Start_Time` time(6) NOT NULL,
    `End_Time` time(6) NOT NULL,
    `Facility_ID` int NOT NULL,
    PRIMARY KEY (`Reservation_ID`),
    CONSTRAINT `chk_reservation_time` CHECK (`Start_Time` < `End_Time`)
) ENGINE = InnoDB;

-- ==========================================================
-- [TASK 2] COMPREHENSIVE ROW COUNTS (Task 2 Figure 2.5)
-- ==========================================================
-- Run this single query to get a nice list of all tables and their row counts.
-- Screenshot the Result Grid.

SELECT 'auth_group' AS Table_Name, COUNT(*) AS Row_Count
FROM auth_group
UNION ALL
SELECT 'auth_user', COUNT(*)
FROM auth_user
UNION ALL
SELECT 'booking', COUNT(*)
FROM booking
UNION ALL
SELECT 'coach', COUNT(*)
FROM coach
UNION ALL
SELECT 'coach_email', COUNT(*)
FROM coach_email
UNION ALL
SELECT 'coach_phone', COUNT(*)
FROM coach_phone
UNION ALL
SELECT 'equipment', COUNT(*)
FROM equipment
UNION ALL
SELECT 'external_visitor', COUNT(*)
FROM external_visitor
UNION ALL
SELECT 'facility', COUNT(*)
FROM facility
UNION ALL
SELECT 'maintenance', COUNT(*)
FROM maintenance
UNION ALL
SELECT 'member', COUNT(*)
FROM member
UNION ALL
SELECT 'member_email', COUNT(*)
FROM member_email
UNION ALL
SELECT 'member_phone', COUNT(*)
FROM member_phone
UNION ALL
SELECT 'reservation', COUNT(*)
FROM reservation
UNION ALL
SELECT 'reservation_equipments', COUNT(*)
FROM reservation_equipments
UNION ALL
SELECT 'session_enrollment', COUNT(*)
FROM session_enrollment
UNION ALL
SELECT 'staff', COUNT(*)
FROM staff
UNION ALL
SELECT 'student', COUNT(*)
FROM student
UNION ALL
SELECT 'training_session', COUNT(*)
FROM training_session
UNION ALL
SELECT 'visitor_application', COUNT(*)
FROM visitor_application;

-- ==========================================================
-- [TASK 4] PERMISSION VERIFICATION (Task 4 Figure 4.x)
-- ==========================================================
-- Replace 'coach_role' or 'user' with the actual user/role name you created.
-- If you created users like 'coach_user'@'localhost', use that.
-- Screenshot the Result Grid showing the GRANT statements.

-- Example 1: Check Grants for the current user or a specific role
-- (Adjust the user/host as per your actual setup)
SHOW GRANTS;
-- OR
-- SHOW GRANTS FOR 'coach_user'@'%';
-- SHOW GRANTS FOR 'member_user'@'%';