1. List the top-10 of provinces for which the difference between the total number of items in purchases of the last 10 days and the preceding period of 10 days is the largest (i.e., the increase is large; we do not look for the largest decreases); list the full name of the province, the full name of the country, and the number of purchases in the last 10 days, as well as in the preceding period of 10 days; order the results by the size of the difference. Note that if there is no preceding period, the outcome is supposed to be empty.
```sql
WITH
Now AS(SELECT max(time) as time FROM Purchases),
Qty10 AS
(SELECT Pr.name as province, C.name as country, Sum(P.qty) as qty_last10
FROM Purchases P, Province Pr, Country C, Now N
WHERE Pr.rowid = P.province AND Pr.country = C.code AND
(P.time = DATE(N.time,'-9 day')
OR
P.time = DATE(N.time,'-8 day')
OR
P.time = DATE(N.time,'-7 day')
OR
P.time = DATE(N.time,'-6 day')
OR
P.time = DATE(N.time,'-5 day')
OR
P.time = DATE(N.time,'-4 day')
OR
P.time = DATE(N.time,'-3 day')
OR
P.time = DATE(N.time,'-2 day')
OR
P.time = DATE(N.time,'-1 day')
OR
P.time = DATE(N.time,'-0 day'))
GROUP BY province),
Qty1020 AS
(SELECT Pr.name as province, C.name as country, Sum(P.qty) as qty_1020
FROM Purchases P, Province Pr, Country C, Now N
WHERE Pr.rowid = P.province AND Pr.country = C.code AND
(P.time = DATE(N.time,'-19 day')
OR
P.time = DATE(N.time,'-18 day')
OR
P.time = DATE(N.time,'-17 day')
OR
P.time = DATE(N.time,'-16 day')
OR
P.time = DATE(N.time,'-15 day')
OR
P.time = DATE(N.time,'-14 day')
OR
P.time = DATE(N.time,'-13 day')
OR
P.time = DATE(N.time,'-12 day')
OR
P.time = DATE(N.time,'-11 day')
OR
P.time = DATE(N.time,'-10 day'))
GROUP BY province)
SELECT q10.province, q10.country, q10.qty_last10, q1020.qty_1020
FROM Qty10 q10, Qty1020 q1020
WHERE q10.province = q1020.province AND q10.country = q1020.country
ORDER BY q10.qty_last10 - q1020.qty_1020 DESC
LIMIT 10
```

2. Determine the 10 countries with the most purchases; list the names of these countries, as well as the number of purchases; sort the results in decreasing order of purchases.
```sql
SELECT C.name, count(id) as cnt
FROM Province P, Purchases Pr, Country C
WHERE P.rowid = Pr.province AND P.country = C.code
GROUP BY P.country
ORDER BY cnt DESC
LIMIT 10
```

3. Determine the total number of purchases for each product. List the number of the product, as well as the total number of purchases.
```sql
SELECT product, count(qty) as cnt
FROM Purchases
GROUP BY product
```

4. Determine for each country the province in which the total number of purchases of product 0 is the highest; list the name of the country, the name of the province, and the number of purchases, both absolute and as a proportion of the total number of purchases in that country. Order the outcome in decreasing order of the proportions.
```sql
WITH
Total AS (SELECT C.name, count(product) as tot
FROM Purchases P, Country C, Province Pr
WHERE P.product = 0 AND P.province = Pr.rowid AND Pr.country = C.code
GROUP BY C.name),
Prov AS
(SELECT C.name, Pr.name as province, count(product) as cnt
FROM Purchases P, Country C, Province Pr
WHERE P.product = 0 AND P.province = Pr.rowid AND Pr.country = C.code
GROUP BY Pr.rowid),
Partial AS
(SELECT Pr.name, max(Pr.cnt) as abs
FROM Prov Pr
GROUP BY Pr.name)
SELECT T.name as country, Pv.province, Pr.abs, CAST(Pr.abs AS FLOAT)/T.tot as prop
FROM Partial Pr, Prov Pv, Total T
WHERE T.name = Pr.name AND Pv.cnt = Pr.abs AND T.name = Pv.name
```

5. List for each continent and each possible number of items per purchase (in the range 1...10), the corresponding number of purchases. Only consider countries that are 100% located in their respective continents.
```sql
SELECT En.continent, P.qty, COUNT(P.qty) as cnt
FROM Purchases P, Encompasses En, Country C, Province Pr
WHERE Pr.rowid = P.province AND Pr.country = C.code AND En.country = C.code AND En.percentage = 100
GROUP BY En.continent, P.qty
```

6. Determine the total number of purchases for each product. List the number of the product, as well as the total number of purchases.
```sql
WITH
Now AS(SELECT max(time) as time FROM Purchases)
SELECT product, count(qty) as cnt
FROM Purchases P, Now N
WHERE 
P.time = DATE(N.time,'-9 day')
OR
P.time = DATE(N.time,'-8 day')
OR
P.time = DATE(N.time,'-7 day')
OR
P.time = DATE(N.time,'-6 day')
OR
P.time = DATE(N.time,'-5 day')
OR
P.time = DATE(N.time,'-4 day')
OR
P.time = DATE(N.time,'-3 day')
OR
P.time = DATE(N.time,'-2 day')
OR
P.time = DATE(N.time,'-1 day')
OR
P.time = DATE(N.time,'-0 day')
GROUP BY product
```

7. Determine the total number of purchases for each of the last ten days. List the date, as well as the total number of purchases.
```sql
WITH
Now AS(SELECT MAX(time) as time FROM Purchases)
SELECT P.time, COUNT(P.id) as cnt
FROM Purchases P, Now N
WHERE 
P.time = DATE(N.time,'-9 day')
OR
P.time = DATE(N.time,'-8 day')
OR
P.time = DATE(N.time,'-7 day')
OR
P.time = DATE(N.time,'-6 day')
OR
P.time = DATE(N.time,'-5 day')
OR
P.time = DATE(N.time,'-4 day')
OR
P.time = DATE(N.time,'-3 day')
OR
P.time = DATE(N.time,'-2 day')
OR
P.time = DATE(N.time,'-1 day')
OR
P.time = DATE(N.time,'-0 day')
Group By P.time 
```

8. Determine the identifiers of purchases performed in Brabant on the last day present in the database.
```sql
WITH
Now AS(SELECT MAX(time) as time FROM Purchases)
SELECT P.id as ids
FROM Purchases P, Now N, Province Pr
WHERE P.time == N.time AND P.province == Pr.rowid AND Pr.name = 'Brabant'
```

9. Determine the identifiers of purchases performed in Vienna on the last day present in the database.
```sql
WITH
Now AS(SELECT MAX(time) as time FROM Purchases)
SELECT P.id as ids
FROM Purchases P, Now N, Province Pr
WHERE P.time == N.time AND P.province == Pr.rowid AND Pr.name = 'Vienna'
```

10. List for each continent and each possible number of items per purchase (in the range 1...10), the corresponding number of purchases. Only consider countries that are 100% located in their respective continents. Note that the difference with the earlier question is that we only consider the last 10 days.```sql
WITH
Now AS(SELECT MAX(time) as time FROM Purchases)
SELECT En.continent, P.qty, COUNT(P.qty) as cnt
FROM Purchases P, Encompasses En, Country C, Province Pr, Now N
WHERE Pr.rowid = P.province AND Pr.country = C.code AND En.country = C.code AND En.percentage = 100 AND 
(P.time = DATE(N.time,'-9 day')
OR
P.time = DATE(N.time,'-8 day')
OR
P.time = DATE(N.time,'-7 day')
OR
P.time = DATE(N.time,'-6 day')
OR
P.time = DATE(N.time,'-5 day')
OR
P.time = DATE(N.time,'-4 day')
OR
P.time = DATE(N.time,'-3 day')
OR
P.time = DATE(N.time,'-2 day')
OR
P.time = DATE(N.time,'-1 day')
OR
P.time = DATE(N.time,'-0 day'))
GROUP BY En.continent, P.qty 
```

11. Optimize the mondial database. The statements given here will be executed at the beginning of the evaluation script. Here, you are expected to add statements for creating indexes and additional tables, based on the given ones in the mondial databases; these additional tables and indexes should help to answer the later queries faster.
```sql
SELECT product
FROM Purchases
```

12. Optimize the full database (mondial + Purchases). We will be adding batches of purchases to the initial empty database. After each batch of purchases is added, you may wish to (re)recreate tables based on these purchases (with corresponding indexes), in order to allow later queries to be executed more efficiently. Write queries for (re)creating such tables based on purchases here.
```sql
SELECT product
FROM Purchases
```
