BEGIN
  FOR t IN (SELECT table_name FROM user_tables
            WHERE table_name IN ('SALARY_HISTORY','EMPLOYEES','JOBS','DEPARTMENTS','PERF_TEST')) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS PURGE';
  END LOOP;
  FOR s IN (SELECT sequence_name FROM user_sequences WHERE sequence_name = 'EMP_SEQ') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE ' || s.sequence_name;
  END LOOP;
END;
/

CREATE OR REPLACE TYPE emp_id_list AS TABLE OF NUMBER;
/

CREATE SEQUENCE emp_seq START WITH 2000 INCREMENT BY 1 NOCACHE;

CREATE TABLE departments (
  dept_id    NUMBER(4)    CONSTRAINT pk_departments PRIMARY KEY,
  dept_name  VARCHAR2(50) NOT NULL CONSTRAINT uq_dept_name UNIQUE,
  location   VARCHAR2(50)
);

CREATE TABLE jobs (
  job_id      VARCHAR2(10)  CONSTRAINT pk_jobs PRIMARY KEY,
  job_title   VARCHAR2(60)  NOT NULL,
  min_salary  NUMBER(12,2)  NOT NULL,
  max_salary  NUMBER(12,2)  NOT NULL,
  CONSTRAINT chk_job_salary_range CHECK (min_salary > 0 AND max_salary >= min_salary)
);

CREATE TABLE employees (
  emp_id            NUMBER(6)    CONSTRAINT pk_employees PRIMARY KEY,
  first_name        VARCHAR2(50) NOT NULL,
  last_name         VARCHAR2(50) NOT NULL,
  email             VARCHAR2(100) NOT NULL CONSTRAINT uq_emp_email UNIQUE,
  hire_date         DATE DEFAULT SYSDATE NOT NULL,
  job_id            VARCHAR2(10) NOT NULL CONSTRAINT fk_emp_job REFERENCES jobs(job_id),
  dept_id           NUMBER(4)    NOT NULL CONSTRAINT fk_emp_dept REFERENCES departments(dept_id),
  manager_id        NUMBER(6)    CONSTRAINT fk_emp_manager REFERENCES employees(emp_id) ON DELETE SET NULL,
  salary            NUMBER(12,2) NOT NULL
                    CONSTRAINT chk_emp_salary CHECK (salary > 0 AND salary <= 10000000),
  status            VARCHAR2(10) DEFAULT 'ACTIVE' NOT NULL
                    CONSTRAINT chk_emp_status CHECK (status IN ('ACTIVE','INACTIVE')),
  termination_date  DATE
);

CREATE TABLE salary_history (
  hist_id      NUMBER GENERATED ALWAYS AS IDENTITY CONSTRAINT pk_salary_history PRIMARY KEY,
  emp_id       NUMBER(6) NOT NULL CONSTRAINT fk_hist_emp REFERENCES employees(emp_id) ON DELETE CASCADE,
  old_salary   NUMBER(12,2),
  new_salary   NUMBER(12,2) NOT NULL,
  change_date  DATE DEFAULT SYSDATE NOT NULL,
  reason       VARCHAR2(100)
);

CREATE TABLE perf_test (
  id   NUMBER,
  val  VARCHAR2(50)
);

CREATE INDEX idx_emp_dept ON employees(dept_id);
CREATE INDEX idx_hist_emp ON salary_history(emp_id);