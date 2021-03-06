/* Q1  (2 points possible)
Write a trigger that makes new students named 'Friendly' automatically like everyone else in their grade. That is, after the trigger runs, we should have ('Friendly', A) in the Likes table for every other Highschooler A in the same grade as 'Friendly'.
Your triggers are created in SQLite, so you must conform to the trigger constructs supported by SQLite.  */

CREATE trigger fr
after insert on Highschooler
for each row
when new.name = 'Friendly'
begin
    insert into Likes select new.ID, ID 
                      from Highschooler 
                      where new.grade = grade
                      and ID <> new.ID;
end;

/* Q2  (2 points possible)
Write one or more triggers to manage the grade attribute of new Highschoolers. If the inserted tuple has a value less than 9 or greater than 12, change the value to NULL. On the other hand, if the inserted tuple has a null value for grade, change it to 9. 
Your triggers are created in SQLite, so you must conform to the trigger constructs supported by SQLite.
To create more than one trigger, separate the triggers with a vertical bar (|).  */

CREATE trigger invalid
after insert on Highschooler
for each row
when new.grade < 9 or new.grade > 12
begin
    update Highschooler set grade = null where id = new.id;
end;
|
CREATE trigger dflt
after insert on Highschooler
for each row
when new.grade is null
begin
    update Highschooler set grade = 9 where id = new.id;
end;

/* Q3  (2 points possible)
Write a trigger that automatically deletes students when they graduate, i.e., when their grade is updated to exceed 12. 
Your triggers are created in SQLite, so you must conform to the trigger constructs supported by SQLite. */

CREATE trigger grad
after update on Highschooler
for each row
when new.grade > 12
begin
    DELETE from Highschooler where id = new.id;
end;

