CREATE OR REPLACE FUNCTION get_emp_id_by_last_name (
  p_last_name IN employees.last_name%TYPE
) RETURN employees.emp_id%TYPE AS
  v_emp_id employees.emp_id%TYPE;
BEGIN
  SELECT emp_id INTO v_emp_id
    FROM employees
   WHERE UPPER(last_name) = UPPER(p_last_name);
  RETURN v_emp_id;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20121, 'No employee with last name: ' || p_last_name);
  WHEN TOO_MANY_ROWS THEN
    RAISE_APPLICATION_ERROR(-20122, 'More than one employee has last name ' || p_last_name ||
                            '; search by employee id instead');
  WHEN OTHERS THEN
    IF SQLCODE BETWEEN -20999 AND -20000 THEN RAISE; END IF;
    RAISE_APPLICATION_ERROR(-20999, 'get_emp_id_by_last_name failed: ' || SQLERRM);
END get_emp_id_by_last_name;
/