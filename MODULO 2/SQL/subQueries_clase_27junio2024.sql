-- SUBQUERIES - SUBCONSULTAS

USE northwind;

SELECT * FROM products LIMIT 10;

SELECT round(AVG(unit_price),2)
FROM products;

SELECT *
FROM products
WHERE unit_price > 28.87;

-- LO CORRECTO SERÍA:
SELECT *
FROM products
WHERE unit_price > 
	(SELECT round(AVG(unit_price),2) 
    FROM products);
    
-- Vamos a buscar todos los productos de las categorías mencionadas:
SELECT * FROM categories;

SELECT *
FROM categories
WHERE category_name IN ("Confections","Condiments");

SELECT * 
FROM products
WHERE category_id IN (2,3);

SELECT * 
FROM products
WHERE category_id IN (
	SELECT category_id 
    FROM categories 
    WHERE category_name IN ("Confections","Condiments")
    );
    
-- SUBCONSULTAS CORRELACIONADAS

-- Vamos a seleccionar los productos de la categoría 1, que su precio
-- sea superior a la media de su categoría:

SELECT AVG(unit_price)
FROM products
WHERE category_id = 1;

SELECT *
FROM products
WHERE category_id = 1 AND unit_price > 37.97;

SELECT * 
FROM products AS p1
WHERE unit_price >
	(SELECT AVG(unit_price)
	FROM products AS p2
	WHERE p1.category_id = p2.category_id)

