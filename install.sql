CREATE DATABASE IF NOT EXISTS `atlas`;
USE `atlas`;

CREATE TABLE `users` (
  `license` VARCHAR(60) NOT NULL,
  `name` VARCHAR(60) NOT NULL,
  `group` VARCHAR(60) NOT NULL,
  `slots` INTEGER(2) NOT NULL,
  `banned` BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (`license`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
  `last_played` date NOT NULL DEFAULT CURDATE(),
  `status` longtext,
  PRIMARY KEY (`char_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;