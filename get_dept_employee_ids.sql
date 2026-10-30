CREATE OR REPLACE FUNCTION get_dept_employee_ids (
  p_dept_id IN departments.dept_id%TYPE
) RETURN emp_id_list AS
  v_ids       emp_id_list;
  v_dept_name departments.dept_name%TYPE;
BEGIN
  SELECT dept_name INTO v_dept_name FROM departments WHERE dept_id = p_dept_id;

  SELECT emp_id BULK COLLECT INTO v_ids
    FROM employees
   WHERE dept_id = p_dept_id AND status = 'ACTIVE'
   ORDER BY emp_id;

  RETURN v_ids;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20141, 'Department not found: ' || p_dept_id);
  WHEN OTHERS THEN
    IF SQLCODE BETWEEN -20999 AND -20000 THEN RAISE; END IF;
    RAISE_APPLICATION_ERROR(-20999, 'get_dept_employee_ids failed: ' || SQLERRM);
END get_dept_employee_ids;
/