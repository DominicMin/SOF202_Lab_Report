/*
 Navicat Premium Data Transfer

 Source Schema         : sports_arena
 Target Server Type    : MySQL
 File Encoding         : 65001

 Task 3 - Triggering Procedures
 Two triggers aligned with the sports_arena schema:
 1) BEFORE INSERT on reservation to block invalid/overlapping bookings and lock the facility.
 2) AFTER DELETE on reservation to release the facility when no bookings remain.
*/

USE `sports_arena`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Trigger structure for reservation_bi_guardrails
-- ----------------------------
DROP TRIGGER IF EXISTS `reservation_bi_guardrails`;
DELIMITER ;;
CREATE TRIGGER `reservation_bi_guardrails` BEFORE INSERT ON `reservation`
FOR EACH ROW
BEGIN
  DECLARE v_facility_status VARCHAR(20);
  DECLARE v_conflicts INT DEFAULT 0;

  -- Ensure the time window is valid
  IF NEW.Start_Time >= NEW.End_Time THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Reservation start time must be earlier than end time';
  END IF;

  -- Facility must exist and be available
  SELECT `Status` INTO v_facility_status
  FROM `facility`
  WHERE `Facility_ID` = NEW.Facility_ID
  LIMIT 1;

  IF v_facility_status IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Facility does not exist for this reservation';
  END IF;

  IF v_facility_status <> 'Available' THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Facility is not available for reservation';
  END IF;

  -- Block overlaps on the same facility/date (any intersecting time window)
  SELECT COUNT(*) INTO v_conflicts
  FROM `reservation` r
  WHERE r.`Facility_ID` = NEW.Facility_ID
    AND r.`Reservation_Date` = NEW.Reservation_Date
    AND NOT (NEW.End_Time <= r.`Start_Time` OR NEW.Start_Time >= r.`End_Time`);

  IF v_conflicts > 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Reservation overlaps with an existing booking for this facility';
  END IF;

  -- Mark facility as occupied after validation passes
  UPDATE `facility`
  SET `Status` = 'Occupied'
  WHERE `Facility_ID` = NEW.Facility_ID;
END;;
DELIMITER ;

-- ----------------------------
-- Trigger structure for reservation_ad_release_facility
-- ----------------------------
DROP TRIGGER IF EXISTS `reservation_ad_release_facility`;
DELIMITER ;;
CREATE TRIGGER `reservation_ad_release_facility` AFTER DELETE ON `reservation`
FOR EACH ROW
BEGIN
  DECLARE v_remaining INT DEFAULT 0;

  SELECT COUNT(*) INTO v_remaining
  FROM `reservation`
  WHERE `Facility_ID` = OLD.Facility_ID;

  IF v_remaining = 0 THEN
    UPDATE `facility`
    SET `Status` = 'Available'
    WHERE `Facility_ID` = OLD.Facility_ID
      AND `Status` = 'Occupied';
  END IF;
END;;
DELIMITER ;

SET FOREIGN_KEY_CHECKS = 1;
