clear screen;
spool /Users/liuyufei/Desktop/income_package_spool.txt
SET SERVEROUTPUT ON;

/*

PDATE			  PTYPE      PAMOUNT MEMBERSHIP_ID
***************- *****-- ------- *****-----
10-APR-17 04.52.48 PM	  UPFRONT	 100		 1
03-APR-17 04.53.13 PM	  POST		   0		 2
04-APR-17 04.53.33 PM	  BYTIME	  15		 3
08-JUN-17 12.43.15 PM	  Visa		  20		 1
14-JUN-17 12.58.29 AM	  VISA		  15		 1
14-JUN-17 01.25.10 AM	  VISA		  15		 1
14-JUN-17 01.27.00 AM	  VISA		  15		 1
14-JUN-17 01.29.32 AM	  VISA		  15		 1
14-JUN-17 12.18.26 PM	  VISA		  15		 1
14-JUN-17 12.22.58 PM	  VISA		  15		 1
14-JUN-17 12.23.16 PM	  VISA		  15		 1

PDATE			  PTYPE      PAMOUNT MEMBERSHIP_ID
***************- *****-- ------- *****-----
14-JUN-17 12.29.06 PM	  VISA		  15		 1
*/


PROMPT formatting the display with COL command
COL pdate format A30
COL ptype format A15
COL pamount format 999
COL membership_id format 999

select pdate,ptype,pamount,membership_id from payment;


PROMPT *****PROCEDURE WHOLE YEAR SUMMARY START*****

exec emp_admin_incomes.incomeReportThisYear;

PROMPT *****PROCEDURE WHOLE YEAR SUMMARY END*****

PROMPT

PROMPT *****FUNCTION ONE MONTH REPORT START*****

DECLARE
    amount  NUMBER;
    year_in NUMBER;
    month_in NUMBER;
BEGIN
    year_in := &year;
    month_in := &month;
    DBMS_OUTPUT.PUT_LINE('Query incomes of '||month_in||'/'||year_in);    
    amount := emp_admin_incomes.incomeAt(year_in,month_in);
    DBMS_OUTPUT.PUT_LINE('Return from function incomeAt: $'||amount);
END;
/

PROMPT *****FUNCTION ONE MONTH REPORT END*****

spool off