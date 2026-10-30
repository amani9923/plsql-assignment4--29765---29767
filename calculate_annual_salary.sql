CREATE OR REPLACE FUNCTION calculate_annual_bonus (
  p_emp_id IN employees.emp_id%TYPE
) RETURN NUMBER AS
  TYPE t_rate_tab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
  v_rates t_rate_tab;
  v_emp   employees%ROWTYPE;
  v_years PLS_INTEGER;
  v_key   PLS_INTEGER;
BEGIN
  v_rates(0)  := 0.02;
  v_rates(2)  := 0.05;
  v_rates(5)  := 0.08;
  v_rates(10) := 0.12;

  BEGIN
    SELECT * INTO v_emp FROM employees WHERE emp_id = p_emp_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20131, 'Employee not found: ' || p_emp_id);
  END;

  IF v_emp.status <> 'ACTIVE' THEN
    RAISE_APPLICATION_ERROR(-20132, 'Employee ' || p_emp_id || ' is INACTIVE; no bonus');
  END IF;

  v_years := FLOOR(MONTHS_BETWEEN(SYSDATE, v_emp.hire_date) / 12);

  v_key := v_rates.LAST;
  WHILE v_key > v_years LOOP
    v_key := v_rates.PRIOR(v_key);
  END LOOP;

  RETURN ROUND(v_emp.salary * 12 * v_rates(v_key), 2);
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE BETWEEN -20999 AND -20000 THEN RAISE; END IF;
    RAISE_APPLICATION_ERROR(-20999, 'calculate_annual_bonus failed: ' || SQLERRM);
END calculate_annual_bonus;
/