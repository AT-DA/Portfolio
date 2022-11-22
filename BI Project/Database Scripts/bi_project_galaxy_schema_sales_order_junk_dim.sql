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
-- Table structure for table `sales_order_junk_dim`
--

DROP TABLE IF EXISTS `sales_order_junk_dim`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales_order_junk_dim` (
  `Junk_Key` int(11) NOT NULL AUTO_INCREMENT,
  `Order_Method_ID` int(11) NOT NULL,
  `Order_Method_Description` varchar(255) NOT NULL,
  `Payment_Type_ID` int(11) NOT NULL,
  `Payment_Type_Description` varchar(255) NOT NULL,
  `Return_Reason_ID` int(11) DEFAULT NULL,
  `Return_Reason_Description` varchar(255) DEFAULT NULL,
  `Activation_Flag` int(1) NOT NULL,
  `Active_From` date NOT NULL,
  `Active_To` date DEFAULT NULL,
  `Last_Key` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`Junk_Key`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_order_junk_dim`
--

LOCK TABLES `sales_order_junk_dim` WRITE;
/*!40000 ALTER TABLE `sales_order_junk_dim` DISABLE KEYS */;
INSERT INTO `sales_order_junk_dim` VALUES (1,1,'Online',1,'Credit',1,'Faulty product',1,'2022-10-10',NULL,'1'),(2,2,'Offline',1,'Credit',1,'Faulty product',1,'2022-10-10',NULL,'2'),(3,1,'Online',2,'Cash',1,'Faulty product',1,'2022-10-10',NULL,'3'),(4,2,'Offline',2,'Cash',1,'Faulty product',1,'2022-10-10',NULL,'4'),(5,1,'Online',1,'Credit',2,'Other',1,'2022-10-10',NULL,'5'),(6,2,'Offline',1,'Credit',2,'Other',1,'2022-10-10',NULL,'6'),(7,1,'Online',2,'Cash',2,'Other',1,'2022-10-10',NULL,'7'),(8,2,'Offline',2,'Cash',2,'Other',1,'2022-10-10',NULL,'8'),(9,1,'Online',1,'Credit',3,'Change In Plans',1,'2022-10-10',NULL,'9'),(10,2,'Offline',1,'Credit',3,'Change In Plans',1,'2022-10-10',NULL,'10'),(11,1,'Online',2,'Cash',3,'Change In Plans',1,'2022-10-10',NULL,'11'),(12,2,'Offline',2,'Cash',3,'Change In Plans',1,'2022-10-10',NULL,'12'),(13,1,'Online',1,'Credit',4,'Need Different Size',1,'2022-10-10',NULL,'13'),(14,2,'Offline',1,'Credit',4,'Need Different Size',1,'2022-10-10',NULL,'14'),(15,1,'Online',2,'Cash',4,'Need Different Size',1,'2022-10-10',NULL,'15'),(16,2,'Offline',2,'Cash',4,'Need Different Size',1,'2022-10-10',NULL,'16'),(17,1,'Online',1,'Credit',5,'Product Expensive',1,'2022-10-10',NULL,'17'),(18,2,'Offline',1,'Credit',5,'Product Expensive',1,'2022-10-10',NULL,'18'),(19,1,'Online',2,'Cash',5,'Product Expensive',1,'2022-10-10',NULL,'19'),(20,2,'Offline',2,'Cash',5,'Product Expensive',1,'2022-10-10',NULL,'20'),(21,1,'Online',1,'Credit',6,'Product Cheap',1,'2022-10-10',NULL,'21'),(22,2,'Offline',1,'Credit',6,'Product Cheap',1,'2022-10-10',NULL,'22'),(23,1,'Online',2,'Cash',6,'Product Cheap',1,'2022-10-10',NULL,'23'),(24,2,'Offline',2,'Cash',6,'Product Cheap',1,'2022-10-10',NULL,'24'),(25,1,'Online',1,'Credit',7,'Bad Quality',1,'2022-10-10',NULL,'25'),(26,2,'Offline',1,'Credit',7,'Bad Quality',1,'2022-10-10',NULL,'26'),(27,1,'Online',2,'Cash',7,'Bad Quality',1,'2022-10-10',NULL,'27'),(28,2,'Offline',2,'Cash',7,'Bad Quality',1,'2022-10-10',NULL,'28'),(29,1,'Online',1,'Credit',8,'Average Quality',1,'2022-10-10',NULL,'29'),(30,2,'Offline',1,'Credit',8,'Average Quality',1,'2022-10-10',NULL,'30'),(31,1,'Online',2,'Cash',8,'Average Quality',1,'2022-10-10',NULL,'31'),(32,2,'Offline',2,'Cash',8,'Average Quality',1,'2022-10-10',NULL,'32'),(33,1,'Online',1,'Credit',NULL,NULL,1,'2022-10-10',NULL,''),(34,2,'Offline',1,'Credit',NULL,NULL,1,'2022-10-10',NULL,''),(35,1,'Online',2,'Cash',NULL,NULL,1,'2022-10-10',NULL,''),(36,2,'Offline',2,'Cash',NULL,NULL,1,'2022-10-10',NULL,'');
/*!40000 ALTER TABLE `sales_order_junk_dim` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-11-20 11:50:48
