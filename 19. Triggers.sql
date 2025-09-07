/* Triggers in SQL
    -> A Trigger is a special kind of Stored Procedure that executes automatically 
       in response to specific events on a table or view.
    -> Trigger Events:
        A. INSERT   -> Fired when a new row is inserted
        B. UPDATE   -> Fired when an existing row is updated
        C. DELETE   -> Fired when a row is deleted
    -> Types of Triggers:
        - BEFORE Trigger   : Executes before the event (MySQL only)
        - AFTER Trigger    : Executes after the event
        - INSTEAD OF Trigger: Executes instead of the event (mainly on views in SQL Server)
    -> General Syntax:
        MySQL:
            CREATE TRIGGER trigger_name
            {BEFORE | AFTER} {INSERT | UPDATE | DELETE}
            ON table_name
            FOR EACH ROW
            BEGIN
                -- SQL statements
            END;

        SQL Server:
            CREATE TRIGGER trigger_name
            ON table_name
            AFTER | INSTEAD OF {INSERT, UPDATE, DELETE}
            AS
            BEGIN
                -- SQL statements
            END;

    -> Execution Process:
        1. Trigger is created and linked to a specific table event.
        2. When the event (INSERT / UPDATE / DELETE) occurs:
            - The database engine detects it.
            - The trigger fires automatically (no manual execution).
            - The SQL code inside the trigger runs as part of the same transaction.
        3. If the trigger fails, the entire transaction may roll back.

    -> Special Row References: 
			- When a trigger fires (INSERT, UPDATE, DELETE), the database gives temporary row references.
            - so we can access the before and after values of the row(s) affected.
			- These are not permanent tables, but pseudo-tables (or virtual references) available only inside the trigger.
        MySQL:   NEW (new values), OLD (previous values)
        SQL Server: INSERTED (new values), DELETED (old values)
*/
use salesdb;
CREATE TABLE EmployeeLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    EmpID INT,
    FirstName VARCHAR(100),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    ActionTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ActionType VARCHAR(20)
);

DELIMITER //
CREATE TRIGGER trg_after_employee_insert
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO EmployeeLog (EmpID, FirstName, Department, Salary, ActionType)
    VALUES (NEW.employeeid, NEW.firstname, NEW.department, NEW.salary, 'INSERT');
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_after_employee_update
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO EmployeeLog (EmpID, FirstName, Department, Salary, ActionType)
    VALUES (NEW.employeeid, NEW.firstname, NEW.department, NEW.salary, 'UPDATE');
END //

DELIMITER ;


INSERT INTO `employees` (`employeeid`,`firstname`,`lastname`,`department`,`birthdate`,`gender`,`salary`,`managerid`) VALUES
  (6, 'Mohit', 'Gusain', 'Technical', '2005-07-10', 'M', 55000, 2);
INSERT INTO `employees` (`employeeid`, `firstname`, `lastname`, `department`, `birthdate`, `gender`, `salary`, `managerid`) 
VALUES
  (7, 'Amit', 'Sharma', 'HR', '1998-03-15', 'M', 45000, 3),
  (8, 'Priya', 'Mehta', 'Finance', '1996-11-22', 'F', 60000, 4);
UPDATE employees set salary=60000 where employeeid = 6;
select * from employeelog;

    

