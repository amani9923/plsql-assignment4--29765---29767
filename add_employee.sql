CREATE OR REPLACE PROCEDURE add_employee (
  p_first_name IN  employees.first_name%TYPE,
  p_last_name  IN  employees.last_name%TYPE,
  p_email      IN  employees.email%TYPE,
  p_job_id     IN  employees.job_id%TYPE,
  p_dept_id    IN  employees.dept_id%TYPE,
  p_salary     IN  employees.salary%TYPE,
  p_manager_id IN  employees.manager_id%TYPE DEFAULT NULL,
  p_emp_id     OUT employees.emp_id%TYPE
) AS
  e_invalid_salary EXCEPTION;
  e_fk_violation   EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_fk_violation, -2291);
  v_job jobs%ROWTYPE;
BEGIN
  BEGIN
    SELECT * INTO v_job FROM jobs WHERE job_id = p_job_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20002, 'Invalid job id: ' || p_job_id);
  END;

  IF p_salary < v_job.min_salary OR p_salary > v_job.max_salary THEN
    RAISE e_invalid_salary;
  END IF;

  INSERT INTO employees (emp_id, first_name, last_name, email, hire_date,
                         job_id, dept_id, manager_id, salary, status)
  VALUES (emp_seq.NEXTVAL, p_first_name, p_last_name, p_email, SYSDATE,
          p_job_id, p_dept_id, p_manager_id, p_salary, 'ACTIVE')
  RETURNING emp_id INTO p_emp_id;

  IF SQL%ROWCOUNT = 1 THEN
    INSERT INTO salary_history (emp_id, old_salary, new_salary, reason)
    VALUES (p_emp_id, NULL, p_salary, 'Initial salary');
    DBMS_OUTPUT.PUT_LINE('Employee ' || p_emp_id || ' added (' ||
                         SQL%ROWCOUNT || ' history row logged).');
  END IF;
EXCEPTION
  WHEN e_invalid_salary THEN
    RAISE_APPLICATION_ERROR(-20003, 'Salary ' || p_salary || ' is outside the range ' ||
                            v_job.min_salary || ' - ' || v_job.max_salary ||
                            ' for job ' || p_job_id);
  WHEN DUP_VAL_ON_INDEX THEN
    RAISE_APPLICATION_ERROR(-20004, 'Email already exists: ' || p_email);
  WHEN e_fk_violation THEN
    RAISE_APPLICATION_ERROR(-20005, 'Department ' || p_dept_id ||
                            ' or manager ' || NVL(TO_CHAR(p_manager_id), 'n/a') || ' does not exist');
  WHEN OTHERS THEN
    IF SQLCODE BETWEEN -20999 AND -20000 THEN RAISE; END IF;
    RAISE_APPLICATION_ERROR(-20999, 'add_employee failed: ' || SQLERRM);
END add_employee;
/