CREATE OR REPLACE PROCEDURE payroll_summary_all_depts (
  p_grand_total OUT NUMBER
) AS
  TYPE t_summary_rec IS RECORD (
    dept_name  departments.dept_name%TYPE,
    headcount  NUMBER,
    total_pay  NUMBER
  );
  v_row t_summary_rec;

  CURSOR c_dept IS
    SELECT d.dept_name,
           COUNT(e.emp_id)         AS headcount,
           NVL(SUM(e.salary), 0)   AS total_pay
      FROM departments d
      LEFT JOIN employees e ON e.dept_id = d.dept_id AND e.status = 'ACTIVE'
     GROUP BY d.dept_name
     ORDER BY total_pay DESC;
BEGIN
  p_grand_total := 0;
  DBMS_OUTPUT.PUT_LINE(RPAD('Department', 26) || RPAD('Headcount', 11) || 'Total payroll');

  FOR r IN c_dept LOOP
    v_row.dept_name := r.dept_name;
    v_row.headcount := r.headcount;
    v_row.total_pay := r.total_pay;
    p_grand_total   := p_grand_total + v_row.total_pay;
    DBMS_OUTPUT.PUT_LINE(RPAD(v_row.dept_name, 26) || RPAD(v_row.headcount, 11) ||
                         TO_CHAR(v_row.total_pay, 'FM999,999,999'));
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('Grand total: ' || TO_CHAR(p_grand_total, 'FM999,999,999'));
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20999, 'payroll_summary_all_depts failed: ' || SQLERRM);
END payroll_summary_all_depts;
/