CREATE OR REPLACE PROCEDURE compare_bulk_vs_loop (
  p_rows    IN  PLS_INTEGER DEFAULT 20000,
  p_loop_ms OUT NUMBER,
  p_bulk_ms OUT NUMBER
) AS
  TYPE t_id_tab  IS TABLE OF perf_test.id%TYPE  INDEX BY PLS_INTEGER;
  TYPE t_val_tab IS TABLE OF perf_test.val%TYPE INDEX BY PLS_INTEGER;
  v_ids   t_id_tab;
  v_vals  t_val_tab;
  v_start PLS_INTEGER;
BEGIN
  IF p_rows IS NULL OR p_rows < 1 OR p_rows > 1000000 THEN
    RAISE_APPLICATION_ERROR(-20050, 'p_rows must be between 1 and 1,000,000');
  END IF;

  DELETE FROM perf_test;

  v_start := DBMS_UTILITY.GET_TIME;
  FOR i IN 1 .. p_rows LOOP
    INSERT INTO perf_test (id, val) VALUES (i, 'Row ' || i);
  END LOOP;
  p_loop_ms := (DBMS_UTILITY.GET_TIME - v_start) * 10;

  DELETE FROM perf_test;

  FOR i IN 1 .. p_rows LOOP
    v_ids(i)  := i;
    v_vals(i) := 'Row ' || i;
  END LOOP;

  v_start := DBMS_UTILITY.GET_TIME;
  FORALL i IN 1 .. p_rows
    INSERT INTO perf_test (id, val) VALUES (v_ids(i), v_vals(i));
  p_bulk_ms := (DBMS_UTILITY.GET_TIME - v_start) * 10;

  DELETE FROM perf_test;

  DBMS_OUTPUT.PUT_LINE('Rows: ' || p_rows || ' | row-by-row: ' || p_loop_ms ||
                       ' ms | FORALL: ' || p_bulk_ms || ' ms');
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE BETWEEN -20999 AND -20000 THEN RAISE; END IF;
    RAISE_APPLICATION_ERROR(-20999, 'compare_bulk_vs_loop failed: ' || SQLERRM);
END compare_bulk_vs_loop;
/