CREATE DATABASE  IF NOT EXISTS `sas`;
USE `sas`;

--
-- Table structure for table `users`
--
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `entity_status` varchar(32) NOT NULL,
  `version` int(11) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password_hash` varchar(64) DEFAULT NULL,
  `user_name` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_users_user_name` (`user_name`),
  KEY `created_by` (`created_by`),
  KEY `updated_by` (`updated_by`),
  KEY `idx_users_email` (`email`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `users_ibfk_2` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

INSERT INTO `users` (`id`, `created_at`, `created_by`, `updated_at`, `updated_by`, `entity_status`, `version`, `email`, `password_hash`, `user_name`)
VALUES
  (1, now(), 1, now(), NULL, 'ACTIVE', 1, 'test@test.com', 'Password1234', 'test'),
  (2, now(), 1, now(), NULL, 'ACTIVE', 1, 'test@test.com', 'Password1234', 'admin');
  
  --
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `entity_status` varchar(32) NOT NULL,
  `version` int(11) NOT NULL,
  `role_name` varchar(32) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_roles_role_name` (`role_name`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `roles_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `role`
--
INSERT INTO `roles` (`created_at`, `entity_status`, `version`, `role_name`)
VALUES
  (now(), 'ACTIVE', 1, 'ROLE_USER'),
  (now(), 'ACTIVE', 1, 'ROLE_ADMIN');



--
-- Table structure for table `user_role`
--

CREATE TABLE `user_roles` (
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `user_roles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `user_roles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO user_roles(user_id, role_id)
SELECT u.id, r.id from users u, roles r where u.user_name='admin' and r.role_name='ROLE_ADMIN';

INSERT INTO user_roles(user_id, role_id)
SELECT u.id, r.id from users u, roles r where u.user_name='admin' and r.role_name='ROLE_USER';

INSERT INTO user_roles(user_id, role_id)
SELECT u.id, r.id from users u, roles r where u.user_name='test' and r.role_name='ROLE_USER';
