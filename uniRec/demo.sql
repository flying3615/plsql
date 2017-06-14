--John login
exec emp_admin.login('John','123456');
--John buys two weeks membership
exec emp_admin.buy_membership('John',2,'VISA',true);
---test trigger
insert into attendance(atstart_time,atend_time,member_id) values (sysdate,null,1);
--test function incomeAt
SET SERVEROUTPUT ON;
DECLARE
  amount       NUMBER;
  BEGIN
      amount := emp_admin.incomeAt(&year,&month);
  --Display the date
  DBMS_OUTPUT.PUT_LINE('Return from function incomeAt: $'||amount);
  END;
/
