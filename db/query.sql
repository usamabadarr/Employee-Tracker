-- Query to insert a new department
INSERT INTO department (name)
VALUES ('Customer Support');

-- Query to insert a new role
INSERT INTO role (title, salary, details, department_id)
VALUES ('Customer Support Specialist', 50000, 'Handles customer inquiries and provides support.', 1);

-- Query to insert a new employee
INSERT INTO employee (first_name, last_name, role_id, manager_id)
VALUES ('Emily', 'Clark', 1, null);

-- Query to retrieve all departments
SELECT * FROM department;

-- Query to retrieve all roles with their department names
SELECT role.id, role.title, role.salary, role.details, department.name AS department_name
FROM role
JOIN department ON role.department_id = department.id;

-- Query to retrieve all employees with their role titles and manager names
SELECT employee.id, employee.first_name, employee.last_name, role.title AS role_title, 
       CONCAT(manager.first_name, ' ', manager.last_name) AS manager_name
FROM employee
JOIN role ON employee.role_id = role.id
LEFT JOIN employee AS manager ON employee.manager_id = manager.id;

-- Query to update an employee's role
UPDATE employee
SET role_id = 2
WHERE id = 1;

-- Query to update an employee's manager
UPDATE employee
SET manager_id = 3
WHERE id = 2;

-- Query to delete a department (Note: this will fail if there are roles associated with this department)
DELETE FROM department
WHERE id = 5;

-- Query to delete a role (Note: this will fail if there are employees associated with this role)
DELETE FROM role
WHERE id = 4;

-- Query to delete an employee
DELETE FROM employee
WHERE id = 6;

-- Query to get the total number of employees in each department
SELECT department.name AS department_name, COUNT(employee.id) AS employee_count
FROM department
JOIN role ON department.id = role.department_id
JOIN employee ON role.id = employee.role_id
GROUP BY department.name;

-- Query to get the average salary in each department
SELECT department.name