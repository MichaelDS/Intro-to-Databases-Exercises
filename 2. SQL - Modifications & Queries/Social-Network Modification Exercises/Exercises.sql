/*
Highschooler ( ID, name, grade ) 
English: There is a high school student with unique ID and a given first name in a certain grade. 

Friend ( ID1, ID2 ) 
English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123). 

Likes ( ID1, ID2 ) 
English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present. 
*/

--Q1. It's time for the seniors to graduate. Remove all 12th graders from Highschooler.

DELETE FROM Highschooler
WHERE grade = 12;

--Q2. If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple. 

DELETE FROM Likes x
WHERE exists (SELECT *
              FROM Friend 
              WHERE ID1 = x.ID1 and ID2 = x.ID2)  --Friends is symmetric
and not exists (SELECT *
                FROM Likes
                WHERE ID1 = x.ID2 and ID2 = x.ID1);

DELETE FROM Likes			       	--SQLite compliant solution
WHERE ID2 in (SELECT ID2 
              FROM Friend 
              WHERE Likes.ID1 = ID1) 
and ID2 not in (SELECT L.ID1 
                FROM Likes L 
                WHERE Likes.ID1 = L.ID2);

--Q3. For all cases where A is friends with B, and B is friends with C, add a new friendship for 
--    the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.) 

INSERT INTO Friend
SELECT F1.ID1, F2.ID2
FROM Friend F1 join Friend F2 on F1.ID2 = F2.ID1
WHERE F1.ID1 <> F2.ID2
except
SELECT * 
FROM Friend