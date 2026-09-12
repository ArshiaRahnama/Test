USE `essentialmode`;

INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
	('caution', 'Caution', 0)
ON DUPLICATE KEY UPDATE
	`label` = VALUES(`label`),
	`shared` = VALUES(`shared`)
;

INSERT INTO `jobs` (`name`, `label`) VALUES
	('slaughterer', 'Slaughterer'),
	('fisherman', 'Fisherman'),
	('miner', 'Miner'),
	('lumberjack', 'Lumberjack'),
	('fueler', 'Fueler'),
	('reporter', 'Reporter'),
	('tailor', 'Tailor')
ON DUPLICATE KEY UPDATE
	`label` = VALUES(`label`)
;

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
	('lumberjack', 0, 'employee', 'Employee', 0, '{}', '{}'),
	('fisherman', 0, 'employee', 'Employee', 0, '{}', '{}'),
	('fueler', 0, 'employee', 'Employee', 0, '{}', '{}'),
	('reporter', 0, 'employee', 'Employee', 0, '{}', '{}'),
	('tailor', 0, 'employee', 'Employee', 0, '{"mask_1":0,"arms":1,"glasses_1":0,"hair_color_2":4,"makeup_1":0,"face":19,"glasses":0,"mask_2":0,"makeup_3":0,"skin":29,"helmet_2":0,"lipstick_4":0,"sex":0,"torso_1":24,"makeup_2":0,"bags_2":0,"chain_2":0,"ears_1":-1,"bags_1":0,"bproof_1":0,"shoes_2":0,"lipstick_2":0,"chain_1":0,"tshirt_1":0,"eyebrows_3":0,"pants_2":0,"beard_4":0,"torso_2":0,"beard_2":6,"ears_2":0,"hair_2":0,"shoes_1":36,"tshirt_2":0,"beard_3":0,"hair_1":2,"hair_color_1":0,"pants_1":48,"helmet_1":-1,"bproof_2":0,"eyebrows_4":0,"eyebrows_2":0,"decals_1":0,"age_2":0,"beard_1":5,"shoes":10,"lipstick_1":0,"eyebrows_1":0,"glasses_2":0,"makeup_4":0,"decals_2":0,"lipstick_3":0,"age_1":0}', '{"mask_1":0,"arms":5,"glasses_1":5,"hair_color_2":4,"makeup_1":0,"face":19,"glasses":0,"mask_2":0,"makeup_3":0,"skin":29,"helmet_2":0,"lipstick_4":0,"sex":1,"torso_1":52,"makeup_2":0,"bags_2":0,"chain_2":0,"ears_1":-1,"bags_1":0,"bproof_1":0,"shoes_2":1,"lipstick_2":0,"chain_1":0,"tshirt_1":23,"eyebrows_3":0,"pants_2":0,"beard_4":0,"torso_2":0,"beard_2":6,"ears_2":0,"hair_2":0,"shoes_1":42,"tshirt_2":4,"beard_3":0,"hair_1":2,"hair_color_1":0,"pants_1":36,"helmet_1":-1,"bproof_2":0,"eyebrows_4":0,"eyebrows_2":0,"decals_1":0,"age_2":0,"beard_1":5,"shoes":10,"lipstick_1":0,"eyebrows_1":0,"glasses_2":0,"makeup_4":0,"decals_2":0,"lipstick_3":0,"age_1":0}'),
	('miner', 0, 'employee', 'Employee', 0, '{"tshirt_2":1,"ears_1":8,"glasses_1":15,"torso_2":0,"ears_2":2,"glasses_2":3,"shoes_2":1,"pants_1":75,"shoes_1":51,"bags_1":0,"helmet_2":0,"pants_2":7,"torso_1":71,"tshirt_1":59,"arms":2,"bags_2":0,"helmet_1":0}', '{}'),
	('slaughterer', 0, 'employee', 'Employee', 0, '{"age_1":0,"glasses_2":0,"beard_1":5,"decals_2":0,"beard_4":0,"shoes_2":0,"tshirt_2":0,"lipstick_2":0,"hair_2":0,"arms":67,"pants_1":36,"skin":29,"eyebrows_2":0,"shoes":10,"helmet_1":-1,"lipstick_1":0,"helmet_2":0,"hair_color_1":0,"glasses":0,"makeup_4":0,"makeup_1":0,"hair_1":2,"bproof_1":0,"bags_1":0,"mask_1":0,"lipstick_3":0,"chain_1":0,"eyebrows_4":0,"sex":0,"torso_1":56,"beard_2":6,"shoes_1":12,"decals_1":0,"face":19,"lipstick_4":0,"tshirt_1":15,"mask_2":0,"age_2":0,"eyebrows_3":0,"chain_2":0,"glasses_1":0,"ears_1":-1,"bags_2":0,"ears_2":0,"torso_2":0,"bproof_2":0,"makeup_2":0,"eyebrows_1":0,"makeup_3":0,"pants_2":0,"beard_3":0,"hair_color_2":4}', '{"age_1":0,"glasses_2":0,"beard_1":5,"decals_2":0,"beard_4":0,"shoes_2":0,"tshirt_2":0,"lipstick_2":0,"hair_2":0,"arms":72,"pants_1":45,"skin":29,"eyebrows_2":0,"shoes":10,"helmet_1":-1,"lipstick_1":0,"helmet_2":0,"hair_color_1":0,"glasses":0,"makeup_4":0,"makeup_1":0,"hair_1":2,"bproof_1":0,"bags_1":0,"mask_1":0,"lipstick_3":0,"chain_1":0,"eyebrows_4":0,"sex":1,"torso_1":49,"beard_2":6,"shoes_1":24,"decals_1":0,"face":19,"lipstick_4":0,"tshirt_1":9,"mask_2":0,"age_2":0,"eyebrows_3":0,"chain_2":0,"glasses_1":5,"ears_1":-1,"bags_2":0,"ears_2":0,"torso_2":0,"bproof_2":0,"makeup_2":0,"eyebrows_1":0,"makeup_3":0,"pants_2":0,"beard_3":0,"hair_color_2":4}')
ON DUPLICATE KEY UPDATE
	`name` = VALUES(`name`),
	`label` = VALUES(`label`),
	`salary` = VALUES(`salary`),
	`skin_male` = VALUES(`skin_male`),
	`skin_female` = VALUES(`skin_female`)
;

INSERT INTO `items` (`name`, `label`, `limit`) VALUES
	('alive_chicken', 'Live Chicken', 20),
	('slaughtered_chicken', 'Slaughtered Chicken', 20),
	('packaged_chicken', 'Packaged Chicken', 100),
	('fish', 'Fish', 100),
	('stone', 'Stone', 7),
	('washed_stone', 'Washed Stone', 7),
	('copper', 'Copper', 56),
	('iron', 'Iron', 42),
	('gold', 'Gold', 21),
	('diamond', 'Diamond', 50),
	('wood', 'Wood', 20),
	('cutted_wood', 'Cut Wood', 20),
	('packaged_plank', 'Packaged Plank', 100),
	('petrol', 'Petrol', 24),
	('petrol_raffin', 'Refined Petrol', 24),
	('essence', 'Gasoline', 24),
	('wool', 'Wool', 40),
	('fabric', 'Fabric', 80),
	('clothe', 'Clothing', 40)
ON DUPLICATE KEY UPDATE
	`label` = VALUES(`label`),
	`limit` = VALUES(`limit`)
;

-- Admin uniform-editor history (persisted in the DB, not a resource file,
-- so it survives resource updates/redeploys)
CREATE TABLE IF NOT EXISTS `esx_jobs_uniforms` (
	`job` VARCHAR(50) NOT NULL,
	`gender` VARCHAR(10) NOT NULL,
	`active_id` VARCHAR(50) NULL,
	`previous_active_id` VARCHAR(50) NULL,
	`history` LONGTEXT NOT NULL,
	PRIMARY KEY (`job`, `gender`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- if the table already existed from before Undo was added, this adds the
-- column without erroring (MySQL 8.0.29+ / MariaDB support IF NOT EXISTS
-- here; on older MySQL just ignore the "duplicate column" error if it's
-- already there)
ALTER TABLE `esx_jobs_uniforms` ADD COLUMN IF NOT EXISTS `previous_active_id` VARCHAR(50) NULL;
