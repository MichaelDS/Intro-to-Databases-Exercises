/* Q1  (3 points possible)
Write one or more triggers to maintain symmetry in friend relationships. Specifically, if (A,B) is deleted from Friend, then (B,A) should be deleted too. If (A,B) is inserted into Friend then (B,A) should be inserted too. Don't worry about updates to the Friend table. 
Your triggers are created in SQLite, so you must conform to the trigger constructs supported by SQLite.
To create more than one trigger, separate the triggers with a vertical bar (|). */

CREATE trigger symmetry1
after insert on Friend
for each row
begin
    insert into Friend values(new.id2, new.id1);
end;
|
CREATE trigger symmetry2
after delete on Friend
for each row
begin
    delete from Friend where id1 = old.id2 and id2 = old.id1;
end;

/* Q2  (3 points possible)
Write a trigger that automatically deletes students when they graduate, i.e., when their grade is updated to exceed 12. In addition, write a trigger so when a student is moved ahead one grade, then so are all of his or her friends. 
Your triggers are created in SQLite, so you must conform to the trigger constructs supported by SQLite.
To create more than one trigger, separate the triggers with a vertical bar (|). */

CREATE trigger grad
after update on Highschooler
for each row
when new.grade > 12
begin
    DELETE from Highschooler where id = new.id;
end;
|
CREATE trigger upFriends
after update on Highschooler
for each row
when new.grade = old.grade + 1
begin
    update Highschooler set grade = grade + 1
                        where id in (select id2
                                     from Friend
                                     where id1 = new.id);
end;

/* Q3  (3 points possible)
Write a trigger to enforce the following behavior: If A liked B but is updated to A liking C instead, and B and C were friends, make B and C no longer friends. Don't forget to delete the friendship in both directions, and make sure the trigger only runs when the "liked" (ID2) person is changed but the "liking" (ID1) person is not changed. 
Your triggers are created in SQLite, so you must conform to the trigger constructs supported by SQLite. */

CREATE trigger feud
after update on Likes
for each row
when new.id1 = old.id1 and exists(select * from Friend where id1 = old.id2 and id2 = new.id2)
begin
    delete from Friend where (id1 = old.id2 and id2 = new.id2) or (id1 = new.id2 and id2 = old.id2);
end;
