# Implementation Plan - Add Conclusion Section

## Goal
Add a "Conclusion" section to the end of the lab report that summarizes the database design and its integration with the Django frontend, without the "Task X" numbering prefix.

## Proposed Changes

### [NEW] [paper/conclusion.tex](file:///c:/Users/DominicMin/Google_Drive/__STUDY__/Courses/4_Database/SOF202_Lab_Report/paper/conclusion.tex)
- Create a new LaTeX file for the Conclusion.
- Use `\section*{Conclusion}` to create an unnumbered section title.
- Use `\addcontentsline{toc}{section}{Conclusion}` to add it to the Table of Contents.
- Content will cover:
    - **Database Design summary**: Reiterate the robustness of the schema, integrity constraints (Domain, Entity, Referential), and normalization.
    - **Trigger Implementation**: Mention the use of triggers for complex business logic (e.g., pending booking limits).
    - **Django Integration**: Highlight how Django ORM works with the DB constraints and how the frontend provides a user-friendly interface while the DB acts as the final guard.
    - **Security**: Briefly mention the defense-in-depth approach (RBAC + Row-Level Security).

### [MODIFY] [paper/main.tex](file:///c:/Users/DominicMin/Google_Drive/__STUDY__/Courses/4_Database/SOF202_Lab_Report/paper/main.tex)
- Add `\input{conclusion.tex}` after `\input{task4.tex}`.

## Verification Plan
### Manual Verification
- **Compile PDF**: The user will compile the PDF.
- **Check TOC**: Verify "Conclusion" appears in the Table of Contents *without* "Task X".
