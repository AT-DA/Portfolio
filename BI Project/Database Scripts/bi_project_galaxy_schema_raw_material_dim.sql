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
-- Table structure for table `raw_material_dim`
--

DROP TABLE IF EXISTS `raw_material_dim`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `raw_material_dim` (
  `Raw_Material_Key` int(11) NOT NULL AUTO_INCREMENT,
  `ID` int(11) DEFAULT NULL,
  `Name` varchar(255) NOT NULL,
  `Category` varchar(255) NOT NULL,
  `Cost_Price` decimal(19,0) NOT NULL,
  `Unit_Of_Measure` varchar(255) NOT NULL,
  `Unit_Value` int(11) NOT NULL,
  `Activation_Flag` int(1) NOT NULL,
  `Active_From` date NOT NULL,
  `Active_To` date DEFAULT NULL,
  `Last_Key` int(11) DEFAULT NULL,
  PRIMARY KEY (`Raw_Material_Key`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `raw_material_dim`
--

LOCK TABLES `raw_material_dim` WRITE;
/*!40000 ALTER TABLE `raw_material_dim` DISABLE KEYS */;
INSERT INTO `raw_material_dim` VALUES (1,1,'Copper','Metals',5,'KG',5,0,'2022-10-26','2022-10-29',9),(2,2,'Lithium','Metals',9,'KG',5,1,'2022-10-26',NULL,2),(3,3,'Tin','Metals',13,'KG',5,1,'2022-10-26',NULL,3),(4,4,'Silver','Metals',14,'KG',5,1,'2022-10-26',NULL,4),(5,5,'Gold','Metals',11,'KG',5,1,'2022-10-26',NULL,5),(6,6,'Nickel','Metals',12,'KG',5,1,'2022-10-26',NULL,6),(7,7,'Aluminum','Metals',14,'KG',5,1,'2022-10-26',NULL,7),(8,1,'Copper1','Metals',5,'KG',5,0,'2022-10-29','2022-10-29',9),(9,1,'Copper','Metals',5,'KG',5,1,'2022-10-29',NULL,9);
/*!40000 ALTER TABLE `raw_material_dim` ENABLE KEYS */;
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
