
## Task 3 Checkpoints (Triggering)

### 1. 截图确认 (Evidence Screenshots)
- [ ] **Scenario A (A1-A3)**: 确保截图清晰展示了“预订插入前后的状态”。A2 必须包含红色的报错信息（Table 'reservation' overlap...）。
- [ ] **Scenario B (B1-B4)**: B3 必须展示报错 "Member already has 2 pending bookings"。B4 需要证明数据库中确实只有 2 条记录。
- [ ] **Scenario C (C1-C2)**: C1 需要展示两个报错（一个是 None，一个是 Both）。C2 展示成功插入。
- [ ] **Scenario D (D1-D3)**: D1 展示 Equipment 初始库存。D3 展示报错 "Requested equipment exceeds available" 或类似逻辑错误。
- [ ] **Scenario E (E1-E3)**: E3 展示报错 "Training session is full"。

### 2. 文本描述优化 (Textual Explanation)
- [ ] **Intro Clarity**: 检查 `section{Triggering}` 开头是否明确声明了："We selected **INSERT** and **UPDATE** events for our triggers." (已在文中，建议复查)。
- [ ] **Before/After Logic**: 确保每个 Scenario 的文字描述中， واضح地指出了 "Before the trigger..." 和 "After the trigger..." 的区别。目前的草稿已经隐含了这一点，如果有空可以加粗强调 **Before** 和 **After** 的字眼。

### 3. 代码一致性 (Code Consistency)
- [ ] 确保 `task3.tex` 中的 SQL 代码与你实际在 Workbench 中运行并截图的代码完全一致（包括变量名、错误提示信息 `MESSAGE_TEXT`）。如果不一致，Rubric "Screenshots complete, clear" 可能会扣分。

### 4. 冗余检查 (Over-delivery check)
- [ ] 现在的报告包含了 5 个场景 (A-E)，远超 Rubric 要求的 "Choose any TWO"。
  - **建议**: 如果报告篇幅过长，可以考虑保留 **Scenario A (Reservation Overlap)** 和 **Scenario E (Capacity)** 作为主打，将其他放入附录或简化展示。目前的完整展示展现了工作量，是加分项，但需注意不要让阅卷人迷失。

## 截图检查
- [ ] 检查截图一致性，必要时一个人在一个环境中截取所有图