-- EJERCICIOS CTEs GITBOOK -- 

USE northwind;


-- 1. Extraer en una CTE todos los nombres de las compañias y los id de los clientes.
-- Para empezar nos han mandado hacer una CTE muy sencilla el id del cliente y el nombre de la compañia de la tabla Customers.

WITH CTE1 AS (
	SELECT *
    FROM customers
    )

SELECT customer_id AS IdCliente, company_name AS Empresa FROM CTE1;

-- 2. Selecciona solo los de que vengan de "Germany"
-- Ampliemos un poco la query anterior. En este caso, queremos un resultado similar al anterior, pero solo queremos los que pertezcan a "Germany".

WITH CTE1 AS (
	SELECT *
    FROM customers
    )
    
SELECT customer_id AS IdCliente, company_name AS Empresa 
FROM CTE1
WHERE country = "Germany";

-- 3. Extraed el id de las facturas y su fecha de cada cliente.
-- En este caso queremos extraer todas las facturas que se han emitido a un cliente, su fecha la compañia a la que pertenece.
-- 📌 NOTA En este caso tendremos columnas con elementos repetidos(CustomerID, y Company Name).

WITH CTE2 AS (
	SELECT * 
    FROM orders
    )
    
SELECT  customers.customer_id, company_name, order_id, order_date
FROM customers
INNER JOIN CTE2 ON cte2.customer_id = customers.customer_id;

-- 4. Contad el número de facturas por cliente
-- Mejoremos la query anterior. En este caso queremos saber el número de facturas emitidas por cada cliente.

WITH CTE2 AS (
	SELECT * 
    FROM orders
    )
    
SELECT  customer_id, company_name, COUNT(order_id) AS numeroFacturas
FROM CTE2
INNER JOIN customers USING (customer_id)
GROUP BY customer_id;

-- 5. Cuál la cantidad media pedida de todos los productos ProductID.
-- Necesitaréis extraer la suma de las cantidades por cada producto y calcular la media.

WITH CTE2 AS (
	SELECT product_id, SUM(quantity) AS CantidadTotal
    FROM order_details
    GROUP BY product_id
    )
    
SELECT product_name, AVG(CantidadTotal) AS MediaPedida
FROM CTE2 
INNER JOIN products p ON CTE2.product_id = p.product_id
GROUP BY p.product_name
ORDER BY p.product_name;

-- BONUS: Estos ejercicios no es obligatorio realizarlos. Los podéis hacer más adelante para poder practicar las CTE´s.

-- Usando una CTE, extraer el nombre de las diferentes categorías de productos, con su precio medio, máximo y mínimo.

WITH precios AS (
	SELECT categories.*, products.unit_price
    FROM categories
    INNER JOIN products ON categories.category_id = products.category_id
    )

SELECT category_name, round(AVG(unit_price),2) AS PrecioMedio, round(MAX(unit_price),2) AS PrecioMaximo, round(MIN(unit_price),2) AS PrecioMinimo
FROM precios
GROUP BY category_name;

-- La empresa nos ha pedido que busquemos el nombre de cliente, su teléfono y el número de pedidos que ha hecho cada uno de ellos.

WITH ClientesPedidos AS (
	SELECT customers.company_name, customers.contact_name, customers.phone, orders.order_id
    FROM customers
    INNER JOIN orders ON customers.customer_id = orders.customer_id
    INNER JOIN order_details ON orders.order_id = order_details.order_id 
    )
    
SELECT company_name AS Empresa, contact_name AS Nombre, phone AS Teléfono, COUNT(order_id) AS NumeroPedidos
FROM ClientesPedidos
GROUP BY company_name, contact_name, phone;

-- Modifica la cte del ejercicio anterior, úsala en una subconsulta para saber el nombre del cliente y su teléfono, para aquellos clientes que hayan hecho más de 6 pedidos en el año 1998.

WITH ClientesPedidos AS (
	SELECT customers.company_name, customers.contact_name, customers.phone, orders.order_id
    FROM customers
    INNER JOIN orders ON customers.customer_id = orders.customer_id
    INNER JOIN order_details ON orders.order_id = order_details.order_id 
    WHERE YEAR(order_date) = 1998
    )
    
SELECT company_name AS Empresa, contact_name AS Nombre, phone AS Teléfono, COUNT(order_id) AS NumeroPedidos
FROM ClientesPedidos
GROUP BY company_name, contact_name, phone
HAVING COUNT(order_id) >6;
    
-- Modifica la consulta anterior para obtener los mismos resultados pero con los pedidos por año que ha hecho cada cliente.

WITH ClientesPedidos AS (
	SELECT order_date, customers.company_name, customers.contact_name, customers.phone, orders.order_id
    FROM customers
    INNER JOIN orders ON customers.customer_id = orders.customer_id
    INNER JOIN order_details ON orders.order_id = order_details.order_id 
    WHERE YEAR(order_date) = 1998
    )    
    
SELECT YEAR(order_date) AS Año, company_name AS Empresa, contact_name AS Nombre, phone AS Teléfono, COUNT(order_id) AS NumeroPedidos
FROM ClientesPedidos
GROUP BY YEAR(order_date), company_name, contact_name, phone
HAVING COUNT(order_id) >6;

