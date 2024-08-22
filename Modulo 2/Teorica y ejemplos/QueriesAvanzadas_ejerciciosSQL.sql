USE northwind;

-- 1. Productos más baratos y caros de nuestra BBDD.
-- Desde la división de productos nos piden conocer el precio de los productos que tienen el precio más alto y más bajo. Dales el alias lowestPrice y highestPrice.

SELECT MAX(unit_price) AS highestPrice, MIN(unit_price) AS lowestPrice
FROM products;

-- 2. Conociendo el numero de productos y su precio medio: Adicionalmente nos piden que diseñemos otra consulta para conocer el número de productos y el precio medio de todos ellos (en general, no por cada producto).

SELECT COUNT(product_id), AVG(unit_price) AS PrecioMedio
FROM products;

-- 3. Sacad la máxima y mínima carga de los pedidos de UK:

SELECT MAX(freight) AS MaximaCarga, MIN(freight) AS MinimaCarga
FROM orders
WHERE ship_country = "UK";

-- 4. Qué productos se venden por encima del precio medio:

SELECT avg(unit_price) as PrecioMedio  
FROM products;

SELECT DISTINCT product_name, unit_price  
FROM products 
WHERE unit_price > (28.86)  
ORDER BY unit_price DESC;

-- 5. Qué productos se han descontinuado:
SELECT COUNT(product_name)
FROM products
WHERE discontinued = 1;

-- 6. Detalles de los productos de la query anterior:
SELECT *
FROM products
WHERE discontinued = 0
ORDER BY product_id DESC
LIMIT 10;

-- 7. Relación entre número de pedidos y máxima carga:

SELECT employee_id, COUNT(order_id) AS NumeroPedidos, MAX(freight) AS MaximaCarga
FROM orders
GROUP BY employee_id;

-- 8. Descartar pedidos sin fecha y ordénalos:
SELECT employee_id, COUNT(order_id) AS NumeroPedidos, MAX(freight) AS MaximaCarga
FROM orders
WHERE shipped_date IS NOT NULL
GROUP BY employee_id;

-- 9. Números de pedidos por día:
SELECT COUNT(*) AS OrderCount, DAY(order_date) AS Dia, MONTH(order_date) AS Mes, YEAR(order_date) AS Anio
FROM orders
WHERE shipped_date IS NOT NULL
GROUP BY order_date
ORDER BY order_date;
 
-- 10. Número de pedidos por mes y año:

SELECT COUNT(*) AS OrderCount, MONTH(order_date) AS Mes, YEAR(order_date) AS Anio
FROM orders
WHERE shipped_date IS NOT NULL
GROUP BY 
    YEAR(order_date), 
    MONTH(order_date)
ORDER BY Anio, Mes;

-- 11. Seleccionad las ciudades con 4 o más empleadas:

SELECT em.territory_id AS IdCiudad, te.territory_description AS nombreCiudad
FROM employee_territories AS em
INNER JOIN territories AS te
ON em.territory_id = te.territory_id
WHERE em.territory_id > 4;

SELECT city, COUNT(employee_id) AS NumEmpleadas
FROM employees
GROUP BY city
HAVING COUNT(employee_id) >= 4;

-- 12. Cread una nueva columna basándonos en la cantidad monetaria:
-- Primero debemos agregar la columna: NO ES NECESARIO
ALTER TABLE order_details
ADD COLUMN cantidadMonteria VARCHAR(10);

SELECT order_id, SUM(unit_price * quantity) AS CantidadDinero,
CASE WHEN  SUM(unit_price * quantity) < 2000 THEN "Bajo"
	ELSE "Alto"
	END AS costes
    FROM order_details
GROUP BY order_id;