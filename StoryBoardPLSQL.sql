SET SERVEROUTPUT ON;
CREATE OR REPLACE PACKAGE emp_admin
IS
    PROCEDURE login(
        usernameIn IN member.musername%TYPE,
        passwordIn IN member.mpassword%TYPE
        );

    FUNCTION incomeAt(
            year_in IN NUMBER,
            month_in IN NUMBER) RETURN NUMBER;

    PROCEDURE buy_membership(usernameIn IN member.musername%TYPE, weeks IN NUMBER, pay_type IN VARCHAR2, is_student BOOLEAN);

END;
/


CREATE OR REPLACE PACKAGE BODY emp_admin
IS

    ---LOGIN FUNCTION
    PROCEDURE login(
        usernameIn IN member.musername%TYPE,
        passwordIn IN member.mpassword%TYPE
        )
    IS
        userID member.ID%TYPE;
        username member.musername%TYPE;
        password member.mpassword%TYPE;
    BEGIN
        SELECT id,musername,mpassword 
        INTO userID,username,password 
        FROM member
        WHERE musername = usernameIn;
    
        IF passwordIn = password THEN
        SYS.DBMS_OUTPUT.PUT_LINE('Login Successfully');                
        ELSE
            SYS.DBMS_OUTPUT.PUT_LINE('Username: '||username||' Password mismatch');            
        END IF;
        
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        SYS.DBMS_OUTPUT.PUT_LINE('Username: '||usernameIn||' Cannot be fount');
    END login;


    -----INCOME IN THE GIVEN MONTH
    FUNCTION incomeAt(
            year_in IN NUMBER,
            month_in IN NUMBER) RETURN NUMBER
    IS
        income NUMBER;
        year_tmp NUMBER;
        month_tmp NUMBER;
        e_no_income_exception EXCEPTION;
    BEGIN
         --get current year by default
        year_tmp := EXTRACT(year FROM sysdate);
        IF year_in != NULL THEN
            year_tmp := year_in;
        END IF;
        -- get current month by default
        month_tmp := EXTRACT(month FROM sysdate);
        IF month_in != null THEN
            month_tmp := month_in;
        END IF;
        SYS.DBMS_OUTPUT.PUT_LINE('Find incomes in '||month_tmp||'/'||year_tmp);
        select sum(p.pamount) into income from payment p where extract(YEAR from p.pdate) = year_tmp AND extract(MONTH from p.pdate) = month_tmp;
        IF income IS NULL THEN
            RAISE e_no_income_exception;
        END IF;
        RETURN income;
        EXCEPTION
    WHEN e_no_income_exception THEN
        SYS.DBMS_OUTPUT.PUT_LINE('Cannot incomes in '||month_tmp||'/'||year_tmp);
    WHEN OTHERS THEN
        SYS.DBMS_OUTPUT.PUT_LINE('Encountered the following error');
        SYS.DBMS_OUTPUT.PUT_LINE(SQLERRM);
    END incomeAt;

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
                        DBMS_OUTPUT.PUT_LINE('less than 50, no discount...');
                        discount := 1;
                    ELSIF attendence_rate = 50 and attendence_rate < 60 THEN
                        DBMS_OUTPUT.PUT_LINE('less than 60, 10% discount...');
                        discount := 0.9;                    
                    ELSIF attendence_rate = 60 and attendence_rate < 70 THEN
                        DBMS_OUTPUT.PUT_LINE('less than 70, 20% discount...');
                        discount := 0.8;                    
                    ELSIF attendence_rate = 70 and attendence_rate < 80 THEN
                        DBMS_OUTPUT.PUT_LINE('less than 80, 30% discount...');
                        discount := 0.7;                    
                    ELSIF attendence_rate = 80 and attendence_rate < 90 THEN
                        DBMS_OUTPUT.PUT_LINE('less than 90, 40% discount...');
                        discount := 0.6;                    
                    ELSIF attendence_rate >= 90 THEN
                        DBMS_OUTPUT.PUT_LINE('greater than 90, 50% discount...');
                        discount := 0.5;                    
                    END IF;               
                END IF;

               
                DBMS_OUTPUT.PUT_LINE('calculate pay amount');
                IF is_student THEN
                    fee := 15*discount;
                ELSE 
                    fee := 20*discount;
                END IF;
                --insert membership table
                select member_ship_seq.nextval into ms_next_id from dual;
                --leave activate date as null, waiting for customer's first visit'
                insert into member_ship values (ms_next_id,SYSTIMESTAMP,weeks,fee,discount,member_id_tmp,null);
                --insert payment table
                select payment_seq.nextval into p_next_id from dual;
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
select msactivatedate into activatedate from member_ship where member_id = :NEW.member_id and msactivatedate is null;
--If null, update membership table's mactivatedate as the day they attendence' 
SYS.DBMS_OUTPUT.PUT_LINE('update users membership activated @'||sysdate);
update member_ship set msactivatedate=sysdate;
EXCEPTION
      WHEN NO_DATA_FOUND THEN
        SYS.DBMS_OUTPUT.PUT_LINE('users membership has been activated');
END;
/
SET SERVEROUTPUT OFF;