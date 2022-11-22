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
-- Table structure for table `branch_dim`
--

DROP TABLE IF EXISTS `branch_dim`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `branch_dim` (
  `Branch_Key` int(11) NOT NULL AUTO_INCREMENT,
  `ID` int(11) DEFAULT NULL,
  `Name` varchar(255) NOT NULL,
  `Type` varchar(255) NOT NULL,
  `Square_Meters` int(11) NOT NULL,
  `Monthly_Rent` int(11) NOT NULL,
  `Average_Monthly_Expenses` int(11) NOT NULL,
  `Area_Name` varchar(255) NOT NULL,
  `City_Name` varchar(255) NOT NULL,
  `Country_Name` varchar(255) NOT NULL,
  `Activation_Flag` int(1) NOT NULL,
  `Active_From` date NOT NULL,
  `Active_To` date DEFAULT NULL,
  `Last_Key` int(11) DEFAULT NULL,
  PRIMARY KEY (`Branch_Key`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branch_dim`
--

LOCK TABLES `branch_dim` WRITE;
/*!40000 ALTER TABLE `branch_dim` DISABLE KEYS */;
INSERT INTO `branch_dim` VALUES (1,1,'Store1','Store',0,10000,2500,'Crime Alley','Gotham','DC Universe',0,'2022-10-10','2022-10-27',10),(2,2,'Store2','Store',0,8000,2000,'Crime Alley','Gotham','DC Universe',0,'2022-10-10','2022-10-27',8),(3,3,'Warehouse1','Warehouse',0,5000,1500,'Crime Alley','Gotham','DC Universe',0,'2022-10-10','2022-10-27',9),(7,1,'Store1_Test','Store',150,10000,2500,'Crime Alley','Gotham City','DC Universe',0,'2022-10-27','2022-10-29',10),(8,2,'Store2','Store',220,8000,2000,'Crime Alley','Gotham City','DC Universe',1,'2022-10-27',NULL,8),(9,3,'Warehouse1','Warehouse',240,5000,1500,'Crime Alley','Gotham City','DC Universe',1,'2022-10-27',NULL,9),(10,1,'Store1','Store',150,10000,2500,'Crime Alley','Gotham City','DC Universe',1,'2022-10-29',NULL,10);
/*!40000 ALTER TABLE `branch_dim` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-11-20 11:50:51
