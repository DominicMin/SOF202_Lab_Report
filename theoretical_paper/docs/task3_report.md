一、Task 3 要求 & 评分标准回顾

从 docs/Assignment Description.pdf 和 rubric.pdf 提取到的 Task 3 要求是：

Assignment Task 3（Logical design, 10%）

a) 将前一题的 EERD 转换为关系模式（relational schema）。
b) 明确定义所有实体的主键（PK）和外键（FK）。
Rubric 对 Task 3 的 Excellent 档（9.0–10.0）描述：

Complete and accurate relational schema derived from EERD.
All entities, relationships, PKs, and FKs are clearly and correctly defined with proper notation.

下面所有评价基于：

Task 3 部分：main.tex (line 396) 开始的 \section{Logical Design} 及其小节；
你的 EERD 说明：eerd/EERD说明.md；
Draw.io 图：eerd/eerd.xml；
Task 2 的概念设计（方便对比是不是“从 EERD 推出”的）。
二、整体判断：是否正确从 EERD 得到关系模式？

总体印象：

你几乎对 所有 EERD 中的主要实体和关系 都给出了明确的关系模式：
Member / Student / Staff / External_Visitor / Facility / Equipment /
Reservation / Booking / Training_Session / Maintenance /
Registration_Application / Reservation_Equipments / Session_Enrollment 等。
每个表都写出了 PK，涉及关联的地方都给出了 FK，而且在后半部分用 MySQL DDL 示例（CREATE TABLE ...）再次验证了一遍 PK、FK、CHECK 约束的设计。
处理了复合属性、多值属性和派生属性（特别是 Contact_Details 和 Available_Quantity），同时解释了为什么逻辑设计阶段不存储派生属性，这和 Task 2/EERD 说明中的设计原则是一致的。
换句话说：Task 3 的逻辑设计整体是完整、成体系且与 EERD 十分接近的，只存在少量“概念层调整”——尤其是 Registration_Application 的部分。下面细分来看。

三、逐块对照 EERD 的映射情况

Member 及其子类（Student / Staff / External_Visitor）
逻辑设计（main.tex (line 455) 之后）：
Member(Member_ID PK, First_Name, Last_Name, Registration_Date, Membership_Status)
Student(Member_ID PK, Student_ID, FK → Member(Member_ID))
Staff(Member_ID PK, Staff_ID, FK → Member(Member_ID))
External_Visitor(Member_ID PK, IC_Number, FK → Member(Member_ID))
EERD 说明（eerd/EERD说明.md (line 31)–40）中：
Member 有 Member_ID、Name、Contact_Details、Registration_Date、Membership_Status 等；
子类 Student/Staff/External_Visitor 继承 Member_ID，并有各自的学号/工号/IC_Number。
映射关系非常标准：

使用了 “Superclass PK pushdown” 模式：每个子类的 Member_ID 既是 PK 又是 FK 指向 Member。这与 EERD 中的泛化结构完全一致。
Name、Contact_Details 被拆为原子属性（First / Last name, Phone, Email）由其他表承载，符合你在 Logical Design 开头写的原则。
→ 无逻辑冲突，映射正确。

多值联系信息（Member_Phone / Member_Email）
逻辑设计：
Member_Phone(Member_ID PK, Phone_Number PK, FK → Member(Member_ID))
Member_Email(Member_ID PK, Email_Address PK, FK → Member(Member_ID))
EERD 中：
在概念层将 Phone_Number、Email_Address 做成多值属性（双线椭圆），
在 EERD 说明末尾明确写到逻辑设计时转换为 Member_Phone(Member_ID, Phone_Number) / Member_Email(Member_ID, Email_Address)（eerd/EERD说明.md (line 656)–657）。
→ 从 EERD 到关系模式的转换完全符合教科书套路，也与自家 EERD 文档一致。

Registration_Application 及其联系方式子表
逻辑设计（main.tex (line 482) 之后）：

Registration_Application(Application_ID PK, First_Name, Last_Name, IC_Number, Application_Date, Status, Approved_By FK → Staff(Member_ID), Approval_Date, Reject_Reason, Created_Member_ID FK → Member(Member_ID))
外加两个弱实体：
Registration_Application_Phone(Application_ID PK, Phone_Number PK, FK → Registration_Application(Application_ID))
Registration_Application_Email(Application_ID PK, Email_Address PK, FK → Registration_Application(Application_ID))
文本明确说明：
申请人是 “prospective external visitors who are not yet members”；
Created_Member_ID 在审批通过后，指向创建好的 Member 记录，用于追溯“哪个申请生成了哪个会员”。
EERD 说明（eerd/EERD说明.md (line 134) 及后文）：

把 Registration_Application 作为强实体，属性包括：
Application_ID (PK)
Member_ID（“申请人，通常是 External_Visitor”）
Application_Date, Status, Approved_By, Approval_Date, Reject_Reason 等。
关系 R10：External_Visitor (1) --(makes)--> (N) Registration_Application（eerd/EERD说明.md (line 186)、235）。
这里有一个重要的小差异：

EERD 中的语义：
Registration_Application.Member_ID 直接指向 External_Visitor / Member，也就是说申请者在 EERD 层面已经是 External_Visitor 子类。
你在 Task 3 中的语义：
申请人在提交申请时 “还不是 Member”，审批通过后才创建 Member & External_Visitor，并通过 Created_Member_ID 反向追踪。
原来 EERD 中的 Member_ID 字段在关系模式里被删除，由 Created_Member_ID 取代，关系 R10（External_Visitor makes Registration_Application）在关系模式里就不再直接存在。
从场景合理性看：

你在 Task 3 中采用的语义（申请人一开始不是 Member）其实更贴合 Scenario 1 原文；
同时也通过 Created_Member_ID 提供了更多审计信息（从申请追溯到最终会员）。
但从“strictly derived from EERD”的角度看：

存在一处“与 EERD 不完全一致的关系转换”：
EERD 里的 External_Visitor -- makes --> Registration_Application + Registration_Application.Member_ID 在关系模式中不再被一一映射；
取而代之的是 Registration_Application.Created_Member_ID → Member 这一新关系。
→ 这点属于 rubric 中“minor errors or missing attributes/keys / “Some relationships inconsistent with EERD” 的典型例子。
→ 不影响整体正确性，但如果老师拿着 EERD 对照，会看到这处“关系没按图来”。

Facility / Equipment / Reservation / Booking / Reservation_Equipments
Facility：
Facility(Facility_ID PK, Facility_Name, Type, Status, Capacity, Building, Floor, Room_Number)（main.tex (line 540) 左右）
与 EERD 中 Facility 的属性基本对应（eerd/EERD说明.md (line 99)–107），Location 已按计划拆为 Building / Floor / Room_Number。
Equipment：
Equipment(Equipment_ID PK, Equipment_Name, Type, Status, Total_Quantity)（main.tex (line 555) 左右）
文本说明 Available_Quantity 为派生属性，不入表（main.tex (line 620) 前后）。
EERD 中 Available_Quantity 是属性，但在 EERD 说明后半部分你自己也提出“Derived attributes not stored”，逻辑一致。
Reservation：
Reservation(Reservation_ID PK, Facility_ID FK → Facility(Facility_ID), Reservation_Date, Start_Time, End_Time)（main.tex (line 628) 附近）。
对应 EERD 中 Reservation + 关系 Reservation -- uses --> Facility（eerd/EERD说明.md (line 181)），你选择在超类中直接存 Facility_ID 作为 FK，这是标准的 1:N 关系实现。
Booking（Reservation 子类）：
Booking(Reservation_ID PK, Member_ID FK → Member(Member_ID), Booking_Status)（main.tex (line 650) 附近）。
对应 EERD 中 Booking 子类 + Member -- makes --> Reservation 关系（R4）。你在逻辑设计中解释得很清楚：
Reservation_ID 作为 PK + FK 实现子类继承；
Member_ID 放在子类中，使得“只有 Booking 类型的 Reservation 才有会员”。这是将 R4 从 Member–Reservation 转换为 Member–Booking 的一个合理变体。
Reservation_Equipments：
Reservation_Equipments(Reservation_ID PK, Equipment_ID PK, Quantity, FK → Reservation, FK → Equipment)（main.tex (line 684)）
与 EERD 中 Reservation_Equipments 弱实体的说明完全一致（eerd/EERD说明.md (line 149)–155），DDL 里也明确 PK(FK) 定义。
→ 这一大块（设施/设备/预订）从 EERD 到关系模式的映射是教科书级别的正确，没有发现逻辑问题。

Coach / Training_Session / Session_Enrollment
Coach & 联系方式：
Coach(Coach_ID PK, First_Name, Last_Name, Sport_Type, Level)；
Coach_Phone(Coach_ID PK, Phone_Number PK, FK → Coach)；
Coach_Email(Coach_ID PK, Email_Address PK, FK → Coach)（main.tex (line 712) 之后）。
和 EERD 说明中对 Coach、多值 Contact_Details 的描述一致（eerd/EERD说明.md (line 63)–71）。
Training_Session 子类：
Training_Session(Reservation_ID PK, Coach_ID FK → Coach(Coach_ID), Max_Capacity, FK → Reservation(Reservation_ID))
EERD：Training_Session 是 Reservation 的子类，并通过 R1 Coach teaches Training_Session 建立 1:N（eerd/EERD说明.md (line 92)–97，177–193）。
你的 schema 完整地实现了：
继承（Reservation_ID PK+FK）；
1:N 教练授课（Coach_ID FK）；
额外加了 Max_Capacity，这是一个合情合理的扩展属性。
Session_Enrollment：
Session_Enrollment(Reservation_ID PK, Member_ID PK, FK → Training_Session(Reservation_ID), FK → Member(Member_ID))
完全对应 EERD 中的弱实体 Session_Enrollment 和关系 R2 (Training_Session has Session_Enrollment) / R3 (Session_Enrollment enrolls in Member)（参见 eerd/EERD说明.md (line 160)、196–205）。
→ 这一块完全符合 EERD，PK/FK 和关系说明都很清晰。

Maintenance
逻辑设计：
Maintenance(Maintenance_ID PK, Scheduled_Date, Completion_Date, Status, Description, Facility_ID FK, Equipment_ID FK)
并通过 CHECK 约束实现 XOR：要么指设施，要么指设备（main.tex (line 820)–860 + DDL 部分）。
EERD：
Maintenance 为独立强实体（非 Reservation 子类），属性 Maintenance_ID, Scheduled_Date, Completion_Date, Status, Description 等（eerd/EERD说明.md (line 123)–132）；
关系 R8/R9：Maintenance requires Equipment/Facility（N:1）并通过 XOR 业务规则限制（eerd/EERD说明.md (line 423)–441）。
你的逻辑模型：

对 PK/FK/XOR 约束的实现完全照着 EERD 自己那套设计说明走；
还补充了维护记录与 Reservation 的协调方式（不强制结构绑定，而通过“选择性创建 Reservation 来屏蔽维护时间段”）。
→ 这一部分与 EERD 完全一致，且实现细节考虑得很到位。

四、综合评价与打分（严格按 rubric）

结合 rubric 对 Task 3 的描述：

Excellent (9.0–10.0)
Complete and accurate relational schema derived from EERD.
All entities, relationships, PKs, and FKs are clearly and correctly defined.

你的 Task 3 有明显优点：

所有主要实体都从 EERD 映射到了关系模式，没有出现漏掉整个实体的情况。
所有关系（1:N、N:M、泛化/特化、弱实体识别关系）都用 FK 或关联表清晰地表达出来了。
每个模式都指出了 PK，涉及关系的地方都标明了 FK，并且给了 DDL 例子来“证明你真的知道怎么在 DBMS 里实现这些约束”。
对多值属性与派生属性的处理完全符合 EERD 说明中自己定下的转换原则。
唯一比较明显、但仍属“小问题”的地方：

Registration_Application 的关系与 EERD 不完全一致：
EERD 中有 External_Visitor -- makes --> Registration_Application 与属性 Member_ID；
在 Task 3 的逻辑模型中，这个关系被替换为
Registration_Application.Created_Member_ID → Member（审批后产生的会员）；
“申请人不是 Member” 的语义。
从 Scenario 1 看，这个改动是合理甚至更自然的，但严格地说，它没有按原 EERD 的关系来映射，属于 rubric 所说的 “minor errors or missing attributes/keys / some relationships inconsistent with EERD”。
因此，在“严格按 rubric”的前提下：

整体肯定在 Good ~ Excellent 边界，不是那种“有好几个实体/键缺失”的情况；
但由于存在至少一处与 EERD 不一致的关系（而非纯粹命名错误），我会把它判定为：一张几乎完美的 Logical Design，但略微偏离原 EERD 的设计决策。
综合给分建议：

Task 3（Logical Design）：9.0 / 10

理由：
结构、PK/FK 定义、关系转换都达到了 Excellent 档要求；
Registration_Application 的那一点点与 EERD 的不一致，我视为“轻微但真实的偏差”，因此不给 10/10，而是 9.0/10。
五、如果想把 Task 3 再抛光到接近“无可挑剔”的状态

不一定要改，你现在这样已经是高分级别，但如果目标是从 teacher 的视角“完全对齐 EERD”，可以考虑：

方案 A：调整 EERD

更新 Chen 图和 EERD说明.md：
在 Registration_Application 中去掉 Member_ID，改为 Created_Member_ID；
把关系 R10 改为 “Registration_Application eventually creates Member (External_Visitor)” 或类似表述。
这样 Task 2 / Task 3 / EERD 完全统一。
方案 B：保持 EERD 不变，微调 Logical Design

在 Registration_Application 表中加回 Applicant_Member_ID（FK → Member(Member_ID)），映射原来的 Member_ID；
同时保留 Created_Member_ID（你的扩展），让一个申请既能指向“申请人（可能是已有 External_Visitor）”，又能指向“审批后生成的 Member”；
逻辑设计里解释：
对于首次申请的外部访客，Applicant_Member_ID 为空，审批通过后才创建 Member 并回填 Created_Member_ID；
对于已有 External_Visitor 续期/改签，Applicant_Member_ID 可以指向已有 External_Visitor。
如果你想，我也可以帮你写出一段简短的 LaTeX 修改建议，让 main.tex 中 Task 3 对 Registration_Application 的描述同时兼容 EERD 和你现在的业务语义。