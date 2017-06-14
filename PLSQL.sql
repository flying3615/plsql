
SET SERVEROUTPUT ON;
DECLARE
  c_course VARCHAR2(40) := 'ITB7325 Advanced Database';
  c_code   VARCHAR2(7);
  c_desc   VARCHAR2(30);
  blank_space NUMBER(2);
  num       NUMBER(2);
BEGIN
  blank_space := INSTR(c_course,' ');
  num := LENGTH(c_course);
  c_code := SUBSTR(c_course,1,(blank_space-1));
  c_desc := SUBSTR(c_course,(blank_space+1),(num-blank_space));
  
  --Display the date
  DBMS_OUTPUT.PUT_LINE('Course Code: '||c_code);
  DBMS_OUTPUT.PUT_LINE('Course Name: '||c_desc);
  DBMS_OUTPUT.PUT_LINE('blank_space : '||blank_space);

END;
/
SET SERVEROUTPUT OFF;

-----------------FOR LOOP------------------

DROP TABLE count_table;

CREATE TABLE count_table (
  counter NUMBER
);


SET SERVEROUTPUT ON;
DECLARE
  loop_count BINARY_INTEGER := 1;
BEGIN
  DELETE FROM count_table;
  LOOP
    INSERT INTO count_table VALUES (loop_count);
    loop_count := loop_count + 1;
    
    IF loop_count >=6 THEN
      EXIT;
    END IF;
  END LOOP;
  SYS.DBMS_OUTPUT.PUT_LINE('LOOP Finished');
END;
/
SET SERVEROUTPUT OFF;

SELECT * FROM count_table;

--------------------WHILE LOOP--------------------

SET SERVEROUTPUT ON;
DECLARE
  loop_count BINARY_INTEGER := 1;
BEGIN
  DELETE FROM count_table;
  WHILE loop_count < 6 LOOP
    INSERT INTO count_table VALUES (loop_count);
    loop_count := loop_count + 1;
  END LOOP;
  SYS.DBMS_OUTPUT.PUT_LINE('LOOP Finished');
END;
/
SET SERVEROUTPUT OFF;

SELECT * FROM count_table;

--------------------FOR ... LOOP------------------------

SET SERVEROUTPUT ON;
DECLARE
  loop_count BINARY_INTEGER := 1;
BEGIN
  DELETE FROM count_table;
  FOR loop_count IN 1..5 LOOP
    INSERT INTO count_table VALUES (loop_count);
    loop_count := loop_count + 1;
  END LOOP;
  SYS.DBMS_OUTPUT.PUT_LINE('LOOP Finished');
END;
/
SET SERVEROUTPUT OFF;

SELECT * FROM count_table;

-----------------Implicit Cursor---------------------
SET SERVEROUTPUT ON;
DECLARE
  username member.musername%TYPE;
  password member.mpassword%TYPE;
BEGIN
  SELECT musername,mpassword 
  INTO username,password 
  FROM member
  WHERE ID = 1;
  SYS.DBMS_OUTPUT.PUT_LINE('Username: '||username||' password: '||password);
END;
/
SET SERVEROUTPUT OFF;

---------------Explicit Cursor------------------
SET SERVEROUTPUT ON;
DECLARE
  --1.Declare the cursor with query
  CURSOR member_cursor IS
    SELECT musername,memail,mpassword FROM member;
  username   member.musername%TYPE;
  email      member.memail%TYPE;
  password   member.mpassword%TYPE;
BEGIN
  --2.open the cursor
  OPEN member_cursor;
  --3.Fetch the data rows
  LOOP
    FETCH member_cursor into username,email,password;
    EXIT WHEN member_cursor%NOTFOUND; --no more rows
    SYS.DBMS_OUTPUT.PUT_LINE('Username: '||username||' password: '||password||' email:'||email);
  END LOOP;
  CLOSE member_cursor;
END;
/
SET SERVEROUTPUT OFF;

------------Explicit Cursor with RowType----------
SET SERVEROUTPUT ON;
DECLARE
  --1.Declare the cursor with query
  CURSOR member_cursor IS
    SELECT * FROM member;
  member_row   member_cursor%ROWTYPE;
BEGIN
  --
  .open the cursor
  OPEN member_cursor;
  --3.Fetch the data rows
  LOOP
    FETCH member_cursor INTO member_row;
    EXIT WHEN member_cursor%NOTFOUND; --no more rows
    SYS.DBMS_OUTPUT.PUT_LINE('Username: '||member_row.musername||' password: '||member_row.mpassword||' email:'||member_row.memail);
  END LOOP;
  CLOSE member_cursor;
END;
/
SET SERVEROUTPUT OFF;

--------------------Explicit Cursor For Loop------------------------

SET SERVEROUTPUT ON;
DECLARE
  --1.Declare the cursor with query
  CURSOR member_cursor IS
    SELECT * FROM member;
  member_row   member_cursor%ROWTYPE;
BEGIN
  --2.For loop no need open
  FOR member_row IN member_cursor LOOP
    SYS.DBMS_OUTPUT.PUT_LINE('Username: '||member_row.musername||' password: '||member_row.mpassword||' email:'||member_row.memail);
  END LOOP;
END;
/
SET SERVEROUTPUT OFF;

--------------------Exception-----------------------

SET SERVEROUTPUT ON;
DECLARE
  m_id NUMBER := &m_id;
  CURSOR member_cursor IS
    SELECT * FROM member WHERE id>m_id;
  member_row   member_cursor%ROWTYPE;
  e_foreign_key_error EXCEPTION;
  PRAGMA EXCEPTION_INIT (e_foreign_key_error, -2291);
  e_my_exception EXCEPTION;
  e_id   member.id%TYPE;
BEGIN
  --2.For loop no need open
  FOR member_row IN member_cursor LOOP
    IF member_row.mmobile IS NULL THEN
      e_id := member_row.id;
      RAISE e_my_exception;
    END IF;
    SYS.DBMS_OUTPUT.PUT_LINE('Username: '||member_row.musername||' password: '||member_row.mpassword||' email:'||member_row.memail);
  END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    SYS.DBMS_OUTPUT.PUT_LINE('No data was found');
  WHEN e_foreign_key_error THEN
    SYS.DBMS_OUTPUT.PUT_LINE('Field Not found in parent table');
  WHEN e_my_exception THEN
    SYS.DBMS_OUTPUT.PUT_LINE('Member '||e_id||' is missing their last name');
  WHEN OTHERS THEN
    SYS.DBMS_OUTPUT.PUT_LINE('Encountered the following error');
    SYS.DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
SET SERVEROUTPUT OFF;
