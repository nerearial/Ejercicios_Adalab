USE northwind;

-- 1. Pedidos por empresa en UK: Desde las oficinas en UK nos han pedido con urgencia que 
-- realicemos una consulta a la base de datos con la que podamos conocer cuántos pedidos 
-- ha realizado cada empresa cliente de UK. Nos piden el ID del cliente y el nombre de la 
-- empresa y el número de pedidos.

SELECT cu.company_name AS NombreEmpresa, cu.customer_id AS Identificador, COUNT(ord.order_id) AS NumeroPedidos
FROM customers AS cu
LEFT JOIN orders AS ord
ON cu.customer_id = ord.customer_id
WHERE ship_country = "UK"
GROUP BY cu.customer_id;

-- 2. Productos pedidos por empresa en UK por año: Desde Reino Unido se quedaron muy contentas 
-- con nuestra rápida respuesta a su petición anterior y han decidido pedirnos una serie de consultas adicionales. La primera de ellas 
-- consiste en una query que nos sirva para conocer cuántos objetos ha pedido cada empresa 
-- cliente de UK durante cada año. Nos piden concretamente conocer el nombre de la empresa, 
-- el año, y la cantidad de objetos que han pedido. Para ello hará falta hacer 2 joins.

-- Cuántos objetos ha pedido cada empresa

SELECT cu.company_name AS NombreEmpresa, YEAR(ord.order_date) AS Año, SUM(orc.quantity) AS NumObjetos
FROM orders as ord
	INNER JOIN order_details AS orc ON ord.order_id = orc.order_id
	INNER JOIN customers AS cu ON cu.customer_id = ord.customer_id
WHERE cu.country = 'UK'
GROUP BY cu.company_name, Año
ORDER BY cu.company_name, Año;

-- 3. Mejorad la query anterior: Lo siguiente que nos han pedido es la misma consulta anterior pero con la adición de la cantidad de dinero
-- que han pedido por esa cantidad de objetos, teniendo en cuenta los descuentos, etc. Ojo que los descuentos en nuestra tabla nos salen en porcentajes, 15% nos sale como 0.15.

SELECT cu.company_name AS NombreEmpresa, YEAR(ord.order_date) AS Año, SUM(orc.quantity) AS NumObjetos, SUM(orc.quantity * orc.unit_price * ( 1 - orc.discount) ) AS PrecioPedido
FROM orders as ord
	INNER JOIN order_details AS orc ON ord.order_id = orc.order_id
	INNER JOIN customers AS cu ON cu.customer_id = ord.customer_id
    INNER JOIN products AS pr ON pr.product_id = orc.product_id
WHERE cu.country = 'UK'
GROUP BY cu.company_name, Año
ORDER BY cu.company_name, Año, PrecioPedido;

-- 4. BONUS: Pedidos que han realizado cada compañía y su fecha:
-- Después de estas solicitudes desde UK y gracias a la utilidad de los resultados que se han obtenido, 
-- desde la central nos han pedido una consulta que indique el nombre de cada compañia cliente junto con cada pedido que han realizado y su fecha.

SELECT DISTINCT ord.order_id AS OrderID, cu.company_name AS NombreEmpresa, ord.order_date AS OrderDate
FROM orders as ord
	INNER JOIN order_details AS orc ON ord.order_id = orc.order_id
	INNER JOIN customers AS cu ON cu.customer_id = ord.customer_id;
-- WHERE cu.country = 'UK';

-- 5. BONUS: Tipos de producto vendidos:
-- Ahora nos piden una lista con cada tipo de producto que se han vendido, sus categorías, nombre de la categoría y el nombre del producto, 
-- y el total de dinero por el que se ha vendido cada tipo de producto (teniendo en cuenta los descuentos).

SELECT pr.product_name AS Productos, ca.category_name AS Categoría, round(SUM(orc.quantity * orc.unit_price * ( 1 - orc.discount) ),2) AS PrecioPedido
FROM products AS pr
	INNER JOIN categories AS ca ON pr.category_id = ca.category_id
    INNER JOIN order_details AS orc ON pr.product_id = orc.product_id
GROUP BY ca.category_name, ca.category_id, pr.product_name;
-- ORDER BY ca.category_id, pr.product_id;

-- 6. Qué empresas tenemos en la BBDD Northwind:
-- Lo primero que queremos hacer es obtener una consulta SQL que nos devuelva el nombre de todas las empresas cliente, los ID de sus pedidos y las fechas.

SELECT DISTINCT ord.order_id AS IdPedido, cu.company_name AS EmpresaCliente, ord.order_date AS FechaPedido
FROM customers AS cu
LEFT JOIN orders AS ord ON cu.customer_id = ord.customer_id
ORDER BY cu.company_name, ord.order_id;

-- 7. Pedidos por cliente de UK:
-- Desde la oficina de Reino Unido (UK) nos solicitan información acerca del número de pedidos que ha realizado cada cliente del propio Reino Unido de cara a conocerlos mejor 
-- y poder adaptarse al mercado actual. Especificamente nos piden el nombre de cada compañía cliente junto con el número de pedidos.

SELECT cu.company_name AS EmpresaCliente,  COUNT(ord.order_id) AS NumeroPedidos
FROM customers AS cu
LEFT JOIN orders AS ord ON cu.customer_id = ord.customer_id
WHERE country = "UK"
GROUP BY cu.company_name;


-- 8. Empresas de UK y sus pedidos:
-- También nos han pedido que obtengamos todos los nombres de las empresas cliente de Reino Unido (tengan pedidos o no) junto con los ID de todos los pedidos que han realizado 
-- y la fecha del pedido.

SELECT DISTINCT ord.order_id AS IdPedido, cu.company_name AS EmpresaCliente, ord.order_date AS FechaPedido
FROM customers AS cu
LEFT JOIN orders AS ord ON cu.customer_id = ord.customer_id
WHERE country = "UK"
ORDER BY cu.company_name, ord.order_id;

-- 9. Empleadas que sean de la misma ciudad:
-- Ejercicio de SELF JOIN: Desde recursos humanos nos piden realizar una consulta que muestre por pantalla los datos de todas las empleadas y sus supervisoras. 
-- Concretamente nos piden: la ubicación, nombre, y apellido tanto de las empleadas como de las jefas. Investiga el resultado, ¿sabes decir quién es el director?

SELECT 
	a.city AS CiudadEmpleado, 
    a.first_name AS NombreEmpleada, a.last_name AS ApellidoEmpleada, b.city AS CiudadSupervisor,
    b.reports_to AS IdSupervisor, b.first_name AS NombreJefe,  b.last_name AS ApellidoJefe
FROM employees AS A, employees as B
WHERE A.reports_to = B.employee_id
ORDER BY a.city, b.city;

-- 10. BONUS: FULL OUTER JOIN
-- Pedidos y empresas con pedidos asociados o no:
-- Selecciona todos los pedidos, tengan empresa asociada o no, y todas las empresas tengan pedidos asociados o no. 
-- Muestra el ID del pedido, el nombre de la empresa y la fecha del pedido (si existe).

SELECT order_id, company_name, order_date
FROM orders AS ord
NATURAL JOIN customers AS cu
WHERE cu.country = 'UK';

SELECT orders.order_id, customers.company_name AS NombreCliente, orders.order_date AS FechaPedido  
FROM orders RIGHT JOIN customers   
ON customers.customer_id = orders.customer_id
WHERE customers.country = 'UK'  

UNION  

SELECT orders.order_id, customers.company_name AS NombreCliente, orders.order_date AS FechaPedido  
FROM orders LEFT JOIN customers  
ON customers.customer_id = orders.customer_id
WHERE customers.country = 'UK';