CREATE TABLE `users` (
  `license` VARCHAR(60) NOT NULL,
  `name` VARCHAR(60) NOT NULL,
  `group` VARCHAR(60) NOT NULL,
  `slots` INTEGER(2) NOT NULL,
  PRIMARY KEY (`license`)
) DEFAULT CHARSET UTF8;

CREATE TABLE `characters` (
  `char_id` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `license` VARCHAR(60) NOT NULL,
  `accounts` longtext,
  `appearance` longtext,
  `char_data` longtext
  `identity` longtext,
  `inventory` longtext,
  `job_data` longtext,
  `status` longtext,
) DEFAULT CHARSET UTF8;