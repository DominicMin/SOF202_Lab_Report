/*
Data Population Script
======================
This script appends additional data to the sports_arena database to meet the
requirement of "minimum 6-10 rows per table" for Task 2.

Pre-requisite:
Run 'sports_arena_with_data.sql' FIRST to set up the DB and initial data.

Changes:
- Uses INSERT IGNORE to prevent duplicate errors.
- Fixes Facility Status to 'Available' to pass reservation triggers.
- Uses Dynamic Dates (CURDATE() + X) to pass "Booking <= 7 days in advance" triggers.
- FIXED: Added backup inserts for Reservation_Equipments linked to Reservations 1 & 2 to ensure Query 5 has data.
*/

USE sports_arena;

SET FOREIGN_KEY_CHECKS = 0;

-- ======================================================
-- 1. Additional Members (IDs 4-10)
-- ======================================================
INSERT IGNORE INTO
    Member (
        Member_ID,
        First_Name,
        Last_Name,
        Registration_Date,
        Membership_Status
    )
VALUES (
        4,
        'Alice',
        'Wang',
        CURDATE() - INTERVAL 60 DAY,
        'Active'
    ),
    (
        5,
        'Bob',
        'Lee',
        CURDATE() - INTERVAL 50 DAY,
        'Active'
    ),
    (
        6,
        'Charlie',
        'Chen',
        CURDATE() - INTERVAL 40 DAY,
        'Active'
    ),
    (
        7,
        'David',
        'Zhang',
        CURDATE() - INTERVAL 30 DAY,
        'Active'
    ),
    (
        8,
        'Eva',
        'Wu',
        CURDATE() - INTERVAL 20 DAY,
        'Active'
    ),
    (
        9,
        'Frank',
        'Liu',
        CURDATE() - INTERVAL 5 DAY,
        'Pending_Approval'
    ),
    (
        10,
        'Grace',
        'Xu',
        CURDATE() - INTERVAL 2 DAY,
        'Inactive'
    );

-- Member Types (Student, Staff, External_Visitor)
INSERT IGNORE INTO
    Student (Member_ID, Student_ID)
VALUES (4, 'STU004'),
    (5, 'STU005'),
    (6, 'STU006');

INSERT IGNORE INTO
    Staff (Member_ID, Staff_ID)
VALUES (7, 'STA007'),
    (8, 'STA008');

INSERT IGNORE INTO
    External_Visitor (Member_ID, IC_Number)
VALUES (9, 'IC999009'),
    (10, 'IC999010');

-- Member Contact Info
INSERT IGNORE INTO
    Member_Email (Member_ID, Email_Address)
VALUES (4, 'alice.w@example.com'),
    (5, 'bob.l@example.com'),
    (6, 'charlie.c@example.com'),
    (7, 'david.z@example.com'),
    (8, 'eva.w@example.com'),
    (9, 'frank.l@example.com'),
    (10, 'grace.x@example.com');

INSERT IGNORE INTO
    Member_Phone (Member_ID, Phone_Number)
VALUES (4, '13800000004'),
    (5, '13800000005'),
    (6, '13800000006'),
    (7, '13800000007'),
    (8, '13800000008');

-- ======================================================
-- 2. Additional Coaches (IDs 2-6)
-- ======================================================
INSERT IGNORE INTO
    Coach (
        Coach_ID,
        First_Name,
        Last_Name,
        Sport_Type,
        Level
    )
VALUES (
        2,
        'Sarah',
        'Connor',
        'Tennis',
        'Senior'
    ),
    (
        3,
        'Mike',
        'Tyson',
        'Boxing',
        'Expert'
    ),
    (
        4,
        'LeBron',
        'James',
        'Basketball',
        'Legendary'
    ),
    (
        5,
        'Serena',
        'Williams',
        'Tennis',
        'Expert'
    ),
    (
        6,
        'Yao',
        'Ming',
        'Basketball',
        'Expert'
    );

INSERT IGNORE INTO
    Coach_Email (Coach_ID, Email_Address)
VALUES (2, 'sarah.c@example.com'),
    (3, 'mike.t@example.com'),
    (4, 'king.james@example.com'),
    (5, 'serena.w@example.com');

INSERT IGNORE INTO
    Coach_Phone (Coach_ID, Phone_Number)
VALUES (2, '13900000002'),
    (3, '13900000003'),
    (4, '13900000004');

-- ======================================================
-- 3. Additional Reservations & Bookings (IDs 3-8, 15)
-- ======================================================
-- Fix: Ensure facilities are Available before booking to avoid Trigger Error 1644
UPDATE Facility
SET
    Status = 'Available'
WHERE
    Facility_ID IN (1, 2, 3, 4, 5, 6, 10);

-- Facility IDs: 1-Pool, 2-Gym, 3-Table Tennis, 4-Tennis, 5-Tennis
-- Dates must be within NEXT 7 DAYS to pass 'booking_bi_guardrails' trigger
INSERT IGNORE INTO
    Reservation (
        Reservation_ID,
        Facility_ID,
        Reservation_Date,
        Start_Time,
        End_Time
    )
VALUES (
        3,
        4,
        CURDATE() + INTERVAL 1 DAY,
        '09:00:00',
        '10:00:00'
    ),
    (
        4,
        5,
        CURDATE() + INTERVAL 1 DAY,
        '10:00:00',
        '11:00:00'
    ),
    (
        5,
        4,
        CURDATE() + INTERVAL 2 DAY,
        '09:00:00',
        '10:00:00'
    ),
    (
        6,
        2,
        CURDATE() + INTERVAL 2 DAY,
        '14:00:00',
        '16:00:00'
    ),
    (
        7,
        3,
        CURDATE() + INTERVAL 3 DAY,
        '15:00:00',
        '16:00:00'
    ),
    (
        8,
        5,
        CURDATE() + INTERVAL 3 DAY,
        '11:00:00',
        '12:00:00'
    ),
    (
        15,
        6,
        CURDATE() + INTERVAL 4 DAY,
        '10:00:00',
        '12:00:00'
    );

INSERT IGNORE INTO
    Booking (
        Reservation_ID,
        Member_ID,
        Booking_Status
    )
VALUES (3, 4, 'Confirmed'),
    (4, 5, 'Pending'),
    (5, 6, 'Confirmed'),
    (6, 4, 'Cancelled'),
    (7, 5, 'Confirmed'),
    (8, 7, 'Pending'),
    (15, 8, 'Confirmed');

-- ======================================================
-- 4. Additional Training Sessions (IDs 9-12, 13-14)
-- ======================================================
INSERT IGNORE INTO
    Reservation (
        Reservation_ID,
        Facility_ID,
        Reservation_Date,
        Start_Time,
        End_Time
    )
VALUES (
        9,
        1,
        CURDATE() + INTERVAL 1 DAY,
        '08:00:00',
        '10:00:00'
    ),
    (
        10,
        10,
        CURDATE() + INTERVAL 2 DAY,
        '18:00:00',
        '20:00:00'
    ),
    (
        11,
        4,
        CURDATE() + INTERVAL 3 DAY,
        '09:00:00',
        '11:00:00'
    ),
    (
        12,
        10,
        CURDATE() + INTERVAL 3 DAY,
        '14:00:00',
        '16:00:00'
    ),
    (
        13,
        1,
        CURDATE() + INTERVAL 4 DAY,
        '10:00:00',
        '12:00:00'
    ),
    (
        14,
        5,
        CURDATE() + INTERVAL 5 DAY,
        '14:00:00',
        '16:00:00'
    );

INSERT IGNORE INTO
    Training_Session (
        Reservation_ID,
        Coach_ID,
        Max_Capacity
    )
VALUES (9, 3, 20),
    (10, 5, 15),
    (11, 2, 4),
    (12, 5, 10),
    (13, 4, 30),
    (14, 6, 12);

-- Enrollments
INSERT IGNORE INTO
    Session_Enrollment (Reservation_ID, Member_ID)
VALUES (9, 4),
    (9, 5),
    (10, 6),
    (10, 7),
    (10, 8),
    (11, 4),
    (13, 5),
    (13, 6);

-- ======================================================
-- 5. Additional Equipment Usage (Weak Entity)
-- ======================================================
-- Equip IDs: 2-Ball Sports, 6-Fitness Gear, 5-Aquatic
-- Ensure Equipment Status is Available
UPDATE Equipment
SET
    Status = 'Available'
WHERE
    Equipment_ID IN (2, 5, 6, 10, 13);

INSERT IGNORE INTO
    Reservation_Equipments (
        Reservation_ID,
        Equipment_ID,
        Quantity
    )
VALUES
    -- Backup rows linked to existing Reservation 1 & 2 (Guarantees data for Query 5)
    (1, 2, 5),
    (2, 6, 2),
    -- New rows
    (3, 2, 2),
    (6, 6, 1),
    (9, 5, 5),
    (10, 13, 5),
    (14, 2, 4);

-- ======================================================
-- 6. Additional Maintenance (IDs 3-7)
-- ======================================================
INSERT IGNORE INTO
    Maintenance (
        Maintenance_ID,
        Scheduled_Date,
        Status,
        Description,
        Facility_ID,
        Equipment_ID
    )
VALUES (
        3,
        CURDATE() + INTERVAL 10 DAY,
        'Scheduled',
        'Annual check',
        1,
        NULL
    ),
    (
        4,
        CURDATE() + INTERVAL 11 DAY,
        'Scheduled',
        'Repair net',
        5,
        NULL
    ),
    (
        5,
        CURDATE() - INTERVAL 2 DAY,
        'Completed',
        'Oil change',
        NULL,
        6
    ),
    (
        6,
        CURDATE() + INTERVAL 0 DAY,
        'In_Progress',
        'Floor polish',
        2,
        NULL
    ),
    (
        7,
        CURDATE() + INTERVAL 12 DAY,
        'Scheduled',
        'Inspection',
        NULL,
        10
    );

-- ======================================================
-- 7. Additional Visitor Applications (IDs 9-13)
-- ======================================================
INSERT IGNORE INTO
    Visitor_Application (
        Application_ID,
        First_Name,
        Last_Name,
        IC_Number,
        Application_Date,
        Status,
        Approved_By
    )
VALUES (
        9,
        'Tom',
        'Hanks',
        'VA009',
        CURDATE() - INTERVAL 5 DAY,
        'Approved',
        2
    ),
    (
        10,
        'Jerry',
        'Mouse',
        'VA010',
        CURDATE() - INTERVAL 4 DAY,
        'Pending',
        NULL
    ),
    (
        11,
        'Mickey',
        'Disney',
        'VA011',
        CURDATE() - INTERVAL 3 DAY,
        'Rejected',
        2
    ),
    (
        12,
        'Donald',
        'Duck',
        'VA012',
        CURDATE() - INTERVAL 2 DAY,
        'Pending',
        NULL
    ),
    (
        13,
        'Goofy',
        'Dog',
        'VA013',
        CURDATE() - INTERVAL 1 DAY,
        'Approved',
        2
    );

-- Application Contacts
INSERT IGNORE INTO
    Visitor_Application_Email (Application_ID, Email_Address)
VALUES (9, 'tom@example.com'),
    (10, 'jerry@example.com');

INSERT IGNORE INTO
    Visitor_Application_Phone (Application_ID, Phone_Number)
VALUES (9, '99900000009'),
    (10, '99900000010');

SET FOREIGN_KEY_CHECKS = 1;

/* End of Data Population */