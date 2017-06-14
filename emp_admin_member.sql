SET SERVEROUTPUT ON;
CREATE OR REPLACE PACKAGE emp_admin_member
IS

    PROCEDURE buy_membership(usernameIn IN member.musername%TYPE, weeks IN NUMBER, pay_type IN VARCHAR2, is_student BOOLEAN);

END;
/


CREATE OR REPLACE PACKAGE BODY emp_admin_member
IS
    ---payment membership renew
    PROCEDURE buy_membership(usernameIn IN member.musername%TYPE, weeks IN NUMBER, pay_type IN VARCHAR2, is_student BOOLEAN)
    IS
    member_id_tmp NUMBER;
    ms_next_id NUMBER;
    p_next_id NUMBER;
    days_between NUMBER;
    att_times NUMBER;
    attendence_rate NUMBER;
    discount NUMBER;
    activatedate DATE;
    fee NUMBER;
    CURSOR c_id IS
        SELECT id
        FROM member
        WHERE musername=usernameIn;

    CURSOR c_activate IS
        SELECT msactivatedate 
        FROM member_ship ms,member m
        WHERE ms.member_id=m.id and m.musername=usernameIn;
    BEGIN
        OPEN c_id;
        FETCH c_id INTO member_id_tmp;
        IF c_id%NOTFOUND THEN
            DBMS_OUTPUT.PUT_LINE('User with name '||usernameIn||' not found!');
        ELSIF c_id%FOUND THEN
                --check if its a new user
                OPEN c_activate;
                FETCH c_activate INTO activatedate;
                IF c_activate%NOTFOUND THEN
                     DBMS_OUTPUT.PUT_LINE('New USER, No discount');
                ELSE
                    --check if there is an exsiting membership which hasn't been activated
                    DBMS_OUTPUT.PUT_LINE('OLD activatedate'||activatedate);   
                    IF activatedate IS NULL THEN
                        DBMS_OUTPUT.PUT_LINE('OLD USER,but there is an exsiting membership which hasnt been activated for user '||usernameIn);
                        RETURN;
                    END IF;
                    DBMS_OUTPUT.PUT_LINE('OLD USER');     
                    --get overall attendence
                    select count(*) into att_times
                    from attendance att,member_ship ms 
                    where att.atend_time > ms.MSDATE and ms.member_id=att.member_id and ms.member_id=member_id_tmp group by att.member_id;
                    --get the all days since start membership
                    select sum(msduration)*7 into days_between from member_ship where member_id=member_id_tmp;
                    --check the attendence
                    attendence_rate := 100*att_times/days_between;
                    IF attendence_rate < 50 THEN
                        DBMS_OUTPUT.PUT_LINE('attendence_rate less than 50, no discount...');
                        discount := 1;
                    ELSIF attendence_rate = 50 and attendence_rate < 60 THEN
                        DBMS_OUTPUT.PUT_LINE('attendence_rate less than 60, 10% discount...');
                        discount := 0.9;                    
                    ELSIF attendence_rate = 60 and attendence_rate < 70 THEN
                        DBMS_OUTPUT.PUT_LINE('attendence_rate less than 70, 20% discount...');
                        discount := 0.8;                    
                    ELSIF attendence_rate = 70 and attendence_rate < 80 THEN
                        DBMS_OUTPUT.PUT_LINE('attendence_rate less than 80, 30% discount...');
                        discount := 0.7;                    
                    ELSIF attendence_rate = 80 and attendence_rate < 90 THEN
                        DBMS_OUTPUT.PUT_LINE('attendence_rate less than 90, 40% discount...');
                        discount := 0.6;                    
                    ELSIF attendence_rate >= 90 THEN
                        DBMS_OUTPUT.PUT_LINE('attendence_rate greater than 90, 50% discount...');
                        discount := 0.5;                    
                    END IF;               
                END IF;


                IF is_student THEN
                    fee := 15*discount;
                ELSE 
                    fee := 20*discount;
                END IF;

                DBMS_OUTPUT.PUT_LINE('calculate pay amount='||fee);
                --insert membership table
                select member_ship_seq.nextval into ms_next_id from dual;
                --leave activate date as null, waiting for customer's first visit'
                DBMS_OUTPUT.PUT_LINE('insert member_ship values '||ms_next_id||','||SYSTIMESTAMP||','||weeks||','||fee||','||discount||','||member_id_tmp );

                insert into member_ship values (ms_next_id,SYSTIMESTAMP,weeks,fee,discount,member_id_tmp,null);
                --insert payment table
                select payment_seq.nextval into p_next_id from dual;
                DBMS_OUTPUT.PUT_LINE('insert payment values '||p_next_id||','||SYSTIMESTAMP||','||pay_type||','||fee||','||member_id_tmp);                
                insert into payment values (p_next_id,SYSTIMESTAMP,pay_type,fee,member_id_tmp);
        END IF;
        -- after payment, freeze the membership until first attendent record inserted
    END buy_membership;
END;
/


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
SET SERVEROUTPUT OFF;



