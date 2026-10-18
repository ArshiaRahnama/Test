-- Jobs for the barber and tattoo shops (one job + one society per type).
-- Safe to run more than once.

INSERT IGNORE INTO `jobs` (`name`, `label`) VALUES
	('barber', 'Barber Shop'),
	('tattoo', 'Tattoo Shop');

INSERT IGNORE INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
	('barber', 0, 'recruit', 'Recruit', 200, '{}', '{}'),
	('barber', 1, 'employee', 'Employee', 300, '{}', '{}'),
	('barber', 2, 'manager', 'Manager', 450, '{}', '{}'),
	('barber', 3, 'boss', 'Boss', 600, '{}', '{}'),
	('tattoo', 0, 'recruit', 'Recruit', 200, '{}', '{}'),
	('tattoo', 1, 'employee', 'Employee', 300, '{}', '{}'),
	('tattoo', 2, 'manager', 'Manager', 450, '{}', '{}'),
	('tattoo', 3, 'boss', 'Boss', 600, '{}', '{}');

INSERT IGNORE INTO `addon_account` (`name`, `label`, `shared`) VALUES
	('society_barber', 'Barber Shop', 1),
	('society_tattoo', 'Tattoo Shop', 1);

-- Old per-shop jobs (barber1..7, tattoo1..4) can be removed once nobody holds them:
-- DELETE FROM job_grades WHERE job_name REGEXP '^(barber|tattoo)[0-9]+$';
-- DELETE FROM jobs WHERE name REGEXP '^(barber|tattoo)[0-9]+$';
