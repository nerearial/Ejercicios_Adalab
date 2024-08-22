
-- 1 Extraer en una CTE todos los nombres de las compañias y los id de los clientes.
-- Para empezar nos han mandado hacer una CTE muy sencilla el id del cliente y el nombre de la compañia de la tabla Customers.

USE northwind;

SELECT customer_id, company_name
FROM customers
ORDER BY company_name;

-- 2. Selecciona solo los de que vengan de "Germany"
-- Ampliemos un poco la query anterior. En este caso, queremos un resultado similar al anterior, pero solo queremos los que pertezcan a "Germany".

SELECT customer_id, company_name
FROM customers
WHERE country = "Germany"
ORDER BY company_name;

-- 3. Extraed el id de las facturas y su fecha de cada cliente.
-- En este caso queremos extraer todas las facturas que se han emitido a un cliente, su fecha la compañia a la que pertenece.
-- NOTA En este caso tendremos columnas con elementos repetidos(CustomerID, y Company Name).

SELECT c.customer_id, c.company_name, o.order_id, o.order_date
FROM customers as c
INNER JOIN orders AS o
ON c.customer_id = o.customer_id
WHERE country = "Germany"
ORDER BY c.company_name;

-- HACER LO MISMO USANDO CTE
WITH facturasCliente AS (
	SELECT c.customer_id, c.company_name, o.order_id, o.order_date
FROM customers as c
INNER JOIN orders AS o
ON c.customer_id = o.customer_id
WHERE country = "Germany"
ORDER BY c.company_name
)
    
SELECT * FROM facturasCliente;

-- 4. Contad el número de facturas por cliente. Mejoremos la query anterior. En este caso queremos saber el número de facturas emitidas por cada cliente.

WITH NumfacturasCliente AS (
    SELECT COUNT(o.order_id) AS NumPedidos, c.customer_id, c.company_name
    FROM customers AS c
    INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
    WHERE c.country = "Germany"
    GROUP BY c.customer_id, c.company_name
)

SELECT customer_id, NumPedidos, company_name
FROM NumfacturasCliente
ORDER BY company_name;

-- 5. Cuál la cantidad media pedida de todos los productos ProductID.
-- Necesitaréis extraer la suma de las cantidades por cada producto y calcular la media.

WITH total_productos AS (
    SELECT product_id, SUM(quantity) AS cantidadTotalEmpresa
    FROM order_details
	GROUP BY product_id
)
    
SELECT AVG(cantidadTotalEmpresa) AS Cantidad_media
FROM total_productos;

--  Estos ejercicios no es obligatorio realizarlos. 
-- Los podéis hacer más adelante para poder practicar las CTE´s.

-- Usando una CTE, extraer el nombre de las diferentes categorías de productos, 
-- con su precio medio, máximo y mínimo.

WITH CTE1 AS (
	SELECT product_name, unit_price
    FROM products
    )
    
SELECT product_name, MAX(unit_price) AS PrecioMáximo, AVG(unit_price) AS PrecioMedio, MIN(unit_price) AS PrecioMinimo
FROM CTE1
GROUP BY product_name;

with tabla as(
	select c.*, p.unit_price 
    from products as p 
	inner join categories as c
	on p.category_id = c.category_id)
    
select category_name, round(avg(unit_price),2) as media, max(unit_price) as max, min(unit_price) as min
from tabla
group by category_name ;

-- 7. La empresa nos ha pedido que busquemos el nombre de cliente, su teléfono y 
-- el número de pedidos que ha hecho cada uno de ellos.

WITH datoCliente AS (
	SELECT *
    FROM orders AS o
    NATURAL JOIN customers AS c
    )

SELECT COUNT(*) AS TotalPedidos, contact_name, phone
FROM (
		WITH TABLA AS (
			SELECT * 
            FROM orders AS o