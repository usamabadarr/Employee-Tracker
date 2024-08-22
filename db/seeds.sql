-- seeds.sql

-- Insert initial departments
INSERT INTO department (name) 
VALUES 
('Engineering'), 
('Sales'), 
('HR'), 
('Operations'),
('Marketing'), 
('Finance');

-- Insert initial roles with details
INSERT INTO role (title, salary, department_id)
VALUES 
('Software Engineer', 127000, 1),
('Sales Manager', 82000, 2),
('HR Specialist', 60000, 3),
('Production Manager', 92000, 4),
('Marketing Coordinator', 55000, 5),
('Financial Analyst', 75000, 6);

-- Insert initial employees
INSERT INTO employee (first_name, last_name, role_id, manager_id) 
VALUES 
('John', 'Doe', 1, null), 
('Jane', 'Smith', 2, null), 
('Jim', 'Brown', 3, null), 
('Alice', 'Johnson', 1, 1), 
('Bob', 'Williams', 2, 2), 
('Carol', 'Davis', 3, 3), 
('David', 'Miller', 4, null), 
('Hailey', 'Hawking', 5, null), 
('Eve', 'Wilson', 6, null);
