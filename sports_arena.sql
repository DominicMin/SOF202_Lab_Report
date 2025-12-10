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

 Date: 09/12/2025 20:22:47
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
