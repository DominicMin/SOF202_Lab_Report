# ===========================================
# MySQL 数据库初始化脚本执行器
# ===========================================
# 此脚本用于执行 init_db.sql 文件，创建 sports_arena 数据库及所有表结构

# 配置参数（请根据实际情况修改）
$MYSQL_HOST = "localhost"
$MYSQL_PORT = "3306"
$MYSQL_USER = "root"
$MYSQL_PASSWORD = ""  # 请填入你的 MySQL root 密码
$SQL_FILE = "init_db.sql"

# 颜色输出函数
function Write-ColorOutput($ForegroundColor, $Message) {
    Write-Host $Message -ForegroundColor $ForegroundColor
}

# 检查 MySQL 客户端是否安装
Write-ColorOutput Cyan "========================================"
Write-ColorOutput Cyan "检查 MySQL 客户端..."
Write-ColorOutput Cyan "========================================"

$mysqlPath = Get-Command mysql -ErrorAction SilentlyContinue
if (-not $mysqlPath) {
    Write-ColorOutput Red "错误: 未找到 MySQL 客户端！"
    Write-ColorOutput Yellow "请确保已安装 MySQL 并将其添加到系统 PATH 环境变量中。"
    exit 1
}

Write-ColorOutput Green "✓ MySQL 客户端已找到: $($mysqlPath.Source)"

# 检查 SQL 文件是否存在
Write-ColorOutput Cyan "`n========================================"
Write-ColorOutput Cyan "检查 SQL 文件..."
Write-ColorOutput Cyan "========================================"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$sqlFilePath = Join-Path $scriptDir $SQL_FILE

if (-not (Test-Path $sqlFilePath)) {
    Write-ColorOutput Red "错误: 未找到 SQL 文件: $sqlFilePath"
    exit 1
}

Write-ColorOutput Green "✓ SQL 文件已找到: $sqlFilePath"

# 提示用户输入密码（如果未在脚本中设置）
if ([string]::IsNullOrEmpty($MYSQL_PASSWORD)) {
    Write-ColorOutput Yellow "`n请输入 MySQL 密码:"
    $securePassword = Read-Host -AsSecureString
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
    $MYSQL_PASSWORD = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
}

# 执行 SQL 文件
Write-ColorOutput Cyan "`n========================================"
Write-ColorOutput Cyan "开始执行 SQL 文件..."
Write-ColorOutput Cyan "========================================"

try {
    # 构建 MySQL 命令
    $mysqlArgs = @(
        "-h$MYSQL_HOST",
        "-P$MYSQL_PORT",
        "-u$MYSQL_USER",
        "-p$MYSQL_PASSWORD",
        "-e",
        "source $sqlFilePath"
    )

    Write-ColorOutput Yellow "`n执行命令: mysql -h$MYSQL_HOST -P$MYSQL_PORT -u$MYSQL_USER -p**** -e `"source $sqlFilePath`""
    
    # 执行命令
    $output = & mysql @mysqlArgs 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput Green "`n========================================"
        Write-ColorOutput Green "✓ 数据库初始化成功完成！"
        Write-ColorOutput Green "========================================"
        Write-ColorOutput Green "`n已创建数据库: sports_arena"
        Write-ColorOutput Green "已创建所有表结构和触发器"
    } else {
        Write-ColorOutput Red "`n========================================"
        Write-ColorOutput Red "✗ 数据库初始化失败！"
        Write-ColorOutput Red "========================================"
        Write-ColorOutput Red "错误信息："
        Write-Host $output
        exit 1
    }
    
} catch {
    Write-ColorOutput Red "`n========================================"
    Write-ColorOutput Red "✗ 执行过程中发生异常！"
    Write-ColorOutput Red "========================================"
    Write-ColorOutput Red "异常信息: $($_.Exception.Message)"
    exit 1
}

# 验证数据库和表是否创建成功
Write-ColorOutput Cyan "`n========================================"
Write-ColorOutput Cyan "验证数据库结构..."
Write-ColorOutput Cyan "========================================"

$verifyQuery = "USE sports_arena; SHOW TABLES;"
$verifyArgs = @(
    "-h$MYSQL_HOST",
    "-P$MYSQL_PORT",
    "-u$MYSQL_USER",
    "-p$MYSQL_PASSWORD",
    "-e",
    $verifyQuery
)

$tables = & mysql @verifyArgs 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-ColorOutput Green "`n✓ 数据库表列表："
    Write-Host $tables
} else {
    Write-ColorOutput Yellow "`n警告: 无法验证数据库结构"
}

Write-ColorOutput Cyan "`n========================================"
Write-ColorOutput Cyan "脚本执行完成！"
Write-ColorOutput Cyan "========================================"
