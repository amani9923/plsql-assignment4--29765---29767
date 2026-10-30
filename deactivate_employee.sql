CREATE OR REPLACE PROCEDURE deactivate_employee (
  p_emp_id        IN  employees.emp_id%TYPE,
  p_term_date     IN  DATE DEFAULT SYSDATE,
  p_rows_updated  OUT NUMBER
) AS
  v_status employees.status%TYPE;
BEGIN
  SELECT status INTO v_status FROM employees WHERE emp_id = p_emp_id;

  IF v_status = 'INACTIVE' THEN
    RAISE_APPLICATION_ERROR(-20036, 'Employee ' || p_emp_id || ' is already INACTIVE');
  END IF;

  UPDATE employees
     SET status = 'INACTIVE', termination_date = p_term_date
   WHERE emp_id = p_emp_id;

  p_rows_updated := SQL%ROWCOUNT;
  DBMS_OUTPUT.PUT_LINE('Employee ' || p_emp_id || ' deactivated. Rows updated: ' || p_rows_updated);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20035, 'Employee not found: ' || p_emp_id);
  WHEN OTHERS THEN
    IF SQLCODE BETWEEN -20999 AND -20000 THEN RAISE; END IF;
    RAISE_APPLICATION_ERROR(-20999, 'deactivate_employee failed: ' || SQLERRM);
END deactivate_employee;
/