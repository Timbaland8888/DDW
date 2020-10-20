/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50637
 Source Host           : localhost:3306
 Source Schema         : ddw

 Target Server Type    : MySQL
 Target Server Version : 50637
 File Encoding         : 65001

 Date: 20/10/2020 16:27:10
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for book_info
-- ----------------------------
DROP TABLE IF EXISTS `book_info`;
CREATE TABLE `book_info`  (
  `id` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `src_imag` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '封面图片地址',
  `go_sort_href` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '当当自营链接',
  `href` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '书本详情链接',
  `update_date` datetime(6) NULL DEFAULT NULL COMMENT '更新日期',
  PRIMARY KEY (`id`, `href`) USING BTREE,
  UNIQUE INDEX `title_id`(`id`) USING BTREE,
  UNIQUE INDEX `book_href`(`href`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for t_book
-- ----------------------------
DROP TABLE IF EXISTS `t_book`;
CREATE TABLE `t_book`  (
  `id` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `book_id` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'book_info外键',
  `book_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '书名',
  `author_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '作者名',
  `publishing_company_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '出版社名',
  `isbn` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'ISBN码',
  `publish_date` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '出版时间',
  `introduce` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '内容简介',
  `price` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '价格',
  `author_introduce` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '作者简介',
  `abstract_info` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '编辑推荐简介',
  `abstract_info_pic` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '编辑推荐介长图',
  `feature_pic` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '产品特色长图',
  `attachImage` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '书摘插画',
  `src_imag` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '封面图片',
  `update_date` datetime(6) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`book_id`) USING BTREE,
  CONSTRAINT `book_info_uuid` FOREIGN KEY (`book_id`) REFERENCES `book_info` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Triggers structure for table book_info
-- ----------------------------
DROP TRIGGER IF EXISTS `book_info_before_insert`;
delimiter ;;
CREATE TRIGGER `book_info_before_insert` BEFORE INSERT ON `book_info` FOR EACH ROW BEGIN
IF new.id is NULL THEN
		SET new.id = UUID();
END IF; 
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
