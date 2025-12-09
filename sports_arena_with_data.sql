/*
 Navicat Premium Dump SQL

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80042 (8.0.42)
 Source Host           : localhost:3306
 Source Schema         : sports_arena

 Target Server Type    : MySQL
 Target Server Version : 80042 (8.0.42)
 File Encoding         : 65001

 Date: 09/12/2025 22:30:41
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_group
-- ----------------------------
INSERT INTO `auth_group` VALUES (2, 'coach_role');
INSERT INTO `auth_group` VALUES (1, 'member_role');

-- ----------------------------
-- Table structure for auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_group_permissions_group_id_permission_id_0cd325b0_uniq`(`group_id` ASC, `permission_id` ASC) USING BTREE,
  INDEX `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm`(`permission_id` ASC) USING BTREE,
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_group_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_permission_content_type_id_codename_01ab375a_uniq`(`content_type_id` ASC, `codename` ASC) USING BTREE,
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 141 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_permission
-- ----------------------------
INSERT INTO `auth_permission` VALUES (1, 'Can add log entry', 1, 'add_logentry');
INSERT INTO `auth_permission` VALUES (2, 'Can change log entry', 1, 'change_logentry');
INSERT INTO `auth_permission` VALUES (3, 'Can delete log entry', 1, 'delete_logentry');
INSERT INTO `auth_permission` VALUES (4, 'Can view log entry', 1, 'view_logentry');
INSERT INTO `auth_permission` VALUES (5, 'Can add permission', 2, 'add_permission');
INSERT INTO `auth_permission` VALUES (6, 'Can change permission', 2, 'change_permission');
INSERT INTO `auth_permission` VALUES (7, 'Can delete permission', 2, 'delete_permission');
INSERT INTO `auth_permission` VALUES (8, 'Can view permission', 2, 'view_permission');
INSERT INTO `auth_permission` VALUES (9, 'Can add group', 3, 'add_group');
INSERT INTO `auth_permission` VALUES (10, 'Can change group', 3, 'change_group');
INSERT INTO `auth_permission` VALUES (11, 'Can delete group', 3, 'delete_group');
INSERT INTO `auth_permission` VALUES (12, 'Can view group', 3, 'view_group');
INSERT INTO `auth_permission` VALUES (13, 'Can add user', 4, 'add_user');
INSERT INTO `auth_permission` VALUES (14, 'Can change user', 4, 'change_user');
INSERT INTO `auth_permission` VALUES (15, 'Can delete user', 4, 'delete_user');
INSERT INTO `auth_permission` VALUES (16, 'Can view user', 4, 'view_user');
INSERT INTO `auth_permission` VALUES (17, 'Can add content type', 5, 'add_contenttype');
INSERT INTO `auth_permission` VALUES (18, 'Can change content type', 5, 'change_contenttype');
INSERT INTO `auth_permission` VALUES (19, 'Can delete content type', 5, 'delete_contenttype');
INSERT INTO `auth_permission` VALUES (20, 'Can view content type', 5, 'view_contenttype');
INSERT INTO `auth_permission` VALUES (21, 'Can add session', 6, 'add_session');
INSERT INTO `auth_permission` VALUES (22, 'Can change session', 6, 'change_session');
INSERT INTO `auth_permission` VALUES (23, 'Can delete session', 6, 'delete_session');
INSERT INTO `auth_permission` VALUES (24, 'Can view session', 6, 'view_session');
INSERT INTO `auth_permission` VALUES (25, 'Can add member', 7, 'add_member');
INSERT INTO `auth_permission` VALUES (26, 'Can change member', 7, 'change_member');
INSERT INTO `auth_permission` VALUES (27, 'Can delete member', 7, 'delete_member');
INSERT INTO `auth_permission` VALUES (28, 'Can view member', 7, 'view_member');
INSERT INTO `auth_permission` VALUES (29, 'Can add coach', 8, 'add_coach');
INSERT INTO `auth_permission` VALUES (30, 'Can change coach', 8, 'change_coach');
INSERT INTO `auth_permission` VALUES (31, 'Can delete coach', 8, 'delete_coach');
INSERT INTO `auth_permission` VALUES (32, 'Can view coach', 8, 'view_coach');
INSERT INTO `auth_permission` VALUES (33, 'Can add coach profile', 9, 'add_coachprofile');
INSERT INTO `auth_permission` VALUES (34, 'Can change coach profile', 9, 'change_coachprofile');
INSERT INTO `auth_permission` VALUES (35, 'Can delete coach profile', 9, 'delete_coachprofile');
INSERT INTO `auth_permission` VALUES (36, 'Can view coach profile', 9, 'view_coachprofile');
INSERT INTO `auth_permission` VALUES (37, 'Can add external_ visitor', 10, 'add_external_visitor');
INSERT INTO `auth_permission` VALUES (38, 'Can change external_ visitor', 10, 'change_external_visitor');
INSERT INTO `auth_permission` VALUES (39, 'Can delete external_ visitor', 10, 'delete_external_visitor');
INSERT INTO `auth_permission` VALUES (40, 'Can view external_ visitor', 10, 'view_external_visitor');
INSERT INTO `auth_permission` VALUES (41, 'Can add staff', 11, 'add_staff');
INSERT INTO `auth_permission` VALUES (42, 'Can change staff', 11, 'change_staff');
INSERT INTO `auth_permission` VALUES (43, 'Can delete staff', 11, 'delete_staff');
INSERT INTO `auth_permission` VALUES (44, 'Can view staff', 11, 'view_staff');
INSERT INTO `auth_permission` VALUES (45, 'Can add student', 12, 'add_student');
INSERT INTO `auth_permission` VALUES (46, 'Can change student', 12, 'change_student');
INSERT INTO `auth_permission` VALUES (47, 'Can delete student', 12, 'delete_student');
INSERT INTO `auth_permission` VALUES (48, 'Can view student', 12, 'view_student');
INSERT INTO `auth_permission` VALUES (49, 'Can add member profile', 13, 'add_memberprofile');
INSERT INTO `auth_permission` VALUES (50, 'Can change member profile', 13, 'change_memberprofile');
INSERT INTO `auth_permission` VALUES (51, 'Can delete member profile', 13, 'delete_memberprofile');
INSERT INTO `auth_permission` VALUES (52, 'Can view member profile', 13, 'view_memberprofile');
INSERT INTO `auth_permission` VALUES (53, 'Can add coach_ email', 14, 'add_coach_email');
INSERT INTO `auth_permission` VALUES (54, 'Can change coach_ email', 14, 'change_coach_email');
INSERT INTO `auth_permission` VALUES (55, 'Can delete coach_ email', 14, 'delete_coach_email');
INSERT INTO `auth_permission` VALUES (56, 'Can view coach_ email', 14, 'view_coach_email');
INSERT INTO `auth_permission` VALUES (57, 'Can add coach_ phone', 15, 'add_coach_phone');
INSERT INTO `auth_permission` VALUES (58, 'Can change coach_ phone', 15, 'change_coach_phone');
INSERT INTO `auth_permission` VALUES (59, 'Can delete coach_ phone', 15, 'delete_coach_phone');
INSERT INTO `auth_permission` VALUES (60, 'Can view coach_ phone', 15, 'view_coach_phone');
INSERT INTO `auth_permission` VALUES (61, 'Can add member_ email', 16, 'add_member_email');
INSERT INTO `auth_permission` VALUES (62, 'Can change member_ email', 16, 'change_member_email');
INSERT INTO `auth_permission` VALUES (63, 'Can delete member_ email', 16, 'delete_member_email');
INSERT INTO `auth_permission` VALUES (64, 'Can view member_ email', 16, 'view_member_email');
INSERT INTO `auth_permission` VALUES (65, 'Can add member_ phone', 17, 'add_member_phone');
INSERT INTO `auth_permission` VALUES (66, 'Can change member_ phone', 17, 'change_member_phone');
INSERT INTO `auth_permission` VALUES (67, 'Can delete member_ phone', 17, 'delete_member_phone');
INSERT INTO `auth_permission` VALUES (68, 'Can view member_ phone', 17, 'view_member_phone');
INSERT INTO `auth_permission` VALUES (69, 'Can add reservation', 18, 'add_reservation');
INSERT INTO `auth_permission` VALUES (70, 'Can change reservation', 18, 'change_reservation');
INSERT INTO `auth_permission` VALUES (71, 'Can delete reservation', 18, 'delete_reservation');
INSERT INTO `auth_permission` VALUES (72, 'Can view reservation', 18, 'view_reservation');
INSERT INTO `auth_permission` VALUES (73, 'Can add old booking', 19, 'add_oldbooking');
INSERT INTO `auth_permission` VALUES (74, 'Can change old booking', 19, 'change_oldbooking');
INSERT INTO `auth_permission` VALUES (75, 'Can delete old booking', 19, 'delete_oldbooking');
INSERT INTO `auth_permission` VALUES (76, 'Can view old booking', 19, 'view_oldbooking');
INSERT INTO `auth_permission` VALUES (77, 'Can add old reservation', 20, 'add_oldreservation');
INSERT INTO `auth_permission` VALUES (78, 'Can change old reservation', 20, 'change_oldreservation');
INSERT INTO `auth_permission` VALUES (79, 'Can delete old reservation', 20, 'delete_oldreservation');
INSERT INTO `auth_permission` VALUES (80, 'Can view old reservation', 20, 'view_oldreservation');
INSERT INTO `auth_permission` VALUES (81, 'Can add old training session', 21, 'add_oldtrainingsession');
INSERT INTO `auth_permission` VALUES (82, 'Can change old training session', 21, 'change_oldtrainingsession');
INSERT INTO `auth_permission` VALUES (83, 'Can delete old training session', 21, 'delete_oldtrainingsession');
INSERT INTO `auth_permission` VALUES (84, 'Can view old training session', 21, 'view_oldtrainingsession');
INSERT INTO `auth_permission` VALUES (85, 'Can add reservation_ equipments', 22, 'add_reservation_equipments');
INSERT INTO `auth_permission` VALUES (86, 'Can change reservation_ equipments', 22, 'change_reservation_equipments');
INSERT INTO `auth_permission` VALUES (87, 'Can delete reservation_ equipments', 22, 'delete_reservation_equipments');
INSERT INTO `auth_permission` VALUES (88, 'Can view reservation_ equipments', 22, 'view_reservation_equipments');
INSERT INTO `auth_permission` VALUES (89, 'Can add reservation equipment', 23, 'add_reservationequipment');
INSERT INTO `auth_permission` VALUES (90, 'Can change reservation equipment', 23, 'change_reservationequipment');
INSERT INTO `auth_permission` VALUES (91, 'Can delete reservation equipment', 23, 'delete_reservationequipment');
INSERT INTO `auth_permission` VALUES (92, 'Can view reservation equipment', 23, 'view_reservationequipment');
INSERT INTO `auth_permission` VALUES (93, 'Can add session enrollment', 24, 'add_sessionenrollment');
INSERT INTO `auth_permission` VALUES (94, 'Can change session enrollment', 24, 'change_sessionenrollment');
INSERT INTO `auth_permission` VALUES (95, 'Can delete session enrollment', 24, 'delete_sessionenrollment');
INSERT INTO `auth_permission` VALUES (96, 'Can view session enrollment', 24, 'view_sessionenrollment');
INSERT INTO `auth_permission` VALUES (97, 'Can add booking', 25, 'add_booking');
INSERT INTO `auth_permission` VALUES (98, 'Can change booking', 25, 'change_booking');
INSERT INTO `auth_permission` VALUES (99, 'Can delete booking', 25, 'delete_booking');
INSERT INTO `auth_permission` VALUES (100, 'Can view booking', 25, 'view_booking');
INSERT INTO `auth_permission` VALUES (101, 'Can add training session', 26, 'add_trainingsession');
INSERT INTO `auth_permission` VALUES (102, 'Can change training session', 26, 'change_trainingsession');
INSERT INTO `auth_permission` VALUES (103, 'Can delete training session', 26, 'delete_trainingsession');
INSERT INTO `auth_permission` VALUES (104, 'Can view training session', 26, 'view_trainingsession');
INSERT INTO `auth_permission` VALUES (105, 'Can add session_ enrollment', 27, 'add_session_enrollment');
INSERT INTO `auth_permission` VALUES (106, 'Can change session_ enrollment', 27, 'change_session_enrollment');
INSERT INTO `auth_permission` VALUES (107, 'Can delete session_ enrollment', 27, 'delete_session_enrollment');
INSERT INTO `auth_permission` VALUES (108, 'Can view session_ enrollment', 27, 'view_session_enrollment');
INSERT INTO `auth_permission` VALUES (109, 'Can add equipment', 28, 'add_equipment');
INSERT INTO `auth_permission` VALUES (110, 'Can change equipment', 28, 'change_equipment');
INSERT INTO `auth_permission` VALUES (111, 'Can delete equipment', 28, 'delete_equipment');
INSERT INTO `auth_permission` VALUES (112, 'Can view equipment', 28, 'view_equipment');
INSERT INTO `auth_permission` VALUES (113, 'Can add facility', 29, 'add_facility');
INSERT INTO `auth_permission` VALUES (114, 'Can change facility', 29, 'change_facility');
INSERT INTO `auth_permission` VALUES (115, 'Can delete facility', 29, 'delete_facility');
INSERT INTO `auth_permission` VALUES (116, 'Can view facility', 29, 'view_facility');
INSERT INTO `auth_permission` VALUES (117, 'Can add visitor_ application', 30, 'add_visitor_application');
INSERT INTO `auth_permission` VALUES (118, 'Can change visitor_ application', 30, 'change_visitor_application');
INSERT INTO `auth_permission` VALUES (119, 'Can delete visitor_ application', 30, 'delete_visitor_application');
INSERT INTO `auth_permission` VALUES (120, 'Can view visitor_ application', 30, 'view_visitor_application');
INSERT INTO `auth_permission` VALUES (121, 'Can add visitor_ application_ email', 31, 'add_visitor_application_email');
INSERT INTO `auth_permission` VALUES (122, 'Can change visitor_ application_ email', 31, 'change_visitor_application_email');
INSERT INTO `auth_permission` VALUES (123, 'Can delete visitor_ application_ email', 31, 'delete_visitor_application_email');
INSERT INTO `auth_permission` VALUES (124, 'Can view visitor_ application_ email', 31, 'view_visitor_application_email');
INSERT INTO `auth_permission` VALUES (125, 'Can add visitor_ application_ phone', 32, 'add_visitor_application_phone');
INSERT INTO `auth_permission` VALUES (126, 'Can change visitor_ application_ phone', 32, 'change_visitor_application_phone');
INSERT INTO `auth_permission` VALUES (127, 'Can delete visitor_ application_ phone', 32, 'delete_visitor_application_phone');
INSERT INTO `auth_permission` VALUES (128, 'Can view visitor_ application_ phone', 32, 'view_visitor_application_phone');
INSERT INTO `auth_permission` VALUES (129, 'Can add visitor application', 33, 'add_visitorapplication');
INSERT INTO `auth_permission` VALUES (130, 'Can change visitor application', 33, 'change_visitorapplication');
INSERT INTO `auth_permission` VALUES (131, 'Can delete visitor application', 33, 'delete_visitorapplication');
INSERT INTO `auth_permission` VALUES (132, 'Can view visitor application', 33, 'view_visitorapplication');
INSERT INTO `auth_permission` VALUES (133, 'Can add external visitor', 34, 'add_externalvisitor');
INSERT INTO `auth_permission` VALUES (134, 'Can change external visitor', 34, 'change_externalvisitor');
INSERT INTO `auth_permission` VALUES (135, 'Can delete external visitor', 34, 'delete_externalvisitor');
INSERT INTO `auth_permission` VALUES (136, 'Can view external visitor', 34, 'view_externalvisitor');
INSERT INTO `auth_permission` VALUES (137, 'Can add maintenance', 35, 'add_maintenance');
INSERT INTO `auth_permission` VALUES (138, 'Can change maintenance', 35, 'change_maintenance');
INSERT INTO `auth_permission` VALUES (139, 'Can delete maintenance', 35, 'delete_maintenance');
INSERT INTO `auth_permission` VALUES (140, 'Can view maintenance', 35, 'view_maintenance');

-- ----------------------------
-- Table structure for auth_user
-- ----------------------------
DROP TABLE IF EXISTS `auth_user`;
CREATE TABLE `auth_user`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_login` datetime(6) NULL DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_user
-- ----------------------------
INSERT INTO `auth_user` VALUES (1, 'pbkdf2_sha256$600000$ktChHFnzzseqrsdIFSbDNV$ffxqMurodmDcYRVK+hDMqhKedbR+8+qf+R488MHtg4g=', '2025-12-08 14:11:39.838991', 1, 'Admin', '', '', 'Admin@qq.com', 1, 1, '2025-12-03 14:13:11.922482');
INSERT INTO `auth_user` VALUES (4, 'pbkdf2_sha256$600000$iwJTcahzJwApPD8Dpoxht2$1yTx7ebyzk0ia2TMysmgJQCYVxzs4EDb7NYiXpHYcFU=', '2025-12-08 14:04:28.432632', 0, 'C1', 'C', '1', 'C1@qq.com', 0, 1, '2025-12-03 16:34:22.134362');
INSERT INTO `auth_user` VALUES (5, 'pbkdf2_sha256$600000$EWGTcAXxVua6ZmzYU4Ayfe$SoGAaheDX27l0+Z296v2AFgf3zTRGiYMzpRwVXZrQsI=', '2025-12-08 13:48:23.097978', 0, 'M1', 'M', '1', 'M1@qq.com', 0, 1, '2025-12-08 06:09:55.154559');
INSERT INTO `auth_user` VALUES (6, 'pbkdf2_sha256$600000$Mp2q3hZrGmQ8vKUX2oeuDh$4YSheBmwDyPzLNCbjSi44Yh8p4nyNWwFI8jQwkXsNU4=', '2025-12-08 14:18:35.476273', 0, 'M2', 'M', '2', 'M2@qq.com', 0, 1, '2025-12-08 14:18:22.803079');
INSERT INTO `auth_user` VALUES (7, 'pbkdf2_sha256$600000$QD4eTkPjwwuu5kovWfJeYS$VGoc9IZMm49F7txbrs9Q1Gm6tl0v8hlirocWLNoyl9w=', NULL, 0, 'Luccy', 'Kailong', 'Deng', 'Luccy@qq.com', 0, 1, '2025-12-08 14:22:13.988279');

-- ----------------------------
-- Table structure for auth_user_groups
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_groups`;
CREATE TABLE `auth_user_groups`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_groups_user_id_group_id_94350c0c_uniq`(`user_id` ASC, `group_id` ASC) USING BTREE,
  INDEX `auth_user_groups_group_id_97559544_fk_auth_group_id`(`group_id` ASC) USING BTREE,
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_user_groups
-- ----------------------------
INSERT INTO `auth_user_groups` VALUES (3, 4, 2);
INSERT INTO `auth_user_groups` VALUES (4, 5, 1);
INSERT INTO `auth_user_groups` VALUES (5, 6, 1);
INSERT INTO `auth_user_groups` VALUES (6, 7, 1);

-- ----------------------------
-- Table structure for auth_user_user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_user_permissions`;
CREATE TABLE `auth_user_user_permissions`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq`(`user_id` ASC, `permission_id` ASC) USING BTREE,
  INDEX `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm`(`permission_id` ASC) USING BTREE,
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_user_user_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for booking
-- ----------------------------
DROP TABLE IF EXISTS `booking`;
CREATE TABLE `booking`  (
  `Reservation_ID` int NOT NULL,
  `Booking_Status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Member_ID` int NOT NULL,
  PRIMARY KEY (`Reservation_ID`) USING BTREE,
  INDEX `Booking_Member__138c47_idx`(`Member_ID` ASC) USING BTREE,
  CONSTRAINT `Booking_Member_ID_311d123e_fk_Member_Member_ID` FOREIGN KEY (`Member_ID`) REFERENCES `member` (`Member_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `Booking_Reservation_ID_2e41085d_fk_Reservation_Reservation_ID` FOREIGN KEY (`Reservation_ID`) REFERENCES `reservation` (`Reservation_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of booking
-- ----------------------------
INSERT INTO `booking` VALUES (1, 'Confirmed', 1);

-- ----------------------------
-- Table structure for coach
-- ----------------------------
DROP TABLE IF EXISTS `coach`;
CREATE TABLE `coach`  (
  `Coach_ID` int NOT NULL AUTO_INCREMENT,
  `First_Name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Last_Name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Sport_Type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int NULL DEFAULT NULL,
  PRIMARY KEY (`Coach_ID`) USING BTREE,
  UNIQUE INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `Coach_user_id_9aeee395_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of coach
-- ----------------------------
INSERT INTO `coach` VALUES (1, 'C', '1', 'General', 'Junior', 4);

-- ----------------------------
-- Table structure for coach_email
-- ----------------------------
DROP TABLE IF EXISTS `coach_email`;
CREATE TABLE `coach_email`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `Email_Address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Coach_ID` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `Coach_Email_Coach_ID_Email_Address_e1c03b7e_uniq`(`Coach_ID` ASC, `Email_Address` ASC) USING BTREE,
  CONSTRAINT `Coach_Email_Coach_ID_56139de1_fk_Coach_Coach_ID` FOREIGN KEY (`Coach_ID`) REFERENCES `coach` (`Coach_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of coach_email
-- ----------------------------

-- ----------------------------
-- Table structure for coach_phone
-- ----------------------------
DROP TABLE IF EXISTS `coach_phone`;
CREATE TABLE `coach_phone`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `Phone_Number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Coach_ID` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `Coach_Phone_Coach_ID_Phone_Number_19d92fc6_uniq`(`Coach_ID` ASC, `Phone_Number` ASC) USING BTREE,
  CONSTRAINT `Coach_Phone_Coach_ID_279028ed_fk_Coach_Coach_ID` FOREIGN KEY (`Coach_ID`) REFERENCES `coach` (`Coach_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of coach_phone
-- ----------------------------
INSERT INTO `coach_phone` VALUES (1, '123456', 1);

-- ----------------------------
-- Table structure for django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `object_repr` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `action_flag` smallint UNSIGNED NOT NULL,
  `change_message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int NULL DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `django_admin_log_content_type_id_c4bce8eb_fk_django_co`(`content_type_id` ASC) USING BTREE,
  INDEX `django_admin_log_user_id_c564eba6_fk_auth_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_admin_log_chk_1` CHECK (`action_flag` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_admin_log
-- ----------------------------
INSERT INTO `django_admin_log` VALUES (1, '2025-12-03 16:14:10.958394', '2', 'M1', 3, '', 4, 1);
INSERT INTO `django_admin_log` VALUES (2, '2025-12-03 16:14:10.961053', '3', 'M2', 3, '', 4, 1);

-- ----------------------------
-- Table structure for django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `django_content_type_app_label_model_76bd3d3b_uniq`(`app_label` ASC, `model` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 36 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_content_type
-- ----------------------------
INSERT INTO `django_content_type` VALUES (8, 'accounts', 'coach');
INSERT INTO `django_content_type` VALUES (14, 'accounts', 'coach_email');
INSERT INTO `django_content_type` VALUES (15, 'accounts', 'coach_phone');
INSERT INTO `django_content_type` VALUES (9, 'accounts', 'coachprofile');
INSERT INTO `django_content_type` VALUES (10, 'accounts', 'external_visitor');
INSERT INTO `django_content_type` VALUES (7, 'accounts', 'member');
INSERT INTO `django_content_type` VALUES (16, 'accounts', 'member_email');
INSERT INTO `django_content_type` VALUES (17, 'accounts', 'member_phone');
INSERT INTO `django_content_type` VALUES (13, 'accounts', 'memberprofile');
INSERT INTO `django_content_type` VALUES (11, 'accounts', 'staff');
INSERT INTO `django_content_type` VALUES (12, 'accounts', 'student');
INSERT INTO `django_content_type` VALUES (1, 'admin', 'logentry');
INSERT INTO `django_content_type` VALUES (3, 'auth', 'group');
INSERT INTO `django_content_type` VALUES (2, 'auth', 'permission');
INSERT INTO `django_content_type` VALUES (4, 'auth', 'user');
INSERT INTO `django_content_type` VALUES (25, 'bookings', 'booking');
INSERT INTO `django_content_type` VALUES (19, 'bookings', 'oldbooking');
INSERT INTO `django_content_type` VALUES (20, 'bookings', 'oldreservation');
INSERT INTO `django_content_type` VALUES (21, 'bookings', 'oldtrainingsession');
INSERT INTO `django_content_type` VALUES (18, 'bookings', 'reservation');
INSERT INTO `django_content_type` VALUES (22, 'bookings', 'reservation_equipments');
INSERT INTO `django_content_type` VALUES (23, 'bookings', 'reservationequipment');
INSERT INTO `django_content_type` VALUES (27, 'bookings', 'session_enrollment');
INSERT INTO `django_content_type` VALUES (24, 'bookings', 'sessionenrollment');
INSERT INTO `django_content_type` VALUES (26, 'bookings', 'trainingsession');
INSERT INTO `django_content_type` VALUES (5, 'contenttypes', 'contenttype');
INSERT INTO `django_content_type` VALUES (28, 'management_portal', 'equipment');
INSERT INTO `django_content_type` VALUES (34, 'management_portal', 'externalvisitor');
INSERT INTO `django_content_type` VALUES (29, 'management_portal', 'facility');
INSERT INTO `django_content_type` VALUES (35, 'management_portal', 'maintenance');
INSERT INTO `django_content_type` VALUES (30, 'management_portal', 'visitor_application');
INSERT INTO `django_content_type` VALUES (31, 'management_portal', 'visitor_application_email');
INSERT INTO `django_content_type` VALUES (32, 'management_portal', 'visitor_application_phone');
INSERT INTO `django_content_type` VALUES (33, 'management_portal', 'visitorapplication');
INSERT INTO `django_content_type` VALUES (6, 'sessions', 'session');

-- ----------------------------
-- Table structure for django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_migrations
-- ----------------------------
INSERT INTO `django_migrations` VALUES (1, 'contenttypes', '0001_initial', '2025-12-03 14:02:32.094927');
INSERT INTO `django_migrations` VALUES (2, 'auth', '0001_initial', '2025-12-03 14:02:32.450510');
INSERT INTO `django_migrations` VALUES (3, 'accounts', '0001_initial', '2025-12-03 14:02:33.062357');
INSERT INTO `django_migrations` VALUES (4, 'admin', '0001_initial', '2025-12-03 14:02:33.161581');
INSERT INTO `django_migrations` VALUES (5, 'admin', '0002_logentry_remove_auto_add', '2025-12-03 14:02:33.167579');
INSERT INTO `django_migrations` VALUES (6, 'admin', '0003_logentry_add_action_flag_choices', '2025-12-03 14:02:33.172754');
INSERT INTO `django_migrations` VALUES (7, 'contenttypes', '0002_remove_content_type_name', '2025-12-03 14:02:33.223002');
INSERT INTO `django_migrations` VALUES (8, 'auth', '0002_alter_permission_name_max_length', '2025-12-03 14:02:33.249798');
INSERT INTO `django_migrations` VALUES (9, 'auth', '0003_alter_user_email_max_length', '2025-12-03 14:02:33.271976');
INSERT INTO `django_migrations` VALUES (10, 'auth', '0004_alter_user_username_opts', '2025-12-03 14:02:33.280232');
INSERT INTO `django_migrations` VALUES (11, 'auth', '0005_alter_user_last_login_null', '2025-12-03 14:02:33.318706');
INSERT INTO `django_migrations` VALUES (12, 'auth', '0006_require_contenttypes_0002', '2025-12-03 14:02:33.320404');
INSERT INTO `django_migrations` VALUES (13, 'auth', '0007_alter_validators_add_error_messages', '2025-12-03 14:02:33.328630');
INSERT INTO `django_migrations` VALUES (14, 'auth', '0008_alter_user_username_max_length', '2025-12-03 14:02:33.388251');
INSERT INTO `django_migrations` VALUES (15, 'auth', '0009_alter_user_last_name_max_length', '2025-12-03 14:02:33.456635');
INSERT INTO `django_migrations` VALUES (16, 'auth', '0010_alter_group_name_max_length', '2025-12-03 14:02:33.492325');
INSERT INTO `django_migrations` VALUES (17, 'auth', '0011_update_proxy_permissions', '2025-12-03 14:02:33.508912');
INSERT INTO `django_migrations` VALUES (18, 'auth', '0012_alter_user_first_name_max_length', '2025-12-03 14:02:33.572324');
INSERT INTO `django_migrations` VALUES (19, 'management_portal', '0001_initial', '2025-12-03 14:02:34.065635');
INSERT INTO `django_migrations` VALUES (20, 'bookings', '0001_initial', '2025-12-03 14:02:35.329675');
INSERT INTO `django_migrations` VALUES (21, 'sessions', '0001_initial', '2025-12-03 14:02:35.357954');
INSERT INTO `django_migrations` VALUES (22, 'bookings', '0002_remove_oldreservation_assigned_officer_and_more', '2025-12-08 09:13:57.353555');
INSERT INTO `django_migrations` VALUES (23, 'accounts', '0002_remove_memberprofile_user_delete_coachprofile_and_more', '2025-12-08 09:13:57.432913');
INSERT INTO `django_migrations` VALUES (24, 'management_portal', '0002_remove_visitorapplication_reviewed_by_and_more', '2025-12-08 09:13:57.508557');

-- ----------------------------
-- Table structure for django_session
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session`  (
  `session_key` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `session_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`) USING BTREE,
  INDEX `django_session_expire_date_a5c62663`(`expire_date` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_session
-- ----------------------------

-- ----------------------------
-- Table structure for equipment
-- ----------------------------
DROP TABLE IF EXISTS `equipment`;
CREATE TABLE `equipment`  (
  `Equipment_ID` int NOT NULL AUTO_INCREMENT,
  `Equipment_Name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Total_Quantity` int UNSIGNED NOT NULL,
  PRIMARY KEY (`Equipment_ID`) USING BTREE,
  CONSTRAINT `equipment_chk_1` CHECK (`Total_Quantity` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of equipment
-- ----------------------------
INSERT INTO `equipment` VALUES (1, 'Equipment1', 'Training Aid', 'Maintenance', 26);
INSERT INTO `equipment` VALUES (2, 'Equipment2', 'Ball Sports', 'Available', 20);
INSERT INTO `equipment` VALUES (3, 'Equipment3', 'Measuring Device', 'Available', 14);
INSERT INTO `equipment` VALUES (4, 'Equipment4', 'Measuring Device', 'Maintenance', 38);
INSERT INTO `equipment` VALUES (5, 'Equipment5', 'Aquatic Gear', 'Available', 6);
INSERT INTO `equipment` VALUES (6, 'Equipment6', 'Fitness Gear', 'In Use', 6);
INSERT INTO `equipment` VALUES (7, 'Equipment7', 'Fitness Gear', 'Maintenance', 26);
INSERT INTO `equipment` VALUES (8, 'Equipment8', 'Training Aid', 'Retired', 44);
INSERT INTO `equipment` VALUES (9, 'Equipment9', 'Measuring Device', 'In Use', 42);
INSERT INTO `equipment` VALUES (10, 'Equipment10', 'Aquatic Gear', 'Available', 39);
INSERT INTO `equipment` VALUES (11, 'Equipment11', 'Ball Sports', 'Maintenance', 6);
INSERT INTO `equipment` VALUES (12, 'Equipment12', 'Training Aid', 'Maintenance', 20);
INSERT INTO `equipment` VALUES (13, 'Equipment13', 'Fitness Gear', 'Maintenance', 28);
INSERT INTO `equipment` VALUES (14, 'Equipment14', 'Training Aid', 'In Use', 42);
INSERT INTO `equipment` VALUES (15, 'Equipment15', 'Training Aid', 'In Use', 49);

-- ----------------------------
-- Table structure for external_visitor
-- ----------------------------
DROP TABLE IF EXISTS `external_visitor`;
CREATE TABLE `external_visitor`  (
  `Member_ID` int NOT NULL,
  `IC_Number` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`Member_ID`) USING BTREE,
  UNIQUE INDEX `IC_Number`(`IC_Number` ASC) USING BTREE,
  CONSTRAINT `External_Visitor_Member_ID_b0cc93e8_fk_Member_Member_ID` FOREIGN KEY (`Member_ID`) REFERENCES `member` (`Member_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of external_visitor
-- ----------------------------

-- ----------------------------
-- Table structure for facility
-- ----------------------------
DROP TABLE IF EXISTS `facility`;
CREATE TABLE `facility`  (
  `Facility_ID` int NOT NULL AUTO_INCREMENT,
  `Facility_Name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Capacity` int UNSIGNED NOT NULL,
  `Building` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Floor` smallint NOT NULL,
  `Room_Number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`Facility_ID`) USING BTREE,
  CONSTRAINT `facility_chk_1` CHECK (`Capacity` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of facility
-- ----------------------------
INSERT INTO `facility` VALUES (1, 'Facility1', 'Swimming Pool', 'Maintenance', 96, 'Main Building', 4, '401');
INSERT INTO `facility` VALUES (2, 'Facility2', 'Gym', 'Occupied', 31, 'Main Building', 2, '202');
INSERT INTO `facility` VALUES (3, 'Facility3', 'Table Tennis Room', 'Occupied', 64, 'Sports Hall B', 4, '403');
INSERT INTO `facility` VALUES (4, 'Facility4', 'Tennis Court', 'Available', 41, 'Main Building', 3, '304');
INSERT INTO `facility` VALUES (5, 'Facility5', 'Tennis Court', 'Available', 69, 'Sports Hall B', 1, '105');
INSERT INTO `facility` VALUES (6, 'Facility6', 'Tennis Court', 'Maintenance', 66, 'Sports Hall B', 1, '106');
INSERT INTO `facility` VALUES (7, 'Facility7', 'Table Tennis Room', 'Occupied', 37, 'Activity Center', 2, '207');
INSERT INTO `facility` VALUES (8, 'Facility8', 'Gym', 'Available', 39, 'Activity Center', 3, '308');
INSERT INTO `facility` VALUES (9, 'Facility9', 'Tennis Court', 'Maintenance', 26, 'Main Building', 3, '309');
INSERT INTO `facility` VALUES (10, 'Facility10', 'Gym', 'Maintenance', 54, 'Sports Hall B', 1, '110');

-- ----------------------------
-- Table structure for maintenance
-- ----------------------------
DROP TABLE IF EXISTS `maintenance`;
CREATE TABLE `maintenance`  (
  `Maintenance_ID` int NOT NULL AUTO_INCREMENT,
  `Scheduled_Date` date NOT NULL,
  `Completion_Date` date NULL DEFAULT NULL,
  `Status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `Equipment_ID` int NULL DEFAULT NULL,
  `Facility_ID` int NULL DEFAULT NULL,
  PRIMARY KEY (`Maintenance_ID`) USING BTREE,
  INDEX `Maintenance_Facilit_592806_idx`(`Facility_ID` ASC, `Scheduled_Date` ASC) USING BTREE,
  INDEX `Maintenance_Equipme_659f45_idx`(`Equipment_ID` ASC, `Scheduled_Date` ASC) USING BTREE,
  CONSTRAINT `Maintenance_Equipment_ID_c578c473_fk_Equipment_Equipment_ID` FOREIGN KEY (`Equipment_ID`) REFERENCES `equipment` (`Equipment_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `Maintenance_Facility_ID_896fee52_fk_Facility_Facility_ID` FOREIGN KEY (`Facility_ID`) REFERENCES `facility` (`Facility_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of maintenance
-- ----------------------------
INSERT INTO `maintenance` VALUES (1, '2025-12-23', NULL, 'In_Progress', '', NULL, 1);
INSERT INTO `maintenance` VALUES (2, '2025-12-31', NULL, 'Cancelled', '', NULL, 1);

-- ----------------------------
-- Table structure for member
-- ----------------------------
DROP TABLE IF EXISTS `member`;
CREATE TABLE `member`  (
  `Member_ID` int NOT NULL AUTO_INCREMENT,
  `First_Name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Last_Name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Registration_Date` date NOT NULL,
  `Membership_Status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int NULL DEFAULT NULL,
  PRIMARY KEY (`Member_ID`) USING BTREE,
  UNIQUE INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `Member_user_id_2cb16a29_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of member
-- ----------------------------
INSERT INTO `member` VALUES (1, 'M', '1', '2025-12-08', 'Active', 5);
INSERT INTO `member` VALUES (2, 'M', '2', '2025-12-08', 'Active', 6);
INSERT INTO `member` VALUES (3, 'Kailong', 'Deng', '2025-12-08', 'Active', 7);

-- ----------------------------
-- Table structure for member_email
-- ----------------------------
DROP TABLE IF EXISTS `member_email`;
CREATE TABLE `member_email`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `Email_Address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Member_ID` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `Member_Email_Member_ID_Email_Address_c5a21fe0_uniq`(`Member_ID` ASC, `Email_Address` ASC) USING BTREE,
  CONSTRAINT `Member_Email_Member_ID_326897c4_fk_Member_Member_ID` FOREIGN KEY (`Member_ID`) REFERENCES `member` (`Member_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of member_email
-- ----------------------------
INSERT INTO `member_email` VALUES (1, 'Luccy@qq.com', 3);

-- ----------------------------
-- Table structure for member_phone
-- ----------------------------
DROP TABLE IF EXISTS `member_phone`;
CREATE TABLE `member_phone`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `Phone_Number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Member_ID` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `Member_Phone_Member_ID_Phone_Number_98973bbd_uniq`(`Member_ID` ASC, `Phone_Number` ASC) USING BTREE,
  CONSTRAINT `Member_Phone_Member_ID_854180fd_fk_Member_Member_ID` FOREIGN KEY (`Member_ID`) REFERENCES `member` (`Member_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of member_phone
-- ----------------------------
INSERT INTO `member_phone` VALUES (1, '123456', 1);
INSERT INTO `member_phone` VALUES (2, '12334', 2);

-- ----------------------------
-- Table structure for reservation
-- ----------------------------
DROP TABLE IF EXISTS `reservation`;
CREATE TABLE `reservation`  (
  `Reservation_ID` int NOT NULL AUTO_INCREMENT,
  `Reservation_Date` date NOT NULL,
  `Start_Time` time(6) NOT NULL,
  `End_Time` time(6) NOT NULL,
  `Facility_ID` int NOT NULL,
  PRIMARY KEY (`Reservation_ID`) USING BTREE,
  UNIQUE INDEX `Reservation_Facility_ID_Reservation__55861018_uniq`(`Facility_ID` ASC, `Reservation_Date` ASC, `Start_Time` ASC) USING BTREE,
  INDEX `Reservation_Facilit_e090a5_idx`(`Facility_ID` ASC, `Reservation_Date` ASC) USING BTREE,
  CONSTRAINT `Reservation_Facility_ID_3e1ddf39_fk_Facility_Facility_ID` FOREIGN KEY (`Facility_ID`) REFERENCES `facility` (`Facility_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_reservation_time` CHECK (`Start_Time` < `End_Time`)
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of reservation
-- ----------------------------
INSERT INTO `reservation` VALUES (1, '2025-12-11', '12:03:00.000000', '12:04:00.000000', 4);
INSERT INTO `reservation` VALUES (2, '2025-12-17', '12:00:00.000000', '16:00:00.000000', 4);

-- ----------------------------
-- Table structure for reservation_equipments
-- ----------------------------
DROP TABLE IF EXISTS `reservation_equipments`;
CREATE TABLE `reservation_equipments`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `Quantity` int UNSIGNED NOT NULL,
  `Equipment_ID` int NOT NULL,
  `Reservation_ID` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `Reservation_Equipments_Reservation_ID_Equipment_ID_f586163f_uniq`(`Reservation_ID` ASC, `Equipment_ID` ASC) USING BTREE,
  INDEX `Reservation_Equipmen_Equipment_ID_d8d10dc7_fk_Equipment`(`Equipment_ID` ASC) USING BTREE,
  CONSTRAINT `Reservation_Equipmen_Equipment_ID_d8d10dc7_fk_Equipment` FOREIGN KEY (`Equipment_ID`) REFERENCES `equipment` (`Equipment_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `Reservation_Equipmen_Reservation_ID_7a5a9783_fk_Reservati` FOREIGN KEY (`Reservation_ID`) REFERENCES `reservation` (`Reservation_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_re_quantity` CHECK (`Quantity` > 0),
  CONSTRAINT `reservation_equipments_chk_1` CHECK (`Quantity` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of reservation_equipments
-- ----------------------------

-- ----------------------------
-- Table structure for session_enrollment
-- ----------------------------
DROP TABLE IF EXISTS `session_enrollment`;
CREATE TABLE `session_enrollment`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `Member_ID` int NOT NULL,
  `Reservation_ID` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `Session_Enrollment_Reservation_ID_Member_ID_77c2eede_uniq`(`Reservation_ID` ASC, `Member_ID` ASC) USING BTREE,
  INDEX `Session_Enr_Member__38750d_idx`(`Member_ID` ASC) USING BTREE,
  CONSTRAINT `Session_Enrollment_Member_ID_3576c05c_fk_Member_Member_ID` FOREIGN KEY (`Member_ID`) REFERENCES `member` (`Member_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `Session_Enrollment_Reservation_ID_9ec02a43_fk_Training_` FOREIGN KEY (`Reservation_ID`) REFERENCES `training_session` (`Reservation_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of session_enrollment
-- ----------------------------

-- ----------------------------
-- Table structure for staff
-- ----------------------------
DROP TABLE IF EXISTS `staff`;
CREATE TABLE `staff`  (
  `Member_ID` int NOT NULL,
  `Staff_ID` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`Member_ID`) USING BTREE,
  UNIQUE INDEX `Staff_ID`(`Staff_ID` ASC) USING BTREE,
  CONSTRAINT `Staff_Member_ID_cc378bb6_fk_Member_Member_ID` FOREIGN KEY (`Member_ID`) REFERENCES `member` (`Member_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of staff
-- ----------------------------
INSERT INTO `staff` VALUES (2, 'ST0A856C');

-- ----------------------------
-- Table structure for student
-- ----------------------------
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student`  (
  `Member_ID` int NOT NULL,
  `Student_ID` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`Member_ID`) USING BTREE,
  UNIQUE INDEX `Student_ID`(`Student_ID` ASC) USING BTREE,
  CONSTRAINT `Student_Member_ID_2e246570_fk_Member_Member_ID` FOREIGN KEY (`Member_ID`) REFERENCES `member` (`Member_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of student
-- ----------------------------
INSERT INTO `student` VALUES (1, 'SA452C7');
INSERT INTO `student` VALUES (3, 'SCBAA9F');

-- ----------------------------
-- Table structure for training_session
-- ----------------------------
DROP TABLE IF EXISTS `training_session`;
CREATE TABLE `training_session`  (
  `Reservation_ID` int NOT NULL,
  `Max_Capacity` int UNSIGNED NOT NULL,
  `Coach_ID` int NOT NULL,
  PRIMARY KEY (`Reservation_ID`) USING BTREE,
  INDEX `Training_Se_Coach_I_403339_idx`(`Coach_ID` ASC) USING BTREE,
  CONSTRAINT `Training_Session_Coach_ID_c101e12a_fk_Coach_Coach_ID` FOREIGN KEY (`Coach_ID`) REFERENCES `coach` (`Coach_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `Training_Session_Reservation_ID_cc1e02b1_fk_Reservati` FOREIGN KEY (`Reservation_ID`) REFERENCES `reservation` (`Reservation_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `training_session_chk_1` CHECK (`Max_Capacity` >= 0)
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of training_session
-- ----------------------------
INSERT INTO `training_session` VALUES (2, 10, 1);

-- ----------------------------
-- Table structure for visitor_application
-- ----------------------------
DROP TABLE IF EXISTS `visitor_application`;
CREATE TABLE `visitor_application`  (
  `Application_ID` int NOT NULL AUTO_INCREMENT,
  `First_Name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Last_Name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `IC_Number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Application_Date` date NOT NULL,
  `Status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Approval_Date` date NULL DEFAULT NULL,
  `Reject_Reason` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `Approved_By` int NULL DEFAULT NULL,
  `Created_Member_ID` int NULL DEFAULT NULL,
  PRIMARY KEY (`Application_ID`) USING BTREE,
  UNIQUE INDEX `IC_Number`(`IC_Number` ASC) USING BTREE,
  INDEX `Visitor_App_Status_31483d_idx`(`Status` ASC, `Application_Date` ASC) USING BTREE,
  INDEX `Visitor_Application_Approved_By_e1d84835_fk_Staff_Member_ID`(`Approved_By` ASC) USING BTREE,
  INDEX `Visitor_Application_Created_Member_ID_c9d10f00_fk_Member_Me`(`Created_Member_ID` ASC) USING BTREE,
  CONSTRAINT `Visitor_Application_Approved_By_e1d84835_fk_Staff_Member_ID` FOREIGN KEY (`Approved_By`) REFERENCES `staff` (`Member_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `Visitor_Application_Created_Member_ID_c9d10f00_fk_Member_Me` FOREIGN KEY (`Created_Member_ID`) REFERENCES `member` (`Member_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of visitor_application
-- ----------------------------
INSERT INTO `visitor_application` VALUES (1, 'Visitor1', 'Wilson', 'IC00000001', '2025-11-23', 'Pending', NULL, NULL, NULL, NULL);
INSERT INTO `visitor_application` VALUES (2, 'Visitor2', 'Smith', 'IC00000002', '2025-12-03', 'Pending', NULL, NULL, NULL, NULL);
INSERT INTO `visitor_application` VALUES (3, 'Visitor3', 'Taylor', 'IC00000003', '2025-12-02', 'Pending', NULL, NULL, NULL, NULL);
INSERT INTO `visitor_application` VALUES (4, 'Visitor4', 'Miller', 'IC00000004', '2025-11-26', 'Pending', NULL, NULL, NULL, NULL);
INSERT INTO `visitor_application` VALUES (5, 'Visitor5', 'Smith', 'IC00000005', '2025-12-04', 'Pending', NULL, NULL, NULL, NULL);
INSERT INTO `visitor_application` VALUES (6, 'Visitor6', 'Brown', 'IC00000006', '2025-12-04', 'Pending', NULL, NULL, NULL, NULL);
INSERT INTO `visitor_application` VALUES (7, 'Visitor7', 'Johnson', 'IC00000007', '2025-11-16', 'Pending', NULL, NULL, NULL, NULL);
INSERT INTO `visitor_application` VALUES (8, 'Visitor8', 'Wilson', 'IC00000008', '2025-11-30', 'Pending', NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for visitor_application_email
-- ----------------------------
DROP TABLE IF EXISTS `visitor_application_email`;
CREATE TABLE `visitor_application_email`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `Email_Address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Application_ID` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `Visitor_Application_Emai_Application_ID_Email_Add_c008470c_uniq`(`Application_ID` ASC, `Email_Address` ASC) USING BTREE,
  CONSTRAINT `Visitor_Application__Application_ID_298ff592_fk_Visitor_A` FOREIGN KEY (`Application_ID`) REFERENCES `visitor_application` (`Application_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of visitor_application_email
-- ----------------------------

-- ----------------------------
-- Table structure for visitor_application_phone
-- ----------------------------
DROP TABLE IF EXISTS `visitor_application_phone`;
CREATE TABLE `visitor_application_phone`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `Phone_Number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Application_ID` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `Visitor_Application_Phon_Application_ID_Phone_Num_0e2efd3d_uniq`(`Application_ID` ASC, `Phone_Number` ASC) USING BTREE,
  CONSTRAINT `Visitor_Application__Application_ID_a21043c7_fk_Visitor_A` FOREIGN KEY (`Application_ID`) REFERENCES `visitor_application` (`Application_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of visitor_application_phone
-- ----------------------------

-- ----------------------------
-- Triggers structure for table booking
-- ----------------------------
DROP TRIGGER IF EXISTS `booking_bi_guardrails`;
delimiter ;;
CREATE TRIGGER `booking_bi_guardrails` BEFORE INSERT ON `booking` FOR EACH ROW BEGIN
  DECLARE v_pending INT DEFAULT 0;
  DECLARE v_reservation_date DATE;
  DECLARE v_start TIME;
  DECLARE v_end TIME;
  DECLARE v_duration_minutes INT;

  SELECT COUNT(*)
    INTO v_pending
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
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table booking
-- ----------------------------
DROP TRIGGER IF EXISTS `booking_bu_guardrails`;
delimiter ;;
CREATE TRIGGER `booking_bu_guardrails` BEFORE UPDATE ON `booking` FOR EACH ROW BEGIN
  DECLARE v_pending INT DEFAULT 0;
  DECLARE v_reservation_date DATE;
  DECLARE v_start TIME;
  DECLARE v_end TIME;
  DECLARE v_duration_minutes INT;

  SELECT COUNT(*)
    INTO v_pending
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
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table maintenance
-- ----------------------------
DROP TRIGGER IF EXISTS `maintenance_bi_xor`;
delimiter ;;
CREATE TRIGGER `maintenance_bi_xor` BEFORE INSERT ON `maintenance` FOR EACH ROW BEGIN
  IF (NEW.Facility_ID IS NULL AND NEW.Equipment_ID IS NULL)
     OR (NEW.Facility_ID IS NOT NULL AND NEW.Equipment_ID IS NOT NULL) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Maintenance must target either a facility or equipment (exclusively)';
  END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table maintenance
-- ----------------------------
DROP TRIGGER IF EXISTS `maintenance_bu_xor`;
delimiter ;;
CREATE TRIGGER `maintenance_bu_xor` BEFORE UPDATE ON `maintenance` FOR EACH ROW BEGIN
  IF (NEW.Facility_ID IS NULL AND NEW.Equipment_ID IS NULL)
     OR (NEW.Facility_ID IS NOT NULL AND NEW.Equipment_ID IS NOT NULL) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Maintenance must target either a facility or equipment (exclusively)';
  END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table reservation
-- ----------------------------
DROP TRIGGER IF EXISTS `reservation_bi_guardrails`;
delimiter ;;
CREATE TRIGGER `reservation_bi_guardrails` BEFORE INSERT ON `reservation` FOR EACH ROW BEGIN
  DECLARE v_facility_status VARCHAR(20);
  DECLARE v_conflicts INT DEFAULT 0;
  DECLARE v_maintenance INT DEFAULT 0;

  SELECT `Status`
    INTO v_facility_status
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

  SELECT COUNT(*)
    INTO v_maintenance
  FROM `maintenance` m
  WHERE m.`Facility_ID` = NEW.Facility_ID
    AND m.`Scheduled_Date` = NEW.Reservation_Date
    AND m.`Status` IN ('Scheduled', 'In_Progress', 'In Progress');

  IF v_maintenance > 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Facility has maintenance scheduled for the requested date';
  END IF;

  SELECT COUNT(*)
    INTO v_conflicts
  FROM `reservation` r
  WHERE r.`Facility_ID` = NEW.Facility_ID
    AND r.`Reservation_Date` = NEW.Reservation_Date
    AND NOT (NEW.End_Time <= r.`Start_Time` OR NEW.Start_Time >= r.`End_Time`);

  IF v_conflicts > 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Reservation overlaps with an existing booking for this facility';
  END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table reservation
-- ----------------------------
DROP TRIGGER IF EXISTS `reservation_bu_guardrails`;
delimiter ;;
CREATE TRIGGER `reservation_bu_guardrails` BEFORE UPDATE ON `reservation` FOR EACH ROW BEGIN
  DECLARE v_facility_status VARCHAR(20);
  DECLARE v_conflicts INT DEFAULT 0;
  DECLARE v_maintenance INT DEFAULT 0;

  SELECT `Status`
    INTO v_facility_status
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

  SELECT COUNT(*)
    INTO v_maintenance
  FROM `maintenance` m
  WHERE m.`Facility_ID` = NEW.Facility_ID
    AND m.`Scheduled_Date` = NEW.Reservation_Date
    AND m.`Status` IN ('Scheduled', 'In_Progress', 'In Progress');

  IF v_maintenance > 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Facility has maintenance scheduled for the requested date';
  END IF;

  SELECT COUNT(*)
    INTO v_conflicts
  FROM `reservation` r
  WHERE r.`Facility_ID` = NEW.Facility_ID
    AND r.`Reservation_Date` = NEW.Reservation_Date
    AND r.`Reservation_ID` <> OLD.Reservation_ID
    AND NOT (NEW.End_Time <= r.`Start_Time` OR NEW.Start_Time >= r.`End_Time`);

  IF v_conflicts > 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Reservation overlaps with an existing booking for this facility';
  END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table reservation_equipments
-- ----------------------------
DROP TRIGGER IF EXISTS `reservation_equipments_bi_guardrails`;
delimiter ;;
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

  SELECT COUNT(*)
    INTO v_maintenance
  FROM `maintenance` m
  WHERE m.`Equipment_ID` = NEW.Equipment_ID
    AND m.`Scheduled_Date` = v_reservation_date
    AND m.`Status` IN ('Scheduled', 'In_Progress', 'In Progress');

  SELECT COALESCE(SUM(re2.`Quantity`), 0)
    INTO v_reserved
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
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table reservation_equipments
-- ----------------------------
DROP TRIGGER IF EXISTS `reservation_equipments_bu_guardrails`;
delimiter ;;
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

  SELECT COUNT(*)
    INTO v_maintenance
  FROM `maintenance` m
  WHERE m.`Equipment_ID` = NEW.Equipment_ID
    AND m.`Scheduled_Date` = v_reservation_date
    AND m.`Status` IN ('Scheduled', 'In_Progress', 'In Progress');

  SELECT COALESCE(SUM(re2.`Quantity`), 0)
    INTO v_reserved
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
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table session_enrollment
-- ----------------------------
DROP TRIGGER IF EXISTS `session_enrollment_bi_capacity`;
delimiter ;;
CREATE TRIGGER `session_enrollment_bi_capacity` BEFORE INSERT ON `session_enrollment` FOR EACH ROW BEGIN
  DECLARE v_capacity INT;
  DECLARE v_current INT DEFAULT 0;

  SELECT `Max_Capacity`
    INTO v_capacity
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

  SELECT COUNT(*)
    INTO v_current
  FROM `session_enrollment`
  WHERE `Reservation_ID` = NEW.Reservation_ID;

  IF v_current >= v_capacity THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Training session is full';
  END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table session_enrollment
-- ----------------------------
DROP TRIGGER IF EXISTS `session_enrollment_bu_capacity`;
delimiter ;;
CREATE TRIGGER `session_enrollment_bu_capacity` BEFORE UPDATE ON `session_enrollment` FOR EACH ROW BEGIN
  DECLARE v_capacity INT;
  DECLARE v_current INT DEFAULT 0;

  SELECT `Max_Capacity`
    INTO v_capacity
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

  SELECT COUNT(*)
    INTO v_current
  FROM `session_enrollment`
  WHERE `Reservation_ID` = NEW.Reservation_ID
    AND `id` <> OLD.`id`;

  IF v_current >= v_capacity THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Training session is full';
  END IF;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
