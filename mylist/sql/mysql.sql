-- Adminer 4.6.2 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

DELIMITER ;;

DROP PROCEDURE IF EXISTS `clean_all`;;
CREATE PROCEDURE `clean_all`()
BEGIN

    DELETE FROM users WHERE true;
    DELETE FROM nodes WHERE true;
    DELETE FROM texts WHERE true;
    DELETE FROM images WHERE true;
    DELETE FROM musics WHERE true;
    DELETE FROM videos WHERE true;
    DELETE FROM parts WHERE true;
    DELETE FROM options WHERE true;

END;;

DELIMITER ;

DROP TABLE IF EXISTS `images`;
CREATE TABLE `images` (
                          `id` bigint(20) unsigned NOT NULL,
                          `image_url` varchar(511) COLLATE utf8mb4_unicode_ci NOT NULL,
                          `image_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                          `image_author` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                          `image_gallery` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                          `image_source` varchar(511) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                          PRIMARY KEY (`id`),
                          CONSTRAINT `images_ibfk_3` FOREIGN KEY (`id`) REFERENCES `nodes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `musics`;
CREATE TABLE `musics` (
                          `id` bigint(20) unsigned NOT NULL,
                          `music_url` varchar(511) COLLATE utf8mb4_unicode_ci NOT NULL,
                          `music_format` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
                          PRIMARY KEY (`id`),
                          CONSTRAINT `musics_ibfk_2` FOREIGN KEY (`id`) REFERENCES `nodes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `nodes`;
CREATE TABLE `nodes` (
                         `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                         `node_user` bigint(20) unsigned NOT NULL,
                         `node_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'list',
                         `node_ctime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Create Time',
                         `node_mtime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Modify Time',
                         `node_title` text COLLATE utf8mb4_unicode_ci,
                         `node_excerpt` text COLLATE utf8mb4_unicode_ci,
                         `node_part` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Is a part',
                         `node_collection` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Ts a collection',
                         `node_permission` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'private',
                         `node_nsfw` tinyint(1) NOT NULL DEFAULT '0',
                         `node_like` tinyint(1) NOT NULL DEFAULT '0',
                         `node_hide` tinyint(1) NOT NULL DEFAULT '0',
                         `node_source` varchar(511) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                         `node_description` text COLLATE utf8mb4_unicode_ci,
                         `node_comment` text COLLATE utf8mb4_unicode_ci,
                         PRIMARY KEY (`id`),
                         KEY `node_ctime` (`node_ctime`),
                         KEY `node_mtime` (`node_mtime`),
                         KEY `node_user` (`node_user`),
                         CONSTRAINT `nodes_ibfk_1` FOREIGN KEY (`node_user`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `parts`;
CREATE TABLE `parts` (
                         `part_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                         `part_parent_id` bigint(20) unsigned NOT NULL COMMENT 'ID of parent node',
                         `part_content_id` bigint(20) unsigned NOT NULL COMMENT 'ID of content node',
                         `part_content_order` int(15) unsigned NOT NULL DEFAULT '0' COMMENT 'Order of content node',
                         PRIMARY KEY (`part_id`),
                         KEY `part_node_id` (`part_parent_id`),
                         KEY `part_content_id` (`part_content_id`),
                         CONSTRAINT `parts_ibfk_2` FOREIGN KEY (`part_parent_id`) REFERENCES `nodes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
                         CONSTRAINT `parts_ibfk_3` FOREIGN KEY (`part_content_id`) REFERENCES `nodes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `texts`;
CREATE TABLE `texts` (
                         `id` bigint(20) unsigned NOT NULL,
                         `text_content` text COLLATE utf8mb4_unicode_ci NOT NULL,
                         PRIMARY KEY (`id`),
                         CONSTRAINT `texts_ibfk_4` FOREIGN KEY (`id`) REFERENCES `nodes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
                         `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                         `user_name` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
                         `user_pass` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
                         `user_email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                         `user_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'activated',
                         PRIMARY KEY (`id`),
                         UNIQUE KEY `user_name` (`user_name`),
                         KEY `user_name_2` (`user_name`,`user_pass`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `videos`;
CREATE TABLE `videos` (
                          `id` bigint(20) unsigned NOT NULL,
                          `video_url` varchar(511) COLLATE utf8mb4_unicode_ci NOT NULL,
                          `video_format` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
                          PRIMARY KEY (`id`),
                          CONSTRAINT `videos_ibfk_2` FOREIGN KEY (`id`) REFERENCES `nodes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `options`;
CREATE TABLE `options` (
                           `option_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                           `option_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
                           `option_value` longtext COLLATE utf8mb4_unicode_ci,
                           PRIMARY KEY (`option_id`),
                           UNIQUE KEY `option_name` (`option_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- 2020-01-20 06:14:48
