import inquirer from 'inquirer';
import { pool, connectToDb } from './connection.js';

(async () => {
  try {
    // Establish the database connection
    await connectToDb();

    // Function to prompt user for selection
    const makeSelection = async () => {
      try {
        const answers = await inquirer.prompt([
          {
            type: 'list',
            name: 'action',
            message: 'What would you like to do?',
            choices: [
              'View All Employees',
              'Add Employee',
              'Update Employee Role',
              'View All Roles',
              'Add Role',
              'View All Departments',
              'Add Department',
              'Quit'
            ]
          }
        ]);

        switch (answers.action) {
          case 'View All Employees':
            await viewAllEmployees();
            break;
          case 'Add Employee':
            await addEmployee();
            break;
          case 'Update Employee Role':
            await updateEmployee();
            break;
          case 'View All Roles':
            await viewAllRoles();
            break;
          case 'Add Role':
            await addRole();
            break;
          case 'View All Departments':
            await viewAllDepartments();
            break;
          case 'Add Department':
            await addDepartment();
            break;
          case 'Quit':
            await pool.end(); 
            console.log("Database connection closed.");
            process.exit(0);
        }
      } catch (err:any) {
        console.error('Error processing selection:', err.message);
        makeSelection(); 
      }
    };

    // Function to view all employees
    const viewAllEmployees = async () => {
      try {
        const sql = `
          SELECT e.id, e.first_name, e.last_name, r.title, d.name AS department, r.salary, 
                 CONCAT(m.first_name, ' ', m.last_name) as manager
          FROM employee e
          JOIN role r ON e.role_id = r.id
          JOIN department d ON r.department_id = d.id
          LEFT JOIN employee m ON e.manager_id = m.id;
        `;
        console.log('hello');
        const result = await pool.query(sql);
        console.log(result);
        console.table(result.rows);
        makeSelection();
      } catch (err:any) {
        console.error('Error retrieving employees:', err.message);
        makeSelection();
      }
    };

    // Function to add a new employee
    const addEmployee = async () => {
      try {
        const roles = await pool.query('SELECT * FROM role;');
        const roleChoices = roles.rows.map(row => ({ name: row.title, value: row.id }));

        const employees = await pool.query('SELECT * FROM employee;');
        const managers = employees.rows.map(emp => ({
          name: `${emp.first_name} ${emp.last_name}`,
          value: emp.id
        }));
        managers.unshift({ name: 'None', value: null });

        const answers = await inquirer.prompt([
          {
            type: 'input',
            name: 'employeeFirstName',
            message: "What is the employee's first name?",
          },
          {
            type: 'input',
            name: 'employeeLastName',
            message: "What is the employee's last name?",
          },
          {
            type: 'list',
            name: 'employeeRole',
            message: "What is the employee's role?",
            choices: roleChoices
          },
          {
            type: 'list',
            name: 'employeeManager',
            message: "Who is the employee's manager?",
            choices: managers
          }
        ]);

        const sql = `INSERT INTO employee (first_name, last_name, role_id, manager_id) VALUES ($1, $2, $3, $4)`;
        await pool.query(sql, [answers.employeeFirstName, answers.employeeLastName, answers.employeeRole, answers.employeeManager]);
        console.log(`${answers.employeeFirstName} ${answers.employeeLastName} added to the database.`);
        makeSelection();
      } catch (err:any) {
        console.error('Error adding employee:', err.message);
        makeSelection();
      }
    };

    // Function to update an employee's role
    const updateEmployee = async () => {
      try {
        const employees = await pool.query('SELECT * FROM employee;');
        const employeeChoices = employees.rows.map(emp => ({
          name: `${emp.first_name} ${emp.last_name}`,
          value: emp.id
        }));

        const roles = await pool.query('SELECT * FROM role;');
        const roleChoices = roles.rows.map(row => ({ name: row.title, value: row.id }));

        const answers = await inquirer.prompt([
          {
            type: 'list',
            name: 'employeeSelect',
            message: "Which employee's role do you want to update?",
            choices: employeeChoices
          },
          {
            type: 'list',
            name: 'employeeRole',
            message: "Which role do you want to assign to the selected employee?",
            choices: roleChoices
          }
        ]);

        const sql = 'UPDATE employee SET role_id = $1 WHERE id = $2';
        await pool.query(sql, [answers.employeeRole, answers.employeeSelect]);
        console.log(`Updated employee's role.`);
        makeSelection();
      } catch (err:any) {
        console.error('Error updating employee role:', err.message);
        makeSelection();
      }
    };

    // Function to view all roles
    const viewAllRoles = async () => {
      try {
        const sql = 'SELECT r.id, r.title, d.name AS department, r.salary FROM role r JOIN department d ON d.id = r.department_id;';
        const result = await pool.query(sql);
        console.table(result.rows);
        makeSelection();
      } catch (err:any) {
        console.error('Error retrieving roles:', err.message);
        makeSelection();
      }
    };

    // Function to add a new role
    const addRole = async () => {
      try {
        const departments = await pool.query('SELECT * FROM department;');
        const departmentChoices = departments.rows.map(row => ({ name: row.name, value: row.id }));

        const answers = await inquirer.prompt([
          {
            type: 'input',
            name: 'roleTitle',
            message: 'What is the name of the role?',
          },
          {
            type: 'input',
            name: 'roleSalary',
            message: 'What is the salary for the role?',
            validate: value => !isNaN(value) ? true : 'Please enter a valid number'
          },
          {
            type: 'list',
            name: 'roleDepartment',
            message: 'Which department does this role belong to?',
            choices: departmentChoices
          }
        ]);

        const sql = 'INSERT INTO role (title, salary, department_id) VALUES ($1, $2, $3)';
        await pool.query(sql, [answers.roleTitle, answers.roleSalary, answers.roleDepartment]);
        console.log(`Added role ${answers.roleTitle} to the database.`);
        makeSelection();
      } catch (err:any) {
        console.error('Error adding role:', err.message);
        makeSelection();
      }
    };

    // Function to view all departments
    const viewAllDepartments = async () => {
      try {
        const sql = 'SELECT * FROM department;';
        const result = await pool.query(sql);
        console.table(result.rows);
        makeSelection();
      } catch (err:any) {
        console.error('Error retrieving departments:', err.message);
        makeSelection();
      }
    };

    // Function to add a new department
    const addDepartment = async () => {
      try {
        const answers = await inquirer.prompt([
          {
            type: 'input',
            name: 'departmentName',
            message: 'What is the name of the department?',
          }
        ]);

        const sql = 'INSERT INTO department (name) VALUES ($1)';
        await pool.query(sql, [answers.departmentName]);
        console.log(`Added department ${answers.departmentName} to the database.`);
        makeSelection();
      } catch (err:any) {
        console.error('Error adding department:', err.message);
        makeSelection();
      }
    };

    // Start the application
    makeSelection();

  } catch (err:any) {
    console.error('Error connecting to the database:', err.message);
    process.exit(1);
  }
})();
