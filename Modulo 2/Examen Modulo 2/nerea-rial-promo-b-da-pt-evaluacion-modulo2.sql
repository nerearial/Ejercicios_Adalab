-- EVALUACIÓN FINAL MÓDULO 2 --

-- NEREA RIAL CONDE - PROMO B 

-- EJERCICIOS - BASE DE DATOS SAKILA

USE sakila;

--  1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title
FROM film;

-- 2.  Muestra los nombres de todas las películas que tengan una clasificación de "PG-13"

SELECT DISTINCT title -- PREGUNTAR A SARA SI ES BUENA PRÁCTICA UTILIZAR EL DISTINCT EN ESTAS CONSULTAS TODAS.
FROM film
WHERE rating = "PG-13";

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción

SELECT title, description
FROM film
WHERE description LIKE "%amazing%";

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos
SELECT title
FROM film
WHERE length > 120;

-- 5. Recupera los nombres de todos los actores
SELECT CONCAT(first_name," ", last_name) AS "Actor Full Name"
FROM actor;

-- 6.  Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE "Gibson"; -- Usamos LIKE porque puede ser que contenga algo más que Gibson

-- 7.  Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20
SELECT actor_id, CONCAT(first_name," ", last_name) AS ActorFullName
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación
SELECT title, rating 
FROM film
WHERE rating NOT IN ("R","PG-13");

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

SELECT rating, COUNT(film_id) AS TotalFilms
FROM film
GROUP BY rating;

-- 10.  Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT CONCAT(first_name," ", last_name) AS CustomerFullName, cu.customer_id, COUNT(rental_id) AS TotalRentals
FROM customer
	AS cu
INNER JOIN rental AS re
	ON cu.customer_id = re.customer_id
GROUP BY cu.customer_id;

-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT ca.name AS Category, COUNT(DISTINCT f1.film_id) AS TotalRentals
FROM rental AS re
	INNER JOIN inventory AS inv
		ON re.inventory_id = inv.inventory_id
	INNER JOIN film_category AS fc
		ON inv.film_id = fc.film_id
	INNER JOIN category AS ca
		ON fc.category_id = ca.category_id
	INNER JOIN film AS f1
		ON fc.film_id = f1.film_id
GROUP BY ca.name;

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT round(AVG(length),2) AS AverageLenght, rating
FROM film 
GROUP BY rating;

-- 13.  Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love"

WITH FilmsbyActor AS (
	SELECT fi.actor_id, film_id, first_name, last_name
    FROM film_actor AS fi
    INNER JOIN actor AS act
		ON fi.actor_id = act.actor_id
        )

SELECT CONCAT(first_name, " ", last_name) As "Actor Full Name"
FROM FilmsbyActor
INNER JOIN film USING (film_id)
WHERE title = "Indian Love";

-- 14.  Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción
        
SELECT title, description
FROM film
WHERE description LIKE "%dog" OR description LIKE "%cat%";

-- 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor

SELECT CONCAT(first_name, " ", last_name) AS ActorFullName
FROM actor
WHERE actor_id NOT IN (
	SELECT actor_id
    FROM film_actor);
    
-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010

SELECT title, release_year
FROM film
WHERE release_year BETWEEN 2005 AND 2010;
    
-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family"

WITH categoryNames AS (
	SELECT flm.title, ca.name
    FROM category AS ca
    INNER JOIN film_category AS fi 
		ON ca.category_id = fi.category_id
	INNER JOIN film AS flm
		ON fi.film_id = flm.film_id
	)
        
SELECT title
FROM categorynames
WHERE name = "Family";

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas

SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
	SELECT actor_id
    FROM film_actor
    GROUP BY actor_id 
    HAVING COUNT(film_id) > 10);

-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film

SELECT title
FROM film
WHERE rating = "R" AND length > 120;

-- 20.  Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración

SELECT ca.name AS Category, AVG(fi.length) AS AverageByCategory
FROM film AS fi
INNER JOIN film_category AS flc 
	ON fi.film_id = flc.film_id
INNER JOIN category AS ca
	ON ca.category_id = flc.category_id
GROUP BY ca.name
HAVING AVG(fi.length) > 120;

-- 21.  Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado

WITH CountingFilms AS (
	SELECT film_actor.film_id, actor.first_name, actor.last_name
    FROM film_actor
    INNER JOIN actor 
		USING (actor_id)
        )

SELECT CONCAT(first_name, " ", last_name) AS ActorFullName, COUNT(film_id) AS CountFilm
FROM CountingFilms
GROUP BY ActorFullName
HAVING COUNT(film_id) >5
ORDER BY COUNT(film_id) DESC;

-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes

SELECT title
FROM film
WHERE film_id IN (
	SELECT film_id
    FROM inventory
    INNER JOIN rental USING (inventory_id)
    WHERE DATEDIFF(return_date, rental_date) > 5
);

-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror".  Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" 
-- y luego exclúyelos de la lista de actores.

SELECT first_name, last_name
FROM actor AS act
WHERE act.actor_id NOT IN (
	SELECT fl.actor_id
    FROM film_actor AS fl
    INNER JOIN film AS f1
		ON f1.film_id = fl.film_id
    INNER JOIN film_category AS fi
		ON fl.film_id = fi.film_id
    INNER JOIN category AS ca 
		ON fi.category_id = ca.category_id
	WHERE ca.name = "Horror"
    );

-- BONUS

-- 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.

SELECT title, length, ca.name
FROM film AS fi
INNER JOIN film_category AS fl 
	ON fi.film_id = fl.film_id
INNER JOIN category AS ca
	ON fl.category_id = ca.category_id
WHERE 
	fi.length > 180 -- Choosing the films that have a length greater than 180 minutes
    AND
	ca.name = "Comedy";

-- 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.

SELECT 
	title, 
    CONCAT(a1.first_name, " ", a1.last_name) AS Actor1,  
    CONCAT(a2.first_name, " ", a2.last_name) AS Actor2,
	COUNT(fi.film_id) AS MoviesTogether
FROM actor AS a1
INNER JOIN film_actor AS fa1 
	ON a1.actor_id = fa1.actor_id -- conecto la tabla actor 1 con la tabla film_actor
INNER JOIN film AS fi
	ON fa1.film_id = fi.film_id -- conecto el primer film_actor con peliculas
INNER JOIN film_actor AS fa2 
	ON fi.film_id = fa2.film_id -- conecto la segunda film_actor con peliculas
INNER JOIN actor AS a2 
	ON fa2.actor_id = a2.actor_id -- conecto la segunda film_actor con el segundo actor
WHERE a1.actor_id <> a2.actor_id -- comparing the actor's id
GROUP BY Actor1, Actor2, title
ORDER BY MoviesTogether DESC;

