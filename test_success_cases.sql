SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200

PROMPT === TEST 1: add_employee (INSERT, SQL%ROWCOUNT) ===
DECLARE
  v_id employees.emp_id%TYPE;
BEGIN
  add_employee('Alice', 'Mugisha', 'alice.mugisha@company.rw', 'DEV', 10, 1000000, 1002, v_id);
  DBMS_OUTPUT.PUT_LINE('New employee id: ' || v_id);
END;
/

PROMPT === TEST 2: update_employee_salary (UPDATE, SQL%FOUND) ===
BEGIN
  update_employee_salary(1004, 1000000, 'Annual review');
END;
/
SELECT emp_id, old_salary, new_salary, reason FROM salary_history WHERE emp_id = 1004 ORDER BY hist_id;

PROMPT === TEST 3: deactivate_employee ===
DECLARE
  v_rows NUMBER;
BEGIN
  deactivate_employee(1005, SYSDATE, v_rows);
END;
/

PROMPT === TEST 4: raise_dept_salaries_bulk - BULK COLLECT + FORALL (Finance, 5%) ===
DECLARE
  v_ok NUMBER; v_fail NUMBER;
BEGIN
  raise_dept_salaries_bulk(20, 5, v_ok, v_fail);
  DBMS_OUTPUT.PUT_LINE('updated=' || v_ok || ' failed=' || v_fail);
END;
/

PROMPT === TEST 5: print_department_report - explicit cursor OPEN/FETCH/CLOSE ===
BEGIN
  print_department_report(10);
END;
/

PROMPT === TEST 6: payroll_summary_all_depts - cursor FOR loop ===
DECLARE
  v_total NUMBER;
BEGIN
  payroll_summary_all_depts(v_total);
END;
/

PROMPT === TEST 7: purge_inactive_employees - DELETE with SQL%ROWCOUNT ===
DECLARE
  v_del NUMBER;
BEGIN
  purge_inactive_employees(12, v_del);
  DBMS_OUTPUT.PUT_LINE('deleted=' || v_del);
END;
/
SELECT emp_id, status FROM employees WHERE emp_id IN (1005, 1011);

PROMPT === TEST 8: compare_bulk_vs_loop (row-by-row vs FORALL) ===
DECLARE
  v_loop NUMBER; v_bulk NUMBER;
BEGIN
  compare_bulk_vs_loop(50000, v_loop, v_bulk);
END;
/

PROMPT === TEST 9: functions called from an anonymous block ===
DECLARE
  v_ids emp_id_list;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Salary of 1003      : ' || get_employee_salary(1003));
  DBMS_OUTPUT.PUT_LINE('Name of 1003        : ' || get_employee_full_name(1003));
  DBMS_OUTPUT.PUT_LINE('Avg salary dept 10  : ' || get_dept_average_salary(10));
  DBMS_OUTPUT.PUT_LINE('Id of Niyonzima     : ' || get_emp_id_by_last_name('Niyonzima'));
  DBMS_OUTPUT.PUT_LINE('Bonus of 1003       : ' || calculate_annual_bonus(1003));
  v_ids := get_dept_employee_ids(20);
  FOR i IN 1 .. v_ids.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE('Dept 20 employee id : ' || v_ids(i));
  END LOOP;
END;
/

PROMPT === TEST 10: functions called from SQL ===
SELECT emp_id, get_employee_full_name(emp_id) AS full_name,
       get_employee_salary(emp_id)            AS salary,
       calculate_annual_bonus(emp_id)         AS annual_bonus
  FROM employees
 WHERE dept_id = 20 AND status = 'ACTIVE'
 ORDER BY emp_id;

SELECT column_value AS emp_id, get_employee_full_name(column_value) AS full_name
  FROM TABLE(get_dept_employee_ids(10));

ROLLBACK;