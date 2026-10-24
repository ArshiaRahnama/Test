-- Government job (department "gov"). Run once. Safe to run again.
INSERT IGNORE INTO `jobs` (`name`, `label`, `whitelisted`) VALUES ('government', 'Government', 1);

INSERT IGNORE INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
  ('government', 0, 'spector',    'Government Spector',      1500, '{}', '{}'),
  ('government', 1, 'agent',      'Government Agent',        2200, '{}', '{}'),
  ('government', 2, 'management', 'Government Management',   3000, '{}', '{}'),
  ('government', 3, 'chief',      'Chief Of Government',     4000, '{}', '{}');
