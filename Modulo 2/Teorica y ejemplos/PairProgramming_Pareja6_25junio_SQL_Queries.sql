-- EJERCICIOS PAIR PROGRAMMING - 25 JUNIO DE 2024

USE tienda;

SELECT * 
FROM customers
LIMIT 10;

SELECT * 
FROM employees
LIMIT 10;

-- 1. Selecciona los apellidos que se encuentren en ambas tablas para employees y customers, con alias 'Apellidos'.

SELECT contact_last_name AS Apellidos
FROM customers
UNION
SELECT last_name AS Apellidos
FROM employees;

-- 2. Selecciona los nombres con alias 'nombre' y apellidos, con alias 'Apellidos' tanto de los clientes como de los empleados de las tablas employees y customers.
SELECT first_name AS Nombre, last_name AS Apellido
FROM employees
UNION ALL
SELECT contact_last_name
FROM customers;

SELECT CONCAT(contact_first_name, " ", first_name) AS Nombre, last_name AS Apellidos
-- SELECT cu.contact_first_name AS Nombre, em.first_name AS Nombre, em.last_name AS Apellidos
FROM employees AS em
INNER JOIN customers AS cu
ON cu.sales_rep_employee_number = em.employee_number;

-- ON em.employee_number = cu.sales_rep_employee_number;

-- 3. Selecciona todos los nombres con alias 'nombre' y apellidos, con alias 'Apellidos' tanto de los clientes como de los empleados de las tablas employees y customers.
SELECT CONCAT(contact_first_name, " ", contact_last_name) AS Apellidos
FROM customers
UNION ALL
SELECT CONCAT(first_name, " ", last_name) AS Apellidos
FROM employees;

-- 4. Queremos ver ahora el employee_number como 'Número empleado', first_n_ame como 'nombre Empleado' y last_name como 'Apellido Empleado' para los empleados con employee_number: 1002,1076,1088 y 1612.
SELECT employee_number AS "Número empleado", first_name AS "nombre Empleado", last_name AS "Apellido Empleado"
FROM employees
WHERE employee_number IN (1002, 1076, 1088, 1612);

-- 5. Queremos ver ahora la 'ciudad' y los nombres de las empresas como 'nombre de la empresa ' de la tabla customers, que no estén en: Ireland, France, Germany.
SELECT city AS Ciudad, customer_name AS "Nombre de la empresa"
FROM customers
WHERE country NOT IN ("Ireland", "France", "Germany");

-- 6. Encuentra los campos nombre del cliente y ciudad, de aquellas ciudades de la tabla de customers que terminen en 'on'.
SELECT customer_name AS "Nombre cliente", city AS Ciudad
FROM customers
WHERE city LIKE "%ON";

SELECT customer_name AS "Nombre cliente", city AS Ciudad
FROM customers
WHERE city REGEXP "on$";

-- 7. Encuentra los campos nombre del cliente, ciudad de aquellas ciudades de la tabla de customers que terminen en 'on' y que unicamente sean de longitud 4.
SELECT customer_name AS "Nombre cliente", city AS Ciudad
FROM customers
WHERE city LIKE "__on";

-- 8. Encuentra el nombre del cliente, primera dirección y ciudad de aquellas ciudades que contengan el número 3 en su dirección postal (o lo que es lo mismo, su primera dirección).
SELECT customer_name AS "Nombre cliente", address_line1 AS "Primera dirección", city AS Ciudad, postal_code
FROM customers
WHERE postal_code LIKE "%3%";

-- 9. Encuentra el nombre del cliente, primera dirección y ciudad de aquellas ciudades que contengan el número 3 en su dirección postal y la ciudad no empiece por T.
SELECT customer_name AS "Nombre cliente", address_line1 AS "Primera dirección", city AS Ciudad, postal_code
FROM customers
WHERE postal_code NOT LIKE "T_" AND postal_code LIKE "%3%";

-- 10. Selecciona, haciendo uso de expresiones regulares, los campos nombre del cliente, primera dirección y ciudad. Unicamente en el caso que la dirección postal, posea algún número en dicho campo.
SELECT customer_name AS "Nombre cliente", address_line1 AS "Primera dirección", city AS Ciudad, postal_code
FROM customers
WHERE address_line1 REGEXP "\d";

-- CON LIKE
SELECT customer_name AS "Nombre cliente", address_line1 AS "Primera dirección", city AS Ciudad, postal_code
FROM customers
WHERE address_line1 LIKE '%0%' OR
      address_line1 LIKE '%1%' OR
      address_line1 LIKE '%2%' OR
      address_line1 LIKE '%3%' OR
      address_line1 LIKE '%4%' OR
      address_line1 LIKE '%5%' OR
      address_line1 LIKE '%6%' OR
      address_line1 LIKE '%7%' OR
      address_line1 LIKE '%8%' OR
      address_line1 LIKE '%9%';
