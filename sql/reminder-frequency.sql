DROP TABLE IF EXISTS `reminder_frequency`;
CREATE TABLE `answer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `frequency` enum('DAILY','WEEKLY','MONTHLY','QUARTERLY'),
  `created` datetime NOT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TRIGGER reminder_frequency_created BEFORE INSERT ON reminder_frequency FOR EACH ROW SET new.created = now();
