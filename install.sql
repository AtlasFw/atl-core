CREATE DATABASE IF NOT EXISTS `atlas`;
USE `atlas`;

CREATE TABLE `users` (
  `license` VARCHAR(60) NOT NULL,
  `name` VARCHAR(60) NOT NULL,
  `group` VARCHAR(60) NOT NULL,
  `slots` INT NOT NULL,
  `banned` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`license`)
) DEFAULT CHARSET=utf8mb4;

CREATE TABLE `characters` (
  `char_id` int NOT NULL AUTO_INCREMENT,
  `license` VARCHAR(60) NOT NULL,
  `accounts` longtext NOT NULL,
  `appearance` longtext,
  `banned` tinyint(1) NOT NULL DEFAULT '0',
  `char_data` longtext,
  `identity` longtext,
  `inventory` longtext NOT NULL DEFAULT '[]',
  `job_data` longtext,
  `last_played` date NOT NULL DEFAULT (CURRENT_DATE),
  `status` longtext,
  PRIMARY KEY (`char_id`)
) DEFAULT CHARSET=utf8mb4;
