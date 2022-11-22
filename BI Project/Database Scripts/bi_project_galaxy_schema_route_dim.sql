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
-- Table structure for table `route_dim`
--

DROP TABLE IF EXISTS `route_dim`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `route_dim` (
  `Route_Key` int(11) NOT NULL AUTO_INCREMENT,
  `ID` int(11) NOT NULL,
  `Code` varchar(255) NOT NULL,
  `From_Branch` varchar(255) NOT NULL,
  `Last_Stop` varchar(255) NOT NULL,
  `Total_Kilometers_Distance` int(11) NOT NULL,
  `Average_Minutes_Duration` int(11) NOT NULL,
  `Is_Active` int(1) NOT NULL,
  `Active_From` date NOT NULL,
  `Active_To` date DEFAULT NULL,
  `Last_Key` int(11) DEFAULT NULL,
  PRIMARY KEY (`Route_Key`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `route_dim`
--

LOCK TABLES `route_dim` WRITE;
/*!40000 ALTER TABLE `route_dim` DISABLE KEYS */;
INSERT INTO `route_dim` VALUES (1,1,'F1','Store1','Crime Alley',64,62,1,'2022-10-26',NULL,1),(2,2,'C3','Store2','The Batcave',82,80,1,'2022-10-26',NULL,2),(3,3,'M7','Warehouse1','Arkham Asylum',34,32,1,'2022-10-26',NULL,3),(4,4,'M4','Store1','GCPD',92,90,1,'2022-10-26',NULL,4),(5,5,'C1','Store2','Blackgate',56,54,1,'2022-10-26',NULL,5),(6,6,'F9','Warehouse1','Ace Chemicals',51,49,1,'2022-10-26',NULL,6),(7,7,'M1','Store1','Wayne Enterprises',43,41,1,'2022-10-26',NULL,7),(8,8,'C1','Store2','Daily Planet',29,27,1,'2022-10-26',NULL,8);
/*!40000 ALTER TABLE `route_dim` ENABLE KEYS */;
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
