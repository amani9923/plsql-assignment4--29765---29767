CREATE OR REPLACE FUNCTION get_dept_average_salary (
  p_dept_id IN departments.dept_id%TYPE
) RETURN NUMBER AS
  v_dept_name departments.dept_name%TYPE;
  v_avg       NUMBER;
BEGIN
  SELECT dept_name INTO v_dept_name FROM departments WHERE dept_id = p_dept_id;

  SELECT AVG(salary) INTO v_avg
    FROM employees
   WHERE dept_id = p_dept_id AND status = 'ACTIVE';

  IF v_avg IS NULL THEN
    RAISE_APPLICATION_ERROR(-20112, 'No active employees in department ' || v_dept_name);
  END IF;

  RETURN ROUND(v_avg, 2);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20111, 'Department not found: ' || p_dept_id);
  WHEN OTHERS THEN
    IF SQLCODE BETWEEN -20999 AND -20000 THEN RAISE; END IF;
    RAISE_APPLICATION_ERROR(-20999, 'get_dept_average_salary failed: ' || SQLERRM);
END get_dept_average_salary;
/