/*
Lab 2 report <Abhijeet Anand (abhan872), Hussnain Khalid (huskh803) and Chayan Shrang Raj(chash345)>
*/

/* All non code should be within SQL-comments like this */ 


/*
Drop all user created tables that have been created when solving the lab
*/

DROP TABLE IF EXISTS jbcheapitems CASCADE;
DROP VIEW IF EXISTS view_cheap_avg_item;
DROP VIEW IF EXISTS view_total_cost_debit;
DROP VIEW IF EXISTS view_total_cost_debit_join;
DROP VIEW IF EXISTS jbsale_supply;


/* Have the source scripts in the file so it is easy to recreate!*/

SOURCE company_schema.sql;
SOURCE company_data.sql;


/* Question 1: List all employees, i.e., all tuples in the jbemployee relation. */
SELECT * from jbemployee;
/* Output:
+------+--------------------+--------+---------+-----------+-----------+----------+
| id   | name               | salary | manager | birthyear | startyear | startage |
+------+--------------------+--------+---------+-----------+-----------+----------+
|   10 | Ross, Stanley      |  15908 |     199 |      1927 |      1945 |     NULL |
|   11 | Ross, Stuart       |  12067 |    NULL |      1931 |      1932 |     NULL |
|   13 | Edwards, Peter     |   9000 |     199 |      1928 |      1958 |     NULL |
|   26 | Thompson, Bob      |  13000 |     199 |      1930 |      1970 |     NULL |
|   32 | Smythe, Carol      |   9050 |     199 |      1929 |      1967 |     NULL |
|   33 | Hayes, Evelyn      |  10100 |     199 |      1931 |      1963 |     NULL |
|   35 | Evans, Michael     |   5000 |      32 |      1952 |      1974 |     NULL |
|   37 | Raveen, Lemont     |  11985 |      26 |      1950 |      1974 |     NULL |
|   55 | James, Mary        |  12000 |     199 |      1920 |      1969 |     NULL |
|   98 | Williams, Judy     |   9000 |     199 |      1935 |      1969 |     NULL |
|  129 | Thomas, Tom        |  10000 |     199 |      1941 |      1962 |     NULL |
|  157 | Jones, Tim         |  12000 |     199 |      1940 |      1960 |     NULL |
|  199 | Bullock, J.D.      |  27000 |    NULL |      1920 |      1920 |     NULL |
|  215 | Collins, Joanne    |   7000 |      10 |      1950 |      1971 |     NULL |
|  430 | Brunet, Paul C.    |  17674 |     129 |      1938 |      1959 |     NULL |
|  843 | Schmidt, Herman    |  11204 |      26 |      1936 |      1956 |     NULL |
|  994 | Iwano, Masahiro    |  15641 |     129 |      1944 |      1970 |     NULL |
| 1110 | Smith, Paul        |   6000 |      33 |      1952 |      1973 |     NULL |
| 1330 | Onstad, Richard    |   8779 |      13 |      1952 |      1971 |     NULL |
| 1523 | Zugnoni, Arthur A. |  19868 |     129 |      1928 |      1949 |     NULL |
| 1639 | Choy, Wanda        |  11160 |      55 |      1947 |      1970 |     NULL |
| 2398 | Wallace, Maggie J. |   7880 |      26 |      1940 |      1959 |     NULL |
| 4901 | Bailey, Chas M.    |   8377 |      32 |      1956 |      1975 |     NULL |
| 5119 | Bono, Sonny        |  13621 |      55 |      1939 |      1963 |     NULL |
| 5219 | Schwarz, Jason B.  |  13374 |      33 |      1944 |      1959 |     NULL |
+------+--------------------+--------+---------+-----------+-----------+----------+
*/

/* Question 2: List the name of all departments in alphabetical order.
Note: by “name” we mean the name attribute in the jbdept relation. */
SELECT name FROM jbdept ORDER BY name ASC ;
/* Output:
+------------------+
| name             |
+------------------+
| Bargain          |
| Book             |
| Candy            |
| Children's       |
| Children's       |
| Furniture        |
| Giftwrap         |
| Jewelry          |
| Junior Miss      |
| Junior's         |
| Linens           |
| Major Appliances |
| Men's            |
| Sportswear       |
| Stationary       |
| Toys             |
| Women's          |
| Women's          |
| Women's          |
+------------------+
*/

/* Question 3: What parts are not in store?
Note that such parts have the value 0 (zero) for the qoh attribute (qoh = quantity on hand).  */
SELECT * FROM jbparts WHERE qoh=0;
/* Output:
+----+-------------------+-------+--------+------+
| id | name              | color | weight | qoh  |
+----+-------------------+-------+--------+------+
| 11 | card reader       | gray  |    327 |    0 |
| 12 | card punch        | gray  |    427 |    0 |
| 13 | paper tape reader | black |    107 |    0 |
| 14 | paper tape punch  | black |    147 |    0 |
+----+-------------------+-------+--------+------+
*/

/* Question 4: List all employees who have a salary between 9000 (included) and 10000 (included)? */
SELECT * FROM jbemployee WHERE salary<=10000 and salary>=9000;
/* Output:
+-----+----------------+--------+---------+-----------+-----------+
| id  | name           | salary | manager | birthyear | startyear |
+-----+----------------+--------+---------+-----------+-----------+
|  13 | Edwards, Peter |   9000 |     199 |      1928 |      1958 |
|  32 | Smythe, Carol  |   9050 |     199 |      1929 |      1967 |
|  98 | Williams, Judy |   9000 |     199 |      1935 |      1969 |
| 129 | Thomas, Tom    |  10000 |     199 |      1941 |      1962 |
+-----+----------------+--------+---------+-----------+-----------+

*/

/* Question 5: List all employees together with the age they had when they started working?
Hint: use the startyear attribute and calculate the age in the SELECT clause. */

ALTER TABLE jbemployee ADD startage int;
SELECT name, startyear, birthyear, (startyear - birthyear) as startage FROM jbemployee;
/* Output:
+--------------------+-----------+-----------+----------+
| name               | startyear | birthyear | startage |
+--------------------+-----------+-----------+----------+
| Ross, Stanley      |      1945 |      1927 |       18 |
| Ross, Stuart       |      1932 |      1931 |        1 |
| Edwards, Peter     |      1958 |      1928 |       30 |
| Thompson, Bob      |      1970 |      1930 |       40 |
| Smythe, Carol      |      1967 |      1929 |       38 |
| Hayes, Evelyn      |      1963 |      1931 |       32 |
| Evans, Michael     |      1974 |      1952 |       22 |
| Raveen, Lemont     |      1974 |      1950 |       24 |
| James, Mary        |      1969 |      1920 |       49 |
| Williams, Judy     |      1969 |      1935 |       34 |
| Thomas, Tom        |      1962 |      1941 |       21 |
| Jones, Tim         |      1960 |      1940 |       20 |
| Bullock, J.D.      |      1920 |      1920 |        0 |
| Collins, Joanne    |      1971 |      1950 |       21 |
| Brunet, Paul C.    |      1959 |      1938 |       21 |
| Schmidt, Herman    |      1956 |      1936 |       20 |
| Iwano, Masahiro    |      1970 |      1944 |       26 |
| Smith, Paul        |      1973 |      1952 |       21 |
| Onstad, Richard    |      1971 |      1952 |       19 |
| Zugnoni, Arthur A. |      1949 |      1928 |       21 |
| Choy, Wanda        |      1970 |      1947 |       23 |
| Wallace, Maggie J. |      1959 |      1940 |       19 |
| Bailey, Chas M.    |      1975 |      1956 |       19 |
| Bono, Sonny        |      1963 |      1939 |       24 |
| Schwarz, Jason B.  |      1959 |      1944 |       15 |
+--------------------+-----------+-----------+----------+

*/

/* Question 6:  List all employees who have a last name ending with “son”. */
SELECT * FROM jbemployee WHERE name like '%son,%';
/* Output:
+----+---------------+--------+---------+-----------+-----------+----------+
| id | name          | salary | manager | birthyear | startyear | startage |
+----+---------------+--------+---------+-----------+-----------+----------+
| 26 | Thompson, Bob |  13000 |     199 |      1930 |      1970 |     NULL |
+----+---------------+--------+---------+-----------+-----------+----------+
*/

/* Question 7: Which items (note items, not parts) have been delivered by a supplier called Fisher-Price?
Formulate this query by using a subquery in the WHERE clause*/
SELECT * FROM jbitem WHERE supplier = (SELECT id FROM jbsupplier WHERE name='Fisher-Price');
/* Output:
+-----+-----------------+------+-------+------+----------+----+--------------+------+
| id  | name            | dept | price | qoh  | supplier | id | name         | city |
+-----+-----------------+------+-------+------+----------+----+--------------+------+
|  43 | Maze            |   49 |   325 |  200 |       89 | 89 | Fisher-Price |   21 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 | 89 | Fisher-Price |   21 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 | 89 | Fisher-Price |   21 |
+-----+-----------------+------+-------+------+----------+----+--------------+------+
*/

/* Question 8: Formulate the same query as above, but without a subquery. */
SELECT * FROM jbitem i, jbsupplier s WHERE s.name = 'Fisher-Price' and s.id=i.supplier;
/* Output:
+-----+-----------------+------+-------+------+----------+----+--------------+------+
| id  | name            | dept | price | qoh  | supplier | id | name         | city |
+-----+-----------------+------+-------+------+----------+----+--------------+------+
|  43 | Maze            |   49 |   325 |  200 |       89 | 89 | Fisher-Price |   21 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 | 89 | Fisher-Price |   21 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 | 89 | Fisher-Price |   21 |
+-----+-----------------+------+-------+------+----------+----+--------------+------+
*/

/* Question 9: List all cities that have suppliers located in them.
Formulate this query using a subquery in the WHERE clause. */
SELECT * FROM jbcity j, jbsupplier s WHERE s.city = j.id;
/* Output:
+-----+----------------+-------+-----+--------------+------+
| id  | name           | state | id  | name         | city |
+-----+----------------+-------+-----+--------------+------+
| 921 | San Diego      | Calif |   5 | Amdahl       |  921 |
| 106 | White Plains   | Neb   |  15 | White Stag   |  106 |
| 118 | Hickville      | Okla  |  20 | Wormley      |  118 |
| 941 | San Francisco  | Calif |  33 | Levi-Strauss |  941 |
| 802 | Denver         | Colo  |  42 | Whitman's    |  802 |
| 303 | Atlanta        | Ga    |  62 | Data General |  303 |
| 841 | Salt Lake City | Utah  |  67 | Edger        |  841 |
|  21 | Boston         | Mass  |  89 | Fisher-Price |   21 |
| 981 | Seattle        | Wash  | 122 | White Paper  |  981 |
| 752 | Dallas         | Tex   | 125 | Playskool    |  752 |
| 900 | Los Angeles    | Calif | 199 | Koret        |  900 |
| 303 | Atlanta        | Ga    | 213 | Cannon       |  303 |
| 100 | New York       | NY    | 241 | IBM          |  100 |
| 609 | Paxton         | Ill   | 440 | Spooley      |  609 |
|  10 | Amherst        | Mass  | 475 | DEC          |   10 |
| 537 | Madison        | Wisc  | 999 | A E Neumann  |  537 |
+-----+----------------+-------+-----+--------------+------+
*/

/* Question 10: What is the name and the color of the parts that are heavier than a card reader?
Formulate this query using a subquery in the WHERE clause. (The query must not contain the weight of the card reader as a constant;
instead, the weight has to be retrieved within the query.) */
SELECT name, color FROM jbparts WHERE weight > (select weight from jbparts where name = 'card reader');
/* Output:
+--------------+--------+
| name         | color  |
+--------------+--------+
| disk drive   | black  |
| tape drive   | black  |
| line printer | yellow |
| card punch   | gray   |
+--------------+--------+
*/

/* Question 11: . Formulate the same query as above, but without a subquery.
Again, the query must not contain the weight of the card reader as a constant. */
SELECT p.name, p.color FROM jbparts p, jbparts j WHERE j.name = "card reader" and p.weight > j.weight;
/* Output:
+--------------+--------+
| name         | color  |
+--------------+--------+
| disk drive   | black  |
| tape drive   | black  |
| line printer | yellow |
| card punch   | gray   |
+--------------+--------+
*/

/* Question 12: What is the average weight of all black parts? */
SELECT AVG(weight) FROM jbparts where color='black';
/* Output:
+-------------+
| AVG(weight) |
+-------------+
|    347.2500 |
+-------------+
*/

/* Question 13: For every supplier in Massachusetts (“Mass”), retrieve the name and the total weight of all parts that the supplier has delivered? Do not forget to
take the quantity of delivered parts into account.
Note that one row should be returned for each supplier.
 */
SELECT sup.name, SUM(totalquan*weight) as totalweight FROM jbparts as parts, jbsupplier as sup, (
    SELECT supplier, part, SUM(quan) as totalquan FROM jbsupply where supplier in (
        SELECT id FROM jbsupplier WHERE city in (
            SELECT id FROM jbcity WHERE state='MASS'))
            GROUP BY supplier, part) as temp_table
            WHERE parts.id = temp_table.part and temp_table.supplier = sup.id 
            GROUP BY sup.name;

/* Output:
+--------------+-------------+
| name         | totalweight |
+--------------+-------------+
| DEC          |        3120 |
| Fisher-Price |     1135000 |
+--------------+-------------+
*/

/* Question 14: Create a new relation with the same attributes as the jbitems relation by using the CREATE TABLE command where you define every attribute
explicitly (i.e., not as a copy of another table). Then, populate this new relation with all items that cost less than the average price for all items.
Remember to define the primary key and foreign keys in your table!
*/
CREATE TABLE jbcheapitems (
	id int,
	name varchar(255),
	dept int,
	price int,
	qoh int,
	supplier int,
	CONSTRAINT primary key (id),
	CONSTRAINT deliver2 foreign key (supplier) references jbsupplier(id));

INSERT INTO jbcheapitems(id, name, dept, price, qoh, supplier)
SELECT * FROM jbitem j WHERE j.price < ( SELECT AVG(price) FROM jbitem);
SELECT * FROM jbcheapitems;
/* Output:
+-----+-----------------+------+-------+------+----------+
| id  | name            | dept | price | qoh  | supplier |
+-----+-----------------+------+-------+------+----------+
|  11 | Wash Cloth      |    1 |    75 |  575 |      213 |
|  19 | Bellbottoms     |   43 |   450 |  600 |       33 |
|  21 | ABC Blocks      |    1 |   198 |  405 |      125 |
|  23 | 1 lb Box        |   10 |   215 |  100 |       42 |
|  25 | 2 lb Box, Mix   |   10 |   450 |   75 |       42 |
|  26 | Earrings        |   14 |  1000 |   20 |      199 |
|  43 | Maze            |   49 |   325 |  200 |       89 |
| 106 | Clock Book      |   49 |   198 |  150 |      125 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 |
| 118 | Towels, Bath    |   26 |   250 | 1000 |      213 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 |
| 120 | Twin Sheet      |   26 |   800 |  750 |      213 |
| 165 | Jean            |   65 |   825 |  500 |       33 |
| 258 | Shirt           |   58 |   650 | 1200 |       33 |
+-----+-----------------+------+-------+------+----------+
*/

/* Question 15: Create a view that contains the items that cost less than the average price for items. */
CREATE VIEW view_cheap_avg_item AS
	SELECT * FROM jbitem
		WHERE price < (SELECT avg(price) FROM jbitem);
SELECT * FROM view_cheap_avg_item;
/* Output:
+-----+-----------------+------+-------+------+----------+
|  11 | Wash Cloth      |    1 |    75 |  575 |      213 |
|  19 | Bellbottoms     |   43 |   450 |  600 |       33 |
|  21 | ABC Blocks      |    1 |   198 |  405 |      125 |
|  23 | 1 lb Box        |   10 |   215 |  100 |       42 |
|  25 | 2 lb Box, Mix   |   10 |   450 |   75 |       42 |
|  26 | Earrings        |   14 |  1000 |   20 |      199 |
|  43 | Maze            |   49 |   325 |  200 |       89 |
|  52 | Jacket          |   60 |  3295 |  300 |       15 |
| 101 | Slacks          |   63 |  1600 |  325 |       15 |
| 106 | Clock Book      |   49 |   198 |  150 |      125 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 |
| 115 | Gold Ring       |   14 |  4995 |   10 |      199 |
| 118 | Towels, Bath    |   26 |   250 | 1000 |      213 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 |
| 120 | Twin Sheet      |   26 |   800 |  750 |      213 |
| 121 | Queen Sheet     |   26 |  1375 |  600 |      213 |
| 127 | Ski Jumpsuit    |   65 |  4350 |  125 |       15 |
| 165 | Jean            |   65 |   825 |  500 |       33 |
| 258 | Shirt           |   58 |   650 | 1200 |       33 |
| 301 | Boy's Jean Suit |   43 |  1250 |  500 |       33 |
+-----+-----------------+------+-------+------+----------+
*/

/* Question 16: What is the difference between a table and a view? One is static and the other is dynamic.
Which is which and what do we mean by static
respectively dynamic?

Answer:
A table is a database object that stores the data of a database and a view is a database object that allows generating a logical subset of data from one or more tables. 
Tables are static, and they are known as master tables that are populated with some data when created in databases in the system. 
Whereas views are virtual / logical tables used to view some parts of the real table so they are dependent on the tables hence they are dynamic.
*/

/* Question 17: Create a view that calculates the total cost of each debit, by considering price and quantity of each bought item. (To be used for charging
customer accounts). The view should contain the sale identifier (debit) and the total cost. In the query that defines the view, capture the join
condition in the WHERE clause (i.e., do not capture the join in the FROM clause by using keywords inner join, right join or left join). */
CREATE VIEW view_total_cost_debit AS
	SELECT js.debit, SUM(ji.price*js.quantity) AS totalcost
    FROM jbsale as js, jbitem as ji
		WHERE js.item = ji.id
        GROUP BY debit;
SELECT * FROM view_total_cost_debit;
/* Output:
+--------+-----------+
| debit  | totalcost |
+--------+-----------+
| 100581 |      2050 |
| 100582 |      1000 |
| 100586 |     13446 |
| 100592 |       650 |
| 100593 |       430 |
| 100594 |      3295 |
+--------+-----------+
*/

/* Question 18: Do the same as in the previous point, but now capture the join conditions in the FROM clause by using only left, right or inner joins. Hence, the
WHERE clause must not contain any join condition in this case. Motivate why you use type of join you do (left, right or inner), and why this is the
correct one (in contrast to the other types of joins).
 */
CREATE VIEW view_total_cost_debit_join AS
	SELECT js.debit, SUM(ji.price*js.quantity) AS totalcost
    FROM jbsale AS js INNER JOIN jbitem as ji ON js.item = ji.id
        GROUP BY debit;
SELECT * FROM view_total_cost_debit_join;
/* Output:
+--------+-----------+
| debit  | totalcost |
+--------+-----------+
| 100581 |      2050 |
| 100582 |      1000 |
| 100586 |     13446 |
| 100592 |       650 |
| 100593 |       430 |
| 100594 |      3295 |
+--------+-----------+
*/

/*
Inner join is used to join the sale of item and item id.
As debit is a foreign key attribute from the jbdebit to jbitem table therefore all the debited items are present in the item master table.
So its easy to use INNER join in this case. 
*/

/* Question 19: Remove all suppliers in Los Angeles from the jbsupplier table. This will not work right away. Instead, you will receive an error with error
code 23000 which you will have to solve by deleting some other related tuples. However, do not delete more tuples from other tables
than necessary, and do not change the structure of the tables (i.e., do not remove foreign keys). Also, you are only allowed to use “Los
Angeles” as a constant in your queries, not “199” or “900”.
 */
/* Delete tuple from jbsale */
DELETE FROM jbsale 
WHERE
    item IN (SELECT jbitem.id
		FROM jbitem
            INNER JOIN
				jbsupplier ON jbsupplier.id = jbitem.supplier
            INNER JOIN
				jbcity ON jbcity.id = jbsupplier.city
			WHERE
				jbcity.name = 'Los Angeles');

/* Delete tuple from the jbitem */    
DELETE FROM jbitem 
WHERE
    supplier IN (SELECT  jbsupplier.id
		FROM jbsupplier
            INNER JOIN
				jbcity ON jbcity.id = jbsupplier.city
			WHERE
				jbcity.name = 'Los Angeles');

/* Delete tuple from jbsupply */
DELETE FROM jbsupply 
WHERE
    supplier IN (SELECT  jbsupplier.id
			FROM jbsupplier
				INNER JOIN
					jbcity ON jbcity.id = jbsupplier.city
				WHERE
					jbcity.name = 'Los Angeles');

/* Delete tuple from jbcheapitems */
DELETE FROM jbcheapitems
WHERE
    supplier IN (SELECT  jbsupplier.id
			FROM jbsupplier
				INNER JOIN
					jbcity ON jbcity.id = jbsupplier.city
				WHERE
					jbcity.name = 'Los Angeles');

/* Delete tuple from jbsupplier */
DELETE FROM jbsupplier 
WHERE
    city = (SELECT id
		FROM jbcity
			WHERE name = 'Los Angeles');
SELECT * FROM jbsupplier;
/* Output:
+-----+--------------+------+
| id  | name         | city |
+-----+--------------+------+
|   5 | Amdahl       |  921 |
|  15 | White Stag   |  106 |
|  20 | Wormley      |  118 |
|  33 | Levi-Strauss |  941 |
|  42 | Whitman's    |  802 |
|  62 | Data General |  303 |
|  67 | Edger        |  841 |
|  89 | Fisher-Price |   21 |
| 122 | White Paper  |  981 |
| 125 | Playskool    |  752 |
| 213 | Cannon       |  303 |
| 241 | IBM          |  100 |
| 440 | Spooley      |  609 |
| 475 | DEC          |   10 |
| 999 | A E Neumann  |  537 |
+-----+--------------+------+
*/

/*
In order to remove the supplier from the database. We have to delete all the data that is related to supplier, item and sale connected to the city.
By removing the tuples in the jbsale, jbitem, jbsupply, and jbcheapitems we can than remove the supplier from Los Angeles in jbsupplier table.
*/

/* Question 20: An employee has tried to find out which suppliers have delivered items that have been sold. To this end, the employee has created a view and
a query that lists the number of items sold from a supplier. */
CREATE VIEW jbsale_supply(supplier, item, item_supplied, item_sold) AS
    SELECT 
        jbsupplier.name, jbitem.name, jbitem.qoh, jbsale.quantity
    FROM
        jbsupplier
            INNER JOIN
				jbitem ON jbsupplier.id = jbitem.supplier
            LEFT OUTER JOIN
				jbsale ON jbsale.item = jbitem.id;

SELECT  supplier, SUM(item_supplied) AS total_supplied, SUM(item_sold) AS total_sold
FROM jbsale_supply
GROUP BY jbsale_supply.supplier;
/* Output:
+--------------+----------------+------------+
| supplier     | total_supplied | total_sold |
+--------------+----------------+------------+
| Cannon       |           2925 |          6 |
| Fisher-Price |            825 |       NULL |
| Levi-Strauss |           2800 |          1 |
| Playskool    |            555 |          2 |
| White Stag   |            750 |          4 |
| Whitman's    |            175 |          2 |
+--------------+----------------+------------+
*/

