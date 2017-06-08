spool '/Users/liuyufei/Desktop/advancedDB/uniRec/uniRec-DDLspool.txt'

PROMPT CREATE Table article_group
CREATE TABLE article_group (
  id number(19) NOT NULL,
  agname varchar2(255) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

-- Generate ID using sequence and trigger
CREATE SEQUENCE article_group_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER article_group_seq_tr
 BEFORE INSERT ON article_group FOR EACH ROW
 WHEN (NEW.id IS NULL)
BEGIN
 SELECT article_group_seq.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/

PROMPT CREATE Table article
CREATE TABLE article (
  id number(19) NOT NULL,
  atitle varchar2(255) DEFAULT NULL,
  acontent varchar2(255) DEFAULT NULL,
  group_id number(19) DEFAULT NULL,
  PRIMARY KEY (id)
 ,
  CONSTRAINT fk_article_group_id FOREIGN KEY (group_id) REFERENCES article_group (id)
) ;

CREATE INDEX fk_article_group_id ON article (group_id);

-- Generate ID using sequence and trigger
CREATE SEQUENCE article_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER article_seq_tr
 BEFORE INSERT ON article FOR EACH ROW
 WHEN (NEW.id IS NULL)
BEGIN
 SELECT article_seq.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/




PROMPT CREATE Table facilities
CREATE TABLE facilities (
  id number(19) NOT NULL,
  fname varchar2(255) NOT NULL,
  fmaxtime number(19) DEFAULT NULL,
  fdescription varchar2(255) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

-- Generate ID using sequence and trigger
CREATE SEQUENCE facilities_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER facilities_seq_tr
 BEFORE INSERT ON facilities FOR EACH ROW
 WHEN (NEW.id IS NULL)
BEGIN
 SELECT facilities_seq.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/

PROMPT CREATE Table group_course
CREATE TABLE group_course (
  id number(19) NOT NULL,
  gcname varchar2(255) NOT NULL,
  gcroom varchar2(255) DEFAULT NULL,
  gcdescription varchar2(255) NOT NULL,
  gcduration number(19) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

-- Generate ID using sequence and trigger
CREATE SEQUENCE group_course_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER group_course_seq_tr
 BEFORE INSERT ON group_course FOR EACH ROW
 WHEN (NEW.id IS NULL)
BEGIN
 SELECT group_course_seq.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/

PROMPT CREATE Table trainer
CREATE TABLE trainer (
  id number(19) NOT NULL,
  tname varchar2(255) NOT NULL,
  tprofile varchar2(255) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

-- Generate ID using sequence and trigger
CREATE SEQUENCE trainer_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER trainer_seq_tr
 BEFORE INSERT ON trainer FOR EACH ROW
 WHEN (NEW.id IS NULL)
BEGIN
 SELECT trainer_seq.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/

PROMPT CREATE Table group_course_trainer
CREATE TABLE group_course_trainer (
  trainers_id number(19) NOT NULL,
  group_courses_id number(19) NOT NULL,
  PRIMARY KEY (group_courses_id,trainers_id)
 ,
  CONSTRAINT fk_gct_group_courses_id FOREIGN KEY (group_courses_id) REFERENCES group_course (id),
  CONSTRAINT fk_gct_trainers_id FOREIGN KEY (trainers_id) REFERENCES trainer (id)
) ;

CREATE INDEX fk_gct_trainers_id ON group_course_trainer (trainers_id);


PROMPT CREATE Table member
CREATE TABLE member (
  id number(19) NOT NULL,
  musername varchar2(255) NOT NULL,
  memail varchar2(255) NOT NULL,
  mpassword varchar2(255) NOT NULL,
  mavatar blob,
  mavatar_content_type varchar2(255) DEFAULT NULL,
  mreg_date timestamp(0) NULL,
  m_bod timestamp(0) NULL,
  mmobile varchar2(255) DEFAULT NULL,
  mfreezed raw(1) DEFAULT NULL,
  mstart_date timestamp(0) NULL,
  mlastattenddate timestamp(0) NULL,
  mgender varchar2(255) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

-- Generate ID using sequence and trigger
CREATE SEQUENCE member_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER member_seq_tr
 BEFORE INSERT ON member FOR EACH ROW
 WHEN (NEW.id IS NULL)
BEGIN
 SELECT member_seq.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/


PROMPT CREATE Table credit_card
CREATE TABLE credit_card (
  id number(19) NOT NULL,
  ccnumber varchar2(255) NOT NULL,
  ccname varchar2(255) DEFAULT NULL,
  ccexpireddate timestamp(0) NULL,
  member_id number(19) DEFAULT NULL,
  PRIMARY KEY (id)
 ,
  CONSTRAINT fk_credit_card_member_id FOREIGN KEY (member_id) REFERENCES member (id)
) ;

CREATE INDEX fk_credit_card_member_id ON credit_card (member_id);

-- Generate ID using sequence and trigger
CREATE SEQUENCE credit_card_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER credit_card_seq_tr
 BEFORE INSERT ON credit_card FOR EACH ROW
 WHEN (NEW.id IS NULL)
BEGIN
 SELECT credit_card_seq.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/

PROMPT CREATE Table member_booking
CREATE TABLE member_booking (
  id number(19) NOT NULL,
  mbtime timestamp(0) NOT NULL,
  last_name varchar2(255) NOT NULL,
  member_id number(19) DEFAULT NULL,
  facility_id number(19) DEFAULT NULL,
  course_id number(19) DEFAULT NULL,
  PRIMARY KEY (id)
 ,
  CONSTRAINT fk_member_booking_course_id FOREIGN KEY (course_id) REFERENCES group_course (id),
  CONSTRAINT fk_member_booking_facility_id FOREIGN KEY (facility_id) REFERENCES facilities (id),
  CONSTRAINT fk_member_booking_member_id FOREIGN KEY (member_id) REFERENCES member (id)
) ;

-- Generate ID using sequence and trigger
CREATE SEQUENCE member_booking_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER member_booking_seq_tr
 BEFORE INSERT ON member_booking FOR EACH ROW
 WHEN (NEW.id IS NULL)
BEGIN
 SELECT member_booking_seq.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/

CREATE INDEX fk_member_booking_member_id ON member_booking (member_id);
CREATE INDEX fk_member_booking_facility_id ON member_booking (facility_id);
CREATE INDEX fk_member_booking_course_id ON member_booking (course_id);

PROMPT CREATE Table member_ship
CREATE TABLE member_ship (
  id number(19) NOT NULL,
  msdate timestamp(0) NOT NULL,
  msduration number(19) DEFAULT NULL,
  msfee number(10,2) DEFAULT NULL,
  msdiscount binary_double DEFAULT NULL,
  member_id number(19) DEFAULT NULL,
  PRIMARY KEY (id)
 ,
  CONSTRAINT fk_member_ship_member_id FOREIGN KEY (member_id) REFERENCES member (id)
) ;

-- Generate ID using sequence and trigger
CREATE SEQUENCE member_ship_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER member_ship_seq_tr
 BEFORE INSERT ON member_ship FOR EACH ROW
 WHEN (NEW.id IS NULL)
BEGIN
 SELECT member_ship_seq.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/

CREATE INDEX fk_member_ship_member_id ON member_ship (member_id);

PROMPT CREATE Table payment
CREATE TABLE payment (
  id number(19) NOT NULL,
  pdate timestamp(0) NOT NULL,
  ptype varchar2(255) NOT NULL,
  pamount number(10,2) DEFAULT NULL,
  membership_id number(19) DEFAULT NULL,
  PRIMARY KEY (id)
 ,
  CONSTRAINT fk_payment_membership_id FOREIGN KEY (membership_id) REFERENCES member_ship (id)
) ;

-- Generate ID using sequence and trigger
CREATE SEQUENCE payment_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER payment_seq_tr
 BEFORE INSERT ON payment FOR EACH ROW
 WHEN (NEW.id IS NULL)
BEGIN
 SELECT payment_seq.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/

CREATE INDEX fk_payment_membership_id ON payment (membership_id);


PROMPT CREATE Table timetable
CREATE TABLE timetable (
  id number(19) NOT NULL,
  ttstart_time timestamp(0) NOT NULL,
  ttend_time timestamp(0) NULL,
  facility_id number(19) DEFAULT NULL,
  course_id number(19) DEFAULT NULL,
  PRIMARY KEY (id)
 ,
  CONSTRAINT fk_timetable_course_id FOREIGN KEY (course_id) REFERENCES group_course (id),
  CONSTRAINT fk_timetable_facility_id FOREIGN KEY (facility_id) REFERENCES facilities (id)
) ;

-- Generate ID using sequence and trigger
CREATE SEQUENCE timetable_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER timetable_seq_tr
 BEFORE INSERT ON timetable FOR EACH ROW
 WHEN (NEW.id IS NULL)
BEGIN
 SELECT timetable_seq.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/

CREATE INDEX fk_timetable_facility_id ON timetable (facility_id);
CREATE INDEX fk_timetable_course_id ON timetable (course_id);



PROMPT CREATE Table attendance
CREATE TABLE attendance (
  id number(19) NOT NULL,
  atstart_time timestamp(0) NULL,
  atend_time timestamp(0) NULL,
  member_id number(19) DEFAULT NULL,
  PRIMARY KEY (id)
 ,
  CONSTRAINT fk_attendance_member_id FOREIGN KEY (member_id) REFERENCES member (id)
) ;

CREATE INDEX fk_attendance_member_id ON attendance (member_id);

-- Generate ID using sequence and trigger
CREATE SEQUENCE attendance_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER attendance_seq_tr
 BEFORE INSERT ON attendance FOR EACH ROW
 WHEN (NEW.id IS NULL)
BEGIN
 SELECT attendance_seq.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/

/*
Turning OFF the Spool
*/
PROMPT Turning OFF the Spool

spool off;