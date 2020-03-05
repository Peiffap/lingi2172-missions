1. For each continent, count the number of independent countries and sum all their area. The result must be a relation composed by a 3-tuple attributes {continent, cnt_countries, sum_area}.

```rel
(SUMMARIZE (Independence {country} JOIN Encompasses {continent, country} JOIN (Country {code, area} RENAME {code as country})) 
BY {continent} : { cnt_countries := COUNT(),  sum_area := SUM(area)}) 
UNION EXTEND ((Continent {name} RENAME {name as continent}) {continent} 
MINUS  
(SUMMARIZE (Independence {country} JOIN Encompasses {country, continent} JOIN (Country {code, area} RENAME {code as country})) 
By {continent} : { cnt_countries := COUNT(),  sum_area := SUM(area)}) {continent}) : {cnt_countries  := 0, sum_area:= 0.0}
```

2. List all mountains that are on a border. The result must be a relation composed by a 3-tuple attributes {mountain, country1, country2} where country1 and country2 are the names of the countries for which a frontier exist and mountain is the mountain located in the frontier.

```rel
((((GeoMountain {country, mountain} RENAME {country AS code})
JOIN (Country {code, name} RENAME {name AS country1})) {mountain, country1}) 
JOIN (((GeoMountain {country, mountain})
JOIN (Country {code, name} RENAME {code AS country, name AS country2})) {mountain, country2}) 
WHERE country1 < country2)
{mountain, country1, country2}
```

3. List all countries that have a mountain of height at least 5000, but no mountain of height higher than 7000. The result must be a relation composed by a 1-tuple attribute {country} where country is the code of the country.

```rel
(GeoMountain {country, mountain} JOIN (Mountain {name, height} RENAME {name as mountain}) WHERE height >= 5000.0) {country}
MINUS
(GeoMountain {country, mountain} JOIN (Mountain {name, height} RENAME {name as mountain}) WHERE height >= 7000.0) {country}
```

4. For all countries that have a bordering country with a province of more than 1.000.000 citizens, list the languages; provide the country code and the language name. The result must be a relation composed by a 2-tuple attributes {country, language} where country is the code of the country and language is the name of the language.

```rel
((Language {name, country} RENAME {name AS language})
MATCHING
(((Province {country, population} RENAME {country AS country1}) WHERE population >= 1000000) {country1}
JOIN
(Borders {country1, country2} RENAME {country2 AS country})) {country})
{country, language}
```

5. Luxembourg is in a specific topographic situation: it has exactly three neighboring countries (Belgium, Germany, and France), each of which are pairwise neighbors of each other as well. As a result, Luxembourg is surrounded by exactly three countries. List the abbreviations of all countries that are in a similar situation as Luxembourg. The result must be a relation composed by a 1-tuple attribute {country} where country is the code of the country.

```rel
WITH
(B := Borders {country1, country2}):

((((((SUMMARIZE B  BY {country1}: {cnt := COUNT()}
WHERE cnt = 3) {country1}
JOIN B)
JOIN (B
RENAME {country2 AS country3})) WHERE country3 > country2)
JOIN  (B RENAME {country2 AS country4})
WHERE country4 > country3) WHERE
COUNT(B RENAME {country1 AS c1, country2 AS c2}
WHERE c1 = country2 AND (c2 = country3 OR c2 = country4)) = 2
AND COUNT(B RENAME {country1 AS c1, country2 AS c2}
WHERE c1 = country3 AND c2 = country4) = 1) {country1} RENAME {country1 AS country}
```

6. List all codes for countries that have a total border length of at most 100.0, and a population of at least 5 million; in the calculation of border lengths, only borders of at least 50.0 should be considered.

```rel
(SUMMARIZE ((((Borders {country1, length} WHERE length >= 50.0) RENAME {country1 as code})
JOIN (Country {code, population} WHERE population >= 5000000)))
BY {code} : {len := SUM(length) } WHERE len <= 100.0) {code}
```

7. List all capitals of provinces that have at least twice the population of capitals of other provinces in the same country, or any neighboring country. The result must be a relation composed by a 3-tuple attributes {name, capital, country} where name is the name of the province, capital is the capital of the province and country is the code of the country.

```rel
WITH
 (C := Country {code} RENAME {code AS country},
  S := (SUMMARIZE (Province {country, population}) BY {country} : {pop := MAX(population)})):

((((SUMMARIZE ((C
MINUS
((S
JOIN
(Province {name, country, population})
WHERE pop <> population AND pop < 2*population) {country})) JOIN (Province {country, population}))
BY {country} : {pop := MAX(population)})
MINUS
((SUMMARIZE ((C
MINUS
((S
JOIN
(Province {name, country, population})
WHERE pop <> population AND pop < 2*population) {country})) JOIN (Province {country, population}))
BY {country} : {pop := MAX(population)})
JOIN
(Borders {country1} RENAME {country1 AS country})))
UNION
((SUMMARIZE ((C
MINUS
((S
JOIN
(Province {name, country, population})
WHERE pop <> population AND pop < 2*population) {country})) JOIN (Province {country, population}))
BY {country} : {pop := MAX(population)})
MINUS
(((SUMMARIZE ((C
MINUS
((S
JOIN
(Province {name, country, population})
WHERE pop <> population AND pop < 2*population) {country})) JOIN (Province {country, population}))
BY {country} : {pop := MAX(population)})
JOIN
(Borders {country1, country2} RENAME {country1 AS country})
JOIN
(Province {name, country, population} RENAME {country AS country2})
WHERE pop < 2*population) {country, pop})))
JOIN
(Province {name, capital, country, population})
WHERE pop = population)
{name, capital, country}
```