-- EJERCICIOS GITBOOK -- SUBCONSULTAS --
USE northwind;
-- 1. Extraed los pedidos con el máximo "order_date" para cada empleado.
-- Nuestro jefe quiere saber la fecha de los pedidos más recientes que ha gestionado cada empleado. Para eso nos pide que lo hagamos con una query correlacionada.

SELECT order_id AS OrderID, customer_id AS CustomerID, employee_id AS EmployeeID, order_date AS OrderDate, required_date AS RequiredDate
FROM orders AS o1
WHERE order_date = (
	SELECT MAX(order_date)
    FROM orders AS o2
    WHERE o2.employee_id = o1.employee_id
    );

-- 2. Extraed el precio unitario máximo (unit_price) de cada producto vendido.
-- Supongamos que ahora nuestro jefe quiere un informe de los productos vendidos y su precio unitario. De nuevo lo tendréis que hacer con queries correlacionadas.

SELECT DISTINCT product_id, MAX(unit_price)
FROM products AS a
WHERE unit_price IN (
	SELECT MAX(unit_price)
    FROM order_details AS b
    WHERE a.product_id = b.product_id
    )
GROUP BY product_id;

-- 3. Extraed información de los productos "Beverages"
-- En este caso nuestro jefe nos pide que le devolvamos toda la información necesaria para identificar un tipo de producto. 
-- En concreto, tienen especial interés por los productos con categoría "Beverages". Devuelve el ID del producto, el nombre del producto y su ID de categoría.

SELECT product_id, product_name, category_id
FROM products
WHERE category_id = (
	SELECT category_id
    FROM categories
    WHERE category_name = "Beverages"
    );
    
-- 4. Extraed la lista de países donde viven los clientes, pero no hay ningún proveedor ubicado en ese país
-- Suponemos que si se trata de ofrecer un mejor tiempo de entrega a los clientes, entonces podría dirigirse a estos países para buscar proveedores adicionales.

SELECT DISTINCT country
FROM customers
WHERE country NOT IN (
	SELECT country
	FROM suppliers
    );

-- 5. Extraer los clientes que compraron mas de 20 articulos "Grandma's Boysenberry Spread"
-- Extraed el OrderId y el nombre del cliente que pidieron más de 20 artículos del producto "Grandma's Boysenberry Spread" (ProductID 6) en un solo pedido.

SELECT order_id AS IDPedido, customer_id AS IDCliente
FROM orders AS o
WHERE (
	SELECT quantity
    FROM order_details AS ord
    INNER JOIN products AS pr 
		USING (product_id)
    WHERE 
		product_name = "Grandma's Boysenberry Spread"
		AND ord.order_id = o.order_id
    ) > 20;