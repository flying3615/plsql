--- A trigger for activate membership when first attendence
CREATE or REPLACE TRIGGER activate_membership
AFTER 
INSERT ON attendance FOR EACH ROW
DECLARE
activatedate DATE;
Begin 
--If null, update membership table's mactivatedate as the day they attendence' 
SYS.DBMS_OUTPUT.PUT_LINE('update users membership activated @'||sysdate);
update member_ship set msactivatedate=sysdate where member_id = :NEW.member_id and msactivatedate is null;
EXCEPTION
      WHEN NO_DATA_FOUND THEN
        SYS.DBMS_OUTPUT.PUT_LINE('users membership has been activated');
END;
/