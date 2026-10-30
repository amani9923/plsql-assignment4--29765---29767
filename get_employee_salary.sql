CREATE OR REPLACE FUNCTION get_employee_salary (
  p_emp_id IN employees.emp_id%TYPE
) RETURN employees.salary%TYPE AS
  v_salary employees.salary%TYPE;
BEGIN
  SELECT salary INTO v_salary FROM employees WHERE emp_id = p_emp_id;
  RETURN v_salary;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20101, 'Employee not found: ' || p_emp_id);
  WHEN OTHERS THEN
    IF SQLCODE BETWEEN -20999 AND -20000 THEN RAISE; END IF;
    RAISE_APPLICATION_ERROR(-20999, 'get_employee_salary failed: ' || SQLERRM);
END get_employee_salary;
/