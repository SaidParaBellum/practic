CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(70),
    age int,
    position VARCHAR(100)
);

INSERT INTO employees (name, age, position) VALUES
('Said', 16, 'Director'),
('Kamron', 15, 'SMM'),
('Daniel', 22, 'Cleaner');

SELECT * FROM employees;

CREATE TABLE IF NOT EXISTS departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(70),
    location VARCHAR(100)
);

INSERT INTO departments (name, location) VALUES
('Asia', 'Nukus'),
('Invest', 'Pushkin');

ALTER TABLE employees 
ADD COLUMN department_id int;

ALTER TABLE employees
ADD CONSTRAINT fk_department FOREIGN KEY (department_id) REFERENCES departments(id);

SELECT employees.name, departments.name 
FROM employees 
JOIN departments ON employees.department_id = departments.id;

CREATE TABLE if not exists projects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(80)
);

CREATE TABLE if not exists employee_projects (
    employee_id int,
    project_id int,
    PRIMARY KEY (employee_id, project_id),
    FOREIGN KEY (employee_id) REFERENCES employees(id),
    FOREIGN KEY (project_id) REFERENCES projects(id)
);

INSERT INTO projects (name) VALUES
('Django'),
('CSS'),
('JS');

SELECT employees.name, projects.name
FROM employees
JOIN employee_projects ON employees.id = employee_projects.employee_id
JOIN projects ON employee_projects.project_id = projects.id;

SELECT AVG(age) FROM employees;


SELECT departments.name, COUNT(employees.id)
FROM departments
LEFT JOIN employees ON departments.id = employees.department_id
GROUP BY departments.name;

SELECT departments.name, COUNT(employees.id) AS employee_count
FROM departments
LEFT JOIN employees ON departments.id = employees.department_id
GROUP BY departments.name
ORDER BY employee_count DESC;

SELECT employees.name, projects.name
FROM employees
LEFT JOIN employee_projects ON employees.id = employee_projects.employee_id
LEFT JOIN projects ON employee_projects.project_id = projects.id;


SELECT employees.name, projects.name
FROM employees
LEFT JOIN employee_projects ON employees.id = employee_projects.employee_id
LEFT JOIN projects ON employee_projects.project_id = projects.id
UNION
SELECT employees.name, projects.name
FROM employees
RIGHT JOIN employee_projects ON employees.id = employee_projects.employee_id
RIGHT JOIN projects ON employee_projects.project_id = projects.id;

CREATE INDEX index_employee_name ON employees(name);

ALTER TABLE employees ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

CREATE OR REPLACE FUNCTION set_created_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.created_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_created_at_trigger
BEFORE INSERT ON employees
FOR EACH ROW
EXECUTE FUNCTION set_created_at();


ALTER TABLE employees ADD COLUMN last_updated TIMESTAMP;

CREATE OR REPLACE FUNCTION set_last_updated()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_last_updated_trigger
BEFORE UPDATE ON employees
FOR EACH ROW
EXECUTE FUNCTION set_last_updated();

