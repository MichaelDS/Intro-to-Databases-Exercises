--Highschooler ( ID, name, grade ) 
--English: There is a high school student with unique ID and a given first name in a certain grade. 

--Friend ( ID1, ID2 ) 
--English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123). 

--Likes ( ID1, ID2 ) 
--English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present. 

--Q1.  Find the names of all students who are friends with someone named Gabriel. 

SELECT name
FROM Highschooler join Friend on ID = ID1
WHERE ID2 in (SELECT ID
              FROM Highschooler
              WHERE name = 'Gabriel');

--Q2.  For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like. 

SELECT H1.name, H1.grade, H2.name, H2.grade
FROM (Highschooler H1 join Likes on H1.ID = ID1) join HighSchooler H2 on H2.ID = ID2 
WHERE H1.grade - H2.grade > 1;

--Q3.  For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order. 

SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1, Highschooler H2, Likes L1, Likes L2
WHERE H1.ID = L1.ID1 and H2.ID = L1.ID2 and H1.ID = L2.ID2 and H2.ID = L2.ID1 and H1.name < H2.name;

--Q4.  Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. 

SELECT name, grade 
FROM Highschooler
WHERE ID not in (SELECT ID1 
		 FROM Highschooler H1, Friend, Highschooler H2
		 WHERE H1.ID = Friend.ID1 and H2.ID = Friend.ID2 and H1.grade <> H2.grade)
ORDER BY grade, name;

--Q5.  Find the name and grade of all students who are liked by more than one other student. 

SELECT name, grade
FROM Highschooler
WHERE ID in (SELECT ID
	     FROM Highschooler join Likes on ID = ID2
	     GROUP BY ID
	     HAVING count(*) > 1);

--Neat Solution
select name, grade 
from (select ID2, count(ID2) as numLiked from Likes group by ID2), Highschooler
where numLiked>1 and ID2=ID;

