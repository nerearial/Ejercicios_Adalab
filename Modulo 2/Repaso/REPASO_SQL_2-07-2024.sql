-- EJERCICIOS REPASO

USE sakila;

-- JOINS -- 

-- 1. Obtener los clientes y las películas que han alquilado.

SELECT * FROM customer;

SELECT c.first_name AS Nombre, c.last_name AS Apellido, f.title AS NombrePeli
FROM customer AS c
INNER JOIN rental AS r
ON c.customer_id = r.customer_id
INNER JOIN inventory AS i 
ON r.inventory_id = i.inventory_id
INNER JOIN film AS f
ON i.film_id = f.film_id;

-- 2. Obtener los actores y las películas en las que han actuado.

SELECT CONCAT(first_name, " ", last_name) AS "Actor Full Name", title
FROM actor AS ac
LEFT JOIN film_actor AS f1
	ON ac.actor_id = f1.actor_id
INNER JOIN film AS f2
	ON f1.film_id = f2.film_id;

-- 3. Obtener todas las películas y, si están disponibles en inventario, mostrar la cantidad disponible.
SELECT title, COUNT(inv.film_id) AS Inventory
FROM film AS fi
INNER JOIN inventory AS inv
	ON fi.film_id = inv.film_id
GROUP BY title;

-- 4. Obtener todos los clientes y mostrar la cantidad de alquileres que han realizado, incluso si no han realizado ningún alquiler.

SELECT customer.first_name, customer.last_name, COUNT(rental_id) AS Alquilados
FROM customer
LEFT JOIN rental
	ON customer.customer_id = rental.customer_id
GROUP BY customer.first_name, customer.last_name
ORDER BY Alquilados DESC;

-- 5. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
SELECT film.title, actor.first_name, actor.last_name
FROM film_actor
RIGHT JOIN actor ON actor.actor_id = film_actor.actor_id
RIGHT JOIN film ON film_actor.film_id = film.film_id;

-- 6. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.

SELECT film.title, actor.first_name, actor.last_name
FROM film
RIGHT JOIN film_actor ON film.film_id = film_actor.film_id
RIGHT JOIN actor ON film_actor.actor_id = actor.actor_id;

-- LIKE, NOT LIKE, REGEXP 

-- 1. Encuentra todas las películas que comienzan con la letra "A" en su título.

SELECT film_id, title, description
FROM film
WHERE title LIKE "A%";

-- 2. Encuentra todas las películas que tienen al menos una vocal en su título.
SELECT title
FROM film
WHERE title LIKE "%a%" OR title LIKE "%e%" OR title LIKE "%i%" OR title LIKE "%o%" OR title LIKE "%u%";

-- REGEXP
SELECT title 
FROM film
WHERE title REGEXP "[aeiouAEOIU]";

-- 3. Encuentra todas las películas que tienen una longitud de título de al menos 10 caracteres.
SELECT title 
FROM film
WHERE title LIKE "__________";

-- REGEXP 
SELECT title
FROM film
WHERE title REGEXP ".{10,}";

-- 4. Encuentra todas las películas cuyo título contiene la palabra "The."

SELECT film_id, title, description
FROM film
WHERE title LIKE "%The%";

-- 5. Encuentra todas las películas cuyo título comienza con la letra "S."

SELECT title
FROM film
WHERE title LIKE "S%";

-- UNIONES --

-- 1. Encuentra todos los actores cuyos nombres comienzan con la letra "A" en la tabla actor, 
-- y encuentra todos los clientes cuyos nombres comienzan con la letra "B" en la tabla 
-- customer. Combina ambos conjuntos de resultados en una sola tabla.

SELECT first_name AS nombre
FROM actor
WHERE first_name LIKE "A%"
UNION
SELECT first_name
FROM customer
WHERE first_name LIKE "B%";

-- 2. Encuentra todas las películas cuyos títulos contienen la palabra "Comedy" en la tabla film, y encuentra todas las películas cuyo título comienza con la letra "D" en la misma tabla. 
-- Combina ambos conjuntos de resultados en una sola lista de películas.

SELECT title
FROM film
WHERE title LIKE "%Comedy%"

UNION

SELECT title
FROM film
WHERE title LIKE "D%";

-- SUBQUERIES -- SUBCONSULTAS --

-- 1. Encuentra el nombre y apellido de los actores que han actuado en películas que se
--  alquilaron después de que la película "ACADEMY DINOSAUR" se alquilara por primera vez. 
-- Ordena los resultados alfabéticamente por apellido.

-- Busco cuándo se alquiló la película "ACADEMY DINOSAUR" por primera vez:

SELECT rental.*, film_id
FROM rental
INNER JOIN inventory
USING (inventory_id);

SELECT title
FROM film_text
WHERE film_id IN (
	SELECT rental.*, film_id
	FROM rental
	INNER JOIN inventory
	USING (inventory_id)
    );
    
-- QUERY FINAL

SELECT actor_id, first_name, last_name, inventory_id
FROM actor
INNER JOIN film_actor
USING (actor_id)
INNER JOIN inventory
USING (film_id)
WHERE inventory_id IN (
	SELECT inventory_id -- seleccionamos el id del inventario
	FROM rental
	INNER JOIN inventory
	USING (inventory_id)
	WHERE rental_date > ( -- sacamos la fecha inicial de alquiler de la peli
		SELECT MIN(rental_date)
		FROM rental
		WHERE inventory_id IN (	-- Sacamos el film_id de la película
			SELECT inventory_id
			FROM inventory
			WHERE film_id = (
				SELECT film_id
				FROM film_text
				WHERE title = 'ACADEMY DINOSAUR'
                )	) ));
                
                
-- OTRA MANERA 

SELECT DISTINCT actor.first_name, actor.last_name 
    FROM rental
INNER JOIN film_actor 
    ON film.film_id = film_actor.film_id
INNER JOIN actor
    ON actor.actor_id = film_actor.actor_id
INNER JOIN inventory
    ON rental.inventory_id = inventory.inventory_id
INNER JOIN film
    ON inventory.film_id = film.film_id
WHERE rental_date > (SELECT min(rental_date) FROM rental
                        INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
                        INNER JOIN film ON film.film_id = inventory.film_id
                            WHERE title = "ACADEMY DINOSAUR")
ORDER BY actor.last_name, actor.first_name;

-- EJERCICIOS DE CTEs --

-- 1. Encuentra el nombre de los actores que han actuado en más películas y la cantidad de películas en las que han actuado.
-- LOS ACTORES QUE MÁS HAN ACTUADO EN MÁS PELÍCULAS

SELECT last_name, first_name, COUNT(DISTINCT film_id)
FROM actor AS a
INNER JOIN film_actor AS f
ON a.actor_id = f.actor_id
GROUP BY last_name, first_name;