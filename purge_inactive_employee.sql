CREATE OR REPLACE PROCEDURE purge_inactive_employees (
  p_months  IN  NUMBER DEFAULT 12,
  p_deleted OUT NUMBER
) AS
BEGIN
  IF p_months IS NULL OR p_months < 0 THEN
    RAISE_APPLICATION_ERROR(-20040, 'p_months must be zero or greater');
  END IF;

  DELETE FROM employees
   WHERE status = 'INACTIVE'
     AND termination_date < ADD_MONTHS(SYSDATE, -p_months);

  p_deleted := SQL%ROWCOUNT;

  IF SQL%NOTFOUND THEN
    DBMS_OUTPUT.PUT_LINE('Nothing to purge: no employee inactive for more than ' || p_months || ' months.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Purged ' || p_deleted || ' inactive employee(s).');
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE BETWEEN -20999 AND -20000 THEN RAISE; END IF;
    RAISE_APPLICATION_ERROR(-20999, 'purge_inactive_employees failed: ' || SQLERRM);
END purge_inactive_employees;
/