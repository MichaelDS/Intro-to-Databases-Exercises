(: Q1  (2.0/2.0 points)
Return all Title elements (of both departments and courses). :)

doc("courses.xml")//Title

(: Q2  (2.0/2.0 points)
Return last names of all department chairs. :)

doc("courses.xml")/Course_Catalog/Department/Chair/Professor/Last_Name
or
doc("courses.xml")//Chair//Last_Name

(: Q3  (2.0/2.0 points)
Return titles of courses with enrollment greater than 500. :)

doc("courses.xml")/Course_Catalog/Department/Course[data(@Enrollment) > 500]/Title
or
doc("courses.xml")//Course[data(@Enrollment)>500]/Title

(: Q4  (2.0/2.0 points)
Return titles of departments that have some course that takes "CS106B" as a prerequisite. :)

doc("courses.xml")//Department[Course/Prerequisites/Prereq = "CS106B"]/Title
or
doc("courses.xml")/Course_Catalog/Department[Course/Prerequisites/Prereq="CS106B"]/Title

(: Q5  (2.0/2.0 points)
Return last names of all professors or lecturers who use a middle initial. Don't worry about eliminating duplicates. :)

doc("courses.xml")//(Professor | Lecturer)[Middle_Initial]/Last_Name

(: Q6  (2.0/2.0 points)
Return the count of courses that have a cross-listed course (i.e., that have "Cross-listed" in their description). :)

doc("courses.xml")/Course_Catalog/count(Department/Course[contains(Description,"Cross-listed")])

(: Q7  (2.0/2.0 points)
Return the average enrollment of all courses in the CS department.  :)

doc("courses.xml")/Course_Catalog/Department[@Code = "CS"]/avg(Course/@Enrollment)
or
doc("courses.xml")//Department[@Code="CS"]/avg(Course/@Enrollment)

(: Q8  (2.0/2.0 points)
Return last names of instructors teaching at least one course that has "system" in its description and enrollment greater than 100. :)

doc("courses.xml")/Course_Catalog/Department/Course[@Enrollment > 100 and contains(Description, "system")]/Instructors//Last_Name
or
doc("courses.xml")//Course[@Enrollment>100 and contains(Description,"system")]/Instructors//Last_Name

