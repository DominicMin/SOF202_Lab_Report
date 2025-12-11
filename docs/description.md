# F. Task(s)

* All tasks in this lab report must be completed as a group (Same group as Assignment).
* Your work must be based on and refer to the group assignment that you completed earlier in the semester.
* Ensure consistency between your previous database design and your current database implementation and testing.

---

## Task 1 (Database Integrity) – 20%

Data integrity refers to the accuracy, consistency, and reliability of data stored in a database. It ensures that the data remains valid, up-to-date, and free from duplication or inconsistency.

Constraints help maintain data integrity by preventing duplicate entries, invalid values, and broken relationships between tables. They also control operations such as INSERT, UPDATE, and DELETE to ensure the stored data remains accurate and meaningful.

Data integrity can be classified into the following three (3) main types of constraints:

* Domain Integrity Constraints
* Entity Integrity Constraints
* Referential Integrity Constraints

### Instructions

a) Write at least ONE (1) sample CREATE TABLE statement that includes relevant constraints for each data integrity above.

#### Note

* Include a screenshot of your CREATE TABLE statement and its successful execution message for Question above.
* The CREATE TABLE statement must be based on the relational schema from Assignment (Task 3A).

b) Explain clearly how each of the above data integrity constraints above is applied and maintained in your database design.

---

## Task 2 (SQL) – 30%

This task focuses on the practical implementation of your database system using a Database Management System (DBMS) (e.g., MySQL). You are required to demonstrate the actual database creation and manipulation through SQL statements based on your selected scenario from Assignment (Task 3- Relational Schema). Your implementation should reflect the logical and physical design stages, showcasing how the database structure, relationships, and constraints are applied in practice.

### Instructions

a) Take screenshots of all the remaining CREATE TABLE commands, except for the examples provided above (Task 1A).

b) Following the previous tasks, populate every table with a minimum of 6–10 rows of data each.

c) Run a variety of SQL commands using different categories of syntax to demonstrate your understanding of data retrieval and manipulation. Using any of your created tables, run three (3) different SQL queries for each category listed below. Include screenshots of each query and its output. Use arithmetic expressions where appropriate.

### Category Syntax

| No. | Category            | Syntax                                                                                                                                      |
| --- | ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| 1.  | Filtering           | - LIKE<br>- BETWEEN<br>- IN (or any other filtering operator)                                                                               |
| 2.  | Aggregate Functions | - SUM<br>- COUNT<br>- AVG (or MIN / MAX)                                                                                                    |
| 3.  | Limit/ Sorting      | - ORDER BY (ASC/DESC)<br>- LIMIT or TOP<br>- Sorting combined with filtering (ORDER BY price DESC with a condition)                         |
| 4.  | Join operators      | - INNER JOIN<br>- LEFT JOIN<br>- RIGHT JOIN                                                                                                 |
| 5.  | String/ Arithmetic  | - Arithmetic expression (Example: hours_worked * rate_per_hour, total_amount % 2, or any other…)<br>- String function (UPPER (), CONCAT ()) |
| 6.  | Formatting          | - Column/table renaming using AS<br>- Concatenated output                                                                                   |

---

## Task 3 (Triggering) – 15%

Triggers can be defined to run automatically BEFORE or AFTER a data-modifying event on a table. The three possible trigger events are:

* INSERT – runs when a new row is added
* UPDATE – runs when an existing row is changed
* DELETE – runs when a row is removed

Each trigger can access special values

* NEW.column → the new value (INSERT or UPDATE)
* OLD.column → the previous value (UPDATE or DELETE)

Choose any TWO (2) of the trigger events above. Write the corresponding MySQL trigger code and provide evidence showing what happens before and after the trigger executes using the same scenario selected from the assignment previously.

---

## Task 4 (Access Control) – 15%

Implement any TWO (2) of the access control mechanisms described in your previous Assignment (Task 5). Include screenshots showing all relevant results, such as the applied access control and the user’s ability to edit, delete, or update the selected table.
