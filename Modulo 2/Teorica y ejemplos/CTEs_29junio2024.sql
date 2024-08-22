-- Repaso ejercicios - 29 JUNIO 2024

USE tienda;

SELECT city, COUNT(customer_number) AS clientasporciudad
FROM customers
GROUP BY city
HAVING COUNT(customer_number) = 5;

-- Con la anterior consulta, sustituimos el 5 por una subconsulta.
/*EJERCICIO 2:
Usando la consulta anterior como subconsulta, selecciona la ciudad con el mayor numero de clientes.
*/
SELECT city
FROM customers
GROUP BY city
HAVING COUNT(customer_number) >= ALL (
	SELECT COUNT(customer_number) AS clientasporciudad
	FROM customers
	GROUP BY city
);

/*EJERCICIO 3:
Por último, usa todas las consultas anteriores para seleccionar el customerNumber, nombre y apellido
 de las clientas asignadas a la ciudad con mayor numero de clientas.
*/

SELECT customer_number, contact_first_name, contact_last_name, city
FROM customers
WHERE city IN (
	SELECT city
	FROM customers
	GROUP BY city
	HAVING COUNT(customer_number) >= ALL (
		SELECT COUNT(customer_number) AS clientasporciudad
		FROM customers
		GROUP BY city
));


-- CTE: es como una tabla que solamente está temporalmente en la query que hacemos.
-- EXPRESIONES DE TABLAS COMUNES

WITH ciudadconmasclientas AS (SELECT city
FROM customers
GROUP BY city
HAVING COUNT(customer_number) >= ALL (SELECT COUNT(customer_number) AS clientasporciudad
FROM customers
GROUP BY city))

-- con una CTE queda así:
SELECT customer_number, contact_first_name, contact_last_name, city
FROM customers
WHERE city IN (SELECT * FROM ciudadconmasclientas);

-- OTRO EJEMPLO DE CTEs

-- EL CÓDIGO COMPLETO SERÍA ESTE:
select * , 'muchos' as cantidad from products
inner join product_lines
using (product_line)
where quantity_in_stock > 5000

union all 

select * , 'pocos' as cantidad from products
inner join product_lines
using (product_line)
where quantity_in_stock <= 5000;

WITH productJoin AS (
	SELECT * 
    FROM products
    INNER JOIN product_lines
    USING (product_line))

SELECT * FROM productJoin;

-- HACER LO MISMO USANDO CTE
WITH productJoin AS (
	SELECT * 
    FROM products
    INNER JOIN product_lines
    USING (product_line))
    
SELECT *, 'pocos' AS cantidad FROM productJoin WHERE quantity_in_stock <= 5000
UNION ALL 
SELECT *, 'muchos' AS cantidad FROM productJoin WHERE quantity_in_stock > 5000 ;
