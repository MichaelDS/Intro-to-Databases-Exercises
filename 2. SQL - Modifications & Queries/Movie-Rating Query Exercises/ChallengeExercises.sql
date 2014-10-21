/*
Movie ( mID, title, year, director ) 
English: There is a movie with ID number mID, a title, a release year, and a director. 

Reviewer ( rID, name ) 
English: The reviewer with ID number rID has a certain name. 

Rating ( rID, mID, stars, ratingDate ) 
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 
*/

--Q1. For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. 
--    Sort by rating spread from highest to lowest, then by movie title. 

SELECT title, max(stars) - min(stars)
FROM Movie join Rating using(mID)
GROUP BY title
ORDER BY max(stars) - min(stars) desc, title;

--Q2. Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. 
--   (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. 
--    Don't just calculate the overall average rating before and after 1980.) 

SELECT max(av1) - min(av1) FROM  --min and max used to find the difference between the only two numbers in the resulting set
(SELECT avg(avgs1) av1
FROM (SELECT avg(stars) avgs1
      FROM Movie join Rating using(mID)
      WHERE Movie.year > 1980
      GROUP BY mID) a1
union
SELECT avg(avgs2) av1
FROM (SELECT avg(stars) avgs2
      FROM Movie join Rating using(mID)
      WHERE Movie.year < 1980 
      GROUP BY mID) a2) a;

--Q3. Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the 
--    director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.) 

SELECT title, director
FROM Movie
WHERE director in (SELECT director
		   FROM MOVIE
		   GROUP BY director
		   HAVING count(mID) > 1);

--Q4.  Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult 
--     to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) 

SELECT title, avg(stars)
FROM Movie join Rating using(mID)
GROUP BY title
HAVING avg(stars) in (SELECT max(av2) FROM 
		     (SELECT avg(stars) av2
		      FROM rating
		      GROUP BY mID) a);

--Q5.  Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than 
--     other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.) 

SELECT title, avg(stars)
FROM Movie join Rating using(mID)
GROUP BY title
HAVING avg(stars) =  (SELECT min(av2) FROM   --can use equality as well
		     (SELECT avg(stars) av2
		      FROM rating
		      GROUP BY mID) a);

--Q6.  For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, 
--     and the value of that rating. Ignore movies whose director is NULL. 

--     Two solutions
SELECT distinct director, title, stars
FROM Movie join Rating using(mID)
WHERE (director, stars) in (SELECT director, max(stars)
			    FROM Movie join Rating using(mID)
			    WHERE director is not null
			    GROUP BY director);

SELECT distinct director, title, stars
FROM (Movie join Rating using (mID)) m
WHERE stars in (SELECT max(stars) 
                FROM Rating join Movie using (mid) 
                WHERE m.director = director);
			    
		 