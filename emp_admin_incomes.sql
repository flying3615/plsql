/*

Incomes package.  
This package includes one function and one precedure,which are used for income statistic purpose.

1.function incomeAt, 
takes year and month two param to get the total incomes in that specific month of the year.
You can skip any param so that function will automatically replace the missing param by current year or month.

customized EXCEPTION e_no_income_exception

output:
Find incomes in 4/2017
the amount is 115

2.procedure incomeReportThisYear, 
no param needed, to calcualte in current year, what's the incomes of each month.
output:
<==============Income in JUNE     ================>
Find incomes in 6/2017
the amount is 140
$140
*/


SET SERVEROUTPUT ON;
CREATE OR REPLACE PACKAGE emp_admin_incomes
IS
    /**
     * @param year_in Number
     * @param month_in Number
     * @return Number
     */
    FUNCTION incomeAt(
            year_in IN NUMBER,
            month_in IN NUMBER) RETURN NUMBER;

    PROCEDURE incomeReportThisYear;

END;
/


CREATE OR REPLACE PACKAGE BODY emp_admin_incomes
IS
     
    FUNCTION incomeAt(
            year_in IN NUMBER,
            month_in IN NUMBER) RETURN NUMBER
    IS
        income NUMBER;
        year_tmp NUMBER;
        month_tmp NUMBER;
        e_no_income_exception EXCEPTION;
    BEGIN
        BEGIN
            --get current year by default
            year_tmp := EXTRACT(year FROM sysdate);
            IF year_in is not NULL THEN
                year_tmp := year_in;
            END IF;
            -- get current month by default
            month_tmp := EXTRACT(month FROM sysdate);
            IF month_in is not NULL THEN
                month_tmp := month_in;
            END IF;
            SYS.DBMS_OUTPUT.PUT_LINE('Find incomes in '||month_tmp||'/'||year_tmp);
            select sum(p.pamount) into income from payment p where extract(YEAR from p.pdate) = year_tmp AND extract(MONTH from p.pdate) = month_tmp;
            IF income IS NULL THEN
                RAISE e_no_income_exception;
            END IF;
            SYS.DBMS_OUTPUT.PUT_LINE('the amount is '||income);        
        EXCEPTION
        WHEN e_no_income_exception THEN
            SYS.DBMS_OUTPUT.PUT_LINE('Cannot incomes in '||month_tmp||'/'||year_tmp);
            income := 0;
        WHEN OTHERS THEN
            SYS.DBMS_OUTPUT.PUT_LINE('Encountered the following error');
            SYS.DBMS_OUTPUT.PUT_LINE(SQLERRM);
        END;
        RETURN income;
    END incomeAt;


    PROCEDURE incomeReportThisYear
    IS
        month_income NUMBER;
        monthStr VARCHAR2(15);
    BEGIN
        FOR mnth in 1 .. EXTRACT(month FROM sysdate) LOOP
            SELECT TO_CHAR(TO_DATE(mnth, 'MM'), 'MONTH') into monthStr FROM DUAL;

            SYS.DBMS_OUTPUT.PUT_LINE('<==============Income in '||monthStr||'================>');
            month_income := incomeAt(null,mnth);
            SYS.DBMS_OUTPUT.PUT_LINE('$'||month_income);
        END LOOP;
    END incomeReportThisYear;

END;
/


SET SERVEROUTPUT OFF;