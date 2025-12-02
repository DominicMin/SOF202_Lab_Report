# 数据库课程作业论文修改日志（Scenario 1）

本日志分为两部分：
1. **内容修改记录**：实际已经在 `main.tex` 中完成的修改及其理由。  
2. **结构修改建议**：目前未实施、仅供后续优化使用的 LaTeX 结构性调整建议，并给出示例代码。

---

## 一、内容修改记录（已修改部分）

> 说明：这里只记录对 `main.tex` 所做的**实质内容修改**，均保证不改变整体排版结构（章节划分、表格/代码环境等保持不变），仅调整用词、枚举取值和实体命名等与 EERD、Rubric 相关的内容。

- **1. 外部访客申请实体命名统一为 `Registration_Application`**
  - 修改位置：
    - 需求分析部分对外部访客注册流程的描述（`Requirement Analysis` → Functional Requirements / Assumptions）。
    - 概念设计中实体小节原 `Visitor_Application` 改为 `Registration_Application`（实体说明+属性列表）。
    - 逻辑设计中关于申请实体的小节（原 `\subsubsection{Visitor_Application}` 以及其关系说明）。
    - 访问控制部分 `Visitor Application Management` 表内的表名与说明文字。
    - 数据完整性与约束部分所有关于申请表/电话/邮箱的 DDL（`CREATE TABLE`、`ALTER TABLE`、`CHECK` 约束等）。
  - 修改前后要点：
    - 原文在多个位置使用 `Visitor_Application`，而 EERD 设计说明及 Chen 图中使用的是 `Registration_Application`。
    - 现在统一为：
      - 实体名：`Registration_Application`
      - 弱实体：`Registration_Application_Phone`、`Registration_Application_Email`
      - 相关约束：`ALTER TABLE Registration_Application ...` 等。
  - 修改理由：
    - 保证概念设计、逻辑设计、访问控制和完整性约束中的命名与 Chen EERD 图和 `EERD说明.md` 一致，避免“EERD 一套名字、论文另一套名字”的不一致情况，符合 Task 2/3 的一致性要求。

- **2. 会员状态枚举 `Membership_Status` 与 EERD 对齐**
  - 修改位置：
    - 概念设计中 `Member` 实体属性列表（原 `ENUM: Active, Suspended, Expired`）。
    - 逻辑设计中对 `Member` 表的示例与说明（使用该状态区分不同会员状态）。
    - 物理设计中“Status Fields and ENUM Usage”示例代码中 `Membership_Status ENUM(...)`。
    - 域完整性部分 `ALTER TABLE Member ... chk_member_status` 约束。
  - 修改前后要点：
    - 原枚举值：`Active, Suspended, Expired`。
    - 现枚举值：`Active, Inactive, Pending_Approval`。
    - 文本说明同步改为“Active / Inactive / Pending_Approval”。
  - 修改理由：
    - `EERD说明.md` 中明确给出了 `Membership_Status` 的业务取值为 `Active / Inactive / Pending_Approval`，原论文枚举值与之不符，属于与 ERD 设计不一致。
    - 对齐后，Task 2（实体属性）、Task 6（域完整性）之间语义统一，更符合 Rubric 对“正确数据类型和取值范围”的要求。

- **3. 设施与设备状态枚举与 EERD 对齐**
  - 修改位置：
    - 概念设计中 `Facility`、`Equipment` 实体的属性列表。
    - 逻辑设计中的 `CREATE TABLE Facility` DDL 以及后续 `ALTER TABLE ... chk_facility_status`、`chk_equipment_status` 约束。
  - 修改前后要点：
    - `Facility.Status`：
      - 原：`Available, Under_Maintenance, Closed`
      - 现：`Available, Under_Maintenance, Unavailable`
    - `Equipment.Status`：
      - 原：`Available, Damaged, Under_Maintenance`
      - 现：`Available, In_Use, Under_Maintenance, Damaged`
    - 相关文字说明同步补充了 `In_Use` 和 `Unavailable` 的语义。
  - 修改理由：
    - EERD 说明中的状态枚举与原文不一致（缺少 `In_Use`、使用 `Unavailable` 而非 `Closed`）。
    - 统一后，实体属性 → 关系模式 → DDL 代码三者完全一致，避免老师检查枚举值时出现“图上和表上写的不一样”的扣分点。

- **4. `Member` 与 `Reservation/Booking` 关系描述与 EERD 一致**
  - 修改位置：
    - 逻辑设计中 `Booking: Member Reservation` 小节，原来的一条 bullet：
      - “In EERD, the 1:N relationship `Member makes Booking` ...”。
  - 修改前后要点：
    - 现描述改为：EERD 中是“成员创建 Reservation”，而在关系模式里，通过在 `Booking` 子类中保存 `Member_ID` 实现该关系（并解释 `Booking` 与 `Reservation` 的 1:1 关系如何保持一致语义）。
  - 修改理由：
    - Chen 图和 `EERD说明.md` 中关系 R4 为 `Member makes Reservation`，而非 `Member makes Booking`，原文属于直接误引 EERD。
    - 修正后准确反映了：EERD 的关系在逻辑设计中是通过 `Reservation` 超类 + `Booking` 子类的主键下推实现的，避免 Task 2B/Task 3 被认为“EERD 和转换过程不匹配”。

- **5. `Available_Quantity` 作为派生属性的描述统一**
  - 修改位置：
    - 概念设计中 `Equipment` 属性说明已指出 `Available_Quantity` 为派生属性、不存表。
    - 物理设计中给出的 SQL 计算示例（通过 `Equipment.Total_Quantity`、`Reservation_Equipments` 与 `Maintenance` 计算）。
    - 事务（Task 7）“Atomicity” 小节中原来的业务步骤 bullet：
      - 原文第三步为“Update `Equipment.Available_Quantity` to reflect the reduced stock”。
  - 修改前后要点：
    - 将事务示例第三步改为：依赖派生的 `Available_Quantity` 进行检查，而**不更新**某个存储列，并与后面示例代码注释“Available_Quantity is a derived attribute, no update needed”保持一致。
  - 修改理由：
    - 原文在 Task 3/4 中把 `Available_Quantity` 明确为派生字段，但在 Task 7 示例中又把其当作持久列更新，出现自相矛盾。
    - 统一后，逻辑设计、物理设计与事务示例在“派生属性不落库、只在查询中计算”的原则上完全一致，符合数据库范式与完整性设计思路。

- **6. 访问控制与完整性约束中关于申请表的命名/约束统一**
  - 修改位置：
    - 访问控制表格中：`Visitor_Application` 系列表名改为 `Registration_Application` 系列。
    - 访问控制说明文本中，对前台和 Manager 操作的描述使用新的表名。
    - 域完整性部分：`ALTER TABLE Registration_Application ... chk_application_status` 取代原来的 `Visitor_Application`。
    - 数据完整性部分：所有 `CREATE TABLE Visitor_Application_*` 改为 `Registration_Application_*` 且外键引用更新为 `REFERENCES Registration_Application(...)`。
  - 修改理由：
    - 保证角色权限表、DDL 和概念实体命名一致，老师在对照访问控制（Task 5）和完整性（Task 6）时不会遇到“表名对不上”的问题。

---

## 二、结构修改建议（尚未实施，仅供后续优化）

> 以下建议不涉及当前评分要点的硬性问题，因此**没有在本次提交中直接修改**，以避免大幅度改动排版结构。若后续有时间，可以据此重构 `main.tex` 结构，使文档更易维护。

- **建议 1：按任务拆分为子文件并使用 `\input` 引入**
  - 现状：
    - 所有内容（Task 1–7、物理设计、访问控制、完整性、事务）都堆在单一 `main.tex` 中，文件超过 2000 行，维护成本较高。
  - 建议结构：
    - 在同级目录新建若干子文件：
      - `task1_requirements.tex`
      - `task2_conceptual_design.tex`
      - `task3_logical_design.tex`
      - `task4_physical_design.tex`
      - `task5_access_control.tex`
      - `task6_integrity.tex`
      - `task7_transactions.tex`
    - 在 `main.tex` 中，用如下方式组织正文：
      ```tex
      % main.tex 中（示例）
      \section{Requirement Analysis}
      \input{task1_requirements}

      \section{Conceptual Design}
      \input{task2_conceptual_design}

      \section{Logical Design}
      \input{task3_logical_design}

      \section{Physical Design and Rationality Analysis}
      \input{task4_physical_design}

      \section{Access Control}
      \input{task5_access_control}

      \section{Database Integrity}
      \input{task6_integrity}

      \section{Database Transaction}
      \input{task7_transactions}
      ```
  - 预期收益：
    - 便于针对单个 Task 做局部修改，不易误伤其他部分。
    - 方便与原始英文/中文草稿 (`raw` 目录) 进行对照和增量维护。

- **建议 2：为常用实体/关系定义 LaTeX 宏，避免硬编码字符串**
  - 现状：
    - 文中多次出现诸如 `\texttt{Registration_Application}`、`\texttt{Reservation_Equipments}`、`\texttt{Session_Enrollment}` 等实体/表名，全部为硬编码。
    - 一旦未来想改名（例如从 `Reservation_Equipments` 改为 `Reservation_Equipment`），需要全局搜索替换，容易漏改。
  - 建议代码：
    - 在导言区或文档前部定义宏：
      ```tex
      % 建议加入到 main.tex 导言区附近
      \newcommand{\tblMember}{\texttt{Member}}
      \newcommand{\tblReservation}{\texttt{Reservation}}
      \newcommand{\tblBooking}{\texttt{Booking}}
      \newcommand{\tblTrainingSession}{\texttt{Training\_Session}}
      \newcommand{\tblRegApp}{\texttt{Registration\_Application}}
      \newcommand{\tblResEquip}{\texttt{Reservation\_Equipments}}
      ```
    - 正文中统一使用：
      ```tex
      The \tblRegApp{} table stores external visitor applications.
      ```
  - 预期收益：
    - 所有命名集中管理，后续设计迭代时只需改宏定义即可全局生效。
    - 降低拼写错误风险（例如 `Training_Session`/`TrainingSession` 混用）。

- **建议 3：统一 SQL 代码环境与样式**
  - 现状：
    - 文中 SQL 片段均使用 `\begin{sql}...\end{sql}` 环境，风格基本一致，但少数地方注释格式和缩进略有差异。
  - 建议做法：
    - 确保导言区定义了 `sql` 环境（通常通过 `listings` 或 `minted` 包）：
      ```tex
      % 仅示例，具体以 xum_review.cls 中已有定义为准
      \lstnewenvironment{sql}{%
        \lstset{
          language=SQL,
          basicstyle=\ttfamily\small,
          keywordstyle=\bfseries,
          commentstyle=\itshape,
          columns=fullflexible,
          keepspaces=true
        }
      }{}
      ```
    - 统一缩进风格，例如关键字大写、列名对齐：
      ```tex
      \begin{sql}
      CREATE TABLE Booking (
          Reservation_ID  INT UNSIGNED PRIMARY KEY,
          Member_ID       INT UNSIGNED NOT NULL,
          Booking_Status  ENUM('Pending', 'Confirmed', 'Cancelled') NOT NULL,
          CONSTRAINT fk_booking_reservation
              FOREIGN KEY (Reservation_ID)
              REFERENCES Reservation(Reservation_ID),
          CONSTRAINT fk_booking_member
              FOREIGN KEY (Member_ID)
              REFERENCES Member(Member_ID)
      );
      \end{sql}
      ```
  - 预期收益：
    - 代码块视觉上更统一，评分时老师更容易阅读 DDL/约束细节。

- **建议 4：适当拆分长小节，增加层次标签**
  - 现状：
    - 如 `Physical Design and Rationality Analysis`、`Database Integrity`、`Database Transaction` 等章节内部内容较长，小节深度和层次较多，阅读时需要频繁上下滚动。
  - 建议做法：
    - 在不改变当前章节结构的前提下，细化 `\subsubsection` 与 `\paragraph` 的使用，并为关键业务规则添加标签：
      ```tex
      \subsubsection{Facility Conflict Constraints}\label{sec:facility-conflict-constraints}
      ...

      \subsubsection{Equipment Availability Constraints}\label{sec:equipment-availability-constraints}
      ...
      ```
    - 在后文引用这些规则时，使用 `\cref{sec:facility-conflict-constraints}` 代替口头描述“上文所述约束”。
  - 预期收益：
    - 逻辑跳转更加清晰，尤其符合 Task 4/Task 6/Task 7 中“解释如何避免 double booking / 保证完整性 / 满足 ACID”的论证路径。

- **建议 5：在参考文献部分统一引用格式**
  - 现状：
    - 文中已有 `\citet{frank2013roleminingprobabilisticmodels}`、`\citep{gouglidis2023modelcheckingaccesscontrol}`、`\citep{Kenig_2022}` 等引用，格式规范，但没有在正文中统一说明“与本设计的关系”的位置。
  - 建议做法：
    - 在各自章节的小节末尾增加一两句“总结性连接语句”，并保持风格一致，例如：
      ```tex
      As shown by \citet{Kenig_2022}, formally reasoning about referential constraints
      helps ensure that schema-level guarantees align with application-level semantics;
      our design choices for foreign keys and ON DELETE actions follow the same line
      of reasoning.
      ```
  - 预期收益：
    - 使引用的文献与本设计的论证更紧密，满足老师对“引用是否有用”的主观评价，而不是仅作为装饰性引用。

---

如需我继续按照上述“结构修改建议”对 `main.tex` 做进一步重构，可以在确认不影响当前版式要求后再进行下一轮调整。当前版本已在不改变整体结构的前提下，修正了与 EERD 及 Rubric 相关的关键内容问题。

