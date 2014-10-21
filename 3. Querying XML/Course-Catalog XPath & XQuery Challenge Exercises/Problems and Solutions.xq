: Q1  (3.0/3.0 points)
Return the title of the course with the largest enrollment.  :

doc("courses.xml")//Course[@Enrollment = max(doc("courses.xml")//Course/@Enrollment)]/Title

: Q2  (3 points possible)
Return course numbers of courses that have the same title as some other course. (Hint: You might want to use the "preceding" and "following" navigation axes for this query, which were not covered in the video or our demo script; they match any preceding or following node, not just siblings.) :

let $courses := doc("courses.xml")//Course
for $c in $courses
where $c/data(Title) = $c/following::*/data(Title) or
$c/data(Title) = $c/preceding::*/data(Title)
return $c/data(@Number)

: Q3  (3 points possible)
Return the number (count) of courses that have no lecturers as instructors. :

let $courses := doc('courses.xml')//Course
return count(
for $c in $courses
where count($c/Instructors/Lecturer) = 0
return $c)

: Q4  (3 points possible)
Return titles of courses taught by the chair of a department. For this question, you may assume that all professors have distinct last names.  :

for $c in doc("courses.xml")//Course
where $c//Professor/Last_Name = $c/parent::Department/Chair/Professor/Last_Name
return $c/Title

: Q5  (3 points possible)
Return titles of courses taught by a professor with the last name "Ng" but not by a professor with the last name "Thrun".  :

for $c in doc("courses.xml")//Course
where count($c//Professor[Last_Name = "Thrun"]) = 0
and $c//Professor[Last_Name = "Ng"]
return $c/Title

: Q6  (3 points possible)
Return course numbers of courses that have a course taught by Eric Roberts as a prerequisite. :

for $cpre in doc("courses.xml")//Course
for $c in doc("courses.xml")//Course
where $cpre//First_Name = "Eric"
and $cpre//Last_Name = "Roberts"
and $c/Prerequisites/data(Prereq) = $cpre/data(@Number)
return $c/data(@Number)

: Q7  (3 points possible)
Create a summary of CS classes: List all CS department courses in order of enrollment. For each course include only its Enrollment (as an attribute) and its Title (as a subelement). :

let $c := doc("courses.xml")//Department[@Code = "CS"]/Course
return <Summary>
{
for $summarize in $c
order by xs:int($summarize/@Enrollment)
return <Course Enrollment = "{$summarize/data(@Enrollment)}">{$summarize/Title}</Course>
}

: Q8  (3 points possible)
Return a "Professors" element that contains as subelements a listing of all professors in all departments, sorted by last name with each professor appearing once. The "Professor" subelements should have the same structure as in the original data. For this question, you may assume that all professors have distinct last names. Watch out -- the presence/absence of middle initials may require some special handling. (This problem is quite challenging; congratulations if you get it right.) :

let $professors := doc("courses.xml")//Professor
let $distinctProf := (
      $professors except (
        for $p in $professors
          where ($p/Last_Name = $p/following::*/Last_Name and $p/First_Name = $p/following::*/First_Name)
          return $p
      )
    )

return <Professors>
  {
    for $p in $distinctProf
    order by $p/Last_Name
    return $p
  }
  </Professors>
