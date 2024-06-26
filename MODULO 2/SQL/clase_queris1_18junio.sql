CREATE SCHEMA Clase;
USE Clase;

CREATE TABLE alumnas (
id_alumna INT NOT NULL AUTO_INCREMENT,
nombre VARCHAR(100) DEFAULT NULL,
apellido VARCHAR(100) DEFAULT NULL,
email VARCHAR(100) DEFAULT NULL,
telefono INT DEFAULT NULL,
direccion VARCHAR(100) DEFAULT NULL,
ciudad VARCHAR(10) DEFAULT NULL,
pais  VARCHAR(10) DEFAULT NULL,
PRIMARY KEY (id_alumna)
);


INSERT INTO alumnas (nombre, apellido, email, telefono , direccion, ciudad, pais)
VALUES("Ana","González","ana@adalab.es",6547685,"Calle alumna 1","Madrid","España"),
("Maria","López","maria@adalab.es",6047687,"Calle alumna 2","Barcelona","España"),
("Lucía","Ramos","lucia@adalab.es",6549685,"Calle alumna 3","Valencia","España"),
("Elena","Bueno","elena@adalab.es",6537685,"Calle alumna 4","Bilbao","España"),
("Rocío","García","arocio@adalab.es",6247385,"Calle alumna 5","Paris","Francia");

SELECT nombre
FROM alumnas;

SELECT nombre, apellido
FROM alumnas;

SELECT nombre, apellido, pais
FROM alumnas
WHERE pais = "Francia";

SELECT nombre, apellido
FROM alumnas
WHERE pais = "España"
AND nombre = "Ana";

SELECT nombre, apellido, ciudad
FROM alumnas
WHERE ciudad = "Barcelona"
OR ciudad = "Valencia";

SELECT nombre, apellido, ciudad
FROM alumnas
WHERE NOT ciudad = "Barcelona";

SELECT ciudad, pais
FROM alumnas
WHERE telefono <> 6047687; -- <> es distinto

SELECT nombre, apellido, email
FROM alumnas
WHERE ciudad IS NULL;

INSERT INTO alumnas (nombre, apellido, email, telefono , direccion, ciudad)
VALUES("BELEN","González","belen@adalab.es",6547685,"Calle alumna 6","Malaga");

SELECT * 
FROM alumnas
WHERE pais IS NULL;

SELECT * 
FROM alumnas
WHERE pais IS NOT NULL;

SELECT * 
FROM alumnas
ORDER BY nombre;

SELECT nombre, pais
FROM alumnas
WHERE pais = "España"
ORDER BY nombre DESC; -- DESC ES DESCENDENTE

SELECT DISTINCT pais -- Nos saca los datos sin repetir
FROM alumnas;

-- Para conocer la estructura
SELECT *
FROM ALUMNAS
ORDER BY nombre
LIMIT 2;

-- PARA QUE COMIENCE DESDE UNA POSICIÓN CONCRETA
SELECT * 
FROM alumnas
LIMIT 3
OFFSET 2;

SELECT * 
FROM alumnas
WHERE ciudad IN ("Barcelona","Valencia");

SELECT id_alumna, nombre, ciudad
FROM alumnas
WHERE id_alumna BETWEEN 3 AND 5;

SELECT nombre, apellido as nom, apellido as ape
FROM alumnas;