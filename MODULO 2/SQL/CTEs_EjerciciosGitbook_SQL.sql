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
	SELECT SUM(o2.quantity) AS CantidadTotal
    FROM orders as o1
    INNER JOIN order_details AS o2
    GROUP BY order_id
    )
    
SELECT AVG(CantidadTotal) AS MediaPedida, product_name
FROM CTE2 
INNER JOIN products USING (product_id);