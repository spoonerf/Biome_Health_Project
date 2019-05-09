CREATE TABLE `country` (
	`country_id` INT(3) NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (`country_id`)
);

CREATE TABLE `terrestrial_site` (
	`site_id` INT(7) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(250) NOT NULL UNIQUE,
	`country_id` INT(3) NOT NULL UNIQUE,
	`lattitude` DECIMAL(10) NOT NULL,
	`longitude` DECIMAL(10) NOT NULL,
	`altitude` DECIMAL(10) NOT NULL,
	`rainfall` DECIMAL(10),
	`temperature` DECIMAL(10),
	PRIMARY KEY (`site_id`)
);

CREATE TABLE `camera` (
	`camera_id` INT(50) NOT NULL UNIQUE,
	`site_id` BINARY NOT NULL,
	`height` DECIMAL(4) NOT NULL,
	`date_installed` DATE(15) NOT NULL,
	PRIMARY KEY (`camera_id`)
);

CREATE TABLE `geography` (
	`country_id` INT(7) NOT NULL
);

CREATE TABLE `aqautic_site` (
	`site_id` INT(7) NOT NULL AUTO_INCREMENT,
	`country_id` INT(3) NOT NULL,
	`name` VARCHAR(250) NOT NULL,
	`lattitude` DECIMAL(10) NOT NULL,
	`longitude` DECIMAL(10) NOT NULL,
	`temperature` DECIMAL(10) NOT NULL,
	`salinity` DECIMAL(10) NOT NULL,
	`biome` VARCHAR(50) NOT NULL,
	PRIMARY KEY (`site_id`)
);

CREATE TABLE `transect` (
	`transect_id` INT(7) NOT NULL AUTO_INCREMENT,
	`site_id` INT(7) NOT NULL,
	`length` DECIMAL(50) NOT NULL,
	`date` DATE(50) NOT NULL,
	`time` TIME(50) NOT NULL,
	`depth` INT(10) NOT NULL,
	PRIMARY KEY (`transect_id`)
);

CREATE TABLE `edna` (
	`edna_id` INT(y) NOT NULL AUTO_INCREMENT,
	`site_id` INT(7) NOT NULL,
	PRIMARY KEY (`edna_id`)
);

CREATE TABLE `image_terrestrial` (
	`image_id` INT(7) NOT NULL AUTO_INCREMENT,
	`camera_id` INT(50) NOT NULL,
	`filename` VARCHAR(50) NOT NULL UNIQUE,
	`time` TIME(15) NOT NULL UNIQUE,
	`date` DATE(15) NOT NULL UNIQUE,
	PRIMARY KEY (`image_id`)
);

CREATE TABLE `3d_model` (
	`` BINARY NOT NULL
);

CREATE TABLE `species` (
	`image_id` INT(7) NOT NULL,
	`species_id` INT(7) NOT NULL UNIQUE,
	`binomial` VARCHAR(30) NOT NULL,
	`genus` VARCHAR(30) NOT NULL,
	`species` VARCHAR(30),
	`subspecies` VARCHAR(30) NOT NULL,
	`country_id` INT(7) NOT NULL,
	`site_id` INT(7) NOT NULL,
	PRIMARY KEY (`species_id`)
);

CREATE TABLE `individuals` (
	`individual_id` INT(7) NOT NULL AUTO_INCREMENT,
	`species_id` INT(7) NOT NULL,
	PRIMARY KEY (`individual_id`)
);

CREATE TABLE `microphone` (
	`mic_id` INT(7) NOT NULL AUTO_INCREMENT,
	`site_id` INT(7) NOT NULL,
	`height` INT(7) NOT NULL,
	`date_installed` DATE(15) NOT NULL,
	PRIMARY KEY (`mic_id`)
);

CREATE TABLE `recording` (
	`recording_id` INT(7) NOT NULL AUTO_INCREMENT,
	`mic_id` INT(7) NOT NULL,
	`filename` VARCHAR(50) NOT NULL UNIQUE,
	`time` TIME(15) NOT NULL,
	`date` DATE(15) NOT NULL,
	PRIMARY KEY (`recording_id`)
);

CREATE TABLE `disturbance` (

);

CREATE TABLE `disturbance_int` (
	`disturbance_int` BINARY NOT NULL,
	`terrestrial` BINARY NOT NULL
);

ALTER TABLE `terrestrial_site` ADD CONSTRAINT `terrestrial_site_fk0` FOREIGN KEY (`country_id`) REFERENCES `country`(`country_id`);

ALTER TABLE `camera` ADD CONSTRAINT `camera_fk0` FOREIGN KEY (`site_id`) REFERENCES `terrestrial_site`(`site_id`);

ALTER TABLE `geography` ADD CONSTRAINT `geography_fk0` FOREIGN KEY (`country_id`) REFERENCES `country`(`country_id`);

ALTER TABLE `aqautic_site` ADD CONSTRAINT `aqautic_site_fk0` FOREIGN KEY (`country_id`) REFERENCES `country`(`country_id`);

ALTER TABLE `transect` ADD CONSTRAINT `transect_fk0` FOREIGN KEY (`site_id`) REFERENCES `aqautic_site`(`site_id`);

ALTER TABLE `edna` ADD CONSTRAINT `edna_fk0` FOREIGN KEY (`site_id`) REFERENCES `aqautic_site`(`site_id`);

ALTER TABLE `image_terrestrial` ADD CONSTRAINT `image_terrestrial_fk0` FOREIGN KEY (`camera_id`) REFERENCES `camera`(`camera_id`);

ALTER TABLE `3d_model` ADD CONSTRAINT `3d_model_fk0` FOREIGN KEY (``) REFERENCES `transect`(`transect_id`);

ALTER TABLE `species` ADD CONSTRAINT `species_fk0` FOREIGN KEY (`image_id`) REFERENCES `image_terrestrial`(`image_id`);

ALTER TABLE `species` ADD CONSTRAINT `species_fk1` FOREIGN KEY (`country_id`) REFERENCES `country`(`country_id`);

ALTER TABLE `species` ADD CONSTRAINT `species_fk2` FOREIGN KEY (`site_id`) REFERENCES `terrestrial_site`(`site_id`);

ALTER TABLE `individuals` ADD CONSTRAINT `individuals_fk0` FOREIGN KEY (`species_id`) REFERENCES `species`(`species_id`);

ALTER TABLE `microphone` ADD CONSTRAINT `microphone_fk0` FOREIGN KEY (`site_id`) REFERENCES `terrestrial_site`(`site_id`);

ALTER TABLE `recording` ADD CONSTRAINT `recording_fk0` FOREIGN KEY (`mic_id`) REFERENCES `microphone`(`mic_id`);

