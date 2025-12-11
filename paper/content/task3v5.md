# Task 3 – MySQL Trigger Validation (v2)

## Prerequisites

- Open Workbench and select the `sports_arena` schema.
- Execute `sports_arena_with_data.sql` to create tables, triggers, and seed data.
- Enable "Continue on Error" so expected trigger errors don't stop execution.

## Triggers covered (full SQL from `sports_arena_with_data.sql`)

- Booking – pending limit and time window:

  ```sql
  CREATE TRIGGER `booking_bi_guardrails` BEFORE INSERT ON `booking` FOR EACH ROW BEGIN
    DECLARE v_pending INT DEFAULT 0;
    DECLARE v_reservation_date DATE;
    DECLARE v_start TIME;
    DECLARE v_end TIME;
    DECLARE v_duration_minutes INT;

    SELECT COUNT(*) INTO v_pending
    FROM `booking`
    WHERE `Member_ID` = NEW.Member_ID
      AND `Booking_Status` = 'Pending';

    IF NEW.Booking_Status = 'Pending' AND v_pending >= 2 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Member already has 2 pending bookings';
    END IF;

    SELECT `Reservation_Date`, `Start_Time`, `End_Time`
      INTO v_reservation_date, v_start, v_end
    FROM `reservation`
    WHERE `Reservation_ID` = NEW.Reservation_ID;

    IF v_reservation_date IS NULL THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Reservation not found for booking';
    END IF;

    SET v_duration_minutes = TIMESTAMPDIFF(MINUTE, v_start, v_end);

    IF v_duration_minutes > 180 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Single booking session cannot exceed 3 hours';
    END IF;

    IF v_reservation_date < CURDATE() THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot book for past dates';
    END IF;

    IF v_reservation_date > DATE_ADD(CURDATE(), INTERVAL 7 DAY) THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bookings can only be made up to 7 days in advance';
    END IF;
  END;
  ```

  ```sql
  CREATE TRIGGER `booking_bu_guardrails` BEFORE UPDATE ON `booking` FOR EACH ROW BEGIN
    DECLARE v_pending INT DEFAULT 0;
    DECLARE v_reservation_date DATE;
    DECLARE v_start TIME;
    DECLARE v_end TIME;
    DECLARE v_duration_minutes INT;

    SELECT COUNT(*) INTO v_pending
    FROM `booking`
    WHERE `Member_ID` = NEW.Member_ID
      AND `Booking_Status` = 'Pending'
      AND `Reservation_ID` <> OLD.Reservation_ID;

    IF NEW.Booking_Status = 'Pending' AND v_pending >= 2 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Member already has 2 pending bookings';
    END IF;

    IF NEW.Reservation_ID <> OLD.Reservation_ID THEN
      SELECT `Reservation_Date`, `Start_Time`, `End_Time`
        INTO v_reservation_date, v_start, v_end
      FROM `reservation`
      WHERE `Reservation_ID` = NEW.Reservation_ID;

      IF v_reservation_date IS NULL THEN
        SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Reservation not found for booking';
      END IF;

      SET v_duration_minutes = TIMESTAMPDIFF(MINUTE, v_start, v_end);

      IF v_duration_minutes > 180 THEN
        SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Single booking session cannot exceed 3 hours';
      END IF;

      IF v_reservation_date < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Cannot book for past dates';
      END IF;

      IF v_reservation_date > DATE_ADD(CURDATE(), INTERVAL 7 DAY) THEN
        SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Bookings can only be made up to 7 days in advance';
      END IF;
    END IF;
  END;
  ```
- Maintenance – XOR (facility or equipment, not both/none):

  ```sql
  CREATE TRIGGER `maintenance_bi_xor` BEFORE INSERT ON `maintenance` FOR EACH ROW BEGIN
    IF (NEW.Facility_ID IS NULL AND NEW.Equipment_ID IS NULL)
       OR (NEW.Facility_ID IS NOT NULL AND NEW.Equipment_ID IS NOT NULL) THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Maintenance must target either a facility or equipment (exclusively)';
    END IF;
  END;
  ```

  ```sql
  CREATE TRIGGER `maintenance_bu_xor` BEFORE UPDATE ON `maintenance` FOR EACH ROW BEGIN
    IF (NEW.Facility_ID IS NULL AND NEW.Equipment_ID IS NULL)
       OR (NEW.Facility_ID IS NOT NULL AND NEW.Equipment_ID IS NOT NULL) THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Maintenance must target either a facility or equipment (exclusively)';
    END IF;
  END;
  ```
- Reservation – overlap/availability:

  ```sql
  CREATE TRIGGER `reservation_bi_guardrails` BEFORE INSERT ON `reservation` FOR EACH ROW BEGIN
    DECLARE v_facility_status VARCHAR(20);
    DECLARE v_conflicts INT DEFAULT 0;
    DECLARE v_maintenance INT DEFAULT 0;

    SELECT `Status` INTO v_facility_status
    FROM `facility`
    WHERE `Facility_ID` = NEW.Facility_ID
    FOR UPDATE;

    IF v_facility_status IS NULL THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Facility does not exist for this reservation';
    END IF;

    IF NEW.Start_Time >= NEW.End_Time THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Reservation start time must be earlier than end time';
    END IF;

    IF v_facility_status <> 'Available' THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Facility is not available for reservation';
    END IF;

    SELECT COUNT(*) INTO v_maintenance
    FROM `maintenance` m
    WHERE m.`Facility_ID` = NEW.Facility_ID
      AND m.`Scheduled_Date` = NEW.Reservation_Date
      AND m.`Status` IN ('Scheduled', 'In_Progress', 'In Progress');

    IF v_maintenance > 0 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Facility has maintenance scheduled for the requested date';
    END IF;

    SELECT COUNT(*) INTO v_conflicts
    FROM `reservation` r
    WHERE r.`Facility_ID` = NEW.Facility_ID
      AND r.`Reservation_Date` = NEW.Reservation_Date
      AND NOT (NEW.End_Time <= r.`Start_Time` OR NEW.Start_Time >= r.`End_Time`);

    IF v_conflicts > 0 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Reservation overlaps with an existing booking for this facility';
    END IF;
  END;
  ```

  ```sql
  CREATE TRIGGER `reservation_bu_guardrails` BEFORE UPDATE ON `reservation` FOR EACH ROW BEGIN
    DECLARE v_facility_status VARCHAR(20);
    DECLARE v_conflicts INT DEFAULT 0;
    DECLARE v_maintenance INT DEFAULT 0;

    SELECT `Status` INTO v_facility_status
    FROM `facility`
    WHERE `Facility_ID` = NEW.Facility_ID
    FOR UPDATE;

    IF v_facility_status IS NULL THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Facility does not exist for this reservation';
    END IF;

    IF NEW.Start_Time >= NEW.End_Time THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Reservation start time must be earlier than end time';
    END IF;

    IF v_facility_status <> 'Available' THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Facility is not available for reservation';
    END IF;

    SELECT COUNT(*) INTO v_maintenance
    FROM `maintenance` m
    WHERE m.`Facility_ID` = NEW.Facility_ID
      AND m.`Scheduled_Date` = NEW.Reservation_Date
      AND m.`Status` IN ('Scheduled', 'In_Progress', 'In Progress');

    IF v_maintenance > 0 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Facility has maintenance scheduled for the requested date';
    END IF;

    SELECT COUNT(*) INTO v_conflicts
    FROM `reservation` r
    WHERE r.`Facility_ID` = NEW.Facility_ID
      AND r.`Reservation_Date` = NEW.Reservation_Date
      AND r.`Reservation_ID` <> OLD.Reservation_ID
      AND NOT (NEW.End_Time <= r.`Start_Time` OR NEW.Start_Time >= r.`End_Time`);

    IF v_conflicts > 0 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Reservation overlaps with an existing booking for this facility';
    END IF;
  END;
  ```
- Reservation_Equipments – availability:

  ```sql
  CREATE TRIGGER `reservation_equipments_bi_guardrails` BEFORE INSERT ON `reservation_equipments` FOR EACH ROW BEGIN
    DECLARE v_total INT;
    DECLARE v_reserved INT DEFAULT 0;
    DECLARE v_available INT;
    DECLARE v_status VARCHAR(20);
    DECLARE v_reservation_date DATE;
    DECLARE v_start TIME;
    DECLARE v_end TIME;
    DECLARE v_maintenance INT DEFAULT 0;

    SELECT r.`Reservation_Date`, r.`Start_Time`, r.`End_Time`
      INTO v_reservation_date, v_start, v_end
    FROM `reservation` r
    WHERE r.`Reservation_ID` = NEW.Reservation_ID
    FOR UPDATE;

    IF v_reservation_date IS NULL THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Reservation not found for equipment assignment';
    END IF;

    SELECT e.`Total_Quantity`, e.`Status`
      INTO v_total, v_status
    FROM `equipment` e
    WHERE e.`Equipment_ID` = NEW.Equipment_ID
    FOR UPDATE;

    IF v_status IS NULL THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Equipment does not exist';
    END IF;

    IF v_status <> 'Available' THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Equipment is not available for reservation';
    END IF;

    IF NEW.Quantity <= 0 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity must be positive';
    END IF;

    SELECT COUNT(*) INTO v_maintenance
    FROM `maintenance` m
    WHERE m.`Equipment_ID` = NEW.Equipment_ID
      AND m.`Scheduled_Date` = v_reservation_date
      AND m.`Status` IN ('Scheduled', 'In_Progress', 'In Progress');

    SELECT COALESCE(SUM(re2.`Quantity`), 0) INTO v_reserved
    FROM `reservation_equipments` re2
    JOIN `reservation` r2 ON r2.`Reservation_ID` = re2.`Reservation_ID`
    WHERE re2.`Equipment_ID` = NEW.Equipment_ID
      AND r2.`Reservation_Date` = v_reservation_date
      AND NOT (v_end <= r2.`Start_Time` OR v_start >= r2.`End_Time`);

    SET v_available = v_total - v_reserved - v_maintenance;

    IF NEW.Quantity > v_available THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Requested equipment exceeds available quantity';
    END IF;
  END;
  ```

  ```sql
  CREATE TRIGGER `reservation_equipments_bu_guardrails` BEFORE UPDATE ON `reservation_equipments` FOR EACH ROW BEGIN
    DECLARE v_total INT;
    DECLARE v_reserved INT DEFAULT 0;
    DECLARE v_available INT;
    DECLARE v_status VARCHAR(20);
    DECLARE v_reservation_date DATE;
    DECLARE v_start TIME;
    DECLARE v_end TIME;
    DECLARE v_maintenance INT DEFAULT 0;

    SELECT r.`Reservation_Date`, r.`Start_Time`, r.`End_Time`
      INTO v_reservation_date, v_start, v_end
    FROM `reservation` r
    WHERE r.`Reservation_ID` = NEW.Reservation_ID
    FOR UPDATE;

    IF v_reservation_date IS NULL THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Reservation not found for equipment assignment';
    END IF;

    SELECT e.`Total_Quantity`, e.`Status`
      INTO v_total, v_status
    FROM `equipment` e
    WHERE e.`Equipment_ID` = NEW.Equipment_ID
    FOR UPDATE;

    IF v_status IS NULL THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Equipment does not exist';
    END IF;

    IF v_status <> 'Available' THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Equipment is not available for reservation';
    END IF;

    IF NEW.Quantity <= 0 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity must be positive';
    END IF;

    SELECT COUNT(*) INTO v_maintenance
    FROM `maintenance` m
    WHERE m.`Equipment_ID` = NEW.Equipment_ID
      AND m.`Scheduled_Date` = v_reservation_date
      AND m.`Status` IN ('Scheduled', 'In_Progress', 'In Progress');

    SELECT COALESCE(SUM(re2.`Quantity`), 0) INTO v_reserved
    FROM `reservation_equipments` re2
    JOIN `reservation` r2 ON r2.`Reservation_ID` = re2.`Reservation_ID`
    WHERE re2.`Equipment_ID` = NEW.Equipment_ID
      AND r2.`Reservation_Date` = v_reservation_date
      AND NOT (v_end <= r2.`Start_Time` OR v_start >= r2.`End_Time`)
      AND re2.`id` <> OLD.`id`;

    SET v_available = v_total - v_reserved - v_maintenance;

    IF NEW.Quantity > v_available THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Requested equipment exceeds available quantity';
    END IF;
  END;
  ```
- Session_Enrollment – capacity:

  ```sql
  CREATE TRIGGER `session_enrollment_bi_capacity` BEFORE INSERT ON `session_enrollment` FOR EACH ROW BEGIN
    DECLARE v_capacity INT;
    DECLARE v_current INT DEFAULT 0;

    SELECT `Max_Capacity` INTO v_capacity
    FROM `training_session`
    WHERE `Reservation_ID` = NEW.Reservation_ID
    FOR UPDATE;

    IF v_capacity IS NULL THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Training session not found for enrollment';
    END IF;

    IF v_capacity <= 0 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Training session has no available capacity';
    END IF;

    SELECT COUNT(*) INTO v_current
    FROM `session_enrollment`
    WHERE `Reservation_ID` = NEW.Reservation_ID;

    IF v_current >= v_capacity THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Training session is full';
    END IF;
  END;
  ```

  ```sql
  CREATE TRIGGER `session_enrollment_bu_capacity` BEFORE UPDATE ON `session_enrollment` FOR EACH ROW BEGIN
    DECLARE v_capacity INT;
    DECLARE v_current INT DEFAULT 0;

    SELECT `Max_Capacity` INTO v_capacity
    FROM `training_session`
    WHERE `Reservation_ID` = NEW.Reservation_ID
    FOR UPDATE;

    IF v_capacity IS NULL THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Training session not found for enrollment';
    END IF;

    IF v_capacity <= 0 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Training session has no available capacity';
    END IF;

    SELECT COUNT(*) INTO v_current
    FROM `session_enrollment`
    WHERE `Reservation_ID` = NEW.Reservation_ID
      AND `id` <> OLD.`id`;

    IF v_current >= v_capacity THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Training session is full';
    END IF;
  END;
  ```

  - [在此插入截图：触发器 SQL 展示界面]

## Evidence scenarios (execute each bullet as a batch)

### Scenario A – Reservation overlap is blocked

- Create two non-overlapping reservations for facility 4 (tomorrow):

  ```sql
  SET @res_facility := 4;
  SET @res_date := DATE_ADD(CURDATE(), INTERVAL 1 DAY);
  INSERT INTO reservation (Reservation_Date, Start_Time, End_Time, Facility_ID)
  VALUES (@res_date, '10:00:00', '11:00:00', @res_facility);
  SET @res_ok_1 := LAST_INSERT_ID();
  INSERT INTO reservation (Reservation_Date, Start_Time, End_Time, Facility_ID)
  VALUES (@res_date, '12:00:00', '13:00:00', @res_facility);
  SET @res_ok_2 := LAST_INSERT_ID();
  SELECT 'current reservations' AS step, Reservation_ID, Start_Time, End_Time
  FROM reservation WHERE Reservation_ID IN (@res_ok_1, @res_ok_2) ORDER BY Reservation_ID;
  ```

  - ![A1](pic/A1.png)
- Attempt an overlapping insert (should fail):

  ```sql
  INSERT INTO reservation (Reservation_Date, Start_Time, End_Time, Facility_ID)
  VALUES (@res_date, '10:30:00', '11:30:00', @res_facility);
  ```

  - ![A2](pic/A2.png)
- Confirm only the two valid rows remain:

  ```sql
  SELECT Reservation_ID, Start_Time, End_Time
  FROM reservation
  WHERE Facility_ID = @res_facility AND Reservation_Date = @res_date
  ORDER BY Reservation_ID;
  ```

  - ![A3](pic/A3.png)

### Scenario B – Booking pending limit (max 2 per member)

- Prepare three future reservations for member 1:

  ```sql
  SET @booking_member := 1;
  SET @booking_date := DATE_ADD(CURDATE(), INTERVAL 2 DAY);
  INSERT INTO reservation (Reservation_Date, Start_Time, End_Time, Facility_ID)
  VALUES (@booking_date, '09:00:00', '10:00:00', 5);
  SET @book_res_1 := LAST_INSERT_ID();
  INSERT INTO reservation (Reservation_Date, Start_Time, End_Time, Facility_ID)
  VALUES (@booking_date, '10:10:00', '11:10:00', 5);
  SET @book_res_2 := LAST_INSERT_ID();
  INSERT INTO reservation (Reservation_Date, Start_Time, End_Time, Facility_ID)
  VALUES (@booking_date, '11:20:00', '12:20:00', 5);
  SET @book_res_3 := LAST_INSERT_ID();
  SELECT 'prep reservations' AS step, Reservation_ID, Reservation_Date, Start_Time, End_Time
  FROM reservation WHERE Reservation_ID IN (@book_res_1, @book_res_2, @book_res_3)
  ORDER BY Reservation_ID;
  ```

  - ![B1](pic/B1.png)
- Insert two Pending bookings (allowed) and count:

  ```sql
  INSERT INTO booking (Reservation_ID, Booking_Status, Member_ID)
  VALUES (@book_res_1, 'Pending', @booking_member);
  INSERT INTO booking (Reservation_ID, Booking_Status, Member_ID)
  VALUES (@book_res_2, 'Pending', @booking_member);
  SELECT 'after two pendings' AS step, COUNT(*) AS pending_count
  FROM booking WHERE Member_ID = @booking_member AND Booking_Status = 'Pending';
  ```

  - ![B2](pic/B2.png)
- Attempt third Pending (should fail) and verify list:

  ```sql
  INSERT INTO booking (Reservation_ID, Booking_Status, Member_ID)
  VALUES (@book_res_3, 'Pending', @booking_member);
  SELECT Reservation_ID, Booking_Status
  FROM booking WHERE Member_ID = @booking_member ORDER BY Reservation_ID;
  ```

  - ![B3](pic/B3.png)
  - ![B4](pic/B4.png)

### Scenario C – Maintenance XOR (one target only)

- Show invalid none/both targets, then valid facility-only:

  ```sql
  INSERT INTO maintenance (Scheduled_Date, Completion_Date, Status, Description, Equipment_ID, Facility_ID)
  VALUES (DATE_ADD(CURDATE(), INTERVAL 4 DAY), NULL, 'Scheduled', 'Invalid: none', NULL, NULL); -- expect error

  INSERT INTO maintenance (Scheduled_Date, Completion_Date, Status, Description, Equipment_ID, Facility_ID)
  VALUES (DATE_ADD(CURDATE(), INTERVAL 4 DAY), NULL, 'Scheduled', 'Invalid: both', 2, 4); -- expect error

  INSERT INTO maintenance (Scheduled_Date, Completion_Date, Status, Description, Equipment_ID, Facility_ID)
  VALUES (DATE_ADD(CURDATE(), INTERVAL 4 DAY), NULL, 'Scheduled', 'Valid facility maintenance', NULL, 4);
  SELECT 'valid maintenance inserted' AS step, Maintenance_ID, Equipment_ID, Facility_ID, Scheduled_Date, Status
  FROM maintenance ORDER BY Maintenance_ID DESC LIMIT 1;
  ```

  - ![C1](pic/C1.png)
  - ![C2](pic/C2.png)

### Scenario D – Reservation equipment availability

- Overlapping reservations for Equipment 2 and stock snapshot:

  ```sql
  SET @equip_date := DATE_ADD(CURDATE(), INTERVAL 2 DAY);
  INSERT INTO reservation (Reservation_Date, Start_Time, End_Time, Facility_ID)
  VALUES (@equip_date, '14:00:00', '15:00:00', 8);
  SET @equip_res_1 := LAST_INSERT_ID();
  INSERT INTO reservation (Reservation_Date, Start_Time, End_Time, Facility_ID)
  VALUES (@equip_date, '14:30:00', '15:30:00', 5);
  SET @equip_res_2 := LAST_INSERT_ID();
  SELECT 'equipment stock snapshot' AS step, Equipment_ID, Equipment_Name, Status, Total_Quantity
  FROM equipment WHERE Equipment_ID = 2;
  ```

  - ![D1](pic/D1.png)
- Valid assign, then over-allocate (should fail):

  ```sql
  INSERT INTO reservation_equipments (Quantity, Equipment_ID, Reservation_ID)
  VALUES (5, 2, @equip_res_1);
  SET @equip_row := LAST_INSERT_ID();
  SELECT 'after valid assign' AS step, id, Equipment_ID, Reservation_ID, Quantity
  FROM reservation_equipments WHERE id = @equip_row;

  INSERT INTO reservation_equipments (Quantity, Equipment_ID, Reservation_ID)
  VALUES (16, 2, @equip_res_2); -- expect error
  ```

  - ![D2](pic/D2.png)
  - ![D3](pic/D3.png)

### Scenario E – Session enrollment capacity

- One-seat session, first enrollment succeeds, second fails:

  ```sql
  SET @session_date := DATE_ADD(CURDATE(), INTERVAL 3 DAY);
  INSERT INTO reservation (Reservation_Date, Start_Time, End_Time, Facility_ID)
  VALUES (@session_date, '16:00:00', '17:00:00', 4);
  SET @session_res_full := LAST_INSERT_ID();
  INSERT INTO training_session (Reservation_ID, Max_Capacity, Coach_ID)
  VALUES (@session_res_full, 1, 1);
  SELECT 'session created' AS step, Reservation_ID, Max_Capacity, Coach_ID
  FROM training_session WHERE Reservation_ID = @session_res_full;

  INSERT INTO session_enrollment (Member_ID, Reservation_ID)
  VALUES (1, @session_res_full);
  SELECT 'after first enrollment' AS step, id, Member_ID, Reservation_ID
  FROM session_enrollment WHERE Reservation_ID = @session_res_full;

  INSERT INTO session_enrollment (Member_ID, Reservation_ID)
  VALUES (2, @session_res_full); -- expect error
  ```
  - ![E1](pic/E1.png)
  - ![E2](pic/E2.png)
  - ![E3](pic/E3.png)
