SET SERVEROUTPUT ON;
--John login
exec emp_admin.login('John','123456');
--John buys two weeks membership
exec emp_admin.buy_membership('John',2,'VISA',true);

DECLARE
  amount       NUMBER;
  BEGIN
      amount := emp_admin.incomeAt(&year,&month);
  --Display the date
  DBMS_OUTPUT.PUT_LINE('Return from function incomeAt: $'||amount);
  END;

---test trigger
insert into attendance(id,atstart_time,atend_time,member_id) values (sysdate,null,1);