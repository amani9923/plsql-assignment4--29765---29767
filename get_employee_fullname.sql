CREATE OR REPLACE FUNCTION get_employee_full_name (
  p_emp_id IN employees.emp_id%TYPE
) RETURN VARCHAR2 AS
  v_emp employees%ROWTYPE;
BEGIN
  SELECT * INTO v_emp FROM employees WHERE emp_id = p_emp_id;
  RETURN v_emp.first_name || ' ' || v_emp.last_name;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20102, 'Employee not found: ' || p_emp_id);
  WHEN OTHERS THEN
    IF SQLCODE BETWEEN -20999 AND -20000 THEN RAISE; END IF;
    RAISE_APPLICATION_ERROR(-20999, 'get_employee_full_name failed: ' || SQLERRM);
END get_employee_full_name;
/