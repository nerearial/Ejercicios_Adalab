-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema spotify
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema spotify
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `spotify` DEFAULT CHARACTER SET utf8 ;
USE `spotify` ;

-- -----------------------------------------------------
-- Table `spotify`.`cancion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`cancion` (
  `idcancion` INT NOT NULL,
  `nombre` VARCHAR(1024) NULL,
  PRIMARY KEY (`idcancion`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`artista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`artista` (
  `artista` INT NOT NULL,
  `nombre` VARCHAR(50) NULL,
  PRIMARY KEY (`artista`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`canciones_artistas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`canciones_artistas` (
  `artista_artista` INT NOT NULL,
  `cancion_idcancion` INT NOT NULL,
  PRIMARY KEY (`cancion_idcancion`, `artista_artista`),
  INDEX `fk_canciones_artistas_artista_idx` (`artista_artista` ASC) VISIBLE,
  INDEX `fk_canciones_artistas_cancion1_idx` (`cancion_idcancion` ASC) VISIBLE,
  CONSTRAINT `fk_canciones_artistas_artista`
    FOREIGN KEY (`artista_artista`)
    REFERENCES `spotify`.`artista` (`artista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_canciones_artistas_cancion1`
    FOREIGN KEY (`cancion_idcancion`)
    REFERENCES `spotify`.`cancion` (`idcancion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
