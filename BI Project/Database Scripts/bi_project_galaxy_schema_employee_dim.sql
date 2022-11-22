-- MySQL dump 10.13  Distrib 8.0.17, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: bi_project_galaxy_schema
-- ------------------------------------------------------
-- Server version	8.0.17

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `employee_dim`
--

DROP TABLE IF EXISTS `employee_dim`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_dim` (
  `Employee_Key` int(10) NOT NULL AUTO_INCREMENT,
  `Employee_ID` int(11) NOT NULL,
  `First_Name` varchar(255) NOT NULL,
  `Last_Name` varchar(255) DEFAULT NULL,
  `Phone_Number` int(10) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Department_Name` varchar(255) NOT NULL,
  `Manager_Name` varchar(255) DEFAULT NULL,
  `Level` int(11) NOT NULL,
  `National_ID` int(11) NOT NULL,
  `Area_Name` varchar(255) NOT NULL,
  `City_Name` varchar(255) NOT NULL,
  `Country_Name` varchar(255) NOT NULL,
  `Activation_Flag` int(1) NOT NULL,
  `Active_From` date NOT NULL,
  `Active_To` date DEFAULT NULL,
  `Last_Key` int(11) DEFAULT NULL,
  PRIMARY KEY (`Employee_Key`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_dim`
--

LOCK TABLES `employee_dim` WRITE;
/*!40000 ALTER TABLE `employee_dim` DISABLE KEYS */;
INSERT INTO `employee_dim` VALUES (1,1,'Hal','Jordan',11110111,'Hal@xyz.com','Sales','Hal',1,123456,'Crime Alley','Gotham','DC Universe',0,'2022-10-26','2022-10-27',4),(2,2,'Barry','Allen',202222,'Barry@xyz.com','Sales','Hal',2,654321,'The Batcave','Gotham','DC Universe',0,'2022-10-26','2022-10-27',5),(3,3,'Arthur','Curry',33333333,'Arthur@xyz.com','Sales','Barry',3,987789,'Crime Alley','Gotham','DC Universe',0,'2022-10-26','2022-10-27',6),(4,1,'Hal','Jordan',11110111,'Hal@xyz.com','Sales','Hal',1,123456,'Crime Alley','Gotham City','DC Universe',1,'2022-10-27',NULL,4),(5,2,'Barry','Allen',202222,'Barry@xyz.com','Sales','Hal',2,654321,'The Batcave','Metropolis','DC Universe',1,'2022-10-27',NULL,5),(6,3,'Arthur','Curry',33333333,'Arthur@xyz.com','Sales','Barry',3,987789,'Crime Alley','Gotham City','DC Universe',1,'2022-10-27',NULL,6);
/*!40000 ALTER TABLE `employee_dim` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-11-20 11:50:47
