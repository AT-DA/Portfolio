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
-- Table structure for table `supplier_dim`
--

DROP TABLE IF EXISTS `supplier_dim`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier_dim` (
  `Supplier_Key` int(11) NOT NULL AUTO_INCREMENT,
  `ID` int(11) DEFAULT NULL,
  `Name` varchar(255) NOT NULL,
  `Phone_Number` int(11) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Area_Name` varchar(255) NOT NULL,
  `City_Name` varchar(255) NOT NULL,
  `Country_Name` varchar(255) NOT NULL,
  `Activation_Flag` int(1) NOT NULL,
  `Active_From` date NOT NULL,
  `Active_To` date DEFAULT NULL,
  `Last_Key` int(11) DEFAULT NULL,
  PRIMARY KEY (`Supplier_Key`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier_dim`
--

LOCK TABLES `supplier_dim` WRITE;
/*!40000 ALTER TABLE `supplier_dim` DISABLE KEYS */;
INSERT INTO `supplier_dim` VALUES (1,1,'LiveSale Supply',11110118,'LiveSaleSupply@xyz.com','Crime Alley','Gotham','DC Universe',0,'2022-10-26','2022-10-27',16),(2,2,'Retail Distribution Bros',202228,'RetailDistributionBros@xyz.com','The Batcave','Gotham','DC Universe',0,'2022-10-26','2022-10-27',9),(3,3,'Wholesale Imported',33333338,'WholesaleImported@xyz.com','Arkham Asylum','Gotham','DC Universe',0,'2022-10-26','2022-10-27',10),(4,4,'SupplySpace Global',33333334,'SupplyspaceGlobal@xyz.com','The Batcave','Gotham','DC Universe',0,'2022-10-26','2022-10-27',11),(5,5,'Metals Trading',33333337,'MetalsTrading@xyz.com','Crime Alley','Gotham','DC Universe',0,'2022-10-26','2022-10-27',12),(6,6,'Leads Group',33333332,'LeadsGroup@xyz.com','Arkham Asylum','Gotham','DC Universe',0,'2022-10-26','2022-10-27',13),(8,1,'LiveSale Supply',11110118,'LiveSaleSupply@xyz.com','Crime Alley','Gotham City','DC Universe',0,'2022-10-27','2022-10-29',16),(9,2,'Retail Distribution Bros',202228,'RetailDistributionBros@xyz.com','The Batcave','Metropolis','DC Universe',1,'2022-10-27',NULL,9),(10,3,'Wholesale Imported',33333338,'WholesaleImported@xyz.com','Arkham Asylum','Smallville','DC Universe',1,'2022-10-27',NULL,10),(11,4,'SupplySpace Global',33333334,'SupplyspaceGlobal@xyz.com','The Batcave','Metropolis','DC Universe',1,'2022-10-27',NULL,11),(12,5,'Metals Trading',33333337,'MetalsTrading@xyz.com','Crime Alley','Gotham City','DC Universe',1,'2022-10-27',NULL,12),(13,6,'Leads Group',33333332,'LeadsGroup@xyz.com','Arkham Asylum','Smallville','DC Universe',1,'2022-10-27',NULL,13),(15,1,'LiveSale Supply1',11110118,'LiveSaleSupply@xyz.com','Crime Alley','Gotham City','DC Universe',0,'2022-10-29','2022-11-08',16),(16,1,'LiveSale Supply',11110118,'LiveSaleSupply@xyz.com','Crime Alley','Gotham City','DC Universe',1,'2022-11-08',NULL,16);
/*!40000 ALTER TABLE `supplier_dim` ENABLE KEYS */;
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
