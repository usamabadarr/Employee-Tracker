-- schema.sql

-- -- Drop the database if it exists and create a new one
-- DROP DATABASE IF EXISTS employee_tracker_db;
-- CREATE DATABASE employee_tracker_db;

-- \c employee_tracker_db

-- -- Create the department table
-- CREATE TABLE department (
--     id SERIAL PRIMARY KEY,
--     name VARCHAR(30) UNIQUE NOT NULL
-- );

-- -- Create the role table
-- CREATE TABLE role (
--     id SERIAL PRIMARY KEY,
--     title VARCHAR(30) UNIQUE NOT NULL,
--     salary DECIMAL NOT NULL,
--     department_id INTEGER NOT NULL,
--     FOREIGN KEY (department_id) 
--     REFERENCES department(id) ON DELETE CASCADE
-- );

-- -- Create the employee table
-- CREATE TABLE employee (
--     id SERIAL PRIMARY KEY,
--     first_name VARCHAR(30) NOT NULL,
--     last_name VARCHAR(30) NOT NULL,
--     role_id INTEGER NOT NULL,
--     manager_id INTEGER,
--     FOREIGN KEY (role_id) 
--     REFERENCES role(id) ON DELETE SET NULL,
--     FOREIGN KEY (manager_id) 
--     REFERENCES employee(id) ON DELETE SET NULL
-- );



-- -- Drop the database if it exists, then create a new one
-- DROP DATABASE IF EXISTS employee_tracker_db;
-- CREATE DATABASE employee_tracker_db;

-- -- Connect to the newly created database
-- \c employee_tracker_db

-- -- Create the department table
-- CREATE TABLE department (
--     id SERIAL PRIMARY KEY,
--     name VARCHAR(30) UNIQUE NOT NULL
-- );

-- -- Create the role table
-- CREATE TABLE role (
--     id SERIAL PRIMARY KEY,
--     title VARCHAR(30) UNIQUE NOT NULL,
--     salary DECIMAL NOT NULL,
--     department_id INTEGER NOT NULL,
--     FOREIGN KEY (department_id) 
--     REFERENCES department(id) 
--     ON DELETE CASCADE  -- Deletes the role if the associated department is deleted
-- );

-- -- Create the employee table
-- CREATE TABLE employee (
--     id SERIAL PRIMARY KEY,
--     first_name VARCHAR(30) NOT NULL,
--     last_name VARCHAR(30) NOT NULL,
--     role_id INTEGER NOT NULL,
--     manager_id INTEGER,
--     FOREIGN KEY (role_id) 
--     REFERENCES role(id) 
--     ON DELETE SET NULL,  -- Sets role_id to NULL if the associated role is deleted
--     FOREIGN KEY (manager_id) 
--     REFERENCES employee(id) 
--     ON DELETE SET NULL  -- Sets manager_id to NULL if the associated manager is deleted
-- );


-- Connect to the database manually via your SQL client

-- Create the department table
CREATE TABLE IF NOT EXISTS department (
    id SERIAL PRIMARY KEY,
    name VARCHAR(30) UNIQUE NOT NULL
);

-- Create the role table
CREATE TABLE IF NOT EXISTS role (
    id SERIAL PRIMARY KEY,
    title VARCHAR(30) UNIQUE NOT NULL,
    salary DECIMAL NOT NULL,
    department_id INTEGER NOT NULL,
    FOREIGN KEY (department_id) 
    REFERENCES department(id) 
    ON DELETE CASCADE  -- Deletes the role if the associated department is deleted
);

-- Create the employee table
CREATE TABLE IF NOT EXISTS employee (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    role_id INTEGER NOT NULL,
    manager_id INTEGER,
    FOREIGN KEY (role_id) 
    REFERENCES role(id) 
    ON DELETE SET NULL,  -- Sets role_id to NULL if the associated role is deleted
    FOREIGN KEY (manager_id) 
    REFERENCES employee(id) 
    ON DELETE SET NULL  -- Sets manager_id to NULL if the associated manager is deleted
);
