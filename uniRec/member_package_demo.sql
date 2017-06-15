clear screen;
spool /Users/liuyufei/Desktop/member_package_spool.txt
SET SERVEROUTPUT ON;

--clean up
delete from member_booking where last_name='John';
commit;


PROMPT formatting the display with COL command
COL MSDATE format A30
COL mbtime format A30
COL MSDURATION format A5
COL MSDISCOUNT format 999
COL duration format 999
COL MSACTIVATEDATE format A15
COL MUSERNAME format A10

--clean up
DECLARE
    ms_id  NUMBER;
BEGIN
    select id into ms_id from member_ship where member_id=1;
    delete from payment where membership_id = ms_id;
    delete from member_ship where member_id=1;
    commit;
    DBMS_OUTPUT.PUT_LINE('After cleanup');
END;
/

PROMPT  ***** NEW/RENEW MEMBERSHIP FOR John START *****

select MSDATE,MSDURATION,MSDISCOUNT,MSACTIVATEDATE,MUSERNAME from member_ship ms,member m where ms.MEMBER_ID=m.id order by msdate desc;
PROMPT  John buy membership first time succeed 

exec emp_admin_member.buy_membership('John',2,'VISA',true);

select MSDATE,MSDURATION,MSDISCOUNT,MSACTIVATEDATE,MUSERNAME from member_ship ms,member m where ms.MEMBER_ID=m.id order by msdate desc;

PROMPT  John buy membership second time failed 

exec emp_admin_member.buy_membership('John',2,'VISA',true);

PROMPT  ***** NEW/RENEW MEMBERSHIP FOR John END *****
PROMPT
PROMPT ***** SIMULATE THE FIRST TIME MEMBER VISIT GYM @05-APR-2017 16:30 AFTER PRUCHASE TO ACTIVATE MEMBERSHIP *****
insert into attendance(atstart_time,atend_time,member_id) 
values (TO_TIMESTAMP('05-APR-2017 16:30','DD-MON-YYYY HH24:MI'),TO_TIMESTAMP('05-APR-2017 17:30','DD-MON-YYYY HH24:MI'),1);

select MSDATE,MSDURATION,MSDISCOUNT,MSACTIVATEDATE,MUSERNAME from member_ship ms,member m where ms.MEMBER_ID=m.id order by msdate desc;


PROMPT  ***** Booking Demo start *****

delete from member_booking where member_id in (1,2);

PROMPT  ##First John book A205@05-APR-2017 16:30

exec emp_admin_member.booking_facilities_available('A205','05-APR-2017 16:30',20,'John');

PROMPT  ##Second Amy booking A205@05-APR-2017 16:40 will be failed, since the engagement

exec emp_admin_member.booking_facilities_available('A205','05-APR-2017 16:40',20,'Amy');

select mbtime,musername,duration from member_booking mb,member m where mb.member_id=m.id and facility_id is not null;

PROMPT  *****Booking Demo end*****

spool off
