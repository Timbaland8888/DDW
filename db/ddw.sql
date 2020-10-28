/*
 Navicat Premium Data Transfer

 Source Server         : 演示环境
 Source Server Type    : MySQL
 Source Server Version : 50729
 Source Host           : 192.168.108.16:3306
 Source Schema         : ddw

 Target Server Type    : MySQL
 Target Server Version : 50729
 File Encoding         : 65001

 Date: 28/10/2020 10:57:24
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
  `flag` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '查询标志 ，\'1\'代表已被查询过，‘0’代表从未被查询过',
  `update_date` datetime(6) NULL DEFAULT NULL COMMENT '更新日期',
  PRIMARY KEY (`id`, `href`) USING BTREE,
  UNIQUE INDEX `title_id`(`id`) USING BTREE,
  UNIQUE INDEX `book_href`(`href`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of book_info
-- ----------------------------
INSERT INTO `book_info` VALUES ('9c7a2412180711eb8883000c29c590d0', 'http://img3m2.ddimg.cn/83/10/29135882-1_b_5.jpg', 'http://search.dangdang.com/?key=9787020165599&act=input&filter=0%7C0%7C0%7C0%7C0%7C1%7C0%7C0%7C0%7C0%7C0%7C0%7C0%7C0%7C0#J_tab', 'http://product.dangdang.com/29135882.html', '1', '2020-10-27 11:50:53.000000');
INSERT INTO `book_info` VALUES ('9c977f72180711eb8883000c29c590d0', 'http://img3m8.ddimg.cn/61/18/25100818-1_b_3.jpg', 'http://search.dangdang.com/?key=9787020165599&act=input&filter=0%7C0%7C0%7C0%7C0%7C1%7C0%7C0%7C0%7C0%7C0%7C0%7C0%7C0%7C0#J_tab', 'http://product.dangdang.com/25100818.html', '1', '2020-10-27 11:50:53.000000');

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
-- Records of t_book
-- ----------------------------
INSERT INTO `t_book` VALUES ('a912d785180711eb8883000c29c590d0', '9c7a2412180711eb8883000c29c590d0', '2021吾皇万睡周历 随书附赠吾皇巴扎黑心情贴纸 陪你度过2021的春夏秋冬！当当独家限量发售', '白茶', '人民文学出版社', '9787020165599', '2020年10月', '《2021吾皇万睡周历》是“吾皇万睡”人民文学出版社合作精心打造的2021年周历，台历共由五十三个周组成，使用简洁大方的开合式金属环 可撕设计，每周有与当周的节气或节日相呼应的吾皇、巴扎黑、牛能等形象生动可爱的彩色漫画。每页还配有一条诙谐幽默的吾皇语录。日期上贴心圈出法定节假日，好看又实用。一年过完，将收获一本完整的小画册。随历赠送吾皇万睡心情贴纸，粘贴出一年的好心情！', '29.50', '作者：\n白茶，青年漫画家。\n曾获中国动漫金龙奖、银河奖、星云奖等奖项，被评为亚洲书店论坛2017年度最热漫画作家，并在微博、微信等平台拥有超过3000万粉丝，是中国漫画领域的重要人物之一。\n其代表作《就喜欢你看不惯我又干不掉我的样子》系列绘本，长期位居畅销书排行榜前列，曾位列“亚洲好书榜”TOP 1。绘本作品中的吾皇、巴扎黑等艺术形象生动有趣，逐渐成长为大众喜爱、老少皆宜的动漫品牌——“吾皇万睡”，该品牌荣获国际授权业协会LIMA等机构颁发的2018、2019“年度中国IP”。', '', 'http://img51.ddimg.cn/99999990207512831.jpghttp://img53.ddimg.cn/99999990207512953.jpg', '', '', 'http://img3m2.ddimg.cn/83/10/29135882-1_b_5.jpg', '2020-10-27 11:51:14.000000');
INSERT INTO `t_book` VALUES ('bae0e52c180711eb8883000c29c590d0', '9c977f72180711eb8883000c29c590d0', '红星照耀中国  青少版 八年级上册必读 人民文学出版社 团购电话4001066666转6', '埃德加·斯诺 董乐山', '人民文学出版社', '9787020129072', '2017年06月', '', '26.70', '', '', '', 'http://img59.ddimg.cn/99999990175002129.jpg', '', 'http://img3m8.ddimg.cn/61/18/25100818-1_b_3.jpg', '2020-10-27 11:51:44.000000');

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
