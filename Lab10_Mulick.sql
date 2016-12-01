--Danny Mulick 12/1/2016 Lab 10: Stored Procedure
--Func1on PreReqsFor(courseNum) - Returns the immediate prerequisites for the passed-in course number.
create or replace function PreReqsFor(int, REFCURSOR) returns refcursor 
as 
$$
declare
   inputCourse int       := $1;
     resultset REFCURSOR := $2;
begin
   open resultset for 
      select prereqnum
        from prerequisites
       where courseNum = inputCourse;
   return resultset;
end;
$$ 
language plpgsql;

select PreReqsFor(499, 'results');
fetch all from results;

--func1on IsPreReqFor(courseNum) - Returns the courses for which the passed-in course number is an immediate pre-requisite.
create or replace function IsPreReqFor(int, REFCURSOR) returns refcursor 
as 
$$
declare
   inputCourse int       := $1;
     resultset REFCURSOR := $2;
begin
   open resultset for 
      select courseNum
        from Prerequisites
       where preReqNum = inputCourse;
   return resultset;
end;
$$ 
language plpgsql;

select IsPreReqFor(221, 'results');
fetch all from results;

