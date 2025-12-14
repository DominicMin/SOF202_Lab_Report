/*
Task 4: Access Control - Screenshot Generation Script
=====================================================
此脚本用于生成 Lab Report Task 4 (Access Control) 所需的 4 张 SQL 截图。

Pre-requisites:
1. 确保已运行 run_init_db.ps1 (或 sports_arena_with_data.sql) 并填充了数据。

Usage:
1. Section 0: 使用 root 用户运行，进行环境配置（创建用户、角色、视图）。
2. Section 1-4: 按照提示分别使用对应用户 (C 或 M) 运行，并截图。
*/

-- ======================================================
-- 0. SETUP (必须先运行此部分 - 使用 ROOT 账号)
--    功能：创建演示用的用户、角色和行级安全视图
-- ======================================================

USE sports_arena;

-- A. 创建演示用户 (模拟具体的自然人)
-- User 'M' 对应 Member 表中 First_Name='M' 的记录 (Member_ID=1)
DROP USER IF EXISTS 'M' @'localhost';

CREATE USER 'M' @'localhost' IDENTIFIED BY 'password';

-- User 'C' 对应 Coach 表中 First_Name='C' 的记录 (Coach_ID=1)
DROP USER IF EXISTS 'C' @'localhost';

CREATE USER 'C' @'localhost' IDENTIFIED BY 'password';

-- B. 创建角色 (RBAC)
DROP ROLE IF EXISTS 'member_role';

DROP ROLE IF EXISTS 'coach_role';

CREATE ROLE 'member_role', 'coach_role';

-- C. 授予权限 (Grant Permissions)
-- Coach Role: 允许查看和更新 Training_Session，查看 Facility
GRANT
SELECT,
UPDATE ON sports_arena.Training_Session TO 'coach_role';

GRANT SELECT ON sports_arena.Facility TO 'coach_role';

GRANT SELECT ON sports_arena.Coach TO 'coach_role';

-- Member Role: 仅允许通过视图访问自己的数据 (Row-Level Security)
-- (将在创建视图后授予权限)

-- D. 分配角色给用户
GRANT 'member_role' TO 'M' @'localhost';

GRANT 'coach_role' TO 'C' @'localhost';

SET DEFAULT ROLE ALL TO 'M' @'localhost';

SET DEFAULT ROLE ALL TO 'C' @'localhost';

-- E. 创建行级安全视图 (Row-Level Security View)
-- 逻辑：通过当前登录用户名 (USER()) 匹配 Member 表的 First_Name
CREATE OR REPLACE VIEW Member_Booking_View AS
SELECT b.Reservation_ID, b.Booking_Status, b.Member_ID, r.Reservation_Date, f.Facility_Name
FROM
    Booking b
    JOIN Reservation r ON b.Reservation_ID = r.Reservation_ID
    JOIN Facility f ON r.Facility_ID = f.Facility_ID
WHERE
    b.Member_ID IN (
        SELECT Member_ID
        FROM Member
        WHERE
            First_Name = SUBSTRING_INDEX(USER (), '@', 1)
    );

-- 为 Member Role 授予视图访问权限
GRANT SELECT ON sports_arena.Member_Booking_View TO 'member_role';

-- F. 刷新权限
FLUSH PRIVILEGES;

/* 
------------------------------------------------------
环境准备完成！
请按照下方步骤，切换用户连接并截图。
------------------------------------------------------ 
*/

-- ======================================================
-- SCREENSHOT 1: RBAC Grant (允许操作)
-- [操作]: 在 Workbench 中新建连接，用户名: C, 密码: password
-- [目的]: 证明 Coach 角色拥有被授权表的访问权
-- ======================================================

-- \/-- 请在 'C' 用户的连接中运行: --\/

USE sports_arena;

SELECT * FROM Training_Session;

-- /\-- 截图要求: 截取下方的 Result Grid，显示成功查询出的数据 --/\

-- ======================================================
-- SCREENSHOT 2: RBAC Deny (拒绝操作)
-- [操作]: 继续在 'C' 用户的连接中运行
-- [目的]: 证明 Coach 角色无法删除 Member 表数据 (越权操作)
-- ======================================================

-- \/-- 请在 'C' 用户的连接中运行: --\/

DELETE FROM Member WHERE Member_ID = 1;

-- /\-- 截图要求: 截取下方的 Output 窗口，必须显示红色错误: "Error Code: 1142. DELETE command denied..." --/\

-- ======================================================
-- SCREENSHOT 3: Row-Level Security Allowed (查看自有数据)
-- [操作]: 在 Workbench 中新建连接，用户名: M, 密码: password
-- [目的]: 证明 Member 只能看到属于自己的 Booking 记录
-- ======================================================

-- \/-- 请在 'M' 用户的连接中运行: --\/

USE sports_arena;

SELECT * FROM Member_Booking_View;

-- /\-- 截图要求: 截取 Result Grid。
--      验证点: Member_ID 应该全是 1 (因为 'M' 用户对应 ID 1)，不应出现 Member_ID=2 的数据。 --/\

-- ======================================================
-- SCREENSHOT 4: Row-Level Security Denied (禁止直连底表)
-- [操作]: 继续在 'M' 用户的连接中运行
-- [目的]: 证明 Member 无法直接访问 Booking 底表 (防止绕过视图查看他人数据)
-- ======================================================

-- \/-- 请在 'M' 用户的连接中运行: --\/

SELECT * FROM Booking;

-- /\-- 截图要求: 截取 Output 窗口，必须显示红色错误: "SELECT command denied to user 'M'..." --/\