CREATE OR REPLACE PROCEDURE update_employee_salary (
  p_emp_id     IN employees.emp_id%TYPE,
  p_new_salary IN employees.salary%TYPE,
  p_reason     IN salary_history.reason%TYPE DEFAULT 'Salary adjustment'
) AS
  e_invalid_salary    EXCEPTION;
  e_inactive_employee EXCEPTION;
  v_emp employees%ROWTYPE;
  v_job jobs%ROWTYPE;
BEGIN
  SELECT * INTO v_emp FROM employees WHERE emp_id = p_emp_id;
  SELECT * INTO v_job FROM jobs WHERE job_id = v_emp.job_id;

  IF v_emp.status <> 'ACTIVE' THEN
    RAISE e_inactive_employee;
  END IF;
  IF p_new_salary < v_job.min_salary OR p_new_salary > v_job.max_salary THEN
    RAISE e_invalid_salary;
  END IF;

  UPDATE employees SET salary = p_new_salary WHERE emp_id = p_emp_id;

  IF SQL%FOUND THEN
    INSERT INTO salary_history (emp_id, old_salary, new_salary, reason)
    VALUES (p_emp_id, v_emp.salary, p_new_salary, p_reason);
    DBMS_OUTPUT.PUT_LINE('Salary of employee ' || p_emp_id || ' changed from ' ||
                         v_emp.salary || ' to ' || p_new_salary ||
                         ' (rows updated: ' || SQL%ROWCOUNT || ')');
  ELSIF SQL%NOTFOUND THEN
    RAISE_APPLICATION_ERROR(-20014, 'No row was updated for employee ' || p_emp_id);
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20011, 'Employee not found: ' || p_emp_id);
  WHEN e_inactive_employee THEN
    RAISE_APPLICATION_ERROR(-20013, 'Employee ' || p_emp_id || ' is INACTIVE; salary cannot be changed');
  WHEN e_invalid_salary THEN
    RAISE_APPLICATION_ERROR(-20012, 'Salary ' || p_new_salary || ' is outside the range ' ||
                            v_job.min_salary || ' - ' || v_job.max_salary ||
                            ' for job ' || v_job.job_id);
  WHEN OTHERS THEN
    IF SQLCODE BETWEEN -20999 AND -20000 THEN RAISE; END IF;
    RAISE_APPLICATION_ERROR(-20999, 'update_employee_salary failed: ' || SQLERRM);
END update_employee_salary;
/