
query_creacion_bbdd = "CREATE SCHEMA IF NOT EXISTS `spotify_f`;"

query_tabla_artistas = """
                    CREATE TABLE IF NOT EXISTS `spotify_f`.`artistas` (
                    `idartistas` VARCHAR(100) NOT NULL,
                    `nombre_artista` VARCHAR(100) NOT NULL,
                    PRIMARY KEY (`idartistas`));
                    """
                    
query_tabla_canciones = """
                        CREATE TABLE IF NOT EXISTS `spotify_f`.`canciones` (
                        `idcanciones` VARCHAR(200) NOT NULL,
                        `titulo` VARCHAR(200) NOT NULL,
                        PRIMARY KEY (`idcanciones`));

                        """

query_tabla_canciones_has_artistas = """
                                    CREATE TABLE IF NOT EXISTS `spotify_f`.`canciones_has_artistas` (
                                    `canciones_idcanciones` VARCHAR(200) NOT NULL,
                                    `artistas_idartistas` VARCHAR(100) NOT NULL,
                                    PRIMARY KEY (`canciones_idcanciones`, `artistas_idartistas`),
                                    INDEX `fk_canciones_has_artistas_artistas1_idx` (`artistas_idartistas` ASC) VISIBLE,
                                    INDEX `fk_canciones_has_artistas_canciones1_idx` (`canciones_idcanciones` ASC) VISIBLE,
                                    CONSTRAINT `fk_canciones_has_artistas_artistas1`
                                        FOREIGN KEY (`artistas_idartistas`)
                                        REFERENCES `spotify_f`.`artistas` (`idartistas`),
                                    CONSTRAINT `fk_canciones_has_artistas_canciones1`
                                        FOREIGN KEY (`canciones_idcanciones`)
                                        REFERENCES `spotify_f`.`canciones` (`idcanciones`));
                                    """

query_tabla_caracteristicas = """
                            CREATE TABLE IF NOT EXISTS `spotify_f`.`caracteristicas` (
                            `idcaracteristicas` INT NOT NULL AUTO_INCREMENT,
                            `danceability` FLOAT NOT NULL,
                            `acousticness` FLOAT NOT NULL,
                            `energy` FLOAT NOT NULL,
                            `canciones_idcanciones` VARCHAR(200) NOT NULL,
                            PRIMARY KEY (`idcaracteristicas`),
                            INDEX `fk_caracteristicas_canciones1_idx` (`canciones_idcanciones` ASC) VISIBLE,
                            CONSTRAINT `fk_caracteristicas_canciones1`
                                FOREIGN KEY (`canciones_idcanciones`)
                                REFERENCES `spotify_f`.`canciones` (`idcanciones`));
                            """
                            
query_insertar_canciones = "INSERT INTO canciones (idcanciones, titulo) VALUES (%s, %s)"
query_insertar_artistas = "INSERT INTO artistas (idartistas, nombre_artista) VALUES (%s, %s)"
query_insertar_canciones_artistas = "INSERT INTO canciones_has_artistas (canciones_idcanciones, artistas_idartistas) VALUES (%s, %s)"
# trunk-ignore(git-diff-check/error)
# trunk-ignore(git-diff-check/error)
query_insertar_caracteristicas = "INSERT INTO caracteristicas (danceability, acousticness, energy, canciones_idcanciones) VALUES (%s, %s, %s, %s)"

