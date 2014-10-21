(: Q1  (3.0/3.0 points)
Return the names of all countries that have at least three cities with population greater than 3 million. :)

let $countries := doc("countries.xml")/countries/country
for $c in $countries
where count($c/city[data(population) > 3000000]) > 3
return $c/data(@name)

(: Q2  (3 points possible)
Create a list of French-speaking and German-speaking countries. The result should take the form: :)

let $countries := doc('countries.xml')/countries/country
let $french := $countries[language = 'French']/data(@name)
let $german := $countries[language = 'German']/data(@name)
return <result>
<French>
{
for $f in $french
return <country>{$f}</country>   
}
</French>
<German>
{
for $g in $german
return <country>{$g}</country>
}
</German>
</result>

(: Q3  (3 points possible)
Return the names of all countries containing a city such that some other country has a city of the same name. (Hint: You might want to use the "preceding" and/or "following" navigation axes for this query, which were not covered in the video or our demo script; they match any preceding or following node, not just siblings.) :)

for $c in doc("countries.xml")/countries/country/city
where $c/data(name) = $c/following::*/data(name) or
$c/data(name) = $c/preceding::*/data(name)
return $c/parent::country/data(@name)

(: Q4  (3 points possible)
Return the average number of languages spoken in countries where Russian is spoken. :)

let $countries := doc("countries.xml")//country
return avg($countries[data(language) = "Russian"]/count(language))

(: Q5  (3 points possible)
Return all country-language pairs where the language is spoken in the country and the name of the country textually contains the language name. Return each pair as a country element with language attribute, e.g.,<country language="French">French Guiana</country> :)

for $c in doc("countries.xml")//country
for $l in $c/language
where contains($c/data(@name), $l)
return <country language= "{data($l)}"> {$c/data(@name)} </country>

(: Q6  (3.0/3.0 points)
Return all countries that have at least one city with population greater than 7 million. For each one, return the country name along with the cities greater than 7 million, in the format: :)

let $countries := doc("countries.xml")/countries/country
for $c in $countries
where count($c/city[population > 7000000]) > 0
return <country name= "{$c/data(@name)}">
{
for $city in $c/city
where $city[population > 7000000]
return <big> {$city/data(name)} </big>
}
</country>

(: Q7  (3 points possible)
Return all countries where at least one language is listed, but the total percentage for all listed languages is less than 90%. Return the country element with its name attribute and its language subelements, but no other attributes or subelements. :)

for $c in doc("countries.xml")/countries/country
where count($c/language) > 0 and
sum($c/language/data(@percentage)) < 90
return <country name="{$c/data(@name)}">
{
for $l in $c/language
return $l
}
</country>

(: Q8  (3 points possible)
Return all countries where at least one language is listed, and every listed language is spoken by less than 20% of the population. Return the country element with its name attribute and its language subelements, but no other attributes or subelements. :)

for $c in doc("countries.xml")/countries/country[language]
where every $l in $c/language satisfies $l/data(@percentage) < 20
return <country name = "{$c/data(@name)}">
{
for $l in $c/language
return $l
}
</country>

(: Q9  (3.0/3.0 points)
Find all situations where one country's most popular language is another country's least popular, and both countries list more than one language. (Hint: You may need to explicitly cast percentages as floating-point numbers with xs:float() to get the correct answer.) Return the name of the language and the two countries, each in the format: :)

let $countries := doc("countries.xml")/countries/country[count(language) > 1],
$popular :=
for $c in $countries
for $l in $c/language
where xs:float($l/data(@percentage)) = xs:float(max($c/language/data(@percentage)))
return $l,
$unpopular :=
for $c in $countries
for $l in $c/language
where xs:float($l/data(@percentage)) = xs:float(min($c/language/data(@percentage)))
return $l
for $p in $popular
for $u in $unpopular
where data($p) = data($u)
return <LangPair language = "{data($p)}">
<MostPopular>{$p/parent::country/data(@name)}</MostPopular>
<LeastPopular>{$u/parent::country/data(@name)}</LeastPopular>
</LangPair>

(: Q10  (3.0/3.0 points)
For each language spoken in one or more countries, create a "language" element with a "name" attribute and one "country" subelement for each country in which the language is spoken. The "country" subelements should have two attributes: the country "name", and "speakers" containing the number of speakers of that language (based on language percentage and the country's population). Order the result by language name, and enclose the entire list in a single "languages" element. For example, your result might look like: :)
<languages>
  ...
  <language name="Arabic">
    <country name="Iran" speakers="660942"/>
    <country name="Saudi Arabia" speakers="19409058"/>
    <country name="Yemen" speakers="13483178"/>
  </language>
  ...
</languages>



let $countries := doc("countries.xml")/countries/country,
$languages := $countries/language,
$lang_names := distinct-values($countries/data(language))
return <languages>
{
for $ln in $lang_names
order by $ln
return <language name = "{$ln}">
{
for $l in $languages
where $ln = data($l)
return <country name = "{$l/parent::country/@name}" 
speakers = "{xs:int($l/parent::country/@population * $l/@percentage div 100)}"/>
}
</language>
}
</languages>




