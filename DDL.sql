-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema
-- -----------------------------------------------------

CREATE SCHEMA IF NOT EXISTS `cs340_castanbh` DEFAULT CHARACTER SET utf8 ;
-- Change the default schema
USE `cs340_castanbh` ;

-- -----------------------------------------------------
-- Table `HeroAgencies`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `HeroAgencies` ;

CREATE TABLE IF NOT EXISTS `HeroAgencies` (
  `agencyID` INT NOT NULL AUTO_INCREMENT,
  `agencyName` VARCHAR(100) NOT NULL,
  `agencyLocation` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`agencyID`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `StudentFamilies`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `StudentFamilies` ;

CREATE TABLE IF NOT EXISTS `StudentFamilies` (
  `familyID` INT NOT NULL AUTO_INCREMENT,
  `familyName` VARCHAR(100) NOT NULL,
  `familyEmail` VARCHAR(100) NOT NULL,
  `quirkStatus` BOOL NULL,
  PRIMARY KEY (`familyID`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Students`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Students` ;

CREATE TABLE IF NOT EXISTS`Students` (
  `studentID` INT NOT NULL AUTO_INCREMENT,
  `agencyID` INT NULL, -- Changed to allow NULL values
  `familyID` INT NOT NULL,
  `studentName` VARCHAR(100) NULL,
  `studentEmail` VARCHAR(100) NULL,
  `rankID` INT NOT NULL,
  `quirkType` VARCHAR(100) NOT NULL,
  `powerStat` DECIMAL(3,1) NULL,
  `speedStat` DECIMAL(3,1) NULL,
  `skillStat` DECIMAL(3,1) NULL,
  `smartStat` DECIMAL(3,1) NULL,
  `teamworkStat` DECIMAL(3,1) NULL,
  `lastUpdated` DATE NULL,
  `tempLicense` BOOL NULL,
  PRIMARY KEY (`studentID`, `agencyID`, `familyID`),
  INDEX `fk_Students_HeroAgencies1_idx` (`agencyID` ASC) VISIBLE,
  INDEX `fk_Students_StudentFamilies1_idx` (`familyID` ASC) VISIBLE,
  CONSTRAINT `fk_Students_HeroAgencies1`
    FOREIGN KEY (`agencyID`)
    REFERENCES `HeroAgencies` (`agencyID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Students_StudentFamilies1`
    FOREIGN KEY (`familyID`)
    REFERENCES `StudentFamilies` (`familyID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `MatchInstances`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MatchInstances` ;

CREATE TABLE IF NOT EXISTS `MatchInstances` (
  `matchID` INT NOT NULL AUTO_INCREMENT,
  `matchDate` DATE NULL,
  PRIMARY KEY (`matchID`)
)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `MatchTeamsList`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MatchTeamsList` ;

CREATE TABLE IF NOT EXISTS `MatchTeamsList` (
  `teamID` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`teamID`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `MatchInstance_has_MatchTeams`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MatchInstance_has_MatchTeams` ;

CREATE TABLE IF NOT EXISTS `MatchInstance_has_MatchTeams` (
  `teamID` INT NOT NULL,
  `matchID` INT NOT NULL,
  PRIMARY KEY (`teamID`, `matchID`),
  INDEX `fk_MatchInstance_has_MatchTeams_MatchTeams1_idx` (`teamID` ASC) VISIBLE,
  INDEX `fk_MatchInstance_has_MatchTeams_MatchInstances1_idx` (`matchID` ASC) VISIBLE,
  CONSTRAINT `fk_MatchInstance_has_MatchTeams_MatchTeams1`
    FOREIGN KEY (`teamID`)
    REFERENCES `MatchTeamsList` (`teamID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_MatchInstance_has_MatchTeams_MatchInstances1`
    FOREIGN KEY (`matchID`)
    REFERENCES `MatchInstances` (`matchID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `MatchTeam_has_Students`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MatchTeam_has_Students` ;

-- Create the MatchTeam_has_Students table
CREATE TABLE IF NOT EXISTS `MatchTeam_has_Students` (
  `teamID` INT NOT NULL,
  `studentID` INT NOT NULL,
  `winOtherLoss` INT NULL DEFAULT 0,
  PRIMARY KEY (`teamID`, `studentID`),
  INDEX `fk_MatchTeams_has_Students_Students1_idx` (`studentID` ASC) VISIBLE,
  INDEX `fk_MatchTeams_has_Students_MatchTeams1_idx` (`teamID` ASC) VISIBLE,
  CONSTRAINT `fk_MatchTeams_has_Students_MatchTeams1`
    FOREIGN KEY (`teamID`)
    REFERENCES `MatchTeamsList` (`teamID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_MatchTeams_has_Students_Students1`
    FOREIGN KEY (`studentID`)
    REFERENCES `Students` (`studentID`)
    ON DELETE NO ACTION -- Don't delete the student if they are on a match team
) ENGINE = InnoDB;  

-- Alter the MatchInstances table
ALTER TABLE `MatchInstances`
  MODIFY COLUMN `matchDate` DATE NULL;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


/*

 INSERT SECTION

*/

-- Need to update hero agencies & families before Students or FK violation

INSERT INTO HeroAgencies (agencyName, agencyLocation)
VALUES
    ('Gran Torino Agency', 'Mustafu'),
    ('Best Jeanist Genius Office', 'Mustafu'),
    ('Gunhead Agency', 'Mustafu'),
    ('Endeavor Agency', 'Mustafu'),
    ('Manual Agency', 'Mustafu'), 
    ('Hawks Hero Agency', 'Mustafu');

INSERT INTO StudentFamilies 
(familyID, familyName, quirkStatus, familyEmail) 
VALUES 
(1, 'Midoriya', 1, 'inko.midoriya@hotmail.com'),
(2, 'Bakugo', 1, 'mitsuki.bakugo@yahoo.com'),
(3, 'Uraraka', 0, 'unnamed@hotmail.com'),
(4, 'Todoroki', 1, 'endeavor@endeavor.com'),
(5, 'IdaI', 1, 'tenya.ida@gmail.com'),
(6, 'Tokoyami', 1, 'dark.shadow@gmail.com');

INSERT INTO Students 
(studentID, studentName, studentEmail, rankID, quirkType, powerStat, speedStat, skillStat, smartStat, teamworkStat, lastUpdated, tempLicense, agencyID, familyID) 
VALUES 
(1, 'Izuku Midoriya', 'midoriya@gmail.com', 1, 'One For All', 80.0, 70.0, 55.0, 70.0, 55.0, '2024-02-07', 1, 1, 1),
(2, 'Katsuki Bakugo', 'bakugo@gmail.com', 2, 'Explosion', 90.0, 75.0, 75.0, 70.0, 70.0, '2024-02-07', 0, 2, 2),
(3, 'Ochaco Uraraka', 'uraraka@gmail.com', 3, 'Zero Gravity', 70.0, 75.0, 45.0, 55.0, 80.0, '2024-02-07', 1, 3, 3),
(4, 'Shoto Todoroki', 'todoroki@gmail.com', 4, 'Half-Cold Half-Hot', 70.0, 25.0, 70.0, 75.0, 50.0, '2024-02-07', 0, 4, 4),
(5, 'Tenya Ida', 'Ida@gmail.com', 5, 'Engine', 80.0, 80.0, 55.0, 65.0, 90.0, '2024-02-07', 1, 5, 5),
(6, 'Fumikage Tokoyami', 'tokoyami@gmail.com', 6, 'Dark Shadow', 85.0, 75.0, 70.0, 65.0, 80.0, '2024-02-07', 1, 6, 6);
 
INSERT INTO MatchInstances (matchID, matchDate)
VALUES
    (1, '2024-02-07'),
    (2, '2024-01-07'),
    (3, '2024-01-14');

INSERT INTO MatchTeamsList (teamID)
VALUES 
    ('1'),
    ('2'),
    ('3'),
    ('4'),
    ('5'),
    ('6');
    

INSERT INTO MatchInstance_has_MatchTeams (matchID, teamID)
VALUES 
    (1, '1'),
    (1, '2'),
    (2, '3'),
    (2, '4'),
    (3, '5'),
    (3, '6');

INSERT INTO MatchTeam_has_Students (teamID, studentID, winOtherLoss)
VALUES 
    ('1', 1, 1),
    ('2', 2, -1),
    ('3', 3, 0),
    ('4', 4, 1),
    ('5', 5, -1),
    ('6', 6, 1);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
