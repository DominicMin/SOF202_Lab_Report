/*
Script: recreate_named_users.sql
Description: Recreates users named 'Member' and 'Coach' (instead of 'M' and 'C') 
and configures their roles/permissions for Lab Report Task 4.
*/

USE sports_arena;

-- ======================================================
-- 1. Create Users (Member & Coach)
-- ======================================================
DROP USER IF EXISTS 'Member' @'localhost';

DROP USER IF EXISTS 'Coach' @'localhost';

CREATE USER 'Member' @'localhost' IDENTIFIED BY 'password';

CREATE USER 'Coach' @'localhost' IDENTIFIED BY 'password';

-- ======================================================
-- 2. Configure Roles (RBAC)
-- ======================================================
DROP ROLE IF EXISTS 'member_role';

DROP ROLE IF EXISTS 'coach_role';

CREATE ROLE 'member_role', 'coach_role';

-- Grant Permissions to Coach Role
-- Allowed: View/Update sessions, View facilities/coaches
GRANT
SELECT,
UPDATE ON sports_arena.training_session TO 'coach_role';

GRANT SELECT ON sports_arena.facility TO 'coach_role';

GRANT SELECT ON sports_arena.coach TO 'coach_role';

-- Member Role permissions will be added after View creation

-- ======================================================
-- 3. Assign Roles
-- ======================================================
GRANT 'member_role' TO 'Member' @'localhost';

GRANT 'coach_role' TO 'Coach' @'localhost';

SET DEFAULT ROLE ALL TO 'Member' @'localhost';

SET DEFAULT ROLE ALL TO 'Coach' @'localhost';

-- ======================================================
-- 4. Data Prerequisites for Row-Level Security
--    (Ensure a Member named 'Member' exists for the View logic)
-- ======================================================
INSERT INTO
    member (
        First_Name,
        Last_Name,
        Registration_Date,
        Membership_Status
    )
SELECT 'Member', 'DemoUser', CURDATE(), 'Active'
WHERE
    NOT EXISTS (
        SELECT 1
        FROM member
        WHERE
            First_Name = 'Member'
    );

INSERT INTO
    coach (
        First_Name,
        Last_Name,
        Sport_Type,
        Level
    )
SELECT 'Coach', 'DemoUser', 'General', 'Senior'
WHERE
    NOT EXISTS (
        SELECT 1
        FROM coach
        WHERE
            First_Name = 'Coach'
    );

-- ======================================================
-- 5. Create Row-Level Security View
-- ======================================================
CREATE OR REPLACE VIEW v_member_booking_detail AS
SELECT b.Reservation_ID, b.Booking_Status, b.Member_ID, r.Reservation_Date, f.Facility_Name
FROM
    booking b
    JOIN reservation r ON r.Reservation_ID = b.Reservation_ID
    JOIN facility f ON f.Facility_ID = r.Facility_ID
WHERE
    b.Member_ID = (
        -- Matches the DB username (e.g., 'Member') to the First_Name in the table
        SELECT Member_ID
        FROM member
        WHERE
            First_Name = SUBSTRING_INDEX(USER (), '@', 1)
        LIMIT 1
    );

-- Grant View Access to Member Role
GRANT SELECT ON v_member_booking_detail TO 'member_role';

-- ======================================================
-- 6. Verification Output (SHOW GRANTS)
-- ======================================================
SELECT 'Users Recreated: Member, Coach' AS Status;

-- These are the queries you need for the Task 4 screenshots:
SHOW GRANTS FOR 'root' @'localhost';

SHOW GRANTS FOR 'Member' @'localhost';

SHOW GRANTS FOR 'Coach' @'localhost';