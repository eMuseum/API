-- MySQL dump 10.13  Distrib 5.5.35, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: emuseum
-- ------------------------------------------------------
-- Server version       5.5.35-0+wheezy1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `e_autors`
--

DROP TABLE IF EXISTS `e_autors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `e_autors` (
  `id` int(1) NOT NULL AUTO_INCREMENT,
  `nom` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `valoracio` float(1) NOT NULL DEFAULT 0,
  `num_valoracions` int(1) NOT NULL DEFAULT 0,
  `descripcio` text COLLATE utf8_unicode_ci NOT NULL,
  `imatge` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `e_museus`
--

DROP TABLE IF EXISTS `e_museus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `e_museus` (
  `id` int(1) NOT NULL AUTO_INCREMENT,
  `nom` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `direccio` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `latitud` double NOT NULL,
  `longitud` double NOT NULL,
  `telefon` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `hora_laboral_inici` int(1) NOT NULL,
  `hora_laboral_fi` int(1) NOT NULL,
  `hora_festiu_inici` int(1) NOT NULL,
  `hora_festiu_fi` int(1) NOT NULL,
  `wifi_ssid` varchar(256) NOT NULL,
  `wifi_password` varchar(1024) NOT NULL,
  `valoracio` float(1) NOT NULL DEFAULT 0,
  `num_valoracions` int(1) NOT NULL DEFAULT 0,
  `descripcio` text COLLATE utf8_unicode_ci NOT NULL,
  `imatge` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `e_obres`
--

DROP TABLE IF EXISTS `e_obres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `e_obres` (
  `id` int(1) NOT NULL AUTO_INCREMENT,
  `nom` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `mid` int(1) NOT NULL,
  `aid` int(1) NOT NULL,
  `valoracio` float(1) NOT NULL DEFAULT 0,
  `num_valoracions` int(1) NOT NULL DEFAULT 0,
  `descripcio` text COLLATE utf8_unicode_ci NOT NULL,
  `imatge` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mid` (`mid`),
  KEY `aid` (`aid`),
  CONSTRAINT `e_obres_ibfk_1` FOREIGN KEY (`mid`) REFERENCES `e_museus` (`id`) ON DELETE CASCADE,
  CONSTRAINT `e_obres_ibfk_2` FOREIGN KEY (`aid`) REFERENCES `e_autors` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `e_users`
--

DROP TABLE IF EXISTS `e_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `e_users` (
  `id` int(1) NOT NULL AUTO_INCREMENT,
  `username` varchar(256) NOT NULL,
  `password` varchar(256) NOT NULL,
  `email` varchar(256) NOT NULL,
  `reset_key` varchar(512) DEFAULT '',
  `reset_time` int(1) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `e_version`
--

DROP TABLE IF EXISTS `e_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `e_version` (
  `name` varchar(256) NOT NULL DEFAULT '',
  `version` smallint(1) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `e_version`
--

LOCK TABLES `e_version` WRITE;
/*!40000 ALTER TABLE `e_version` DISABLE KEYS */;
INSERT INTO `e_version` VALUES ('API',1),('Global',2);
/*!40000 ALTER TABLE `e_version` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


DROP TABLE IF EXISTS `e_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `e_comments` (
  `id` int(1) NOT NULL AUTO_INCREMENT,
  `eid` int(1) NOT NULL,
  `type` tinyint(1) NOT NULL,
  `username` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `comment` text COLLATE utf8_unicode_ci NOT NULL,
  `date` int(1) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


DROP TABLE IF EXISTS `e_admins`;
CREATE TABLE `e_admins` (
  `id` int(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;
