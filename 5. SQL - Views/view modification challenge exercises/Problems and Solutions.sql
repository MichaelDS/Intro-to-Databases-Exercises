/*You've started a new movie-rating website, and you've been collecting data on reviewers' ratings of various movies. Here's the schema:

Movie ( mID, title, year, director )
English: There is a movie with ID number mID, a title, a release year, and a director.

Reviewer ( rID, name )
English: The reviewer with ID number rID has a certain name.

Rating ( rID, mID, stars, ratingDate )
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate.

In addition to the base tables, you've created three views:

View LateRating contains movie ratings after January 20, 2011. The view contains the movie ID, movie title, number of stars, and rating date.

create view LateRating as
  select distinct R.mID, title, stars, ratingDate
  from Rating R, Movie M
  where R.mID = M.mID
  and ratingDate > '2011-01-20'

View HighlyRated contains movies with at least one rating above 3 stars. The view contains the movie ID and movie title. 

create view HighlyRated as
  select mID, title
  from Movie
  where mID in (select mID from Rating where stars > 3)

View NoRating contains movies with no ratings in the database. The view contains the movie ID and movie title.

create view NoRating as
  select mID, title
  from Movie
  where mID not in (select mID from Rating)   */


/*   Q1
(3 points possible)
Write a single instead-of trigger that enables simultaneous updates to attributes mID, title, and/or stars in view LateRating. Combine the view-update policies of the questions 1-3 in the core set, with the exception that mID may now be updated. Make sure the ratingDate attribute of view LateRating has not also been updated -- if it has been updated, don't make any changes.

    Remember you need to use an instead-of trigger for view modifications as supported by SQLite. */

CREATE trigger updateLR
instead of update on LateRating
for each row
when new.ratingDate = old.ratingDate
begin
  update Movie
  set mID = new.mID, title = new.title
  where mID = old.mID;

  update Rating
  set mID = new.mID
  where mID = old.mID;

  update Rating
  set stars = new.stars
  where mID = new.mID   --new.mID because this is happening after the update to Rating.mID
  and ratingDate = old.ratingDate;
end;

/* Q2
(3 points possible)
Write an instead-of trigger that enables insertions into view HighlyRated.

Policy: An insertion should be accepted only when the (mID,title) pair already exists in the Movie table. (Otherwise, do nothing.) Insertions into view HighlyRated should add a new rating for the inserted movie with rID = 201, stars = 5, and NULL ratingDate.

    Remember you need to use an instead-of trigger for view modifications as supported by SQLite. */

CREATE trigger insertHR
instead of insert on HighlyRated
for each row
when exists (SELECT mID, title
             FROM Movie
             WHERE mID = new.mID and title = new.title)
begin
  insert into Rating values(201, new.mID, 5, null);
end;

/* Q3
(3 points possible)
Write an instead-of trigger that enables insertions into view NoRating.

Policy: An insertion should be accepted only when the (mID,title) pair already exists in the Movie table. (Otherwise, do nothing.) Insertions into view NoRating should delete all ratings for the corresponding movie.

    Remember you need to use an instead-of trigger for view modifications as supported by SQLite. */

CREATE trigger insertNR
instead of insert on NoRating
for each row
when exists (SELECT *
             FROM Movie
             WHERE mID = new.mID and title = new.title)
begin
  delete from Rating
  where mID = new.mID;
end;