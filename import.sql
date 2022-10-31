CREATE DATABASE IF NOT EXISTS `atlas`;

USE `atlas`;

CREATE TABLE `users` (
    `user_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(50) DEFAULT NULL,
    `identifiers` JSON DEFAULT '{}' CHECK (JSON_VALID(`identifiers`)),
    `group` VARCHAR(60) DEFAULT 'user',
    `slots` TINYINT DEFAULT 3,
    PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

CREATE TABLE `characters` (
    `char_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` INT UNSIGNED NOT NULL,
    `first_name` VARCHAR(20) NOT NULL,
    `last_name` VARCHAR(20) NOT NULL,
    `sex` VARCHAR(1) NOT NULL,
    `dob` DATE NOT NULL,
    `quote` VARCHAR(100) DEFAULT NULL,
    `accounts` LONGTEXT NOT NULL,
    `jobs` LONGTEXT NOT NULL,
    `statuses` LONGTEXT NOT NULL,
    `inventory` LONGTEXT NOT NULL,
    `appearance` LONGTEXT NOT NULL,
    `metadata` LONGTEXT NOT NULL,
    `last_played` DATE DEFAULT CURDATE(),
    `is_dead` TINYINT DEFAULT 0,
    `banned` TINYINT DEFAULT 0,
    `deleted` TINYINT DEFAULT 0,
    PRIMARY KEY (`char_id`) USING BTREE,
    FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;