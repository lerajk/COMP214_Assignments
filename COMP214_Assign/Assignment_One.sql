-- Created by Da Vinci

/* 1. Name of each officer who has reported more than average number of crimes */

WITH COUNTING AS (
    select officer_id , count(crime_id) "Crime_Reported"
    FROM crime_officers
    group by officer_id
)

select "LAST", "FIRST"
from officers alias1
    join  COUNTING alias2 on alias1.officer_id = alias2.officer_id
where "Crime_Reported" > (select avg("Crime_Reported")
                          FROM COUNTING);
/* 2. Names of criminals who have committed less than the average number of crimes and aren't violent offenders */

WITH counting AS (
   select criminal_ID, count(CHARGE_ID)  "Charge_countt"
   FROM (select crime_charges.Crime_ID, crime_charges.charge_ID, crimes.criminal_id
           FROM crime_charges
           INNER JOIN crimes
           ON crime_charges.crime_ID=crimes.crime_ID)
   group by criminal_ID
)

select "LAST", "FIRST"
from criminals alias1
     join counting alias2 on alias1.criminal_id = alias2.criminal_id
where "Charge_countt"  < (select avg("Charge_countt")
                        from counting);

/* 3. Appeal information for each appeal that has less than average number of days between filing and hearing dates */

select *
from appeals
where (HEARING_DATE-FILING_DATE) <  (select avg ("difference") "average_Of_Dates"
                                     From (select HEARING_DATE- FILING_DATE "difference"
                                           from appeals));

/* 4. List the names of probation officers who have had a less than average number of criminals assigned */

with count1 as (
    select prob_id, count(criminal_ID) "Count2"
    FROM sentences group by prob_id)

select "FIRST", "LAST"
from prob_officers alias1
    join  count1 alias2 on alias1.prob_id = alias2.prob_id
where "Count2" < (select avg("Count2")
                          FROM count1);

/* 5. each crime that has the highest number of appeals */

select crime_id from crimes
join appeals using(crime_id)
having (count(crime_id)) = (select max(count(crime_id)) from appeals
                            group by crime_id)
group by crime_id;
