SET SERVEROUTPUT ON;

prompt ---------generate financial report start--------

exec emp_admin_incomes.incomeReportThisYear;

prompt ---------generate financial report end--------


DECLARE
    amount  NUMBER;
BEGIN
    amount := emp_admin.incomeAt(&year,&month);
    DBMS_OUTPUT.PUT_LINE('Return from function incomeAt: $'||amount);
END;