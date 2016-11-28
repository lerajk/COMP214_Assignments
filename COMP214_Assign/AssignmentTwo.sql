-- CREATED BY DA VINCI

-- QUESTION 1 (3-9)

/* STEP 1: Creating a View to store the Sub-Query */

CREATE VIEW RESULTOFQUERY AS
SELECT IDPROJ, PROJNAME, TOTAL, NUMBEROFPLEDGES, AVERAGEPLEDGE
FROM
(SELECT alias1.IDPROJ, alias1.PROJNAME, alias2.TOTAL, alias2.NUMBEROFPLEDGES, alias2.AVERAGEPLEDGE
    FROM DD_PROJECT alias1
 join
    (select IDPROJ,sum(PLEDGEAMT) "TOTAL", count(IDPLEDGE) "NUMBEROFPLEDGES", avg(PLEDGEAMT) "AVERAGEPLEDGE"
        from DD_PLEDGE
        group by IDPROJ) alias2
  on alias1.IDPROJ = alias2.IDPROJ);/

/* STEP 2: You can view the store view */

select * from RESULTOFQUERY;


/* STEP 3: USING PL/SQL TO ANSWER QUESTION 1 */

accept x number prompt 'Please enter PROJECTID:'
DECLARE
  a number;
  PROJECTID NUMBER(10);
  PROJECTNAME VARCHAR2(100);
  TOT NUMBER(10);
  PLEDGENUMBER NUMBER(10);
  AVERAGE NUMBER(10,2);
BEGIN
a := &x;
SELECT IDPROJ, PROJNAME, TOTAL, NUMBEROFPLEDGES, AVERAGEPLEDGE
INTO PROJECTID, PROJECTNAME, TOT, PLEDGENUMBER, AVERAGE
FROM RESULTOFQUERY
WHERE IDPROJ = a;
DBMS_OUTPUT.PUT_LINE(PROJECTID || ' ' || PROJECTNAME || ' ' || TOT || ' ' || PLEDGENUMBER || ' ' || AVERAGE);
END;


-- QUESTION 2 (3-10)


/* STEP 1: CREATING A SEQUENCE */

CREATE SEQUENCE DD_PROJID_SEQ
START WITH 530
INCREMENT BY 1
NOCACHE
NOCYCLE;

/* STEP 2: USING PL/SQL TO ANSWER QUESTION 2 */

DECLARE
  PROJECTID NUMBER(10);
  PROJECTNAME VARCHAR2(100) := 'HK ANIMAL SHELTER';
  STARTDATE DATE := '1-JAN-13';
  ENDDATE DATE := '5-MAY-13';
  FUND NUMBER(10) := 65000;
  COORDINATOR VARCHAR2(100) := 'JESSICA';
BEGIN
INSERT INTO DD_PROJECT (IDPROJ, PROJNAME, PROJSTARTDATE, PROJENDDATE, PROJFUNDGOAL, PROJCOORD)
VALUES (DD_PROJID_SEQ.NEXTVAL, PROJECTNAME, STARTDATE, ENDDATE, FUND, COORDINATOR);
END;

/* STEP 3: VIEW THE NEW INPUTTED DATA and the SEQUENCE VALUE */

SELECT * FROM DD_PROJECT;

SELECT DD_PROJID_SEQ.NEXTVAL FROM dual;


-- QUESTION 3 (3-11)

/* USING CURSOR AND PL/SQL BLOCK TO ANSWER QUESTION 3 */

SET SERVEROUTPUT ON
     BEGIN
          FOR cursor1 IN (SELECT * FROM DD_PLEDGE WHERE PLEDGEDATE BETWEEN '01-OCT-12' AND '31-OCT-12' ORDER BY PAYMONTHS)
          LOOP
            DBMS_OUTPUT.PUT_LINE('IDPLEDGE=  ' || cursor1.IDPLEDGE ||', IDDONOR =  ' || cursor1.IDDONOR ||
                                 ', PLEDGEAMT= ' || cursor1.PLEDGEAMT ||', PAYMONTHS= ' || cursor1.PAYMONTHS);
             IF cursor1.PAYMONTHS = 0 THEN
             DBMS_OUTPUT.PUT_LINE('LUMP SUM');
             ELSE
             DBMS_OUTPUT.PUT_LINE('Monthly= ' || cursor1.PAYMONTHS);
             END IF;
          END LOOP;
     END;


-- QUESTION 4 (3-12)


/* STEP 1: Creating a View to store the Sub-Query */

CREATE VIEW RESULTOFQUERY2 AS
SELECT IDPLEDGE, IDDONOR, PLEDGEAMT, PAYAMT, DIFFERENCE
FROM
(SELECT DISTINCT(ALIAS1.IDPLEDGE), ALIAS1.IDDONOR, ALIAS1.PLEDGEAMT, ALIAS2.PAYAMT, ALIAS1.PLEDGEAMT - ALIAS2.PAYAMT AS DIFFERENCE
  FROM DD_PLEDGE ALIAS1
JOIN  DD_PAYMENT ALIAS2
ON ALIAS1.IDPLEDGE = ALIAS2.IDPLEDGE
ORDER BY ALIAS1.IDPLEDGE ASC);

/* STEP 2: You can view the store view */

select * from RESULTOFQUERY2;


/* STEP 3: USING PL/SQL TO ANSWER QUESTION 4 */

accept x number prompt 'Please enter PLEDGEID:'
DECLARE
  a number;
  PLEDGEID NUMBER(20);
  DONORID NUMBER(20);
  PLEDGEAMOUNT NUMBER(20);
  PAYMENT NUMBER(20);
  CURRENTDIFFERENCE NUMBER(20);
BEGIN
a := &x;
SELECT IDPLEDGE, IDDONOR, PLEDGEAMT, PAYAMT, DIFFERENCE
INTO PLEDGEID, DONORID, PLEDGEAMOUNT, PAYMENT, CURRENTDIFFERENCE
FROM RESULTOFQUERY2
WHERE IDPLEDGE = a;
DBMS_OUTPUT.PUT_LINE(PLEDGEID || ' ' || DONORID || ' ' || PLEDGEAMOUNT || ' ' || PAYMENT || ' ' || CURRENTDIFFERENCE);
END;


-- QUESTION 5 (3-13)


DECLARE
  PROJECTNAME VARCHAR(50);
  PROJECTDATE DATE;
  GOAL NUMBER(10);
  GOAL2 NUMBER(10);
BEGIN

SELECT PROJNAME, PROJSTARTDATE, PROJFUNDGOAL
  INTO PROJECTNAME, PROJECTDATE, GOAL
  FROM DD_PROJECT
  WHERE IDPROJ = 500;
UPDATE DD_PROJECT
-- CHANGE PROJFUNDGOAL = 30000 OR ANYTHING ELSE TO VIEW THE ACCURATE RESULTS
SET PROJFUNDGOAL = 20008
WHERE IDPROJ =500;
DBMS_OUTPUT.PUT_LINE(PROJECTNAME || ' ' || PROJECTDATE || ' ' || GOAL);

SELECT PROJNAME, PROJSTARTDATE, PROJFUNDGOAL
  INTO PROJECTNAME, PROJECTDATE, GOAL2
  FROM DD_PROJECT
  WHERE IDPROJ = 500;
  DBMS_OUTPUT.PUT_LINE(PROJECTNAME || ' ' || PROJECTDATE || ' ' || GOAL2);

END;
