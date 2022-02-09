CREATE TABLE `users` (
    `character_id` int NOT NULL AUTO_INCREMENT,
    `license` VARCHAR(60) NOT NULL,
    `group` VARCHAR(60) NOT NULL,
    `accounts` longtext,
    `appearance` longtext,
    `status` longtext,
    `inventory` longtext,
    `identity` longtext,
    `job_data` longtext,
    `char_data` longtext,
    PRIMARY KEY (`character_id`)
) DEFAULT CHARSET=utf8;