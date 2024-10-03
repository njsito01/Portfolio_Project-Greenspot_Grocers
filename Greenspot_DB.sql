CREATE DATABASE  IF NOT EXISTS `greenspot_grocers` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `greenspot_grocers`;
-- MySQL dump 10.13  Distrib 8.0.38, for macos14 (x86_64)
--
-- Host: localhost    Database: greenspot_grocers
-- ------------------------------------------------------
-- Server version	8.0.38

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
-- Table structure for table `items`
--

DROP TABLE IF EXISTS `items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `items` (
  `item_number` int NOT NULL,
  `item_desc` varchar(100) DEFAULT NULL,
  `item_type` varchar(45) DEFAULT NULL,
  `unit` varchar(45) DEFAULT NULL,
  `location` varchar(45) DEFAULT NULL,
  `quantity_on_hand` int DEFAULT NULL,
  `vendor_id` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`item_number`),
  UNIQUE KEY `item_number_UNIQUE` (`item_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `items`
--

LOCK TABLES `items` WRITE;
/*!40000 ALTER TABLE `items` DISABLE KEYS */;
INSERT INTO `items` VALUES (1000,'Bennet Farm free-range eggs','Dairy','dozen','D12',17,'V-1'),(1100,'Freshness White beans','Canned','12 oz can','A2',26,'V-2'),(1222,'Freshness Green beans','Canned','12 oz can','A3',28,'V-2'),(1223,'Freshness Green beans','Canned','36 oz can','A7',15,'V-2'),(1224,'Freshness Wax beans','Canned','12 oz can','A3',15,'V-2'),(2000,'Ruby\'s Kale','Produce','bunch','P12',21,'V-3'),(2001,'Ruby\'s Organic Kale','Produce','bunch','PO2',22,'V-3');
/*!40000 ALTER TABLE `items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchases`
--

DROP TABLE IF EXISTS `purchases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchases` (
  `purchase_id` varchar(10) NOT NULL,
  `vendor_id` varchar(10) DEFAULT NULL,
  `item_number` int DEFAULT NULL,
  `date_purchased` datetime DEFAULT NULL,
  `quantity_purchased` int DEFAULT NULL,
  `cost_per_unit` decimal(10,2) DEFAULT NULL,
  `trans_type` varchar(45) DEFAULT 'Purchase',
  PRIMARY KEY (`purchase_id`),
  UNIQUE KEY `purchase_id_UNIQUE` (`purchase_id`),
  KEY `fk_purchases_items1_idx` (`item_number`),
  KEY `fk_purchases_vendors1_idx` (`vendor_id`),
  CONSTRAINT `fk_purchases_items1` FOREIGN KEY (`item_number`) REFERENCES `items` (`item_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchases`
--

LOCK TABLES `purchases` WRITE;
/*!40000 ALTER TABLE `purchases` DISABLE KEYS */;
INSERT INTO `purchases` VALUES ('P-1','V-1',1000,'2022-02-01 00:00:00',25,2.35,'Purchase'),('P-2','V-2',1100,'2022-02-02 00:00:00',40,0.69,'Purchase'),('P-3','V-2',1222,'2022-02-10 00:00:00',40,0.59,'Purchase'),('P-4','V-2',1223,'2022-02-10 00:00:00',10,1.75,'Purchase'),('P-5','V-2',1223,'2022-02-15 00:00:00',10,1.80,'Purchase'),('P-6','V-2',1224,'2022-02-10 00:00:00',30,0.68,'Purchase'),('P-7','V-2',2000,'2022-02-12 00:00:00',25,1.29,'Purchase'),('P-8','V-3',2001,'2022-02-12 00:00:00',20,2.19,'Purchase');
/*!40000 ALTER TABLE `purchases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales`
--

DROP TABLE IF EXISTS `sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales` (
  `sale_id` varchar(10) NOT NULL,
  `customer_id` varchar(10) DEFAULT NULL,
  `item_number` int DEFAULT NULL,
  `date_sold` datetime DEFAULT NULL,
  `quantity_sold` int DEFAULT NULL,
  `price_per_unit` decimal(10,2) DEFAULT NULL,
  `trans_type` varchar(45) DEFAULT 'Sale',
  PRIMARY KEY (`sale_id`),
  UNIQUE KEY `sale_id_UNIQUE` (`sale_id`),
  KEY `fk_sales_items_idx` (`item_number`),
  CONSTRAINT `fk_sales_items` FOREIGN KEY (`item_number`) REFERENCES `items` (`item_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales`
--

LOCK TABLES `sales` WRITE;
/*!40000 ALTER TABLE `sales` DISABLE KEYS */;
INSERT INTO `sales` VALUES ('S-1','C-198765',1000,'2022-02-02 00:00:00',2,5.49,'Sale'),('S-10',NULL,2000,'2022-02-02 00:00:00',2,3.99,'Sale'),('S-11','C-111000',2000,'2022-02-15 00:00:00',2,3.99,'Sale'),('S-12','C-100988',2001,'2022-02-13 00:00:00',1,6.99,'Sale'),('S-13','C-202900',2001,'2022-02-14 00:00:00',12,6.99,'Sale'),('S-2','C-196777',1000,'2022-02-04 00:00:00',2,5.99,'Sale'),('S-3','C-277177',1000,'2022-02-11 00:00:00',4,5.49,'Sale'),('S-4','C-202900',1100,'2022-02-02 00:00:00',2,1.49,'Sale'),('S-5','C-198765',1100,'2022-02-07 00:00:00',8,1.49,'Sale'),('S-6',NULL,1100,'2022-02-11 00:00:00',4,1.49,'Sale'),('S-7','C-111000',1222,'2022-02-12 00:00:00',12,1.29,'Sale'),('S-8','C-198765',1223,'2022-02-13 00:00:00',5,3.49,'Sale'),('S-9',NULL,1224,'2022-02-12 00:00:00',8,1.55,'Sale');
/*!40000 ALTER TABLE `sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vendors`
--

DROP TABLE IF EXISTS `vendors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vendors` (
  `vendor_id` varchar(10) NOT NULL,
  `vendor_name` varchar(100) DEFAULT NULL,
  `street` varchar(100) DEFAULT NULL,
  `city` varchar(45) DEFAULT NULL,
  `state` varchar(2) DEFAULT NULL,
  `zip_code` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`vendor_id`),
  UNIQUE KEY `vendor_id_UNIQUE` (`vendor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vendors`
--

LOCK TABLES `vendors` WRITE;
/*!40000 ALTER TABLE `vendors` DISABLE KEYS */;
INSERT INTO `vendors` VALUES ('V-1','Bennet Farms','R. 17','Evansville','IL','55446'),('V-2','Freshness, Inc.','202 E. Maple St.','St. Joseph','MO','45678'),('V-3','Ruby Redd Produce, LLC','1212 Milam St.','Kenosha','AL','34567');
/*!40000 ALTER TABLE `vendors` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-02 15:40:27
