# 大学体育综合设施系统 - EERD 设计说明

---

## 📋 目录

1. [系统概述](#系统概述)
2. [实体说明](#实体说明)
3. [关系说明](#关系说明)
4. [增强特性说明](#增强特性说明)
5. [设计决策与理由](#设计决策与理由)
6. [关键业务规则](#关键业务规则)

---

## 系统概述

本 EERD 设计旨在解决大学体育综合设施当前依赖手动记录簿和电子表格的问题，实现：
- ✅ 维护清晰的设施和设备目录
- ✅ 允许会员（学生、教职工、外部访客）注册和预订
- ✅ 分配教练到培训课程
- ✅ 防止预订冲突
- ✅ 跟踪设备和设施的维护计划

---

## 实体说明

### 📌 主要实体（8个）

#### 1. **Member** (会员 - 超类)
- **描述：** 系统的所有用户基类，包含会员的共同属性
- **主键：** Member_ID
- **属性：**
  - `Member_ID` (PK) - 会员唯一标识符
  - `Name` (复合属性) - 包含 First_Name 和 Last_Name
  - `Contact_Details` (复合属性) - 包含 Email_Address 和 Phone_Number（多值）
  - `Registration_Date` - 注册日期
  - `Membership_Status` - 会员状态（Active/Inactive/Pending_Approval）
- **特化子类：** Student, Staff, External_Visitor

#### 2. **Student** (学生 - Member子类)
- **描述：** 在校学生会员
- **额外属性：**
  - `Student_ID` - 学号（唯一标识但非主键）
  - `Member_ID` (继承PK)
- **注册流程：** 自动激活（有学号验证）

#### 3. **Staff** (教职工 - Member子类)
- **描述：** 大学教职工会员
- **额外属性：**
  - `Staff_ID` - 工号（唯一标识但非主键）
  - `Member_ID` (继承PK)
- **注册流程：** 自动激活（有工号验证）

#### 4. **External_Visitor** (外部访客 - Member子类)
- **描述：** 非大学人员的访客会员
- **额外属性：**
  - `IC_Number` - 身份证号（唯一标识但非主键）
  - `Member_ID` (继承PK)
- **注册流程：** 需要管理员审批后激活

#### 5. **Coach** (教练)
- **描述：** 提供培训课程的教练
- **主键：** Coach_ID
- **属性：**
  - `Coach_ID` (PK) - 教练唯一标识符
  - `Name` (复合属性) - 包含 First_Name 和 Last_Name
  - `Contact_Details` (复合属性) - 包含 Email_Address 和 Phone_Number（多值）
  - `Specialization` (复合属性) - 包含 Sport_Type 和 Level
- **业务规则：** 一个教练可以教授多个培训课程

#### 6. **Reservation** (预订 - 超类)
- **描述：** 所有预订的基类
- **主键：** Reservation_ID
- **属性：**
  - `Reservation_ID` (PK) - 预订唯一标识符
  - `Date` - 预订日期
  - `Start_Time` - 开始时间
  - `End_Time` - 结束时间
- **特化子类：** Booking (普通预订), Training_Session (培训课程)
- **设计理由：** 将共同属性提升到超类，避免冗余

#### 7. **Booking** (普通预订 - Reservation子类)
- **描述：** 会员的常规设施预订
- **额外属性：**
  - `Member_ID` - 预订者（通过 makes 关系关联）
  - `Booking_Status` - 预订状态
  - `Reservation_ID` (继承PK)
- **业务规则：** 每个预订必须关联一个会员和一个设施

#### 8. **Training_Session** (培训课程 - Reservation子类)
- **描述：** 由教练主导的培训课程
- **额外属性：**
  - `Coach_ID` - 教练（通过 teaches 关系关联）
  - `Reservation_ID` (继承PK)
- **业务规则：** 每个培训课程必须有一个教练；会员可以报名参加

#### 9. **Facility** (设施)
- **描述：** 体育综合设施的场地
- **主键：** Facility_ID
- **属性：**
  - `Facility_ID` (PK) - 设施唯一标识符
  - `Facility_Name` - 设施名称（如"羽毛球场A"）
  - `Type` - 类型（体育馆/游泳池/球场等）
  - `Location` (复合属性) - 包含 Building, Floor, Room_Number
  - `Capacity` - 容量
  - `Status` - 状态（Available/Under_Maintenance/Unavailable）
- **业务规则：** 一个设施可以有多个预订（不同时间）

#### 10. **Equipment** (设备)
- **描述：** 可预订的体育设备
- **主键：** Equipment_ID
- **属性：**
  - `Equipment_ID` (PK) - 设备唯一标识符
  - `Equipment_Name` - 设备名称
  - `Type` - 类型（球类/器械等）
  - `Total_Quantity` - 总数量
  - `Available_Quantity` - 可用数量
  - `Status` - 状态（Available/In_Use/Under_Maintenance/Damaged）
- **业务规则：** 支持数量管理，防止超量预订

#### 11. **Maintenance** (维护记录)
- **描述：** 设施和设备的维护计划和记录
- **主键：** Maintenance_ID
- **属性：**
  - `Maintenance_ID` (PK) - 维护记录唯一标识符
  - `Scheduled_Date` - 计划日期
  - `Completion_Date` - 完成日期
  - `Status` - 状态（Scheduled/In_Progress/Completed）
  - `Description` - 维护描述
- **业务规则：** 一条维护记录关联一个设施或一个设备

#### 12. **Registration_Application** (注册申请)
- **描述：** 外部访客的注册申请记录
- **主键：** Application_ID
- **属性：**
  - `Application_ID` (PK) - 申请唯一标识符
  - `Member_ID` - 申请人（关联到 External_Visitor）
  - `Application_Date` - 申请日期
  - `Status` - 状态（Pending/Approved/Rejected）
  - `Approved_By` - 审批人
  - `Approval_Date` - 审批日期
  - `Reject_Reason` - 拒绝原因
- **设计理由：** 作为强实体独立存在，支持审批历史追踪

### 📌 弱实体（2个）

#### 13. **Reservation_Equipments** (预订设备 - 弱实体)
- **描述：** 记录每个预订所使用的设备及数量
- **主键：** (Reservation_ID, Equipment_ID) - 复合主键
- **部分键：** Equipment_ID（虚线下划线）
- **属性：**
  - `Reservation_ID` (PK, FK) - 所属预订
  - `Equipment_ID` (部分键, FK) - 设备
  - `Quantity` - 预订数量
- **依赖关系：** 完全依赖于 Reservation
- **设计理由：** 没有独立的业务意义，必须依附于预订存在

#### 14. **Session_Enrollment** (课程报名 - 弱实体)
- **描述：** 记录会员报名参加的培训课程
- **主键：** (Reservation_ID, Member_ID) - 复合主键
- **属性：**
  - `Reservation_ID` (PK, FK) - 培训课程
  - `Member_ID` (PK, FK) - 报名会员
- **依赖关系：** 依赖于 Training_Session 和 Member
- **设计理由：** 连接培训课程和参加的会员

---

## 关系说明

### 🔗 关系总览表

| # | 关系名称 | 实体1 | 实体2 | 基数 | 实体1参与 | 实体2参与 | 关系类型 |
|---|---------|-------|-------|------|----------|----------|----------|
| 1 | teaches | Coach | Training_Session | 1:N | 可选 | 完全 | 普通关系 |
| 2 | has | Training_Session | Session_Enrollment | 1:N | 完全 | 完全 | 识别关系 |
| 3 | enrolls in | Session_Enrollment | Member | N:1 | 完全 | 可选 | 识别关系 |
| 4 | makes | Member | Reservation | 1:N | 可选 | 完全 | 普通关系 |
| 5 | uses | Reservation | Facility | N:1 | 完全 | 可选 | 普通关系 |
| 6 | has | Reservation | Reservation_Equipments | 1:N | 完全 | 完全 | 识别关系 |
| 7 | uses | Reservation_Equipments | Equipment | N:1 | 可选 | 可选 | 普通关系 |
| 8 | requires | Maintenance | Equipment | N:1 | 可选 | 可选 | 普通关系 |
| 9 | requires | Maintenance | Facility | N:1 | 可选 | 可选 | 普通关系 |
| 10 | makes | External_Visitor | Registration_Application | 1:N | 可选 | 完全 | 普通关系 |

### 详细关系说明

#### R1: teaches (教练 教授 培训课程)
- **连接：** Coach (1) → (N) Training_Session
- **含义：** 一个教练可以教授多个培训课程；每个培训课程必须由一个教练负责
- **参与：** Coach 可选参与（新教练可能还没有课程）；Training_Session 完全参与（必须有教练）

#### R2: has (培训课程 拥有 课程报名)
- **连接：** Training_Session (1) → (N) Session_Enrollment
- **含义：** 一个培训课程可以有多个报名；每个报名记录属于一个课程
- **类型：** 识别关系（双线菱形）
- **参与：** 均为完全参与

#### R3: enrolls in (课程报名 属于 会员)
- **连接：** Session_Enrollment (N) → (1) Member
- **含义：** 多个报名记录可以属于一个会员；每个报名记录必须关联一个会员
- **类型：** 识别关系（双线菱形）
- **参与：** Session_Enrollment 完全参与；Member 可选参与（会员可以不报名）

#### R4: makes (会员 创建 预订)
- **连接：** Member (1) → (N) Reservation
- **含义：** 一个会员可以创建多个预订；每个预订必须由一个会员创建
- **参与：** Member 可选参与（新会员可能还没预订）；Reservation 完全参与（必须有会员）

#### R5: uses (预订 使用 设施)
- **连接：** Reservation (N) → (1) Facility
- **含义：** 多个预订可以使用同一设施（不同时间）；每个预订必须使用一个设施
- **参与：** Reservation 完全参与（必须有设施）；Facility 可选参与（设施可能暂时没有预订）

#### R6: has (预订 拥有 预订设备)
- **连接：** Reservation (1) → (N) Reservation_Equipments
- **含义：** 一个预订可以包含多个设备记录；每个设备记录属于一个预订
- **类型：** 识别关系（双线菱形）- 弱实体
- **参与：** 均为完全参与

#### R7: uses (预订设备 使用 设备)
- **连接：** Reservation_Equipments (N) → (1) Equipment
- **含义：** 多个预订设备记录可以引用同一设备；每个记录关联一个设备
- **参与：** 均为可选参与

#### R8 & R9: requires (维护 需要 设备/设施)
- **连接：** Maintenance (N) → (1) Equipment/Facility
- **含义：** 多个维护记录可以针对同一设备或设施；每个维护记录关联一个资源
- **参与：** 均为可选参与
- **业务规则：** 一条维护记录只能关联设备或设施其中之一（通过应用层或约束控制）

#### R10: makes (外部访客 提交 注册申请)
- **连接：** External_Visitor (1) → (N) Registration_Application
- **含义：** 一个外部访客可以提交多个申请（如被拒绝后重新申请）
- **参与：** External_Visitor 可选参与；Registration_Application 完全参与

---

## 增强特性说明

### 🌟 1. 泛化/特化 (Generalization/Specialization)

#### Member 的特化
- **超类：** Member
- **子类：** Student, Staff, External_Visitor
- **类型：** Disjoint（互斥）- 一个会员只能属于一种类型
- **符号：** "d" 圆圈 + 3条分支线
- **理由：** 
  - 三种会员有共同属性（姓名、联系方式、注册日期等）
  - 也有各自独特的标识符和业务规则
  - 符合 IS-A 关系

#### Reservation 的特化
- **超类：** Reservation
- **子类：** Booking, Training_Session
- **类型：** Disjoint（互斥）- 一个预订只能是普通预订或培训课程
- **符号：** "d" 圆圈 + 2条分支线
- **理由：**
  - 两种预订共享时间属性（日期、开始时间、结束时间）
  - Booking 关注会员和设施
  - Training_Session 关注教练和参与学员
  - 简化设施和设备的关系（提升到超类层面）

### 🌟 2. 弱实体 (Weak Entities)

#### Reservation_Equipments
- **标记：** 双线矩形
- **识别关系：** has（双线菱形）
- **部分键：** Equipment_ID（虚线下划线）
- **完整主键：** (Reservation_ID, Equipment_ID)
- **理由：**
  - 没有独立的业务意义（没有预订就不存在设备记录）
  - 主键依赖于 Reservation
  - 满足弱实体定义

#### Session_Enrollment
- **标记：** 双线矩形
- **识别关系：** has 和 enrolls in（双线菱形）
- **完整主键：** (Reservation_ID, Member_ID)
- **理由：**
  - 报名记录完全依赖于课程和会员
  - 作为关联实体连接 Training_Session 和 Member

### 🌟 3. 复合属性 (Composite Attributes)

#### Name（姓名）
- **实体：** Member, Coach
- **子属性：** First_Name, Last_Name
- **显示：** Name 连接到两个子属性椭圆
- **理由：** 姓名通常需要分开存储和查询（如排序、搜索）

#### Contact_Details（联系方式）
- **实体：** Member, Coach
- **子属性：** Email_Address（多值）, Phone_Number（多值）
- **显示：** Contact_Details 连接到多值属性椭圆（双线椭圆）
- **理由：** 联系方式是一个逻辑组，且支持多个值

#### Location（位置）
- **实体：** Facility
- **子属性：** Building, Floor, Room_Number
- **理由：** 设施位置是一个层级结构

#### Specialization（专业领域）
- **实体：** Coach
- **子属性：** Sport_Type, Level
- **理由：** 教练的专业包含运动类型和级别

### 🌟 4. 多值属性 (Multivalued Attributes)

#### Phone_Number（电话号码）
- **实体：** Member, Coach
- **符号：** 双线椭圆
- **理由：** 用户可能有多个联系电话（手机、家庭电话、办公电话）

#### Email_Address（电子邮件）
- **实体：** Member, Coach
- **符号：** 双线椭圆
- **理由：** 用户可能有多个电子邮件地址（个人、工作）

---

## 设计决策与理由

### 📌 关键设计决策

#### 1. 为什么 Reservation 是超类？
**决策：** 将 Booking 和 Training_Session 的共同属性提升到 Reservation
**理由：**
- 减少冗余：时间属性（Date, Start_Time, End_Time）只定义一次
- 统一管理：设施和设备的关系在超类层面定义，简化设计
- 便于冲突检查：可以在 Reservation 层面统一检查时间冲突

#### 2. 为什么使用弱实体 Reservation_Equipments？
**决策：** 将设备预订记录建模为弱实体
**理由：**
- 符合业务逻辑：没有预订就不存在设备记录
- 满足 Rubric 要求：EERD 必须包含弱实体
- 自然主键：(Reservation_ID, Equipment_ID) 唯一标识每条记录

#### 3. 为什么 Member 子类不重复显示继承的属性？
**决策：** 子类只显示自己的特有属性
**理由：**
- 符合 Chen's Model 的 EERD 规范
- 避免图形混乱
- 继承关系已由 ISA 层次结构表达

#### 4. 为什么 Maintenance 同时关联 Equipment 和 Facility？
**决策：** 使用两个 "requires" 关系
**理由：**
- 设备和设施都需要维护
- 一条维护记录只针对一个资源（通过应用约束或触发器强制）
- 保持设计简洁，避免额外的超类

#### 5. 为什么 Registration_Application 是强实体？
**决策：** 作为独立实体而非弱实体
**理由：**
- 有独立的业务价值：需要查询所有待审批申请
- 支持历史追踪：被拒绝后可以重新申请，保留历史
- 有明确的业务标识符：Application_ID

---

## 关键业务规则

### ⚠️ 防止冲突的机制

#### 1. 设施冲突检查
```
约束：同一设施在同一时间段只能有一个预订
检查条件：
- 相同 Facility_ID
- Date 相同
- 时间段重叠：[Start_Time, End_Time] 与现有预订冲突
```

#### 2. 设备数量检查
```
约束：预订设备数量不能超过可用数量
检查公式：
Available_Quantity >= SUM(Quantity) 
WHERE Equipment_ID = ? 
  AND Date = ? 
  AND [Start_Time, End_Time] 重叠
```

#### 3. 教练冲突检查
```
约束：同一教练在同一时间段只能教授一个课程
检查条件：
- 相同 Coach_ID
- Date 相同
- 时间段重叠：[Start_Time, End_Time] 与现有课程冲突
```

#### 4. 时间冲突管理规则（Reservation 与 Maintenance）

##### 📋 系统中的两类时间占用

本系统采用**双轨制时间管理**设计，分别处理预订和维护两类不同的时间占用：

**【Reservation 体系】- 面向用户的预订系统**
- **实体：** Reservation（超类）→ Booking（普通预订）、Training_Session（培训课程）
- **时间属性：** Date, Start_Time, End_Time
- **关联资源：**
  - Facility：通过 `uses` 关系（N:1）
  - Equipment：通过 `Reservation_Equipments` 弱实体 + `uses` 关系
- **管理主体：** 会员（Member）通过 `makes` 关系创建预订
- **业务特点：** 面向终端用户，需要实时响应，高频操作

**【Maintenance 体系】- 维护管理系统**
- **实体：** Maintenance（独立强实体）
- **时间属性：** Scheduled_Date, Completion_Date
- **关联资源：**
  - Facility：通过 `requires` 关系（N:1）
  - Equipment：通过 `requires` 关系（N:1）
- **管理主体：** 系统管理员或维护部门
- **业务特点：** 后台管理，计划性操作，需要追踪完成状态

##### 🔀 两类体系的互斥约束

**Maintenance 资源互斥规则：**
```
每个 Maintenance 记录必须满足：
(关联一个 Facility) XOR (关联一个 Equipment)

含义：
- 一条维护记录针对且仅针对一个资源
- 不能同时维护设施和设备
- 也不能不关联任何资源
```

**实现方式：**
- **EERD 层面：** 两个独立的 `requires` 关系（可选参与）
- **逻辑层面：** 添加 CHECK 约束
  ```sql
  CHECK (
    (Facility_ID IS NOT NULL AND Equipment_ID IS NULL) OR
    (Facility_ID IS NULL AND Equipment_ID IS NOT NULL)
  )
  ```

##### ⚡ 跨体系的时间冲突检查

为了防止预订和维护在同一资源上产生冲突，系统必须实现**跨体系的冲突检查机制**：

**【设施冲突检查】- Facility 层面**
```
检查时机：创建/修改 Reservation 或 Maintenance 时

检查逻辑：
1. 提取目标设施的所有时间占用：
   - 从 Reservation 表获取：WHERE Facility_ID = ? AND Date = ?
   - 从 Maintenance 表获取：WHERE Facility_ID = ? AND Scheduled_Date = ?
   
2. 时间段重叠判断：
   新记录的 [Start_Time, End_Time] 不能与任何现有记录重叠
   
   重叠定义：
   (新Start_Time < 现有End_Time) AND (新End_Time > 现有Start_Time)

3. 拒绝条件：
   IF 存在重叠 THEN 拒绝操作并返回错误信息
```

**示例场景：**
```
假设 "羽毛球场A" 已有以下记录：
- Booking: 2024-11-15, 10:00-12:00 （会员预订）
- Maintenance: 2024-11-15, 14:00-16:00 （维护计划）

则以下操作会被拒绝：
❌ 新建 Training_Session: 2024-11-15, 11:00-13:00 （与 Booking 重叠）
❌ 新建 Maintenance: 2024-11-15, 15:30-17:00 （与现有 Maintenance 重叠）

以下操作允许：
✅ 新建 Booking: 2024-11-15, 12:30-13:30 （无重叠）
✅ 新建 Booking: 2024-11-15, 16:30-18:00 （无重叠）
```

**【设备冲突检查】- Equipment 层面**
```
检查时机：创建/修改 Reservation_Equipments 或 Maintenance 时

检查逻辑：
1. 计算同一时段的设备占用总量：
   
   已占用数量 = 
     (SELECT SUM(Quantity) FROM Reservation_Equipments
      WHERE Equipment_ID = ?
        AND EXISTS (
          SELECT 1 FROM Reservation
          WHERE Reservation_ID = Reservation_Equipments.Reservation_ID
            AND Date = ?
            AND [Start_Time, End_Time] 与新预订重叠
        ))
     +
     (SELECT COUNT(*) FROM Maintenance
      WHERE Equipment_ID = ?
        AND Scheduled_Date = ?
        AND Status IN ('Scheduled', 'In_Progress')
        AND [时间段] 与新预订重叠)
   
2. 可用性判断：
   可用数量 = Total_Quantity - 已占用数量
   
   IF 可用数量 < 请求数量 THEN 拒绝操作

3. 特殊处理：
   - 维护中的设备：完全不可用（视为占用全部数量）
   - 已完成的维护：不计入占用
```

**示例场景：**
```
假设 "羽毛球拍" 有：
- Total_Quantity = 10
- 2024-11-15, 10:00-12:00: Booking预订 5支
- 2024-11-15, 10:00-12:00: Training_Session预订 3支
- 2024-11-15, 14:00-16:00: Maintenance占用（视为全部10支不可用）

则以下操作会被拒绝：
❌ 新建 Booking 预订 3支 (10:00-12:00): 5+3+3=11 > 10
❌ 新建 Booking 预订 1支 (14:00-16:00): 维护期间不可用

以下操作允许：
✅ 新建 Booking 预订 2支 (10:00-12:00): 5+3+2=10 ≤ 10
✅ 新建 Booking 预订 5支 (16:30-18:00): 无冲突
```

##### 🛠️ 实现层级说明

**【EERD/概念层】- 当前阶段**
- ✅ 定义两类实体及其时间属性
- ✅ 定义资源关联关系
- ✅ 在文档中明确说明冲突检查规则
- ✅ 不显式建模冲突检查逻辑（属于实现细节）

**【逻辑设计层】- Task 3 阶段**
- 设计关系模式（表结构）
- 定义外键约束
- 添加 CHECK 约束（如 Maintenance 的资源互斥）
- 设计索引以支持高效的冲突查询

**【物理实现层】- 未来数据库实现**
- 创建触发器（Trigger）自动检查冲突
  ```sql
  -- 示例：Reservation 插入前触发器
  CREATE TRIGGER check_facility_conflict
  BEFORE INSERT ON Reservation
  FOR EACH ROW
  BEGIN
    -- 检查 Reservation 表中的冲突
    -- 检查 Maintenance 表中的冲突
    -- 如有冲突则 SIGNAL SQLSTATE '45000'
  END;
  ```
- 或在应用层实现冲突检查逻辑（更灵活）
  ```python
  def create_reservation(facility_id, date, start_time, end_time):
      # 1. 查询 Reservation 表
      # 2. 查询 Maintenance 表
      # 3. 检测冲突
      # 4. 如无冲突则插入
  ```

##### 📌 设计理由与权衡

**为什么采用双轨制而非统一模型？**

**方案对比：**
| 方案 | 优点 | 缺点 |
|------|------|------|
| **双轨制（当前）** | ✅ 语义清晰（预订 vs 维护）<br>✅ 职责分离（用户 vs 管理员）<br>✅ 属性匹配（维护需要 Completion_Date）<br>✅ 符合 EERD "表达现实"的原则 | ⚠️ 需要跨表查询冲突<br>⚠️ 需在应用/触发器层实现约束 |
| **统一为 Reservation 子类** | ✅ 统一时间管理<br>✅ 冲突检查简单（单表） | ❌ 语义混淆（维护不是"预订"）<br>❌ Maintenance 继承不需要的 Member 关系<br>❌ 无法表达 Completion_Date（结束时间 ≠ 完成时间） |
| **创建独立时间实体** | ✅ 时间统一管理 | ❌ 过度抽象（时间是属性而非实体）<br>❌ 增加复杂度<br>❌ 违反规范化原则 |

**最终决策：** 采用双轨制设计
- **EERD 层面**保持语义准确性和概念清晰度
- **实现层面**通过触发器或应用逻辑保证数据一致性
- 符合"概念设计关注'是什么'、逻辑/物理设计关注'怎么做'"的数据库设计原则

##### 🎯 后续工作清单

在 Task 3（逻辑设计）阶段需要：
1. ✅ 为 Reservation 和 Maintenance 表添加时间相关索引
   ```sql
   CREATE INDEX idx_reservation_facility_time 
   ON Reservation(Facility_ID, Date, Start_Time, End_Time);
   
   CREATE INDEX idx_maintenance_facility_time
   ON Maintenance(Facility_ID, Scheduled_Date);
   ```

2. ✅ 设计视图简化冲突查询
   ```sql
   CREATE VIEW v_facility_occupancy AS
   SELECT Facility_ID, Date, Start_Time AS Occ_Start, End_Time AS Occ_End, 
          'Reservation' AS Source_Type, Reservation_ID AS Source_ID
   FROM Reservation
   UNION ALL
   SELECT Facility_ID, Scheduled_Date AS Date, 
          Scheduled_Date AS Occ_Start, Scheduled_Date AS Occ_End,
          'Maintenance' AS Source_Type, Maintenance_ID AS Source_ID
   FROM Maintenance
   WHERE Facility_ID IS NOT NULL;
   ```

3. ✅ 编写存储过程封装冲突检查逻辑
   ```sql
   CREATE PROCEDURE sp_check_facility_conflict(
       IN p_facility_id INT,
       IN p_date DATE,
       IN p_start_time TIME,
       IN p_end_time TIME,
       OUT p_has_conflict BOOLEAN
   )
   ```

### 🔒 完整性约束

#### 实体完整性
- 所有实体都有明确的主键（用下划线标记）
- 主键不允许 NULL

#### 参照完整性
- 所有外键必须引用存在的记录
- 级联删除：
  - 删除 Reservation → 自动删除关联的 Reservation_Equipments
  - 删除 Training_Session → 自动删除关联的 Session_Enrollment

#### 域完整性
- Status 字段使用枚举类型
- Quantity 必须 > 0
- Date 不能是过去的日期（新建预订时）
- Start_Time < End_Time

---

## 下一步工作（Task 3 - Logical Design）

### 转换为关系模式时的注意事项：

1. **泛化处理：**
   - Member 及其子类：可以使用 "Separate Tables" 方法
   - Reservation 及其子类：同样使用独立表

2. **弱实体处理：**
   - Reservation_Equipments: (Reservation_ID, Equipment_ID, Quantity)
     - PK: (Reservation_ID, Equipment_ID)
     - FK: Reservation_ID → Reservation(Reservation_ID)
     - FK: Equipment_ID → Equipment(Equipment_ID)

3. **多值属性处理：**
   - Phone_Number: 创建独立表 Member_Phone(Member_ID, Phone_Number)
   - Email_Address: 创建独立表 Member_Email(Member_ID, Email_Address)

4. **复合属性处理：**
   - Name: 展开为 First_Name, Last_Name（两个独立列）
   - Location: 展开为 Building, Floor, Room_Number

---

## 附录：图例说明

### 实体表示
- **强实体：** 单线矩形
- **弱实体：** 双线矩形

### 属性表示
- **简单属性：** 单线椭圆
- **主键属性：** 实线下划线
- **部分键：** 虚线下划线
- **多值属性：** 双线椭圆
- **复合属性：** 椭圆连接到子属性椭圆

### 关系表示
- **普通关系：** 单线菱形
- **识别关系：** 双线菱形（连接弱实体）

### 参与约束
- **可选参与：** 单线
- **完全参与：** 双线

### 基数表示
- **1** - 一个
- **N** - 多个
