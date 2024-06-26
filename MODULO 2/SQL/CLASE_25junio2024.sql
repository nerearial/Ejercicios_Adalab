-- UNION: Juntar queries, eliminando valores duplicados
-- UNION ALL, extraer todas las filas
-- IN: incluir valores dentro de un WHERE
-- NOT IN
-- LIKE: buscar por patrones más simplificados que Regex
-- NOT LIKE
-- REGEX: 

CREATE SCHEMA northwind;

USE northwind;

SELECT * FROM employees;
SELECT city FROM employees;

SELECT city from customers
UNION ALL
SELECT city from employees;

SELECT contact_name FROM customers
UNION
SELECT CONCAT(first_name, " ", last_name) AS contact_name FROM employees;

SELECT p.category_id, p.product_name, p.unit_price, c.category_name
FROM products AS p
INNER JOIN categories AS c
ON p.category_id = c.category_id;

-- probamos otro
SELECT p.category_id, p.product_name, p.unit_price, c.category_name
FROM products AS p
INNER JOIN categories AS c
ON p.category_id = c.category_id
WHERE c.category_name = "Condiments";

SELECT p.category_id, p.product_name, p.unit_price, c.category_name
FROM products AS p
INNER JOIN categories AS c
ON p.category_id = c.category_id
WHERE c.category_name IN ("Condiments","Beverages");

-- AHORA CON NOT IN
SELECT p.category_id, p.product_name, p.unit_price, c.category_name
FROM products AS p
INNER JOIN categories AS c
ON p.category_id = c.category_id
WHERE c.category_name NOT IN ("Condiments","Beverages");

-- LIKE AND NOT LIKE
SELECT p.category_id, p.product_name, p.unit_price, c.category_name
FROM products AS p
INNER JOIN categories AS c
ON p.category_id = c.category_id
WHERE c.category_name LIKE "S%"; -- aqui estamos poniendo que empiece por S

SELECT p.category_id, p.product_name, p.unit_price, c.category_name
FROM products AS p
INNER JOIN categories AS c
ON p.category_id = c.category_id
WHERE c.category_name REGEXP "S*"; -- Importante!! cuando se utiliza REGEX se utiliza su patrón