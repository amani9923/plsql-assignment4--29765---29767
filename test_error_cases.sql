SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200

PROMPT === E1: add_employee - invalid job (-20002) ===
DECLARE v_id NUMBER; BEGIN
  add_employee('X','Y','x1@company.rw','NOPE',10,500000,NULL,v_id);
  DBMS_OUTPUT.PUT_LINE('UNEXPECTED: no error raised');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Caught: ' || SQLERRM); END;
/

PROMPT === E2: add_employee - salary out of range (-20003) ===
DECLARE v_id NUMBER; BEGIN
  add_employee('X','Y','x2@company.rw','SUP',10,5000000,NULL,v_id);
  DBMS_OUTPUT.PUT_LINE('UNEXPECTED: no error raised');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Caught: ' || SQLERRM); END;
/

PROMPT === E3: add_employee - duplicate email (-20004) ===
DECLARE v_id NUMBER; BEGIN
  add_employee('X','Y','eric.habimana@company.rw','SUP',10,500000,NULL,v_id);
  DBMS_OUTPUT.PUT_LINE('UNEXPECTED: no error raised');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Caught: ' || SQLERRM); END;
/

PROMPT === E4: add_employee - department does not exist (-20005) ===
DECLARE v_id NUMBER; BEGIN
  add_employee('X','Y','x4@company.rw','SUP',99,500000,NULL,v_id);
  DBMS_OUTPUT.PUT_LINE('UNEXPECTED: no error raised');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Caught: ' || SQLERRM); END;
/

PROMPT === E5: update_employee_salary - employee not found (-20011) ===
BEGIN
  update_employee_salary(99999, 500000);
  DBMS_OUTPUT.PUT_LINE('UNEXPECTED: no error raised');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Caught: ' || SQLERRM); END;
/

PROMPT === E6: update_employee_salary - salary out of range (-20012) ===
BEGIN
  update_employee_salary(1003, 9000000);
  DBMS_OUTPUT.PUT_LINE('UNEXPECTED: no error raised');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Caught: ' || SQLERRM); END;
/

PROMPT === E7: update_employee_salary - inactive employee (-20013) ===
BEGIN
  update_employee_salary(1011, 400000);
  DBMS_OUTPUT.PUT_LINE('UNEXPECTED: no error raised');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Caught: ' || SQLERRM); END;
/

PROMPT === E8: deactivate_employee - not found (-20035), already inactive (-20036) ===
DECLARE v_rows NUMBER; BEGIN
  BEGIN
    deactivate_employee(99999, SYSDATE, v_rows);
  EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Caught: ' || SQLERRM); END;
  BEGIN
    deactivate_employee(1011, SYSDATE, v_rows);
  EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Caught: ' || SQLERRM); END;
END;
/

PROMPT === E9: raise_dept_salaries_bulk - -20020, -20021, -20022 ===
DECLARE v_ok NUMBER; v_fail NUMBER; BEGIN
  BEGIN raise_dept_salaries_bulk(10, 80, v_ok, v_fail);
  EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Caught: ' || SQLERRM); END;
  BEGIN raise_dept_salaries_bulk(40, 5, v_ok, v_fail);
  EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Caught: ' || SQLERRM); END;
  BEGIN raise_dept_salaries_bulk(99, 5, v_ok, v_fail);
  EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Caught: ' || SQLERRM); END;
END;
/

PROMPT === E10: raise_dept_salaries_bulk - FORALL SAVE EXCEPTIONS (IT, 50%) ===
DECLARE v_ok NUMBER; v_fail NUMBER; BEGIN
  raise_dept_salaries_bulk(10, 50, v_ok, v_fail);
  DBMS_OUTPUT.PUT_LINE('updated=' || v_ok || ' failed=' || v_fail);
END;
/
SELECT emp_id, salary FROM employees WHERE dept_id = 10 AND status = 'ACTIVE' ORDER BY emp_id;
ROLLBACK;

PROMPT === E11: print_department_report - -20031 and -20032 ===
BEGIN
  BEGIN print_department_report(99);
  EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Caught: ' || SQLERRM); END;
  BEGIN print_department_report(40);
  EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Caught: ' || SQLERRM); END;
END;
/

PROMPT === E12: purge_inactive_employees - invalid months (-20040) ===
DECLARE v_del NUMBER; BEGIN
  purge_inactive_employees(-5, v_del);
  DBMS_OUTPUT.PUT_LINE('UNEXPECTED: no error raised');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Caught: ' || SQLERRM); END;
/

PROMPT === E13: compare_bulk_vs_loop - invalid row count (-20050) ===
DECLARE v_l NUMBER; v_b NUMBER; BEGIN
  compare_bulk_vs_loop(0, v_l, v_b);
  DBMS_OUTPUT.PUT_LINE('UNEXPECTED: no error raised');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Caught: ' || SQLERRM); END;
/

PROMPT === E14: functions - NO_DATA_FOUND, TOO_MANY_ROWS and other errors ===
DECLARE
  v_n NUMBER; v_s VARCHAR2(200); v_ids emp_id_list;
BEGIN
  BEGIN v_n := get_employee_salary(99999);
  EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Caught: ' || SQLERRM); END;

  BEGIN v_s := get_employee_full_name(99999);
  EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Caught: ' || SQLERRM); END;

  BEGIN v_n := get_dept_average_salary(40);
  EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Caught: ' || SQLERRM); END;

  BEGIN v_n := get_dept_average_salary(99);
  EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Caught: ' || SQLERRM); END;

  BEGIN v_n := get_emp_id_by_last_name('Nobody');
  EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Caught: ' || SQLERRM); END;

  BEGIN v_n := get_emp_id_by_last_name('Uwase');
  EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Caught: ' || SQLERRM); END;

  BEGIN v_n := calculate_annual_bonus(99999);
  EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Caught: ' || SQLERRM); END;

  BEGIN v_n := calculate_annual_bonus(1011);
  EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Caught: ' || SQLERRM); END;

  BEGIN v_ids := get_dept_employee_ids(99);
  EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Caught: ' || SQLERRM); END;
END;
/ 