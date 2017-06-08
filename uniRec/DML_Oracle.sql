
spool '/Users/liuyufei/Desktop/advancedDB/uniRec/uniRec-DMLspool.txt'

PROMPT Inserting Data into article_group table
INSERT INTO article_group (id, agname)
	 VALUES (1,'Ad');
INSERT INTO article_group (id, agname)
	 VALUES (2,'Notification');

PROMPT Inserting Data into article table
INSERT INTO article (id, atitle, acontent, group_id)
	 VALUES (1,'Nutrition','Eat apples everyday',1);
INSERT INTO article (id, atitle, acontent, group_id)
	 VALUES (2,'Pay attention to your health','Something you need to know about your body',2);


PROMPT Inserting Data into facilities table
INSERT INTO facilities (id, fname, fmaxtime, fdescription)
	 VALUES (1,'A205',60,'REV roome');
INSERT INTO facilities (id, fname, fmaxtime, fdescription)
	 VALUES (2,'A301',60,'Dancing room');
INSERT INTO facilities (id, fname, fmaxtime, fdescription)
	 VALUES (3,'D205',NULL,'Cardio room');

PROMPT Inserting Data into group_course table
INSERT INTO group_course (id, gcname, gcroom, gcdescription, gcduration)
	 VALUES (2,'Zomba','A201','Dancing',60);
INSERT INTO group_course (id, gcname, gcroom, gcdescription, gcduration)
	 VALUES (3,'Yoga','A301','Yoga class',120);

PROMPT Inserting Data into trainer table
INSERT INTO trainer (id, tname, tprofile)
	 VALUES (1,'Gabriel','Zomba teacher');
INSERT INTO trainer (id, tname, tprofile)     
	 VALUES (2,'Hami','Yoga');



PROMPT Inserting Data into member table
INSERT INTO member (id, musername, memail, mpassword, mavatar, mavatar_content_type, mreg_date, m_bod, mmobile, mfreezed, mstart_date, mlastattenddate, mgender)
	 VALUES (1,'John','John@123.com','123456','','',to_date('2017-03-27 13:18:36','yyyy-mm-dd hh24:mi:ss'),to_date('2017-04-04 13:18:41','yyyy-mm-dd hh24:mi:ss'),'123456',NULL,to_date('2017-04-05 13:18:55','yyyy-mm-dd hh24:mi:ss'),to_date('2017-04-07 13:19:03','yyyy-mm-dd hh24:mi:ss'),'MALE');
INSERT INTO member (id, musername, memail, mpassword, mavatar, mavatar_content_type, mreg_date, m_bod, mmobile, mfreezed, mstart_date, mlastattenddate, mgender)
	 VALUES (2,'Amy','Amy@123.com','123456','','',to_date('2017-04-06 13:20:02','yyyy-mm-dd hh24:mi:ss'),to_date('2017-04-05 13:20:06','yyyy-mm-dd hh24:mi:ss'),'123456',NULL,to_date('2017-04-09 13:20:19','yyyy-mm-dd hh24:mi:ss'),to_date('2017-03-29 13:20:23','yyyy-mm-dd hh24:mi:ss'),'FEMALE');
INSERT INTO member (id, musername, memail, mpassword, mavatar, mavatar_content_type, mreg_date, m_bod, mmobile, mfreezed, mstart_date, mlastattenddate, mgender)
	 VALUES (3,'Joe','Joe@123.com','123456','','',to_date('2017-04-04 13:21:09','yyyy-mm-dd hh24:mi:ss'),to_date('2017-03-28 13:21:15','yyyy-mm-dd hh24:mi:ss'),'123456',NULL,to_date('2017-04-05 13:21:22','yyyy-mm-dd hh24:mi:ss'),to_date('2017-03-31 13:21:28','yyyy-mm-dd hh24:mi:ss'),'MALE');
INSERT INTO member (id, musername, memail, mpassword, mavatar, mavatar_content_type, mreg_date, m_bod, mmobile, mfreezed, mstart_date, mlastattenddate, mgender)
	 VALUES (4,'Maggie','Maggei@123.com','123456','','',to_date('2017-04-05 13:24:13','yyyy-mm-dd hh24:mi:ss'),to_date('2017-03-29 13:24:19','yyyy-mm-dd hh24:mi:ss'),'123456',NULL,to_date('2017-04-04 13:24:26','yyyy-mm-dd hh24:mi:ss'),to_date('2017-04-05 13:24:30','yyyy-mm-dd hh24:mi:ss'),'FEMALE');


PROMPT Inserting Data into credit_card table
INSERT INTO credit_card (id, ccnumber, ccname, ccexpireddate, member_id)
	 VALUES (1,'123456','Visa',to_date('2017-03-30 13:24:55','yyyy-mm-dd hh24:mi:ss'),1);
INSERT INTO credit_card (id, ccnumber, ccname, ccexpireddate, member_id)
	 VALUES (2,'654321','Master',to_date('2017-03-30 13:26:36','yyyy-mm-dd hh24:mi:ss'),2);
INSERT INTO credit_card (id, ccnumber, ccname, ccexpireddate, member_id)
	 VALUES (3,'555888','UnionPay',to_date('2017-04-30 17:01:15','yyyy-mm-dd hh24:mi:ss'),3);

PROMPT Inserting Data into member_booking table
INSERT INTO member_booking (id, mbtime, last_name, member_id, facility_id, course_id)
	 VALUES (1,to_date('2017-04-04 16:53:55','yyyy-mm-dd hh24:mi:ss'),'Zhang',1,1,NULL);
INSERT INTO member_booking (id, mbtime, last_name, member_id, facility_id, course_id)
	 VALUES (2,to_date('2017-04-10 16:54:50','yyyy-mm-dd hh24:mi:ss'),'Brown',3,NULL,2);
INSERT INTO member_booking (id, mbtime, last_name, member_id, facility_id, course_id)
	 VALUES (3,to_date('2017-04-02 16:55:26','yyyy-mm-dd hh24:mi:ss'),'Smith',4,NULL,3);

PROMPT Inserting Data into member_ship table
INSERT INTO member_ship (id, msdate, msduration, msfee, msdiscount, member_id)
	 VALUES (1,to_date('2017-04-04 13:28:07','yyyy-mm-dd hh24:mi:ss'),10000,20.00,0.1,1);
INSERT INTO member_ship (id, msdate, msduration, msfee, msdiscount, member_id)
	 VALUES (2,to_date('2017-04-12 13:29:58','yyyy-mm-dd hh24:mi:ss'),1000,20.00,0.5,2);
INSERT INTO member_ship (id, msdate, msduration, msfee, msdiscount, member_id)
	 VALUES (3,to_date('2017-04-10 15:49:36','yyyy-mm-dd hh24:mi:ss'),12000,100.00,0.5,3);

PROMPT Inserting Data into payment table
INSERT INTO payment (id, pdate, ptype, pamount, membership_id)
	 VALUES (1,to_date('2017-04-10 16:52:48','yyyy-mm-dd hh24:mi:ss'),'UPFRONT',100.00,1);
INSERT INTO payment (id, pdate, ptype, pamount, membership_id)
	 VALUES (2,to_date('2017-04-03 16:53:13','yyyy-mm-dd hh24:mi:ss'),'POST',0.00,2);
INSERT INTO payment (id, pdate, ptype, pamount, membership_id)
	 VALUES (3,to_date('2017-04-04 16:53:33','yyyy-mm-dd hh24:mi:ss'),'BYTIME',15.00,3);

PROMPT Inserting Data into timetable table
INSERT INTO timetable (id, ttstart_time, ttend_time, facility_id, course_id)
	 VALUES (1,to_date('2017-04-10 15:59:49','yyyy-mm-dd hh24:mi:ss'),to_date('2017-04-11 15:59:55','yyyy-mm-dd hh24:mi:ss'),1,NULL);
INSERT INTO timetable (id, ttstart_time, ttend_time, facility_id, course_id)
     VALUES (2,to_date('2017-04-01 16:06:01','yyyy-mm-dd hh24:mi:ss'),to_date('2017-04-03 00:00:00','yyyy-mm-dd hh24:mi:ss'),2,NULL);
INSERT INTO timetable (id, ttstart_time, ttend_time, facility_id, course_id)
	 VALUES (3,to_date('2017-04-03 16:06:49','yyyy-mm-dd hh24:mi:ss'),to_date('2017-04-10 16:06:53','yyyy-mm-dd hh24:mi:ss'),NULL,2);
INSERT INTO timetable (id, ttstart_time, ttend_time, facility_id, course_id)
	 VALUES (4,to_date('2017-04-01 16:09:37','yyyy-mm-dd hh24:mi:ss'),to_date('2017-04-02 16:09:46','yyyy-mm-dd hh24:mi:ss'),NULL,3);

PROMPT Inserting Data into attendance table
INSERT INTO attendance (id, atstart_time, atend_time, member_id)
VALUES (1,to_date('2017-04-10 16:43:29','yyyy-mm-dd hh24:mi:ss'),to_date('2017-04-10 16:43:34','yyyy-mm-dd hh24:mi:ss'),1);

/*
Turning OFF the Spool
*/
PROMPT Turning OFF the Spool

spool off;