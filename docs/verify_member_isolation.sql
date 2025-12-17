/*
Script: verify_member_isolation.sql
Description: Sets up data for Member 2 and verifies that Member 1 cannot see it.
Usage: Run this script with a user that has INSERT privileges (like root) first to setup data,
THEN log in as 'Member' to run the verification query.
*/

USE sports_arena;

-- ======================================================
-- 1. SETUP: Create Member 2 and a Booking for them (Run as ROOT)
-- ======================================================

-- Ensure Member 2 exists
INSERT INTO
    member (
        First_Name,
        Last_Name,
        Registration_Date,
        Membership_Status
    )
SELECT 'Member2', 'TestUser', CURDATE(), 'Active'
WHERE
    NOT EXISTS (
        SELECT 1
        FROM member
        WHERE
            First_Name = 'Member2'
    );

-- Get IDs (Dynamic to avoid hardcoding errors)
SET
    @m2_id = (
        SELECT Member_ID
        FROM member
        WHERE
            First_Name = 'Member2'
        LIMIT 1
    );

SET @fac_id = ( SELECT Facility_ID FROM facility LIMIT 1 );

-- Create a Reservation for Member 2 (Tomorrow 10:00-11:00)
INSERT INTO
    reservation (
        Reservation_Date,
        Start_Time,
        End_Time,
        Facility_ID
    )
SELECT DATE_ADD(CURDATE(), INTERVAL 1 DAY), '10:00:00', '11:00:00', @fac_id
WHERE
    NOT EXISTS (
        SELECT 1
        FROM reservation
        WHERE
            Facility_ID = @fac_id
            AND Reservation_Date = DATE_ADD(CURDATE(), INTERVAL 1 DAY)
            AND Start_Time = '10:00:00'
    );

SET
    @res_id = (
        SELECT Reservation_ID
        FROM reservation
        WHERE
            Facility_ID = @fac_id
            AND Reservation_Date = DATE_ADD(CURDATE(), INTERVAL 1 DAY)
            AND Start_Time = '10:00:00'
        LIMIT 1
    );

-- Create Booking for Member 2
INSERT INTO
    booking (
        Reservation_ID,
        Member_ID,
        Booking_Status
    )
SELECT @res_id, @m2_id, 'Confirmed'
WHERE
    NOT EXISTS (
        SELECT 1
        FROM booking
        WHERE
            Reservation_ID = @res_id
    );

SELECT 'Setup Complete. Member 2 has a booking.' AS Status;

-- ======================================================
-- 2. VERIFICATION: Try to access as Member 1 (Run as 'Member')
-- ======================================================

/* 
INSTRUCTIONS FOR SCREENSHOT:
1. Connect to MySQL Workbench as 'Member' (password: password).
2. Run the following queries.
3. Screenshot the result (should be Empty for the second query).
*/

-- Query 1: Prove I am Member 1
SELECT USER (), current_role();

-- Query 2: Try to see Member 2's booking explicitly (Expect Empty Set)
-- Assuming Member 2's ID is known or we try to find bookings that are NOT ours.
SELECT *
FROM v_member_booking_detail
WHERE
    Member_ID = (
        SELECT Member_ID
        FROM member
        WHERE
            First_Name = 'Member2'
    );

-- Query 3: Generic check (Everything I see should be mine)
SELECT * FROM v_member_booking_detail;