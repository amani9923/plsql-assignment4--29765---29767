CREATE OR REPLACE PROCEDURE print_department_report (
  p_dept_id IN departments.dept_id%TYPE
) AS
  TYPE t_emp_rec IS RECORD (
    emp_id     employees.emp_id%TYPE,
    full_name  VARCHAR2(101),
    job_title  jobs.job_title%TYPE,
    salary     employees.salary%TYPE,
    hire_date  employees.hire_date%TYPE
  );
  TYPE t_sal_tab IS TABLE OF employees.salary%TYPE INDEX BY PLS_INTEGER;

  CURSOR c_emp (cp_dept departments.dept_id%TYPE) IS
    SELECT e.emp_id, e.first_name || ' ' || e.last_name, j.job_title, e.salary, e.hire_date
      FROM employees e JOIN jobs j ON j.job_id = e.job_id
     WHERE e.dept_id = cp_dept AND e.status = 'ACTIVE'
     ORDER BY e.salary DESC;

  v_rec     t_emp_rec;
  v_dept    departments%ROWTYPE;
  v_sals    t_sal_tab;
  v_total   NUMBER := 0;
  v_max     NUMBER;
BEGIN
  SELECT * INTO v_dept FROM departments WHERE dept_id = p_dept_id;

  DBMS_OUTPUT.PUT_LINE('=== ' || v_dept.dept_name || ' (' || v_dept.location || ') ===');

  OPEN c_emp(p_dept_id);
  LOOP
    FETCH c_emp INTO v_rec;
    EXIT WHEN c_emp%NOTFOUND;
    v_sals(c_emp%ROWCOUNT) := v_rec.salary;
    DBMS_OUTPUT.PUT_LINE(RPAD(v_rec.emp_id, 6) || RPAD(v_rec.full_name, 24) ||
                         RPAD(v_rec.job_title, 22) || LPAD(TO_CHAR(v_rec.salary, 'FM99,999,999'), 10) ||
                         '  hired ' || TO_CHAR(v_rec.hire_date, 'YYYY-MM-DD'));
  END LOOP;
  CLOSE c_emp;

  IF v_sals.COUNT = 0 THEN
    RAISE_APPLICATION_ERROR(-20032, 'No active employees in department ' || v_dept.dept_name);
  END IF;

  FOR i IN 1 .. v_sals.COUNT LOOP
    v_total := v_total + v_sals(i);
  END LOOP;
  v_max := v_sals(1);

  DBMS_OUTPUT.PUT_LINE('Headcount: ' || v_sals.COUNT || ' | Total: ' || v_total ||
                       ' | Average: ' || ROUND(v_total / v_sals.COUNT, 2) || ' | Highest: ' || v_max);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    IF c_emp%ISOPEN THEN CLOSE c_emp; END IF;
    RAISE_APPLICATION_ERROR(-20031, 'Department not found: ' || p_dept_id);
  WHEN OTHERS THEN
    IF c_emp%ISOPEN THEN CLOSE c_emp; END IF;
    IF SQLCODE BETWEEN -20999 AND -20000 THEN RAISE; END IF;
    RAISE_APPLICATION_ERROR(-20999, 'print_department_report failed: ' || SQLERRM);
END print_department_report;
/