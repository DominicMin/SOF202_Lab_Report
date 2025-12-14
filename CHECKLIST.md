## Task 3 Checkpoints (Triggering)

### 1. 截图确认 (Evidence Screenshots)
- [ ] **Scenario A (A1-A3)**: 确保截图清晰展示了“预订插入前后的状态”。A2 必须包含红色的报错信息（Table 'reservation' overlap...）。
- [ ] **Scenario B (B1-B4)**: B3 必须展示报错 "Member already has 2 pending bookings"。B4 需要证明数据库中确实只有 2 条记录。
- [ ] **Scenario C (C1-C2)**: C1 需要展示两个报错（一个是 None，一个是 Both）。C2 展示成功插入。
- [ ] **Scenario D (D1-D3)**: D1 展示 Equipment 初始库存。D3 展示报错 "Requested equipment exceeds available" 或类似逻辑错误。
- [ ] **Scenario E (E1-E3)**: E3 展示报错 "Training session is full"。

### 2. 文本描述优化 (Textual Explanation)
- [ ] **Intro Clarity**: 检查 `section{Triggering}` 开头是否明确声明了："We selected **INSERT** and **UPDATE** events for our triggers." (已在文中，建议复查)。
- [ ] **Before/After Logic**: 确保每个 Scenario 的文字描述中，明确 指出了 "Before the trigger..." 和 "After the trigger..." 的区别。目前的草稿已经隐含了这一点，如果有空可以加粗强调 **Before** 和 **After** 

### 3. 代码一致性 (Code Consistency)
- [ ] 确保 `task3.tex` 中的 SQL 代码与你实际在 Workbench 中运行并截图的代码完全一致（包括变量名、错误提示信息 `MESSAGE_TEXT`）。如果不一致，Rubric "Screenshots complete, clear" 可能会扣分。

### 4. 冗余检查 (Over-delivery check)
- [ ] 现在的报告包含了 5 个场景 (A-E)，远超 Rubric 要求的 "Choose any TWO"。
  - **建议**: 如果报告篇幅过长，可以考虑保留 **Scenario A (Reservation Overlap)** 和 **Scenario E (Capacity)** 作为主打，将其他放入附录或简化展示。目前的完整展示展现了工作量，是加分项，但需注意不要让阅卷人迷失。

## 截图检查
- [ ] 检查截图一致性，必要时一个人在一个环境中截取所有图

# 实验报告 Task 1 截图检查清单 (Checklist)

本清单列出了 Task 1 (Database Integrity) 中需要放入报告的截图。请确保截图清晰，并能体现题目要求的“成功执行”或“报错信息”。

## 1. Domain Integrity (域完整性)
- [ ] **截图 1.1**: MySQL 终端或 Workbench 中执行 `CREATE TABLE Equipment` 的成功截图。
    - **重点**: 应展示 `Total_Quantity >= 0` 的 CHECK 约束定义。
    - **位置**: `paper/task1.tex` -> `Figure 1.1`
- [ ] **截图 1.2**: MySQL 终端或 Workbench 中执行 `CREATE TABLE Reservation` 的成功截图。
    - **重点**: 应展示 `Start_Time < End_Time` 的 CHECK 约束定义。
    - **位置**: `paper/task1.tex` -> `Figure 1.2`

## 2. Entity Integrity (实体完整性)
- [ ] **截图 1.3**: MySQL 终端或 Workbench 中执行 `CREATE TABLE Member` 的成功截图。
    - **重点**: 应展示 `PRIMARY KEY` (Member_ID) 和 `UNIQUE` (user_id) 约束。
    - **位置**: `paper/task1.tex` -> `Figure 1.3`
- [ ] **截图 1.4**: (可选) 展示插入重复主键或唯一键导致报错的截图，证明实体完整性生效。
    - **位置**: `paper/task1.tex` -> `Figure 1.4` (如有)

## 3. Referential Integrity (参照完整性)
- [ ] **截图 1.5**: MySQL 终端或 Workbench 中执行 `CREATE TABLE Booking` 的成功截图。
    - **重点**: 应展示 `FOREIGN KEY` (Member_ID, Reservation_ID) 约束及其 `ON DELETE/UPDATE RESTRICT` 规则。
    - **位置**: `paper/task1.tex` -> `Figure 1.5`
- [ ] **截图 1.6**: (可选) 展示删除被引用的父表记录（如 Member）导致报错的截图，证明参照完整性生效。
    - **位置**: `paper/task1.tex` -> `Figure 1.6` (如有)

# 实验报告 Task 2 截图检查清单 (Checklist)

本清单列出了 Task 2 (SQL Implementation) 中需要放入报告的截图。请确保截图清晰，涵盖语句执行结果。

## 1. Table Creation (剩余表创建)
> **注意**: 除 Task 1 中已创建的 `Equipment`, `Reservation`, `Member`, `Booking` 外，其余所有表均需截图。

- [ ] **截图 2.1**: Member Types 表创建 (`Student`, `Staff`, `External_Visitor`)
    - **位置**: `paper/task2.tex` -> `Figure 2.1` (`screenshot_create_tables_part1.png`)
- [ ] **截图 2.2**: Contact Info 表创建 (`Member_Email`, `Member_Phone`, `Coach_Email`, `Coach_Phone`)
    - **位置**: `paper/task2.tex` -> `Figure 2.2` (`screenshot_create_tables_part2.png`)
- [ ] **截图 2.3**: Facility & Coach 表创建 (`Facility`, `Coach`, `Maintenance`)
    - **位置**: `paper/task2.tex` -> `Figure 2.3` (`screenshot_create_tables_part3.png`)
- [ ] **截图 2.4**: Applications & Transactions 表创建 (`Visitor_Application`, `Training_Session`, `Session_Enrollment`, `Reservation_Equipments`)
    - **位置**: `paper/task2.tex` -> `Figure 2.4` (`screenshot_create_tables_part4.png`)

## 2. Data Population (数据填充验证)
- [ ] **截图 2.5**: 所有表的数据行数统计 (`SELECT COUNT(*) FROM ...`)
    - **要求**: 每个表至少 6-10 行数据。建议将所有 count 查询放在一个截图中，或分两次截取。
    - **位置**: `paper/task2.tex` -> `Figure 2.5` (`screenshot_data_population_count.png`)

## 3. Data Retrieval (六类查询)
> **每类需要 3 个不同查询的语句 + 输出结果截图**

### 3.1 Filtering (LIKE, BETWEEN, IN)
- [ ] **截图 2.6**: Filtering 类 3 个查询的执行结果
    - Query 1: LIKE (Facility Type)
    - Query 2: BETWEEN (Reservation Date)
    - Query 3: IN (Booking Status)
    - **位置**: `paper/task2.tex` -> `Figure 2.6` (`screenshot_query_filtering.png`)

### 3.2 Aggregate Functions (COUNT, SUM, AVG)
- [ ] **截图 2.7**: Aggregate 类 3 个查询的执行结果
    - Query 4: COUNT (Facility by Type)
    - Query 5: SUM (Equipment Quantity)
    - Query 6: AVG (Coach Capacity)
    - **位置**: `paper/task2.tex` -> `Figure 2.7` (`screenshot_query_aggregate.png`)

### 3.3 Limit / Sorting (ORDER BY, LIMIT)
- [ ] **截图 2.8**: Limit/Sorting 类 3 个查询的执行结果
    - Query 7: Top 3 Facilities
    - Query 8: Recent Reservations
    - Query 9: Recent Applications
    - **位置**: `paper/task2.tex` -> `Figure 2.8` (`screenshot_query_sorting.png`)

### 3.4 Join Operators (INNER, LEFT, RIGHT)
- [ ] **截图 2.9**: JOIN 类 3 个查询的执行结果
    - Query 10: INNER JOIN (Booking details)
    - Query 11: LEFT JOIN (Session details)
    - Query 12: RIGHT JOIN (Equipment stats)
    - **位置**: `paper/task2.tex` -> `Figure 2.9` (`screenshot_query_join.png`)

### 3.5 String / Arithmetic Operations
- [ ] **截图 2.10**: String/Math 类 3 个查询的执行结果
    - Query 13: Math (Duration calculation)
    - Query 14: String (Name concatenation)
    - Query 15: Complex (Inventory calculation)
    - **位置**: `paper/task2.tex` -> `Figure 2.10` (`screenshot_query_string_math.png`)

### 3.6 Formatting (AS, Date Format)
- [ ] **截图 2.11**: Formatting 类 3 个查询的执行结果
    - Query 16: Column Aliasing
    - Query 17: Date Formatting
    - Query 18: Session Formatting
    - **位置**: `paper/task2.tex` -> `Figure 2.11` (`screenshot_query_formatting.png`)
