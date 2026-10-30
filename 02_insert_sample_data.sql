INSERT INTO departments VALUES (10, 'Information Technology', 'Kigali');
INSERT INTO departments VALUES (20, 'Finance',                 'Kigali');
INSERT INTO departments VALUES (30, 'Human Resources',         'Huye');
INSERT INTO departments VALUES (40, 'Marketing',               'Musanze');

INSERT INTO jobs VALUES ('DIR', 'Director',            3000000, 10000000);
INSERT INTO jobs VALUES ('MGR', 'Manager',             1500000,  3000000);
INSERT INTO jobs VALUES ('DEV', 'Software Developer',   600000,  1500000);
INSERT INTO jobs VALUES ('ACC', 'Accountant',           500000,  1200000);
INSERT INTO jobs VALUES ('HRO', 'HR Officer',           450000,  1000000);
INSERT INTO jobs VALUES ('SUP', 'Support Technician',   300000,   700000);

INSERT INTO employees (emp_id, first_name, last_name, email, hire_date, job_id, dept_id, manager_id, salary, status, termination_date) VALUES
 (1001, 'Eric', 'Habimana', 'eric.habimana@company.rw', DATE '2015-03-01', 'DIR', 10, NULL, 9000000, 'ACTIVE', NULL);
INSERT INTO employees (emp_id, first_name, last_name, email, hire_date, job_id, dept_id, manager_id, salary, status, termination_date) VALUES
 (1002, 'Aline', 'Uwase', 'aline.uwase@company.rw', DATE '2018-06-15', 'MGR', 10, 1001, 2500000, 'ACTIVE', NULL);
INSERT INTO employees (emp_id, first_name, last_name, email, hire_date, job_id, dept_id, manager_id, salary, status, termination_date) VALUES
 (1003, 'Jean', 'Niyonzima', 'jean.niyonzima@company.rw', DATE '2020-01-10', 'DEV', 10, 1002, 1200000, 'ACTIVE', NULL);
INSERT INTO employees (emp_id, first_name, last_name, email, hire_date, job_id, dept_id, manager_id, salary, status, termination_date) VALUES
 (1004, 'Grace', 'Mukamana', 'grace.mukamana@company.rw', DATE '2022-09-05', 'DEV', 10, 1002, 900000, 'ACTIVE', NULL);
INSERT INTO employees (emp_id, first_name, last_name, email, hire_date, job_id, dept_id, manager_id, salary, status, termination_date) VALUES
 (1005, 'Patrick', 'Uwase', 'patrick.uwase@company.rw', DATE '2023-02-20', 'SUP', 10, 1002, 450000, 'ACTIVE', NULL);
INSERT INTO employees (emp_id, first_name, last_name, email, hire_date, job_id, dept_id, manager_id, salary, status, termination_date) VALUES
 (1006, 'Clarisse', 'Ingabire', 'clarisse.ingabire@company.rw', DATE '2017-11-01', 'MGR', 20, 1001, 2200000, 'ACTIVE', NULL);
INSERT INTO employees (emp_id, first_name, last_name, email, hire_date, job_id, dept_id, manager_id, salary, status, termination_date) VALUES
 (1007, 'David', 'Nsengiyumva', 'david.nsengiyumva@company.rw', DATE '2019-04-12', 'ACC', 20, 1006, 800000, 'ACTIVE', NULL);
INSERT INTO employees (emp_id, first_name, last_name, email, hire_date, job_id, dept_id, manager_id, salary, status, termination_date) VALUES
 (1008, 'Sandra', 'Umutoni', 'sandra.umutoni@company.rw', DATE '2024-07-01', 'ACC', 20, 1006, 700000, 'ACTIVE', NULL);
INSERT INTO employees (emp_id, first_name, last_name, email, hire_date, job_id, dept_id, manager_id, salary, status, termination_date) VALUES
 (1009, 'Emmanuel', 'Kagabo', 'emmanuel.kagabo@company.rw', DATE '2016-08-22', 'MGR', 30, 1001, 2000000, 'ACTIVE', NULL);
INSERT INTO employees (emp_id, first_name, last_name, email, hire_date, job_id, dept_id, manager_id, salary, status, termination_date) VALUES
 (1010, 'Josiane', 'Mutesi', 'josiane.mutesi@company.rw', DATE '2021-05-17', 'HRO', 30, 1009, 650000, 'ACTIVE', NULL);
INSERT INTO employees (emp_id, first_name, last_name, email, hire_date, job_id, dept_id, manager_id, salary, status, termination_date) VALUES
 (1011, 'Olivier', 'Habiyaremye', 'olivier.habiyaremye@company.rw', DATE '2019-10-01', 'SUP', 10, 1002, 400000, 'INACTIVE', DATE '2024-01-15');

INSERT INTO salary_history (emp_id, old_salary, new_salary, change_date, reason)
SELECT emp_id, NULL, salary, hire_date, 'Initial salary' FROM employees;

COMMIT;