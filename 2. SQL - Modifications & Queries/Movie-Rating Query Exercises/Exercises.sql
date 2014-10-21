/*
Movie ( mID, title, year, director ) 
English: There is a movie with ID number mID, a title, a release year, and a director. 

Reviewer ( rID, name ) 
English: The reviewer with ID number rID has a certain name. 

Rating ( rID, mID, stars, ratingDate ) 
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 
*/


--Q1. Find the titles of all movies directed by Steven Spielberg.

SELECT title
FROM Movie
WHERE director = 'Steven Spielberg';

--Q2. Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. 

SELECT distinct year
FROM Movie join Rating using(mID)
WHERE stars = 4 or stars = 5
ORDER BY year;

--Q3. Find the titles of all movies that have no ratings. 
 
SELECT title
FROM Movie
WHERE mID not in (SELECT mID FROM Rating);

--Q4. Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. 

SELECT name
FROM Reviewer join Rating using(rID)
WHERE ratingDate is null;

--Q5. Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, 
--    first by reviewer name, then by movie title, and lastly by number of stars. 

SELECT name, title, stars, ratingDate
FROM (Movie join Rating using(mID)) join Reviewer using(rID)
ORDER BY name, title, stars;

--Q6. For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. 
--Two options for illustration of viable table variable usage

SELECT name, title
FROM (Movie join Rating using(mID)) join Reviewer using(rID) 
join Rating R2 on Rating.mID = R2.mID and Rating.rID = R2.rID
WHERE R2.ratingDate > Rating.ratingDate and R2.stars > Rating.stars and R2.rID = Rating.rID;

SELECT name, title
FROM ((Movie join Rating using(mID)) join Reviewer using(rID)) R1 
join Rating R2 on R1.mID = R2.mID and R1.rID = R2.rID
WHERE R2.ratingDate > R1.ratingDate and R2.stars > R1.stars and R2.rID = R1.rID;

--Q7. For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. 

SELECT distinct title, stars
FROM Movie JOIN Rating R1 using(mID)
WHERE not exists (SELECT * FROM Rating R2
                  WHERE R2.stars > R1.stars and R1.mID = R2.mID)
ORDER BY title;

--Q8.  List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order. 

SELECT title, avg(stars) 
FROM Movie join Rating using(mID)
GROUP BY(title)
ORDER BY(avg(stars)) desc, title;

--Q9. Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.)
--Challenge option:  Without -HAVING- or without COUNT

SELECT name
FROM Reviewer join Rating using(rID)
GROUP BY name
HAVING COUNT(*) > 2;

select name 
from Reviewer 
where 3 <= (select count(*) 
            from Rating 
            where Rating.rID = Reviewer.rID)
