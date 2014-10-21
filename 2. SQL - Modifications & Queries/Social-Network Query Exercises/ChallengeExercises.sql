/*
Highschooler ( ID, name, grade ) 
English: There is a high school student with unique ID and a given first name in a certain grade. 

Friend ( ID1, ID2 ) 
English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123). 

Likes ( ID1, ID2 ) 
English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present. 
*/

--Q1. Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade. 

SELECT name, grade
FROM Highschooler H
WHERE not exists (SELECT *
                  FROM Likes
                  WHERE H.ID = ID1 or H.ID = ID2)
ORDER BY grade, name;

--Q2.  For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the 
--     name and grade of A, B, and C.

SELECT A.name, A.grade, B.name, B.grade, C.name, C.grade
FROM Highschooler A, Highschooler B, Highschooler C, Likes, Friend F1, Friend F2
WHERE A.ID = Likes.ID1 and B.ID = Likes.ID2 and B.ID not in (SELECT ID1 FROM Friend WHERE A.ID = ID2)
and A.ID = F1.ID1 and C.ID = F1.ID2 and B.ID = F2.ID1 and C.ID = F2.ID2;

--Q3.  Find the difference between the number of students in the school and the number of different first names. 

SELECT s.c1 - n.c2
FROM (SELECT count(ID) c1 FROM Highschooler) s, (SELECT count(distinct name) c2 FROM Highschooler) n;

--Q4.  What is the average number of friends per student? (Your result should be just one number.) 

SELECT avg(groups.c)
FROM (SELECT count(*) c
      FROM Highschooler join Friend on ID = ID1
      GROUP BY ID) groups;

--Q5.  Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend. 

SELECT ID2 
FROM Friend 
WHERE ID1 in (SELECT ID2 FROM Friend WHERE ID1 in (select ID FROM Highschooler WHERE name = 'Cassandra'))
and ID1 not in (SELECT ID FROM Highschooler WHERE name = 'Cassandra');

--Q6.  Find the name and grade of the student(s) with the greatest number of friends.

SELECT name, grade
FROM (SELECT ID1, count(ID1) c
      FROM Friend
      GROUP BY ID1) a
join Highschooler on ID = a.ID1
WHERE a.c in (SELECT max(a.c)
              FROM (SELECT ID1, count(ID1) c
	            FROM Friend
                    GROUP BY ID1) a)

-- Another solution
select name, grade 
from highschooler 
where id in (select id1 
	     from (select id1, count(id2) c 
		   from friend 
		   group by id1 
		   having c=(select max(c2) 
			     from (select id1, count(id2) c2 
			           from friend 
			           group by id1 
			           order by c2 desc))))