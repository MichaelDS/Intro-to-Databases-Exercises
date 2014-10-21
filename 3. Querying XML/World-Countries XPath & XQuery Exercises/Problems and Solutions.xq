(: Q1  (2.0/2.0 points)
Return the area of Mongolia. 
Reminder: To return the value of an attribute attr, you must use data(@attr), although just @attr may be used in comparisons. You will need to remember this for some later questions as well. :)

doc("countries.xml")/countries/country[@name = "Mongolia"]/data(@area)

or
 
doc("countries.xml")//country[@name = "Mongolia"]/data(@area)

(: Q2  (2.0/2.0 points)
Return the names of all cities that have the same name as the country in which they are located. :)

for $co in doc("countries.xml")/countries/country
for $ci in $co/city
where $ci/name = $co/@name
return $ci/name

or

for $b in doc("countries.xml")//country
for $c in $b/city
where $c/name = $b/@name
return $c/name

(: Q3  (2.0/2.0 points)
Return the average population of Russian-speaking countries.  :)

doc("countries.xml")/countries/avg(country[language="Russian"]/data(@population))

or

avg(doc("countries.xml")//country[language="Russian"]/data(@population))

(: Q4  (2.0/2.0 points)
Return the names of all countries where over 50% of the population speaks German. (Hint: Depending on your solution, you may want to use ".", which refers to the "current element" within an XPath expression.) :)

let $countries := doc("countries.xml")/countries
return $countries//language[data(.) = 'German' and @percentage > 50]/parent::country/data(@name)

(: Q5  (2.0/2.0 points)
Return the name of the country with the highest population. (Hint: You may need to explicitly cast population numbers as integers with xs:int() to get the correct answer.) :)

let $countries := doc("countries.xml")/countries
return $countries/country[@population =  max($countries/country/data(@population))]/data(@name)

or

let $countries := doc('countries.xml')/countries
return $countries/*[@population =  max($countries/country/data(@population))]/data(@name)
