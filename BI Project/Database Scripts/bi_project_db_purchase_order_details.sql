-- MySQL dump 10.13  Distrib 8.0.17, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: bi_project_db
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
-- Table structure for table `purchase_order_details`
--

DROP TABLE IF EXISTS `purchase_order_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_order_details` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Purchase_OrderID` int(11) NOT NULL,
  `Line_Number` int(11) NOT NULL,
  `Raw_MaterialID` int(11) NOT NULL,
  `Ordered_Quantity` int(11) NOT NULL,
  `Ordered_Value` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1492 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_order_details`
--

LOCK TABLES `purchase_order_details` WRITE;
/*!40000 ALTER TABLE `purchase_order_details` DISABLE KEYS */;
INSERT INTO `purchase_order_details` VALUES (1,1,1,2,40,360),(2,1,2,5,49,539),(3,1,3,6,32,384),(4,2,1,4,36,504),(5,2,2,5,44,484),(6,3,1,3,41,533),(7,3,2,4,39,546),(8,3,3,2,37,333),(9,4,1,1,31,155),(10,5,1,1,49,245),(11,5,2,3,32,416),(12,5,3,7,40,560),(13,6,1,2,48,432),(14,6,2,4,38,532),(15,6,3,6,48,576),(16,7,1,4,43,602),(17,8,1,3,44,572),(18,9,1,2,41,369),(19,9,2,1,30,150),(20,9,3,4,49,686),(21,10,1,4,45,630),(22,11,1,4,45,630),(23,11,2,6,36,432),(24,12,1,2,42,378),(25,12,2,3,42,546),(26,13,1,7,39,546),(27,13,2,2,43,387),(28,13,3,5,43,473),(29,14,1,4,48,672),(30,15,1,1,32,160),(31,15,2,6,30,360),(32,15,3,7,46,644),(33,16,1,6,31,372),(34,16,2,5,44,484),(35,17,1,5,43,473),(36,17,2,6,46,552),(37,17,3,3,34,442),(38,18,1,6,38,456),(39,18,2,2,33,297),(40,19,1,4,44,616),(41,20,1,6,49,588),(42,20,2,3,34,442),(43,20,3,4,39,546),(44,21,1,1,34,170),(45,21,2,4,42,588),(46,21,3,2,39,351),(47,22,1,3,36,468),(48,22,2,1,39,195),(49,22,3,7,33,462),(50,23,1,6,34,408),(51,23,2,1,32,160),(52,23,3,7,46,644),(53,24,1,5,35,385),(54,24,2,6,30,360),(55,24,3,1,35,175),(56,25,1,5,41,451),(57,26,1,1,43,215),(58,27,1,4,35,490),(59,27,2,7,34,476),(60,28,1,4,46,644),(61,29,1,1,40,200),(62,30,1,4,42,588),(63,31,1,5,31,341),(64,31,2,3,41,533),(65,32,1,4,38,532),(66,32,2,7,49,686),(67,33,1,2,46,414),(68,33,2,5,47,517),(69,34,1,2,33,297),(70,34,2,7,42,588),(71,35,1,4,30,420),(72,35,2,7,42,588),(73,36,1,2,38,342),(74,36,2,3,36,468),(75,37,1,6,37,444),(76,38,1,3,46,598),(77,38,2,7,48,672),(78,38,3,6,36,432),(79,39,1,4,32,448),(80,40,1,5,36,396),(81,40,2,7,31,434),(82,41,1,3,40,520),(83,41,2,5,41,451),(84,42,1,5,39,429),(85,42,2,1,46,230),(86,42,3,2,40,360),(87,43,1,1,37,185),(88,43,2,2,43,387),(89,44,1,7,32,448),(90,44,2,1,30,150),(91,44,3,2,41,369),(92,45,1,1,43,215),(93,46,1,2,33,297),(94,47,1,2,42,378),(95,47,2,6,46,552),(96,48,1,2,33,297),(97,48,2,4,45,630),(98,48,3,1,38,190),(99,49,1,6,42,504),(100,49,2,2,41,369),(101,49,3,4,30,420),(102,50,1,5,42,462),(103,50,2,4,43,602),(104,50,3,6,36,432),(105,51,1,6,47,564),(106,51,2,5,34,374),(107,52,1,7,46,644),(108,52,2,5,47,517),(109,52,3,3,39,507),(110,53,1,1,32,160),(111,53,2,5,46,506),(112,54,1,6,37,444),(113,55,1,2,36,324),(114,56,1,3,43,559),(115,56,2,5,45,495),(116,57,1,6,30,360),(117,58,1,5,33,363),(118,59,1,2,35,315),(119,59,2,7,36,504),(120,60,1,5,40,440),(121,60,2,1,43,215),(122,61,1,5,39,429),(123,61,2,3,37,481),(124,62,1,4,33,462),(125,62,2,7,43,602),(126,62,3,6,34,408),(127,63,1,1,48,240),(128,64,1,2,41,369),(129,64,2,1,33,165),(130,65,1,5,34,374),(131,65,2,7,42,588),(132,65,3,3,46,598),(133,66,1,3,46,598),(134,67,1,6,34,408),(135,68,1,1,39,195),(136,69,1,5,46,506),(137,69,2,1,34,170),(138,69,3,3,45,585),(139,70,1,2,41,369),(140,70,2,6,48,576),(141,70,3,1,30,150),(142,71,1,1,43,215),(143,71,2,6,30,360),(144,71,3,4,35,490),(145,72,1,3,34,442),(146,72,2,7,49,686),(147,72,3,6,44,528),(148,73,1,6,35,420),(149,74,1,2,37,333),(150,75,1,5,38,418),(151,75,2,4,42,588),(152,75,3,3,34,442),(153,76,1,5,44,484),(154,77,1,4,34,476),(155,77,2,2,48,432),(156,77,3,1,36,180),(157,78,1,5,38,418),(158,78,2,3,49,637),(159,78,3,4,41,574),(160,79,1,5,42,462),(161,80,1,7,35,490),(162,80,2,2,34,306),(163,81,1,7,42,588),(164,81,2,4,48,672),(165,82,1,3,32,416),(166,82,2,1,43,215),(167,82,3,7,30,420),(168,83,1,6,36,432),(169,83,2,3,33,429),(170,83,3,2,42,378),(171,84,1,6,32,384),(172,84,2,1,46,230),(173,84,3,3,45,585),(174,85,1,1,39,195),(175,85,2,3,37,481),(176,85,3,6,45,540),(177,86,1,6,41,492),(178,87,1,3,49,637),(179,87,2,6,47,564),(180,87,3,5,32,352),(181,88,1,5,43,473),(182,88,2,1,45,225),(183,88,3,6,36,432),(184,89,1,7,44,616),(185,89,2,4,35,490),(186,89,3,1,38,190),(187,90,1,3,48,624),(188,91,1,2,32,288),(189,91,2,1,37,185),(190,91,3,5,46,506),(191,92,1,5,43,473),(192,93,1,4,36,504),(193,94,1,5,36,396),(194,94,2,2,41,369),(195,95,1,2,37,333),(196,96,1,7,49,686),(197,96,2,6,42,504),(198,97,1,4,38,532),(199,97,2,6,41,492),(200,97,3,5,31,341),(201,98,1,4,48,672),(202,99,1,4,41,574),(203,99,2,6,45,540),(204,100,1,5,47,517),(205,100,2,2,49,441),(206,100,3,3,40,520),(207,101,1,5,48,528),(208,102,1,3,37,481),(209,103,1,7,47,658),(210,103,2,6,35,420),(211,104,1,5,34,374),(212,104,2,3,43,559),(213,105,1,7,48,672),(214,105,2,2,32,288),(215,105,3,3,38,494),(216,106,1,3,39,507),(217,106,2,6,41,492),(218,106,3,5,33,363),(219,107,1,1,48,240),(220,108,1,7,39,546),(221,108,2,2,31,279),(222,109,1,3,45,585),(223,109,2,5,49,539),(224,109,3,7,49,686),(225,110,1,1,49,245),(226,111,1,5,34,374),(227,112,1,5,43,473),(228,112,2,6,42,504),(229,112,3,3,31,403),(230,113,1,2,41,369),(231,113,2,3,48,624),(232,113,3,7,40,560),(233,114,1,3,36,468),(234,114,2,5,38,418),(235,115,1,3,37,481),(236,116,1,3,43,559),(237,116,2,1,31,155),(238,116,3,7,45,630),(239,117,1,3,30,390),(240,118,1,6,43,516),(241,119,1,3,41,533),(242,119,2,7,36,504),(243,119,3,4,43,602),(244,120,1,5,34,374),(245,120,2,1,49,245),(246,121,1,4,37,518),(247,121,2,5,31,341),(248,122,1,1,31,155),(249,122,2,4,41,574),(250,122,3,2,48,432),(251,123,1,3,33,429),(252,123,2,1,44,220),(253,123,3,4,42,588),(254,124,1,1,37,185),(255,125,1,3,39,507),(256,126,1,3,37,481),(257,126,2,2,49,441),(258,126,3,5,45,495),(259,127,1,7,32,448),(260,127,2,4,38,532),(261,127,3,2,33,297),(262,128,1,7,38,532),(263,128,2,4,33,462),(264,128,3,5,33,363),(265,129,1,3,31,403),(266,130,1,4,41,574),(267,131,1,4,32,448),(268,131,2,6,30,360),(269,132,1,7,35,490),(270,133,1,5,39,429),(271,133,2,6,35,420),(272,133,3,3,30,390),(273,134,1,6,30,360),(274,134,2,3,45,585),(275,134,3,2,42,378),(276,135,1,6,30,360),(277,136,1,3,48,624),(278,136,2,6,32,384),(279,136,3,2,48,432),(280,137,1,7,48,672),(281,137,2,3,38,494),(282,137,3,1,31,155),(283,138,1,6,44,528),(284,139,1,1,31,155),(285,139,2,6,45,540),(286,139,3,7,30,420),(287,140,1,4,35,490),(288,140,2,2,45,405),(289,141,1,3,33,429),(290,142,1,6,30,360),(291,142,2,3,31,403),(292,142,3,1,32,160),(293,143,1,4,38,532),(294,144,1,2,40,360),(295,145,1,4,37,518),(296,146,1,3,46,598),(297,146,2,1,45,225),(298,146,3,6,48,576),(299,147,1,4,39,546),(300,147,2,7,37,518),(301,148,1,6,47,564),(302,148,2,2,34,306),(303,149,1,6,36,432),(304,150,1,5,31,341),(305,150,2,2,31,279),(306,150,3,1,45,225),(307,151,1,3,40,520),(308,152,1,7,34,476),(309,153,1,7,41,574),(310,153,2,3,40,520),(311,153,3,4,36,504),(312,154,1,3,46,598),(313,155,1,3,35,455),(314,156,1,2,36,324),(315,156,2,5,48,528),(316,156,3,3,43,559),(317,157,1,6,42,504),(318,157,2,5,39,429),(319,157,3,3,34,442),(320,158,1,6,42,504),(321,158,2,3,32,416),(322,158,3,7,30,420),(323,159,1,1,45,225),(324,159,2,6,44,528),(325,160,1,1,40,200),(326,161,1,2,30,270),(327,161,2,3,37,481),(328,161,3,6,43,516),(329,162,1,3,39,507),(330,163,1,6,31,372),(331,163,2,2,33,297),(332,163,3,4,32,448),(333,164,1,5,39,429),(334,164,2,1,33,165),(335,164,3,6,38,456),(336,165,1,4,35,490),(337,165,2,1,30,150),(338,165,3,3,34,442),(339,166,1,1,44,220),(340,167,1,3,30,390),(341,167,2,1,44,220),(342,168,1,6,49,588),(343,168,2,7,49,686),(344,169,1,7,37,518),(345,169,2,6,35,420),(346,170,1,3,43,559),(347,171,1,2,48,432),(348,171,2,5,43,473),(349,171,3,4,41,574),(350,172,1,7,43,602),(351,173,1,7,42,588),(352,173,2,2,37,333),(353,173,3,1,38,190),(354,174,1,7,46,644),(355,174,2,2,47,423),(356,175,1,6,38,456),(357,175,2,4,48,672),(358,175,3,1,35,175),(359,176,1,6,32,384),(360,176,2,3,35,455),(361,177,1,3,49,637),(362,177,2,7,31,434),(363,178,1,2,36,324),(364,178,2,5,39,429),(365,179,1,1,31,155),(366,179,2,3,38,494),(367,179,3,2,46,414),(368,180,1,2,35,315),(369,180,2,1,47,235),(370,180,3,6,32,384),(371,181,1,4,43,602),(372,181,2,5,32,352),(373,182,1,5,46,506),(374,182,2,6,40,480),(375,182,3,2,37,333),(376,183,1,7,44,616),(377,183,2,2,42,378),(378,183,3,5,41,451),(379,184,1,3,36,468),(380,185,1,1,30,150),(381,185,2,3,33,429),(382,185,3,7,36,504),(383,186,1,5,38,418),(384,186,2,3,40,520),(385,186,3,4,42,588),(386,187,1,7,36,504),(387,188,1,7,35,490),(388,188,2,2,36,324),(389,188,3,5,45,495),(390,189,1,1,31,155),(391,189,2,4,33,462),(392,189,3,7,32,448),(393,190,1,4,40,560),(394,191,1,1,42,210),(395,191,2,2,34,306),(396,192,1,6,34,408),(397,193,1,1,30,150),(398,193,2,2,30,270),(399,194,1,4,31,434),(400,194,2,2,34,306),(401,195,1,3,41,533),(402,195,2,7,34,476),(403,195,3,4,37,518),(404,196,1,1,39,195),(405,196,2,3,34,442),(406,197,1,4,48,672),(407,198,1,3,47,611),(408,198,2,1,49,245),(409,199,1,1,34,170),(410,199,2,4,45,630),(411,200,1,2,48,432),(412,201,1,6,44,528),(413,201,2,1,33,165),(414,201,3,2,36,324),(415,202,1,4,40,560),(416,203,1,4,40,560),(417,204,1,4,36,504),(418,204,2,2,46,414),(419,205,1,6,32,384),(420,205,2,4,47,658),(421,205,3,7,37,518),(422,206,1,7,35,490),(423,206,2,3,34,442),(424,206,3,2,32,288),(425,207,1,1,40,200),(426,208,1,7,39,546),(427,209,1,2,39,351),(428,210,1,6,30,360),(429,210,2,3,43,559),(430,210,3,4,34,476),(431,211,1,6,34,408),(432,212,1,6,47,564),(433,213,1,4,45,630),(434,213,2,5,33,363),(435,214,1,1,37,185),(436,215,1,4,42,588),(437,215,2,1,34,170),(438,216,1,3,35,455),(439,216,2,2,44,396),(440,216,3,4,45,630),(441,217,1,1,45,225),(442,217,2,3,39,507),(443,218,1,3,42,546),(444,218,2,6,37,444),(445,218,3,4,32,448),(446,219,1,1,49,245),(447,220,1,5,30,330),(448,221,1,2,38,342),(449,221,2,6,36,432),(450,221,3,7,45,630),(451,222,1,2,39,351),(452,222,2,5,38,418),(453,223,1,2,38,342),(454,223,2,4,49,686),(455,223,3,7,44,616),(456,224,1,1,45,225),(457,224,2,7,36,504),(458,225,1,6,39,468),(459,226,1,1,39,195),(460,226,2,7,47,658),(461,226,3,3,33,429),(462,227,1,5,41,451),(463,227,2,6,34,408),(464,227,3,7,36,504),(465,228,1,7,36,504),(466,228,2,1,30,150),(467,228,3,3,45,585),(468,229,1,1,43,215),(469,229,2,7,45,630),(470,230,1,3,32,416),(471,230,2,4,31,434),(472,231,1,2,38,342),(473,231,2,4,36,504),(474,232,1,6,32,384),(475,232,2,3,33,429),(476,233,1,1,47,235),(477,234,1,6,48,576),(478,234,2,7,45,630),(479,234,3,2,46,414),(480,235,1,4,35,490),(481,235,2,5,40,440),(482,236,1,6,34,408),(483,237,1,1,38,190),(484,237,2,2,48,432),(485,238,1,1,32,160),(486,238,2,4,32,448),(487,239,1,5,30,330),(488,240,1,2,39,351),(489,240,2,7,44,616),(490,241,1,6,48,576),(491,242,1,7,37,518),(492,242,2,3,31,403),(493,242,3,4,38,532),(494,243,1,2,35,315),(495,243,2,3,42,546),(496,243,3,5,45,495),(497,244,1,5,38,418),(498,245,1,1,43,215),(499,246,1,1,44,220),(500,246,2,2,34,306),(501,247,1,6,39,468),(502,247,2,1,35,175),(503,247,3,2,48,432),(504,248,1,6,35,420),(505,249,1,2,42,378),(506,250,1,2,33,297),(507,250,2,6,40,480),(508,251,1,3,41,533),(509,251,2,2,38,342),(510,252,1,1,47,235),(511,252,2,4,36,504),(512,252,3,5,34,374),(513,253,1,3,40,520),(514,253,2,7,36,504),(515,254,1,7,32,448),(516,254,2,5,31,341),(517,254,3,2,41,369),(518,255,1,5,36,396),(519,255,2,4,48,672),(520,255,3,3,46,598),(521,256,1,5,47,517),(522,257,1,6,49,588),(523,257,2,4,40,560),(524,257,3,3,42,546),(525,258,1,4,34,476),(526,258,2,2,36,324),(527,259,1,2,46,414),(528,259,2,6,31,372),(529,260,1,5,42,462),(530,261,1,3,49,637),(531,261,2,6,45,540),(532,261,3,7,48,672),(533,262,1,2,34,306),(534,262,2,1,30,150),(535,262,3,5,44,484),(536,263,1,6,36,432),(537,264,1,7,31,434),(538,265,1,2,48,432),(539,265,2,6,48,576),(540,265,3,7,41,574),(541,266,1,7,34,476),(542,266,2,3,39,507),(543,267,1,7,33,462),(544,267,2,4,38,532),(545,267,3,6,43,516),(546,268,1,5,38,418),(547,268,2,6,43,516),(548,268,3,1,46,230),(549,269,1,1,34,170),(550,269,2,2,34,306),(551,270,1,7,33,462),(552,270,2,2,40,360),(553,270,3,3,43,559),(554,271,1,5,44,484),(555,271,2,1,32,160),(556,272,1,6,44,528),(557,272,2,2,47,423),(558,272,3,1,30,150),(559,273,1,5,39,429),(560,273,2,7,31,434),(561,274,1,7,43,602),(562,274,2,5,45,495),(563,275,1,5,36,396),(564,276,1,2,41,369),(565,276,2,4,33,462),(566,276,3,1,45,225),(567,277,1,6,30,360),(568,277,2,4,42,588),(569,277,3,5,46,506),(570,278,1,1,34,170),(571,278,2,6,47,564),(572,279,1,7,45,630),(573,279,2,5,37,407),(574,280,1,3,45,585),(575,281,1,3,42,546),(576,282,1,7,34,476),(577,282,2,5,33,363),(578,283,1,1,39,195),(579,283,2,6,37,444),(580,283,3,7,30,420),(581,284,1,3,33,429),(582,284,2,7,47,658),(583,284,3,2,41,369),(584,285,1,1,39,195),(585,285,2,6,49,588),(586,286,1,1,32,160),(587,286,2,4,45,630),(588,286,3,6,41,492),(589,287,1,1,33,165),(590,287,2,6,32,384),(591,288,1,4,46,644),(592,288,2,7,42,588),(593,289,1,7,37,518),(594,289,2,4,48,672),(595,289,3,1,40,200),(596,290,1,2,34,306),(597,291,1,7,31,434),(598,291,2,5,39,429),(599,291,3,4,36,504),(600,292,1,5,40,440),(601,292,2,1,35,175),(602,293,1,6,46,552),(603,293,2,1,46,230),(604,294,1,4,49,686),(605,295,1,1,36,180),(606,296,1,3,35,455),(607,296,2,4,38,532),(608,297,1,2,47,423),(609,297,2,3,34,442),(610,297,3,6,38,456),(611,298,1,3,31,403),(612,299,1,1,36,180),(613,299,2,7,30,420),(614,300,1,7,38,532),(615,300,2,1,38,190),(616,300,3,6,48,576),(617,301,1,4,34,476),(618,301,2,2,44,396),(619,301,3,3,31,403),(620,302,1,4,34,476),(621,303,1,2,35,315),(622,303,2,1,33,165),(623,304,1,5,33,363),(624,305,1,6,40,480),(625,305,2,1,39,195),(626,305,3,3,43,559),(627,306,1,2,44,396),(628,307,1,7,42,588),(629,307,2,5,35,385),(630,307,3,2,40,360),(631,308,1,2,32,288),(632,308,2,5,31,341),(633,309,1,1,42,210),(634,309,2,6,45,540),(635,309,3,4,33,462),(636,310,1,4,47,658),(637,310,2,7,37,518),(638,311,1,5,34,374),(639,311,2,1,38,190),(640,311,3,4,38,532),(641,312,1,5,35,385),(642,313,1,6,40,480),(643,314,1,2,34,306),(644,315,1,4,32,448),(645,315,2,5,46,506),(646,315,3,1,46,230),(647,316,1,2,40,360),(648,316,2,5,45,495),(649,317,1,4,32,448),(650,317,2,3,42,546),(651,317,3,1,44,220),(652,318,1,6,37,444),(653,319,1,1,35,175),(654,319,2,3,39,507),(655,319,3,2,31,279),(656,320,1,1,44,220),(657,321,1,6,37,444),(658,321,2,4,37,518),(659,321,3,5,36,396),(660,322,1,7,49,686),(661,322,2,3,34,442),(662,323,1,1,46,230),(663,324,1,4,42,588),(664,324,2,5,47,517),(665,325,1,5,40,440),(666,325,2,1,33,165),(667,326,1,1,44,220),(668,326,2,3,37,481),(669,327,1,5,49,539),(670,327,2,1,31,155),(671,327,3,2,46,414),(672,328,1,3,39,507),(673,328,2,5,30,330),(674,329,1,6,37,444),(675,329,2,1,37,185),(676,330,1,7,30,420),(677,331,1,4,47,658),(678,332,1,1,31,155),(679,332,2,6,39,468),(680,332,3,4,42,588),(681,333,1,7,38,532),(682,333,2,2,38,342),(683,334,1,3,32,416),(684,334,2,1,45,225),(685,335,1,7,48,672),(686,335,2,1,42,210),(687,336,1,6,39,468),(688,337,1,3,37,481),(689,337,2,1,41,205),(690,337,3,5,41,451),(691,338,1,4,38,532),(692,338,2,2,33,297),(693,339,1,3,46,598),(694,339,2,1,42,210),(695,339,3,7,38,532),(696,340,1,5,39,429),(697,340,2,6,42,504),(698,341,1,4,40,560),(699,341,2,7,40,560),(700,341,3,2,30,270),(701,342,1,7,36,504),(702,342,2,3,34,442),(703,342,3,4,30,420),(704,343,1,2,31,279),(705,343,2,5,38,418),(706,344,1,2,47,423),(707,344,2,7,42,588),(708,344,3,3,42,546),(709,345,1,6,48,576),(710,345,2,5,44,484),(711,345,3,2,45,405),(712,346,1,4,35,490),(713,347,1,2,37,333),(714,347,2,6,31,372),(715,348,1,3,48,624),(716,349,1,6,49,588),(717,350,1,6,34,408),(718,351,1,5,45,495),(719,352,1,5,37,407),(720,352,2,6,44,528),(721,353,1,4,39,546),(722,353,2,2,47,423),(723,353,3,5,34,374),(724,354,1,1,40,200),(725,354,2,5,31,341),(726,354,3,7,45,630),(727,355,1,6,40,480),(728,355,2,7,36,504),(729,355,3,4,42,588),(730,356,1,7,35,490),(731,356,2,5,32,352),(732,356,3,1,37,185),(733,357,1,2,49,441),(734,357,2,6,40,480),(735,358,1,6,41,492),(736,358,2,5,48,528),(737,359,1,7,34,476),(738,360,1,4,36,504),(739,360,2,1,34,170),(740,361,1,3,40,520),(741,361,2,7,49,686),(742,361,3,6,33,396),(743,362,1,2,31,279),(744,363,1,6,45,540),(745,364,1,3,41,533),(746,365,1,3,34,442),(747,365,2,4,31,434),(748,365,3,1,47,235),(749,366,1,7,43,602),(750,366,2,2,49,441),(751,366,3,5,35,385),(752,367,1,3,48,624),(753,368,1,3,35,455),(754,368,2,1,33,165),(755,369,1,1,33,165),(756,370,1,3,35,455),(757,370,2,4,40,560),(758,370,3,5,38,418),(759,371,1,5,47,517),(760,371,2,3,45,585),(761,371,3,6,48,576),(762,372,1,6,39,468),(763,372,2,1,47,235),(764,373,1,2,40,360),(765,374,1,7,41,574),(766,374,2,2,39,351),(767,374,3,6,46,552),(768,375,1,5,32,352),(769,375,2,4,30,420),(770,376,1,3,31,403),(771,376,2,5,39,429),(772,377,1,7,37,518),(773,378,1,5,37,407),(774,378,2,6,38,456),(775,379,1,3,38,494),(776,379,2,6,47,564),(777,379,3,2,32,288),(778,380,1,7,46,644),(779,380,2,2,43,387),(780,381,1,6,39,468),(781,382,1,7,37,518),(782,383,1,7,36,504),(783,383,2,6,46,552),(784,383,3,5,46,506),(785,384,1,5,34,374),(786,385,1,2,40,360),(787,385,2,3,36,468),(788,385,3,1,40,200),(789,386,1,4,45,630),(790,386,2,5,38,418),(791,386,3,1,43,215),(792,387,1,4,47,658),(793,387,2,6,46,552),(794,387,3,5,42,462),(795,388,1,3,39,507),(796,388,2,1,41,205),(797,389,1,1,33,165),(798,389,2,2,45,405),(799,390,1,2,45,405),(800,390,2,4,36,504),(801,390,3,6,48,576),(802,391,1,3,49,637),(803,391,2,1,30,150),(804,391,3,5,37,407),(805,392,1,7,33,462),(806,392,2,5,42,462),(807,393,1,7,32,448),(808,394,1,5,35,385),(809,394,2,2,44,396),(810,395,1,7,46,644),(811,395,2,2,33,297),(812,396,1,5,40,440),(813,396,2,2,40,360),(814,397,1,4,32,448),(815,397,2,6,32,384),(816,398,1,3,31,403),(817,398,2,6,41,492),(818,398,3,7,32,448),(819,399,1,1,42,210),(820,399,2,3,44,572),(821,400,1,5,41,451),(822,401,1,3,47,611),(823,401,2,4,48,672),(824,402,1,4,32,448),(825,402,2,5,37,407),(826,403,1,3,31,403),(827,403,2,5,36,396),(828,404,1,1,33,165),(829,404,2,5,44,484),(830,405,1,2,48,432),(831,405,2,3,34,442),(832,405,3,6,43,516),(833,406,1,1,42,210),(834,407,1,3,43,559),(835,407,2,5,44,484),(836,408,1,2,39,351),(837,408,2,3,30,390),(838,408,3,1,31,155),(839,409,1,5,40,440),(840,409,2,7,30,420),(841,410,1,7,46,644),(842,410,2,6,38,456),(843,410,3,4,32,448),(844,411,1,1,43,215),(845,411,2,3,40,520),(846,411,3,6,32,384),(847,412,1,1,43,215),(848,412,2,6,48,576),(849,412,3,4,32,448),(850,413,1,2,41,369),(851,413,2,4,41,574),(852,414,1,7,30,420),(853,414,2,1,30,150),(854,414,3,4,46,644),(855,415,1,5,45,495),(856,415,2,3,30,390),(857,416,1,4,39,546),(858,417,1,4,42,588),(859,418,1,7,41,574),(860,418,2,6,47,564),(861,419,1,5,39,429),(862,420,1,1,34,170),(863,421,1,6,41,492),(864,422,1,5,43,473),(865,422,2,4,37,518),(866,423,1,4,47,658),(867,423,2,7,49,686),(868,424,1,7,38,532),(869,424,2,1,34,170),(870,425,1,7,35,490),(871,425,2,3,33,429),(872,425,3,2,37,333),(873,426,1,7,41,574),(874,426,2,2,41,369),(875,427,1,1,37,185),(876,428,1,1,33,165),(877,428,2,2,43,387),(878,428,3,7,43,602),(879,429,1,4,38,532),(880,429,2,3,38,494),(881,430,1,5,38,418),(882,431,1,4,39,546),(883,431,2,7,49,686),(884,432,1,4,35,490),(885,432,2,7,34,476),(886,433,1,7,44,616),(887,433,2,2,41,369),(888,434,1,7,38,532),(889,434,2,6,45,540),(890,434,3,1,37,185),(891,435,1,2,32,288),(892,435,2,6,36,432),(893,436,1,7,46,644),(894,436,2,5,34,374),(895,437,1,5,33,363),(896,437,2,6,46,552),(897,437,3,3,40,520),(898,438,1,4,36,504),(899,438,2,7,45,630),(900,438,3,2,39,351),(901,439,1,1,45,225),(902,440,1,6,40,480),(903,440,2,4,45,630),(904,440,3,2,33,297),(905,441,1,4,37,518),(906,441,2,2,36,324),(907,442,1,2,43,387),(908,442,2,1,49,245),(909,443,1,3,41,533),(910,444,1,2,40,360),(911,444,2,4,40,560),(912,445,1,2,44,396),(913,445,2,6,43,516),(914,446,1,7,43,602),(915,446,2,5,48,528),(916,446,3,3,30,390),(917,447,1,7,43,602),(918,447,2,5,41,451),(919,448,1,1,48,240),(920,448,2,3,43,559),(921,448,3,6,45,540),(922,449,1,2,37,333),(923,450,1,3,35,455),(924,451,1,6,39,468),(925,451,2,7,36,504),(926,451,3,5,46,506),(927,452,1,5,30,330),(928,452,2,3,44,572),(929,452,3,4,40,560),(930,453,1,1,36,180),(931,453,2,6,31,372),(932,454,1,3,34,442),(933,454,2,5,31,341),(934,455,1,4,43,602),(935,455,2,7,40,560),(936,455,3,3,36,468),(937,456,1,1,35,175),(938,456,2,3,39,507),(939,457,1,4,41,574),(940,457,2,7,37,518),(941,458,1,1,39,195),(942,459,1,4,41,574),(943,460,1,1,31,155),(944,460,2,2,30,270),(945,460,3,5,49,539),(946,461,1,1,36,180),(947,462,1,6,36,432),(948,463,1,1,35,175),(949,463,2,7,32,448),(950,464,1,2,45,405),(951,464,2,7,43,602),(952,465,1,1,41,205),(953,466,1,6,32,384),(954,467,1,6,38,456),(955,467,2,4,37,518),(956,468,1,7,32,448),(957,468,2,3,45,585),(958,469,1,7,37,518),(959,469,2,2,44,396),(960,470,1,4,31,434),(961,470,2,6,33,396),(962,471,1,3,38,494),(963,471,2,5,49,539),(964,472,1,1,37,185),(965,473,1,6,47,564),(966,474,1,2,38,342),(967,474,2,6,38,456),(968,474,3,4,32,448),(969,475,1,2,48,432),(970,475,2,4,41,574),(971,475,3,6,44,528),(972,476,1,4,36,504),(973,476,2,7,40,560),(974,476,3,6,48,576),(975,477,1,2,45,405),(976,478,1,4,40,560),(977,478,2,6,33,396),(978,478,3,3,42,546),(979,479,1,3,48,624),(980,479,2,4,37,518),(981,479,3,2,39,351),(982,480,1,2,33,297),(983,480,2,1,34,170),(984,480,3,5,48,528),(985,481,1,3,40,520),(986,482,1,1,49,245),(987,482,2,6,47,564),(988,483,1,3,43,559),(989,483,2,1,43,215),(990,484,1,2,36,324),(991,485,1,6,41,492),(992,485,2,3,37,481),(993,486,1,4,34,476),(994,486,2,3,37,481),(995,487,1,3,49,637),(996,487,2,1,42,210),(997,488,1,4,32,448),(998,488,2,1,33,165),(999,489,1,3,49,637),(1000,489,2,1,35,175),(1001,489,3,7,31,434),(1002,490,1,1,47,235),(1003,490,2,2,39,351),(1004,491,1,1,34,170),(1005,491,2,3,35,455),(1006,491,3,5,49,539),(1007,492,1,1,34,170),(1008,492,2,6,49,588),(1009,492,3,3,45,585),(1010,493,1,6,40,480),(1011,493,2,5,48,528),(1012,493,3,2,48,432),(1013,494,1,1,38,190),(1014,495,1,2,46,414),(1015,495,2,7,48,672),(1016,496,1,6,42,504),(1017,496,2,4,35,490),(1018,496,3,7,47,658),(1019,497,1,1,45,225),(1020,498,1,4,43,602),(1021,498,2,5,38,418),(1022,499,1,6,47,564),(1023,499,2,7,30,420),(1024,499,3,5,43,473),(1025,500,1,6,37,444),(1026,501,1,7,39,546),(1027,501,2,1,43,215),(1028,501,3,2,36,324),(1029,502,1,7,42,588),(1030,503,1,4,43,602),(1031,504,1,1,38,190),(1032,505,1,2,31,279),(1033,505,2,3,47,611),(1034,505,3,4,32,448),(1035,506,1,2,47,423),(1036,506,2,4,35,490),(1037,507,1,1,48,240),(1038,507,2,6,41,492),(1039,507,3,5,37,407),(1040,508,1,5,43,473),(1041,509,1,6,42,504),(1042,509,2,7,38,532),(1043,509,3,3,38,494),(1044,510,1,2,35,315),(1045,510,2,7,40,560),(1046,511,1,4,33,462),(1047,511,2,5,47,517),(1048,511,3,1,30,150),(1049,512,1,7,33,462),(1050,513,1,6,43,516),(1051,514,1,2,34,306),(1052,514,2,4,41,574),(1053,515,1,6,33,396),(1054,515,2,3,44,572),(1055,515,3,1,49,245),(1056,516,1,1,32,160),(1057,516,2,4,42,588),(1058,516,3,3,39,507),(1059,517,1,5,46,506),(1060,518,1,1,48,240),(1061,519,1,2,35,315),(1062,519,2,6,45,540),(1063,520,1,3,36,468),(1064,520,2,6,38,456),(1065,521,1,3,48,624),(1066,521,2,6,49,588),(1067,522,1,6,46,552),(1068,522,2,7,31,434),(1069,522,3,4,34,476),(1070,523,1,5,39,429),(1071,523,2,1,42,210),(1072,524,1,6,36,432),(1073,525,1,6,30,360),(1074,525,2,3,30,390),(1075,525,3,5,34,374),(1076,526,1,2,31,279),(1077,526,2,5,42,462),(1078,527,1,6,44,528),(1079,527,2,1,37,185),(1080,528,1,1,43,215),(1081,528,2,3,42,546),(1082,528,3,5,40,440),(1083,529,1,2,32,288),(1084,529,2,3,44,572),(1085,529,3,6,39,468),(1086,530,1,4,49,686),(1087,531,1,6,31,372),(1088,531,2,4,42,588),(1089,531,3,7,32,448),(1090,532,1,4,31,434),(1091,532,2,7,44,616),(1092,533,1,5,37,407),(1093,534,1,3,31,403),(1094,534,2,7,34,476),(1095,534,3,1,37,185),(1096,535,1,6,33,396),(1097,535,2,3,35,455),(1098,535,3,5,31,341),(1099,536,1,2,49,441),(1100,536,2,1,49,245),(1101,537,1,2,48,432),(1102,537,2,6,35,420),(1103,537,3,7,40,560),(1104,538,1,4,42,588),(1105,538,2,2,42,378),(1106,539,1,5,39,429),(1107,539,2,6,34,408),(1108,540,1,3,37,481),(1109,540,2,6,31,372),(1110,540,3,7,36,504),(1111,541,1,7,41,574),(1112,541,2,5,30,330),(1113,541,3,2,33,297),(1114,542,1,2,34,306),(1115,542,2,5,44,484),(1116,542,3,4,38,532),(1117,543,1,3,48,624),(1118,544,1,1,36,180),(1119,545,1,6,37,444),(1120,545,2,3,36,468),(1121,546,1,6,32,384),(1122,547,1,5,32,352),(1123,547,2,7,37,518),(1124,548,1,3,37,481),(1125,549,1,6,49,588),(1126,550,1,3,39,507),(1127,551,1,4,33,462),(1128,551,2,6,31,372),(1129,551,3,2,49,441),(1130,552,1,4,48,672),(1131,552,2,3,32,416),(1132,553,1,5,49,539),(1133,553,2,4,31,434),(1134,553,3,2,31,279),(1135,554,1,7,44,616),(1136,555,1,7,37,518),(1137,556,1,2,48,432),(1138,556,2,1,34,170),(1139,556,3,4,47,658),(1140,557,1,2,38,342),(1141,557,2,6,43,516),(1142,557,3,5,44,484),(1143,558,1,1,42,210),(1144,558,2,2,49,441),(1145,558,3,7,35,490),(1146,559,1,5,34,374),(1147,560,1,3,35,455),(1148,560,2,6,46,552),(1149,560,3,5,40,440),(1150,561,1,1,41,205),(1151,562,1,6,40,480),(1152,562,2,7,49,686),(1153,563,1,5,40,440),(1154,563,2,6,41,492),(1155,563,3,2,31,279),(1156,564,1,7,36,504),(1157,565,1,1,47,235),(1158,566,1,1,32,160),(1159,567,1,6,49,588),(1160,567,2,3,38,494),(1161,567,3,4,35,490),(1162,568,1,4,35,490),(1163,568,2,1,46,230),(1164,568,3,6,42,504),(1165,569,1,1,46,230),(1166,569,2,2,43,387),(1167,569,3,7,40,560),(1168,570,1,6,44,528),(1169,571,1,3,42,546),(1170,572,1,6,41,492),(1171,572,2,3,47,611),(1172,573,1,4,47,658),(1173,574,1,7,43,602),(1174,574,2,1,30,150),(1175,574,3,6,46,552),(1176,575,1,5,35,385),(1177,576,1,1,48,240),(1178,576,2,2,38,342),(1179,577,1,3,31,403),(1180,577,2,7,46,644),(1181,578,1,7,38,532),(1182,578,2,3,41,533),(1183,578,3,4,42,588),(1184,579,1,5,48,528),(1185,580,1,5,43,473),(1186,581,1,6,46,552),(1187,582,1,7,38,532),(1188,582,2,5,35,385),(1189,583,1,6,34,408),(1190,583,2,4,43,602),(1191,583,3,7,37,518),(1192,584,1,7,41,574),(1193,584,2,3,43,559),(1194,585,1,7,32,448),(1195,586,1,1,34,170),(1196,586,2,3,31,403),(1197,586,3,2,40,360),(1198,587,1,7,43,602),(1199,588,1,6,30,360),(1200,588,2,4,31,434),(1201,589,1,1,30,150),(1202,589,2,6,35,420),(1203,590,1,6,36,432),(1204,590,2,7,49,686),(1205,591,1,3,37,481),(1206,592,1,7,46,644),(1207,593,1,2,40,360),(1208,594,1,3,35,455),(1209,594,2,5,47,517),(1210,594,3,2,44,396),(1211,595,1,6,43,516),(1212,595,2,4,41,574),(1213,596,1,1,30,150),(1214,596,2,4,36,504),(1215,597,1,7,48,672),(1216,597,2,5,47,517),(1217,597,3,6,37,444),(1218,598,1,5,30,330),(1219,599,1,6,37,444),(1220,599,2,1,48,240),(1221,600,1,3,48,624),(1222,600,2,4,32,448),(1223,601,1,3,34,442),(1224,601,2,5,47,517),(1225,602,1,7,44,616),(1226,602,2,6,32,384),(1227,602,3,1,36,180),(1228,603,1,7,38,532),(1229,603,2,4,34,476),(1230,604,1,5,33,363),(1231,604,2,6,31,372),(1232,604,3,1,33,165),(1233,605,1,7,48,672),(1234,605,2,6,40,480),(1235,606,1,4,42,588),(1236,606,2,5,43,473),(1237,607,1,5,45,495),(1238,607,2,1,41,205),(1239,608,1,4,44,616),(1240,608,2,2,40,360),(1241,609,1,1,41,205),(1242,609,2,7,47,658),(1243,610,1,3,40,520),(1244,611,1,3,38,494),(1245,611,2,6,47,564),(1246,612,1,4,38,532),(1247,612,2,5,43,473),(1248,613,1,1,34,170),(1249,614,1,7,42,588),(1250,615,1,6,38,456),(1251,616,1,3,38,494),(1252,616,2,7,40,560),(1253,616,3,4,41,574),(1254,617,1,4,31,434),(1255,618,1,7,36,504),(1256,619,1,3,38,494),(1257,619,2,5,36,396),(1258,620,1,6,38,456),(1259,620,2,5,45,495),(1260,621,1,5,37,407),(1261,622,1,7,33,462),(1262,623,1,1,37,185),(1263,623,2,7,47,658),(1264,624,1,6,47,564),(1265,625,1,4,34,476),(1266,626,1,1,30,150),(1267,626,2,5,39,429),(1268,626,3,6,45,540),(1269,627,1,5,42,462),(1270,628,1,2,41,369),(1271,629,1,4,43,602),(1272,629,2,1,42,210),(1273,630,1,7,41,574),(1274,630,2,6,34,408),(1275,631,1,6,46,552),(1276,631,2,7,43,602),(1277,632,1,3,38,494),(1278,633,1,2,45,405),(1279,634,1,5,39,429),(1280,635,1,4,46,644),(1281,635,2,6,38,456),(1282,635,3,2,42,378),(1283,636,1,2,33,297),(1284,636,2,1,38,190),(1285,636,3,4,47,658),(1286,637,1,7,39,546),(1287,637,2,4,44,616),(1288,637,3,5,43,473),(1289,638,1,6,42,504),(1290,639,1,3,30,390),(1291,639,2,2,30,270),(1292,639,3,1,41,205),(1293,640,1,2,30,270),(1294,640,2,6,39,468),(1295,641,1,3,47,611),(1296,641,2,6,48,576),(1297,641,3,2,39,351),(1298,642,1,5,39,429),(1299,643,1,6,47,564),(1300,643,2,1,40,200),(1301,643,3,5,34,374),(1302,644,1,1,42,210),(1303,644,2,4,48,672),(1304,645,1,7,49,686),(1305,645,2,5,42,462),(1306,645,3,6,35,420),(1307,646,1,7,37,518),(1308,646,2,6,47,564),(1309,646,3,4,45,630),(1310,647,1,2,43,387),(1311,648,1,4,47,658),(1312,649,1,1,40,200),(1313,649,2,4,49,686),(1314,649,3,7,35,490),(1315,650,1,6,43,516),(1316,651,1,6,32,384),(1317,651,2,5,39,429),(1318,652,1,4,35,490),(1319,652,2,1,49,245),(1320,652,3,5,40,440),(1321,653,1,7,48,672),(1322,653,2,2,32,288),(1323,654,1,3,44,572),(1324,655,1,3,39,507),(1325,655,2,6,33,396),(1326,656,1,5,34,374),(1327,656,2,6,46,552),(1328,657,1,7,32,448),(1329,657,2,4,30,420),(1330,658,1,5,33,363),(1331,659,1,5,31,341),(1332,659,2,2,37,333),(1333,659,3,3,36,468),(1334,660,1,7,40,560),(1335,661,1,4,32,448),(1336,661,2,6,32,384),(1337,661,3,5,38,418),(1338,662,1,7,46,644),(1339,662,2,3,45,585),(1340,662,3,6,48,576),(1341,663,1,6,46,552),(1342,664,1,7,33,462),(1343,665,1,6,46,552),(1344,665,2,2,45,405),(1345,666,1,3,33,429),(1346,667,1,3,43,559),(1347,667,2,2,43,387),(1348,668,1,1,34,170),(1349,668,2,5,35,385),(1350,669,1,1,40,200),(1351,669,2,4,48,672),(1352,669,3,2,38,342),(1353,670,1,4,33,462),(1354,670,2,3,35,455),(1355,671,1,1,31,155),(1356,671,2,7,32,448),(1357,671,3,3,44,572),(1358,672,1,2,48,432),(1359,672,2,5,41,451),(1360,673,1,4,48,672),(1361,673,2,5,37,407),(1362,674,1,3,32,416),(1363,675,1,7,33,462),(1364,675,2,5,46,506),(1365,675,3,3,46,598),(1366,676,1,2,33,297),(1367,676,2,1,41,205),(1368,676,3,3,40,520),(1369,677,1,7,46,644),(1370,677,2,3,49,637),(1371,678,1,6,35,420),(1372,678,2,4,36,504),(1373,678,3,3,30,390),(1374,679,1,4,43,602),(1375,679,2,1,34,170),(1376,679,3,5,37,407),(1377,680,1,2,38,342),(1378,680,2,7,44,616),(1379,680,3,5,36,396),(1380,681,1,6,32,384),(1381,681,2,2,32,288),(1382,682,1,5,39,429),(1383,682,2,7,48,672),(1384,682,3,3,32,416),(1385,683,1,2,39,351),(1386,684,1,7,42,588),(1387,685,1,5,45,495),(1388,685,2,7,49,686),(1389,685,3,2,42,378),(1390,686,1,7,43,602),(1391,687,1,4,49,686),(1392,688,1,7,43,602),(1393,688,2,4,39,546),(1394,689,1,1,35,175),(1395,689,2,6,47,564),(1396,689,3,3,38,494),(1397,690,1,7,40,560),(1398,691,1,2,43,387),(1399,691,2,5,34,374),(1400,692,1,7,47,658),(1401,692,2,3,32,416),(1402,692,3,1,41,205),(1403,693,1,3,45,585),(1404,693,2,5,35,385),(1405,693,3,7,44,616),(1406,694,1,2,45,405),(1407,695,1,1,43,215),(1408,695,2,3,41,533),(1409,696,1,1,43,215),(1410,696,2,4,41,574),(1411,696,3,6,46,552),(1412,697,1,1,47,235),(1413,697,2,7,41,574),(1414,698,1,2,39,351),(1415,698,2,1,49,245),(1416,698,3,4,32,448),(1417,699,1,1,40,200),(1418,699,2,5,40,440),(1419,700,1,1,48,240),(1420,701,1,2,36,324),(1421,701,2,7,33,462),(1422,702,1,5,47,517),(1423,703,1,4,41,574),(1424,704,1,5,48,528),(1425,704,2,1,45,225),(1426,704,3,3,37,481),(1427,705,1,2,36,324),(1428,705,2,5,36,396),(1429,706,1,4,35,490),(1430,707,1,4,38,532),(1431,707,2,7,43,602),(1432,708,1,2,48,432),(1433,708,2,1,45,225),(1434,709,1,2,41,369),(1435,709,2,7,36,504),(1436,709,3,6,41,492),(1437,710,1,1,39,195),(1438,711,1,5,40,440),(1439,711,2,6,32,384),(1440,712,1,3,32,416),(1441,712,2,4,43,602),(1442,712,3,5,37,407),(1443,713,1,4,36,504),(1444,714,1,5,34,374),(1445,714,2,6,45,540),(1446,715,1,7,31,434),(1447,716,1,2,33,297),(1448,717,1,1,46,230),(1449,718,1,2,44,396),(1450,719,1,1,45,225),(1451,720,1,1,37,185),(1452,720,2,5,32,352),(1453,720,3,2,35,315),(1454,721,1,4,33,462),(1455,721,2,2,47,423),(1456,722,1,5,48,528),(1457,723,1,7,48,672),(1458,724,1,7,41,574),(1459,725,1,7,40,560),(1460,725,2,6,46,552),(1461,726,1,5,33,363),(1462,726,2,1,39,195),(1463,726,3,2,30,270),(1464,727,1,5,32,352),(1465,728,1,2,38,342),(1466,729,1,6,45,540),(1467,729,2,7,38,532),(1468,730,1,5,49,539),(1469,730,2,2,34,306),(1470,731,1,5,41,451),(1471,731,2,6,30,360),(1472,731,3,1,43,215),(1473,732,1,5,44,484),(1474,733,1,3,44,572),(1475,733,2,2,40,360),(1476,734,1,4,38,532),(1477,735,1,5,40,440),(1478,736,1,3,39,507),(1479,736,2,7,40,560),(1480,736,3,5,36,396),(1481,737,1,6,35,420),(1482,737,2,1,46,230),(1483,737,3,3,45,585),(1484,738,1,2,42,378),(1485,739,1,3,38,494),(1486,739,2,1,34,170),(1487,740,1,2,49,441),(1488,740,2,4,44,616),(1489,741,1,6,31,372),(1490,741,2,4,42,588),(1491,741,3,5,41,451);
/*!40000 ALTER TABLE `purchase_order_details` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-11-20 11:50:58