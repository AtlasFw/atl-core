CREATE DATABASE IF NOT EXISTS `atlas`;

USE `atlas`;

CREATE TABLE `users` (
    `char_id` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `license` VARCHAR(60) NOT NULL,
    `group` VARCHAR(60) NOT NULL,
    `accounts` longtext,
    `appearance` longtext,
    `status` longtext,
    `inventory` longtext,
    `identity` longtext,
    `job_data` longtext,
    `char_data` longtext
) DEFAULT CHARSET UTF8;
