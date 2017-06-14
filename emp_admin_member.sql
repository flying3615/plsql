SET SERVEROUTPUT ON;
CREATE OR REPLACE PACKAGE emp_admin_member
IS

    PROCEDURE buy_membership(usernameIn IN member.musername%TYPE, weeks IN NUMBER, pay_type IN VARCHAR2, is_student BOOLEAN);

    PROCEDURE booking_facilities_available(facility_name IN facilities.fname%TYPE, bookTime IN member_booking.mbtime%TYPE, duration IN NUMBER, usernameIn IN member.musername%TYPE);

END;
/


CREATE OR REPLACE PACKAGE BODY emp_admin_member
IS
    FUNCTION checkBookable(hasBookedStartTime IN VARCHAR2,hasBookedEndTime IN VARCHAR2,toBeBookedStartTime IN VARCHAR2,tobeBookedEndTime IN VARCHAR2) 
    RETURN BOOLEAN
    IS
    BEGIN
        --(3 kinds of conditions which cannot allow to book)    
        IF toBeBookedStartTime > hasBookedStartTime AND toBeBookedStartTime < hasBookedEndTime THEN
            --1. to-be-booked begintime is in the range of exsiting booking time span            
            RETURN false;
        ELSIF tobeBookedEndTime > hasBookedStartTime AND tobeBookedEndTime < hasBookedEndTime THEN
            --2. to-be-booked endtime is in the range of exsiting booking time span
            RETURN false;
        ELSIF toBeBookedStartTime <= hasBookedStartTime AND tobeBookedEndTime >= hasBookedEndTime THEN
            --3. (to-be-booked begintime is eariler than or equals to exsiting begintime) && (to-be-booked endtime is later than or equals to exsiting endtime)
            RETURN false;
        ELSE
            RETURN true;
        END IF;
    END checkBookable;



    ---payment membership renew
    PROCEDURE buy_membership(usernameIn IN member.musername%TYPE, weeks IN NUMBER, pay_type IN VARCHAR2, is_student BOOLEAN)
    IS
        member_id_tmp NUMBER;
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
                --leave activate date as null, waiting for customer's first visit'
                DBMS_OUTPUT.PUT_LINE('insert member_ship values '||','||SYSTIMESTAMP||','||weeks||','||fee||','||discount||','||member_id_tmp );
                insert into member_ship values (member_ship_seq.nextval,SYSTIMESTAMP,weeks,fee,discount,member_id_tmp,null);

                --insert payment table
                DBMS_OUTPUT.PUT_LINE('insert payment values '||','||SYSTIMESTAMP||','||pay_type||','||fee||','||member_id_tmp);                
                insert into payment values (payment_seq.nextval,SYSTIMESTAMP,pay_type,fee,member_id_tmp);
                CLOSE c_activate;
                CLOSE c_id;
        END IF;
        -- after payment, freeze the membership until first attendent record inserted
    END buy_membership;

    --book facility for a memebr
    PROCEDURE booking_facilities_available(facility_name IN facilities.fname%TYPE, bookTime IN member_booking.mbtime%TYPE, duration IN NUMBER, usernameIn IN member.musername%TYPE)
    IS
        membership_expired_date DATE;
        hasBookedStartTime VARCHAR2(20);
        hasBookedEndTime VARCHAR2(20);
        toBeBookedStartTime VARCHAR2(20);
        tobeBookedEndTime VARCHAR2(20);
        f_id facilities.id%TYPE;
        m_id member.id%TYPE;
        CURSOR c_fac_booked_time IS
            select to_char(mb.mbtime,'DD-MON-YYYY HH24:MI') as startTime,to_char((mb.mbtime+mb.DURATION*1/(24*60)),'DD-MON-YYYY HH24:MI') as endtime 
            from facilities f, member_booking mb 
            where f.id=mb.facility_id and f.FNAME=facility_name;
    BEGIN
        select id into f_id from facilities where fname=facility_name;
        select id into m_id from member where musername=usernameIn;

        select future into membership_expired_date 
        from (select ms.MSDATE+7*ms.MSDURATION as future, ms.MSDURATION from member_ship ms, member mm where ms.member_id=mm.id and mm.musername=usernameIn order by future desc) 
        where rownum = 1;
        --check username if is a memebr or mebership is outdated at the future booking time        
        IF membership_expired_date < bookTime THEN
            DBMS_OUTPUT.PUT_LINE('Membership of '||usernameIn||' will be expried before '||bookTime||', cannot book anything');
            RETURN;
        END IF;

        toBeBookedStartTime := to_char(bookTime,'DD-MON-YYYY HH24:MI');
        tobeBookedEndTime := to_char((bookTime+duration*1/(24*60)),'DD-MON-YYYY HH24:MI');

        OPEN c_fac_booked_time;        
        LOOP
        FETCH c_fac_booked_time into hasBookedStartTime,hasBookedEndTime;
            EXIT WHEN c_fac_booked_time%NOTFOUND;
            --check the facility he'd like to book if is available at his booking time
            IF NOT checkBookable(hasBookedStartTime,hasBookedEndTime,toBeBookedStartTime,tobeBookedEndTime) THEN
                --if there is an exsiting engaged, book failed and return
                DBMS_OUTPUT.PUT_LINE('facility_name is not avaliable during  '||toBeBookedStartTime||' to '||tobeBookedEndTime);   
                RETURN;             
            END IF;
        END LOOP;
        CLOSE c_fac_booked_time;
          --if so, insert booking table
        DBMS_OUTPUT.PUT_LINE(usernameIn||' book '||facility_name||' successfully during '||toBeBookedStartTime||' to '||tobeBookedEndTime);
        insert into member_booking values(member_booking_seq.nextval,bookTime,usernameIn,m_id,f_id,null,duration);
  
    END booking_facilities_available;

    
END;
/

SET SERVEROUTPUT OFF;



