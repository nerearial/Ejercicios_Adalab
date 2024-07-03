-- PAIR PROGRAMMING SUBCONSULTAS

-- Primer ejercicio no hay subconsulta. 
-- Queries puente para hacer subqueries
-- HACER, 1, 4 Y 5. EL 2 Y EL 3 NO.

USE tienda;

-- 1. Calcula el nº de clientes para cada ciudad:
SELECT COUNT(customer_number) AS NumClientes, city
FROM customers
GROUP BY city
HAVING COUNT(customer_number)>0; -- Funcion de agregacion

-- 2. Ciudad con el mayor número de clientes

SELECT city AS Ciudad, NumeroClientes
FROM (
	SELECT city, COUNT(customer_number) AS NumeroClientes
	FROM customers
	GROUP BY city
)   AS patata
ORDER BY NumeroClientes DESC
LIMIT 1;

-- 3. Por último, usa todas las consultas anteriores para seleccionar el customerNumber, 
-- nombre y apellido de las clientas asignadas a la ciudad con mayor numero de clientas.

SELECT customer_number, contact_first_name AS Nombre, contact_last_name AS Apellido, city
	FROM customers
    WHERE city = (
        SELECT city
		FROM (
			SELECT city, COUNT(customer_number) AS NumeroClientes
			FROM customers
			GROUP BY city
			ORDER BY NumeroClientes DESC
			LIMIT 1
		)   AS patata
);


-- 4. Queremos ver ahora que empleados tienen algún contrato asignado con alguno de los clientes
-- existentes. Para ello selecciona employeeNumber como 'Número empleado', 
-- firstName como 'nombre Empleado' y lastName como 'Apellido Empleado'
    
SELECT employee_number AS NumeroEmpleado, first_name AS NombreEmpleado, last_name AS ApellidoEmpleado
FROM employees AS p1
WHERE employee_number IN (
	SELECT sales_rep_employee_number 
    FROM customers AS p2
    WHERE p1.employee_number = p2.sales_rep_employee_number
    );
    
-- 5. Queremos ver ahora en cuantas ciudades en las cuales tenemos clientes, 
-- no también una oficina de nuestra empresa para ello: Selecciona aquellas ciudades 
-- como 'ciudad' y los nombres de las empresas como 'nombre de la empresa ' de la 
-- tabla customers, sin repeticiones, que no tengan una oficina en dicha ciudad de la
-- tabla offices.

SELECT p1.city AS Ciudad, customer_name AS NombreEmpresa
FROM customers AS p1
WHERE p1.city NOT IN (
	SELECT p2.city
    FROM offices AS p2
    );