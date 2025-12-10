@echo off
chcp 65001 >nul
REM ===========================================
REM MySQL 数据库初始化脚本执行器（批处理版本）
REM ===========================================

echo ========================================
echo MySQL 数据库初始化脚本
echo ========================================
echo.

REM 配置参数（请根据实际情况修改）
set MYSQL_HOST=localhost
set MYSQL_PORT=3306
set MYSQL_USER=root
set SQL_FILE=init_db.sql

REM 检查 MySQL 客户端
echo [1/4] 检查 MySQL 客户端...
where mysql >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [错误] 未找到 MySQL 客户端！
    echo 请确保已安装 MySQL 并将其添加到系统 PATH 环境变量中。
    pause
    exit /b 1
)
echo [成功] MySQL 客户端已找到
echo.

REM 检查 SQL 文件
echo [2/4] 检查 SQL 文件...
if not exist "%SQL_FILE%" (
    echo [错误] 未找到 SQL 文件: %SQL_FILE%
    pause
    exit /b 1
)
echo [成功] SQL 文件已找到: %SQL_FILE%
echo.

REM 提示输入密码
echo [3/4] 请输入 MySQL 密码:
set /p MYSQL_PASSWORD=密码: 
echo.

REM 执行 SQL 文件
echo [4/4] 执行 SQL 文件...
echo ========================================
echo.

mysql -h%MYSQL_HOST% -P%MYSQL_PORT% -u%MYSQL_USER% -p%MYSQL_PASSWORD% < "%SQL_FILE%"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo [成功] 数据库初始化完成！
    echo ========================================
    echo.
    echo 已创建数据库: sports_arena
    echo 已创建所有表结构和触发器
    echo.
    
    REM 显示创建的表
    echo 验证数据库表...
    echo ========================================
    mysql -h%MYSQL_HOST% -P%MYSQL_PORT% -u%MYSQL_USER% -p%MYSQL_PASSWORD% -e "USE sports_arena; SHOW TABLES;"
    echo ========================================
) else (
    echo.
    echo ========================================
    echo [失败] 数据库初始化失败！
    echo ========================================
    echo 请检查错误信息
)

echo.
echo 脚本执行完成！
pause
