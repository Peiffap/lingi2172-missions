1. List the names of all the countries.
```sql
SELECT name
FROM Country
```

2. List the names of all the mountains that exceed (strictly) 4000 meters in height.
```sql
SELECT M.name
FROM Mountain M
WHERE M.height > 4000
```

3. List the provinces of Belgium that have a population that doesn’t exceed one million; for each province, provide the name of the capital and the population.
```sql
SELECT P.capital, P.population
FROM Province P
WHERE P.population <= 1000000 AND P.country == 'B'
```

4. List the names of all languages in the database. The result must be a relation with one attribute called language.
```sql
SELECT DISTINCT name AS language
FROM Language
```

5. For each country that has declared independence, give its full name and its independence date.
```sql
SELECT C.name, I.independence
FROM Country C, Independence I
WHERE C.code == I.country
```

6. List all countries which are on two different continents. The result must be a relation defined with 3-tuple attributes {name, percentage, continent} where name is the name of the country.
```sql
SELECT C.name, E.percentage, E.continent
FROM Country C, Encompasses E
WHERE C.code == E.country AND E.percentage != 100
```

7. List the Swiss mountains with a height between 4400 and 4500. The result must be a relation composed of 2-tuples with attributes {mountain, height}.
```sql
SELECT M.name as mountain, M.height
FROM GeoMountain G, Mountain M
WHERE G.country == 'CH' AND G.mountain == M.name AND M.height >= 4400 AND M.height <= 4500
```

8. List all pairs of neighbouring countries. The result must be a relation composed of 2-tuples with attributes {name1, name2}, i.e., the full country names must be given. (For instance, a result could be {Belgium, France}.) Make sure that every pair of neighbouring countries is only included once.
```sql
SELECT C1.name as name1, C2.name as name2
FROM Borders B, Country C1, Country C2
WHERE B.country1 == C1.code AND B.country2 == C2.code AND C1.code < C2.code
```

9. List the name of the countries that do not have mountains.
```sql
SELECT C.name
FROM Country C
WHERE C.code NOT IN (SELECT G.country FROM GeoMountain G)
```

10. List all names that are shared by a province and a country.
```sql
SELECT name
FROM Country
INTERSECT
SELECT name
FROM Province
```

11. List the full names of the countries that border the United States, as well as the countries that border those bordering countries: i.e., the output should contain Mexico, but also Belize, which borders Mexico. The United States itself should not be part of the output.
```sql
SELECT C.name
FROM Country C, Borders B
WHERE B.country1 == 'USA' AND
      B.country2 == C.code
UNION
SELECT C1.name
FROM Country C1, Country C2, Borders B
WHERE B.country1 == C1.code AND
      B.country2 == C2.code AND
      C1.code != 'USA' AND
      C2.code IN (SELECT C.code
                  FROM Country C, Borders B
                  WHERE B.country1 == 'USA' AND
                  B.country2 == C.code)
```

12. Count the number of different ethnic groups. The result must be a relation composed by a 1-tuple attribute {cnt}.
```sql
SELECT COUNT(DISTINCT name) as cnt
FROM EthnicGroup
```

13. List the names of the countries with 3 mountains or less — including those with no mountains! The result must be a relation composed of 2-tuples with attributes {name, cnt}, where name is the name of the country and cnt is the number of mountains in the country.
```sql
SELECT name, cnt
FROM (SELECT DISTINCT C.name, COUNT(G.mountain) AS cnt
      FROM Country C, GeoMountain G
      WHERE G.country == C.code
      GROUP BY C.name)
WHERE cnt <= 3
UNION
SELECT C.name, 0 AS cnt
FROM Country C
WHERE C.code NOT IN (SELECT country FROM GeoMountain)
```

14. List the most prominent language(s) for each country; i.e., list for each country those languages for which the percentage is maximal. You are not allowed to use SUMMARIZE. The result must be a relation composed of 2-tuples with attributes {country, name}, where country is the code of the country and name is the name of the language.
```sql
SELECT C.code as country, L1.name
FROM Language L1, Country C
WHERE L1.percentage == (SELECT MAX(L.percentage)
                        FROM Language L
                        WHERE L.country == C.code)
      AND L1.country == C.code
```

15. In the given database the Borders relation is symmetric: if the country 1 (c1) borders country 2 (c2), country 2 also borders country 1. One may wish to check this property on a given database. Write a query that determines all tuples {c1, c2}, where c1 and c2 are the codes of the countries, for which the inverse direction is missing.
```sql
SELECT C1.code as c1, C2.code as c2
FROM Country C1, Country C2, Borders B
WHERE B.country1 == C1.code AND B.country2 == C2.code
      AND NOT EXISTS(SELECT * 
                     FROM Borders B
                     WHERE B.country1 = C2.code AND B.country2 = C1.code)
```