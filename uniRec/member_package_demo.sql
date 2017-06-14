SET SERVEROUTPUT ON;

--clean up
delete from member_booking where last_name='John';
commit;
prompt  ---------Booking Demo start----------

prompt  ##first John book A205@05-APR-2017 16:30

exec emp_admin_member.booking_facilities_available('A205','05-APR-2017 16:30',20,'John');

prompt  ##second Amy booking A205@05-APR-2017 16:40 will be failed, since the engagement

exec emp_admin_member.booking_facilities_available('A205','05-APR-2017 16:40',20,'Amy');

prompt  ---------Booking Demo end----------


prompt  ---------Buy MemberShip start----------

--clean up
delete from member_ship where member_id=1;
commit;
prompt  John buy membership first time succeed 

exec emp_admin_member.buy_membership('John',2,'VISA',true);
prompt  John buy membership second time failed 

exec emp_admin_member.buy_membership('John',2,'VISA',true);

prompt  ---------Buy MemberShip end----------

prompt ---test trigger---
insert into attendance(atstart_time,atend_time,member_id) 
values (TO_TIMESTAMP('05-APR-2017 16:30','DD-MON-YYYY HH24:MI'),TO_TIMESTAMP('05-APR-2017 17:30','DD-MON-YYYY HH24:MI'),1);