1. List the full names of countries that border Poland and are 100% located in Europe.
```cypher
MATCH (Continent {name: "Europe"}) - [Encompasses {percentage: "100.0"}] - (c:Country) <- [Borders] - (Country {name:"Poland"})
RETURN c.name
```

2. List the pairs of countries that neighbor Russia, and that are also neighbors of each other. Provide the full names of both countries; only list the pairs in which the first name of the pair is strictly lower than the second name in the pair.
```cypher
MATCH (c1: Country) <- [:Borders] - (Country {name: "Russia"}) - [:Borders] -> (c2: Country) - [Borders] -> (c3: Country)
WHERE c1.name = c3.name AND c1.name < c2.name
RETURN c1.name, c2.name
```

3. Provide the full names of all countries that are 100% located in Europe, but that border a country located (not, or not entirely located) in Europe.
```cypher
MATCH (cont: Continent) - [:Encompasses] -> (c2: Country) - [Borders] -> (c1: Country) <- [:Encompasses {percentage: "100.0"}] - (Continent {name: "Europe"})
WHERE cont.name <> "Europe"
RETURN c1.name
```

4. Provide the full names of all countries that can be reached in at most two steps from the United States, excluding the United States itself. Make sure to include every country in the output only once.
```cypher
MATCH (Country {name: "United States"}) - [Borders*1..2] -> (c: Country)
WHERE c.name <> "United States"
RETURN c.name
```

5. List the number of neighboring countries for every country in Europe (i.e., this is the degree of every country in Europe, when only considering the Borders relation). Provide for each country the full name, and its degree. Sort the output in decreasing order of degree.
```cypher
MATCH (c:Country) <- [Encompasses] - (Continent {name: "Europe"})
WITH c, size((c) - [:Borders] -> ()) AS degree
RETURN c.name, degree
ORDER BY degree DESC
```

6. Find the country with the largest number of neighbors; if there are multiple such countries, it is allowed to break ties arbitrarily; provide the full name and the number of neighbors.
```cypher
MATCH (c:Country)
WITH c, size((c) - [:Borders] -> ()) AS degree
RETURN c.name, degree
ORDER BY degree DESC
LIMIT 1
```

7. Determine the shortest path from Belgium to China; provide the complete path, that is, all nodes and edges on this path, starting from Belgium and ending in China.
```cypher
MATCH path = shortestPath((:Country {name: "Belgium"}) - [*] -> (:Country {name: "China"}))
RETURN path
```

8. Find the country which has the longest shortest path to Belgium; provide the full name of this country.
```cypher
MATCH (c: Country), path = shortestPath((c) - [*] -> (:Country {name: "Belgium"}))
WHERE c.name <> "Belgium"
RETURN c.name
ORDER BY length(path) DESC
LIMIT 1
```

9. Luxembourg is in a specific topographic situation: it has exactly three neighboring countries (Belgium, Germany, and France), each of which are pairwise neighbors of each other as well. As a result, Luxembourg is surrounded by exactly three countries. List the full names of all countries that are in a similar situation as Luxembourg.
```cypher
MATCH (c1: Country) - [:Borders] -> (c2: Country) - [:Borders] -> (c3: Country)
MATCH (c1: Country) - [:Borders] -> (c3: Country) - [:Borders] -> (c4: Country)
MATCH (c1: Country) - [:Borders] -> (c4: Country) - [:Borders] -> (c2: Country)
WITH c1, size((c1) - [:Borders] -> ()) AS degree
WHERE degree = 3
RETURN DISTINCT c1.name
```

10. List all countries in Europe for which there is no path of length in between 1 and 3 to a country (partially) located in Asia.
```cypher
MATCH (:Continent {name: "Europe"}) - [:Encompasses] -> (c1: Country)
MATCH (:Continent {name: "Asia"}) - [:Encompasses] -> (c2: Country)
WHERE c1.name <> c2.name
MATCH (:Continent {name: "Europe"}) - [:Encompasses] -> (c0: Country)
MATCH path = shortestPath((c1) - [*1..3] -> (c2))
WITH collect(DISTINCT c0.name) AS europeanCountries, collect(DISTINCT c1.name) AS closeCountries
UNWIND [x IN (europeanCountries) WHERE NOT(x in (closeCountries))] AS n
RETURN n
```
