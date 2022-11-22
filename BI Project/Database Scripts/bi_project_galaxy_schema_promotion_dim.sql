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
-- Table structure for table `promotion_dim`
--

DROP TABLE IF EXISTS `promotion_dim`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotion_dim` (
  `Promotion_Key` int(11) NOT NULL AUTO_INCREMENT,
  `ID` int(11) NOT NULL,
  `Code` varchar(255) NOT NULL,
  `Type` varchar(255) NOT NULL,
  `Amount` decimal(19,0) DEFAULT NULL,
  `Valid_From` date DEFAULT NULL,
  `Valid_To` date DEFAULT NULL,
  `Activation_Flag` int(1) NOT NULL,
  `Active_From` date NOT NULL,
  `Active_To` date DEFAULT NULL,
  `Last_Key` int(11) DEFAULT NULL,
  PRIMARY KEY (`Promotion_Key`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotion_dim`
--

LOCK TABLES `promotion_dim` WRITE;
/*!40000 ALTER TABLE `promotion_dim` DISABLE KEYS */;
INSERT INTO `promotion_dim` VALUES (1,1,'10% discount','Discount',0,'2022-06-06','2022-06-06',0,'2022-10-26','2022-10-27',22),(2,2,'20% discount','Discount',0,'2099-06-06','2099-06-06',0,'2022-10-26','2022-10-27',23),(4,1,'10% discount','Discount',0,'2022-06-06','2022-06-06',0,'2022-10-27','2022-10-29',22),(5,2,'20% discount','Discount',0,'2099-06-06','2099-06-06',0,'2022-10-27','2022-10-29',23),(7,1,'10% discount','Discount',0,'2022-06-06','2022-06-06',0,'2022-10-29','2022-10-29',22),(8,2,'20% discount','Discount',0,'2099-06-06','2099-06-06',0,'2022-10-29','2022-10-29',23),(10,1,'10% discount','Discount',0,'2022-06-06','2022-06-06',0,'2022-10-29','2022-10-29',22),(11,2,'20% discount','Discount',0,'2099-06-06','2099-06-06',0,'2022-10-29','2022-10-29',23),(13,1,'10% discount','Discount',0,'2022-06-06','2022-06-06',0,'2022-10-29','2022-10-29',22),(14,2,'20% discount','Discount',0,'2099-06-06','2099-06-06',0,'2022-10-29','2022-10-29',23),(16,1,'10% discount','Discount',0,'2022-06-06','2022-06-06',0,'2022-10-29','2022-10-29',22),(17,2,'20% discount','Discount',0,'2099-06-06','2099-06-06',0,'2022-10-29','2022-10-29',23),(19,1,'10% discount','Discount',0,'2022-06-06','2022-06-06',0,'2022-10-29','2022-11-08',22),(20,2,'20% discount','Discount',0,'2099-06-06','2099-06-06',0,'2022-10-29','2022-11-08',23),(22,1,'10% discount','Discount',0,'2022-06-06','2022-06-06',1,'2022-11-08',NULL,22),(23,2,'20% discount','Discount',0,'2099-06-06','2099-06-06',1,'2022-11-08',NULL,23);
/*!40000 ALTER TABLE `promotion_dim` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-11-20 11:50:46
