1. List the names of all the countries.
	(Country {name})

2. List the names of all the mountains that exceed (strictly) 4000 meters in height.
	(Mountain {height, name} WHERE height > 4000.0) {name}

3. List the provinces of Belgium that have a population that doesn’t exceed one million; for each province, provide the name of the capital and the population.
	(Province {capital, population, country} WHERE population <= 1000000 AND country = "B") {capital, population}

4. List the names of all languages in the database. The result must be a relation with one attribute called language.
	(Language {name} RENAME {name AS language})

5. For each country that has declared independence, give its full name and its independence date.
	((Independence {independence, country} RENAME {country as code}) JOIN (Country {code, name})) {name, independence}

6. List all countries which are on two different continents. The result must be a relation defined with 3-tuple attributes {name, percentage, continent} where name is the name of the country.
	(((Encompasses {country, continent, percentage} RENAME {country as code}) JOIN (Country {name, code})) WHERE percentage < 100.0) {name, percentage, continent}

7. List the Swiss mountains with a height between 4400 and 4500. The result must be a relation composed of 2-tuples with attributes {mountain, height}.
	(((GeoMountain {mountain, country} WHERE country = "CH") JOIN (Mountain {name, height} RENAME {name AS mountain}) WHERE height <= 4500.0 AND height >= 4400.0)) {mountain, height}

8. List all pairs of neighbouring countries. The result must be a relation composed of 2-tuples with attributes {name1, name2}, i.e., the full country names must be given. (For instance, a result could be {Belgium, France}.) Make sure that every pair of neighbouring countries is only included once.
	((Borders {country1, country2}) JOIN (((Country {name, code} RENAME {code AS country1, name AS name1}) JOIN (Country {name, code} RENAME {code AS country2, name AS name2})) WHERE country1 < country2)) {name1, name2}

9. List the name of the countries that do not have mountains.
	(Country {name, code} JOIN (Country {code}) NOT MATCHING (GeoMountain {country} RENAME {country AS code})) {name}

10. List all names that are shared by a province and a country.
	(Country {name}) INTERSECT (Province {name})

11. List the full names of the countries that border the United States, as well as the countries that border those bordering countries: i.e., the output should contain Mexico, but also Belize, which borders Mexico. The United States itself should not be part of the output.
	(((Borders {country1, country2} WHERE country1 = "USA") JOIN (Country {name, code} RENAME {code AS country2})) {name}) UNION ((Country {code, name} RENAME {code AS country1} JOIN (Borders MATCHING ((Borders WHERE country1 = "USA") {country2}) WHERE country1 <> "USA")) {name})

12. Count the number of different ethnic groups. The result must be a relation composed by a 1-tuple attribute {cnt}.
	RELATION {TUPLE {cnt COUNT((EthnicGroup {name}))}}

13. List the names of the countries with 3 mountains or less — including those with no mountains! The result must be a relation composed of 2-tuples with attributes {name, cnt}, where name is the name of the country and cnt is the number of mountains in the country.
	(SUMMARIZE (GeoMountain {country, mountain}) PER (Country {name, code} RENAME {code AS country}) : {cnt := COUNT()} WHERE cnt <= 3) {name, cnt}

14. List the most prominent language(s) for each country; i.e., list for each country those languages for which the percentage is maximal. You are not allowed to use SUMMARIZE. The result must be a relation composed of 2-tuples with attributes {country, name}, where country is the code of the country and name is the name of the language.
	(((Language JOIN (Country {code} RENAME {code AS country})) WHERE percentage = MAX(((Language {percentage, country} RENAME {country AS c})) WHERE c = country, percentage))) {country, name}

15. In the given database the Borders relation is symmetric: if the country 1 (c1) borders country 2 (c2), country 2 also borders country 1. One may wish to check this property on a given database. Write a query that determines all tuples {c1, c2}, where c1 and c2 are the codes of the countries, for which the inverse direction is missing.
	((Borders {country1, country2} RENAME {country1 AS c1, country2 AS c2}) NOT MATCHING (Borders {country2, country1} RENAME {country1 AS c2, country2 AS c1}))