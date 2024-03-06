DROP TABLE IF EXISTS `pay`;
DROP TABLE IF EXISTS `review_file`;
DROP TABLE IF EXISTS `review`;
DROP TABLE IF EXISTS `book_order_detail`;
DROP TABLE IF EXISTS `book_order`;
DROP TABLE IF EXISTS `book_order_status`;
DROP TABLE IF EXISTS `wrapping`;
DROP TABLE IF EXISTS `accumulation_rate_policy`;
DROP TABLE IF EXISTS `delivery_policy`;
DROP TABLE IF EXISTS `book_coupon`;
DROP TABLE IF EXISTS `category_coupon`;
DROP TABLE IF EXISTS `member_coupon`;
DROP TABLE IF EXISTS `coupon`;
DROP TABLE IF EXISTS `coupon_status`;
DROP TABLE IF EXISTS `coupon_type`;
DROP TABLE IF EXISTS `shopping_cart`;
DROP TABLE IF EXISTS `wish`;
DROP TABLE IF EXISTS `book_category`;
DROP TABLE IF EXISTS `category`;
DROP TABLE IF EXISTS `book_tag`;
DROP TABLE IF EXISTS `tag`;
DROP TABLE IF EXISTS `book_file`;
DROP TABLE IF EXISTS `book_author`;
DROP TABLE IF EXISTS `author`;
DROP TABLE IF EXISTS `book`;
DROP TABLE IF EXISTS `book_status`;
DROP TABLE IF EXISTS `publisher`;
DROP TABLE IF EXISTS `file`;
DROP TABLE IF EXISTS `point_history`;
DROP TABLE IF EXISTS `member_address`;
DROP TABLE IF EXISTS `general_address`;
DROP TABLE IF EXISTS `member`;
DROP TABLE IF EXISTS `member_status`;
DROP TABLE IF EXISTS `member_auth`;
DROP TABLE IF EXISTS `member_grade`;
DROP TABLE IF EXISTS `point_policy`;
DROP TABLE IF EXISTS `point_policy_type`;

CREATE TABLE `point_policy_type`
(
    `point_policy_type_id` INT         NOT NULL,
    `policy_type`          VARCHAR(20) NOT NULL,

    CONSTRAINT `point_policy_type_pk` PRIMARY KEY (`point_policy_type_id`)
);

CREATE TABLE `point_policy`
(
    `point_policy_id`      BIGINT NOT NULL AUTO_INCREMENT,
    `accumulate_point`     BIGINT NOT NULL,
    `created_at`           DATE   NOT NULL,
    `point_policy_type_id` INT    NOT NULL,

    CONSTRAINT `point_policy_pk` PRIMARY KEY (`point_policy_id`),
    CONSTRAINT `point_policy_type_id` FOREIGN KEY (`point_policy_type_id`) REFERENCES `point_policy_type` (`point_policy_type_id`)
);

CREATE TABLE `member_grade`
(
    `grade_id`        TINYINT     NOT NULL,
    `grade`           VARCHAR(10) NOT NULL,
    `point_rate`      DECIMAL     NOT NULL,
    `standard_amount` BIGINT      NOT NULL,

    CONSTRAINT `member_grade_pk` PRIMARY KEY (`grade_id`)
);

CREATE TABLE `member_status`
(
    `member_status_id`   INT         NOT NULL,
    `member_status_name` VARCHAR(20) NOT NULL,

    CONSTRAINT `member_status_pk` PRIMARY KEY (`member_status_id`)
);

CREATE TABLE `member_auth`
(
    `member_auth_id`   INT         NOT NULL,
    `member_auth_name` VARcHAR(20) NOT NULL,

    CONSTRAINT `member_auth_pk` PRIMARY KEY (`member_auth_id`)
);

CREATE TABLE `member`
(
    `member_id`        BIGINT       NOT NULL AUTO_INCREMENT,
    `member_name`      VARCHAR(20)  NOT NULL,
    `phone_number`     CHAR(11)     NOT NULL UNIQUE,
    `email`            VARCHAR(64)  NOT NULL UNIQUE,
    `birthday`         DATE         NOT NULL,
    `last_login_date`  DATE NULL,
    `password`         VARCHAR(255) NOT NULL,
    `created_at`       DATETIME     NOT NULL,
    `member_point`     BIGINT       NOT NULL DEFAULT 0,
    `withdraw_at`      DATETIME NULL,
    `grade_id`         TINYINT      NOT NULL,
    `member_auth_id`   INT          NOT NULL,
    `member_status_id` INT          NOT NULL,

    CONSTRAINT `member_pk` PRIMARY KEY (`member_id`),
    CONSTRAINT `member_grade_fk` FOREIGN KEY (`grade_id`) REFERENCES `member_grade` (`grade_id`),
    CONSTRAINT `member_auth_fk` FOREIGN KEY (`member_auth_id`) REFERENCES `member_auth` (`member_auth_id`),
    CONSTRAINT `member_status_fk` FOREIGN KEY (`member_status_id`) REFERENCES `member_status` (`member_status_id`)
);

CREATE TABLE `general_address`
(
    `general_address_id` BIGINT       NOT NULL AUTO_INCREMENT,
    `zip_code`           CHAR(5)      NOT NULL,
    `address`            VARCHAR(200) NOT NULL,

    CONSTRAINT `general_address_pk` PRIMARY KEY (`general_address_id`)
);

CREATE TABLE `member_address`
(
    `address_id`         BIGINT       NOT NULL AUTO_INCREMENT,
    `alias`              VARCHAR(20)  NOT NULL,
    `address_detail`     VARCHAR(200) NOT NULL,
    `member_id`          BIGINT       NOT NULL,
    `general_address_id` BIGINT       NOT NULL,

    CONSTRAINT `member_address_pk` PRIMARY KEY (`address_id`),
    CONSTRAINT `member_address_member_fk` FOREIGN KEY (`member_id`) REFERENCES `member` (`member_id`),
    CONSTRAINT `member_address_general_address_fk` FOREIGN KEY (`general_address_id`) REFERENCES `general_address` (`general_address_id`)
);


CREATE TABLE `point_history`
(
    `point_id`   BIGINT      NOT NULL AUTO_INCREMENT,
    `reason`     VARCHAR(50) NOT NULL,
    `point`      BIGINT      NOT NULL,
    `accrued_at` DATETIME    NOT NULL,
    `member_id`  BIGINT      NOT NULL,

    CONSTRAINT `point_history_pk` PRIMARY KEY (`point_id`),
    CONSTRAINT `point_history_member_fk` FOREIGN KEY (`member_id`) REFERENCES `member` (`member_id`)
);



CREATE TABLE `file`
(
    `file_id`        BIGINT        NOT NULL AUTO_INCREMENT,
    `file_url`       VARCHAR(1000) NOT NULL,
    `file_name`      VARCHAR(100) NULL,
    `file_extension` VARCHAR(20) NULL,

    CONSTRAINT `file_pk` PRIMARY KEY (`file_id`)
);



CREATE TABLE `publisher`
(
    `publisher_id`   BIGINT      NOT NULL AUTO_INCREMENT,
    `publisher_name` VARCHAR(30) NOT NULL,

    CONSTRAINT `publisher_pk` PRIMARY KEY (`publisher_id`)
);



CREATE TABLE `book_status`
(
    `status_id`   BIGINT      NOT NULL,
    `status_name` VARCHAR(10) NOT NULL,

    CONSTRAINT `book_status_pk` PRIMARY KEY (`status_id`)
);



CREATE TABLE `book`
(
    `book_id`        BIGINT        NOT NULL AUTO_INCREMENT,
    `book_title`     VARCHAR(50)   NOT NULL,
    `book_index`     VARCHAR(2000) NOT NULL,
    `description`    TEXT          NOT NULL,
    `publicated_at`  DATE          NOT NULL,
    `isbn`           CHAR(13)      NOT NULL,
    `regular_price`  BIGINT        NOT NULL,
    `price`          BIGINT        NOT NULL,
    `discount_ratio` DECIMAL(4,1)       NOT NULL DEFAULT 0,
    `stock`          INT           NOT NULL DEFAULT 0,
    `is_packagable`  BOOLEAN       NOT NULL DEFAULT FALSE,
    `status_id`      BIGINT        NOT NULL,
    `publisher_id`   BIGINT        NOT NULL,
    `thumbnail_id`   BIGINT        NOT NULL,

    CONSTRAINT `book_pk` PRIMARY KEY (`book_id`),
    CONSTRAINT `book_publisher_fk` FOREIGN KEY (`publisher_id`) REFERENCES `publisher` (`publisher_id`),
    CONSTRAINT `book_book_status_fk` FOREIGN KEY (`status_id`) REFERENCES `book_status` (`status_id`),
    CONSTRAINT `book_file_fk` FOREIGN KEY (`thumbnail_id`) REFERENCES `file` (`file_id`)
);



CREATE TABLE `author`
(
    `author_id`        BIGINT      NOT NULL AUTO_INCREMENT,
    `author_name`      VARCHAR(20) NOT NULL,
    `author_introduce` VARCHAR(1000) NULL,
    `file_id`          BIGINT NULL,

    CONSTRAINT `author_pk` PRIMARY KEY (`author_id`),
    CONSTRAINT `author_file_fk` FOREIGN KEY (`file_id`) REFERENCES `file` (`file_id`)
);



CREATE TABLE `book_author`
(
    `author_id` BIGINT NOT NULL,
    `book_id`   BIGINT NOT NULL,

    CONSTRAINT `book_author_pk` PRIMARY KEY (`author_id`, `book_id`),
    CONSTRAINT `book_author_book_fk` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`),
    CONSTRAINT `book_author_author_fk` FOREIGN KEY (`author_id`) REFERENCES `author` (`author_id`)
);



CREATE TABLE `book_file`
(
    `file_id` BIGINT NOT NULL,
    `book_id` BIGINT NOT NULL,

    CONSTRAINT `book_file_pk` PRIMARY KEY (`file_id`),
    CONSTRAINT `book_file_book_fk` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`),
    CONSTRAINT `book_file_file_fk` FOREIGN KEY (`file_id`) REFERENCES `file` (`file_id`)
);



CREATE TABLE `tag`
(
    `tag_id`   BIGINT      NOT NULL AUTO_INCREMENT,
    `tag_name` VARCHAR(10) NOT NULL,

    CONSTRAINT `tag_pk` PRIMARY KEY (`tag_id`)
);



CREATE TABLE `book_tag`
(
    `book_id` BIGINT NOT NULL,
    `tag_id`  BIGINT NOT NULL,

    CONSTRAINT `book_tag_pk` PRIMARY KEY (`book_id`, `tag_id`),
    CONSTRAINT `book_tag_book_fk` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`),
    CONSTRAINT `book_tag_tag_fk` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`tag_id`)
);



CREATE TABLE `category`
(
    `category_id`   BIGINT      NOT NULL AUTO_INCREMENT,
    `category_name` VARCHAR(10) NOT NULL,
    `parent_id`     BIGINT NULL,

    CONSTRAINT `category_pk` PRIMARY KEY (`category_id`),
    CONSTRAINT `category_fk` FOREIGN KEY (`parent_id`) REFERENCES `category` (`category_id`)
);



CREATE TABLE `book_category`
(
    `category_id` BIGINT NOT NULL,
    `book_id`     BIGINT NOT NULL,

    CONSTRAINT `book_category_pk` PRIMARY KEY (`category_id`, `book_id`),
    CONSTRAINT `book_category_book_fk` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`),
    CONSTRAINT `book_category_category_fk` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`)
);



CREATE TABLE `wish`
(
    `member_id` BIGINT NOT NULL,
    `book_id`   BIGINT NOT NULL,

    CONSTRAINT `wish_pk` PRIMARY KEY (`member_id`, `book_id`),
    CONSTRAINT `wish_member_fk` FOREIGN KEY (`member_id`) REFERENCES `member` (`member_id`),
    CONSTRAINT `wish_book_fk` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`)
);



CREATE TABLE `shopping_cart`
(
    `cart_id`   BIGINT NOT NULL AUTO_INCREMENT,
    `member_id` BIGINT NOT NULL,
    `book_id`   BIGINT NOT NULL,
    `amount`    INT    NOT NULL,

    CONSTRAINT `shopping_cart_pk` PRIMARY KEY (`cart_id`),
    CONSTRAINT `shopping_cart_member_fk` FOREIGN KEY (`member_id`) REFERENCES `member` (`member_id`),
    CONSTRAINT `shopping_cart_book_fk` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`)
);



CREATE TABLE `coupon_type`
(
    `coupon_type_id` INT         NOT NULL,
    `type_name`      VARCHAR(20) NOT NULL,

    CONSTRAINT `coupon_type_pk` PRIMARY KEY (`coupon_type_id`)
);

CREATE TABLE `coupon_status`
(
    `coupon_status_id`   INT         NOT NULL,
    `coupon_status_name` VARCHAR(30) NOT NULL,

    CONSTRAINT `coupon_status_pk` PRIMARY KEY (`coupon_status_id`)
);

CREATE TABLE `coupon`
(
    `coupon_id`          VARCHAR(200) NOT NULL,
    `coupon_name`        VARCHAR(50)  NOT NULL,
    `min_price`          BIGINT       NOT NULL DEFAULT 0,
    `max_discount_price` BIGINT NULL,
    `discount_price`     BIGINT       NOT NULL,
    `basic_issued_date`  DATE         NOT NULL,
    `basic_expired_date` DATE         NOT NULL,
    `validity`           INT          NOT NULL,
    `coupon_type_id`     INT          NOT NULL,
    `is_birth`           BOOLEAN      NOT NULL,
    `coupon_status_id`   INT          NOT NULL,

    CONSTRAINT `coupon_pk` PRIMARY KEY (`coupon_id`),
    CONSTRAINT `coupon_coupon_type_fk` FOREIGN KEY (`coupon_type_id`) REFERENCES `coupon_type` (`coupon_type_id`),
    CONSTRAINT `coupon_coupon_status_fk` FOREIGN KEY (`coupon_status_id`) REFERENCES `coupon_status` (`coupon_status_id`)
);


CREATE TABLE `member_coupon`
(
    `member_coupon_id` VARCHAR(200) NOT NULL,
    `member_id`        BIGINT       NOT NULL,
    `coupon_id`        VARCHAR(200) NOT NULL,
    `expired_at`       DATE         NOT NULL,
    `issued_at`        DATE         NOT NULL,
    `used_at`          DATE NULL,

    CONSTRAINT `member_coupon_pk` PRIMARY KEY (`member_coupon_id`),
    CONSTRAINT `member_coupon_member_fk` FOREIGN KEY (`member_id`) REFERENCES `member` (`member_id`),
    CONSTRAINT `member_coupon_coupon_fk` FOREIGN KEY (`coupon_id`) REFERENCES `coupon` (`coupon_id`)
);



CREATE TABLE `category_coupon`
(
    `category_id` BIGINT       NOT NULL,
    `coupon_id`   VARCHAR(200) NOT NULL,

    CONSTRAINT `category_coupon_pk` PRIMARY KEY (`category_id`, `coupon_id`),
    CONSTRAINT `category_coupon_category_fk` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`),
    CONSTRAINT `category_coupon_coupon_fk` FOREIGN KEY (`coupon_id`) REFERENCES `coupon` (`coupon_id`)
);



CREATE TABLE `book_coupon`
(
    `coupon_id` VARCHAR(200) NOT NULL,
    `book_id`   BIGINT       NOT NULL,

    CONSTRAINT `book_coupon` PRIMARY KEY (`coupon_id`, `book_id`),
    CONSTRAINT `book_coupon_book_fk` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`),
    CONSTRAINT `book_coupon_coupon_fk` FOREIGN KEY (`coupon_id`) REFERENCES `coupon` (`coupon_id`)
);



CREATE TABLE `delivery_policy`
(
    `delivery_policy_id`  BIGINT NOT NULL AUTO_INCREMENT,
    `delivery_price`      BIGINT NOT NULL,
    `created_at`          DATE   NOT NULL,
    `free_delivery_price` BIGINT NOT NULL,

    CONSTRAINT `delivery_policy_pk` PRIMARY KEY (`delivery_policy_id`)
);



CREATE TABLE `accumulation_rate_policy`
(
    `accumulation_rate_policy_id` BIGINT NOT NULL AUTO_INCREMENT,
    `accumulation_rate`           INT    NOT NULL,
    `created_at`                  DATE   NOT NULL,

    CONSTRAINT `accumulation_rate_policy_pk` PRIMARY KEY (`accumulation_rate_policy_id`)
);


CREATE TABLE `wrapping`
(
    `wrapping_id`   BIGINT      NOT NULL AUTO_INCREMENT,
    `wrapping_name` VARCHAR(20) NOT NULL,
    `price`         BIGINT      NOT NULL,
    `is_active`     BOOLEAN     NOT NULL DEFAULT TRUE,

    CONSTRAINT `wrapping_pk` PRIMARY KEY (`wrapping_id`)
);

CREATE TABLE `book_order_status`
(
    `order_status_id` BIGINT      NOT NULL,
    `order_status`    VARCHAR(10) NOT NULL,

    CONSTRAINT `book_order_status_pk` PRIMARY KEY (`order_status_id`)
);


CREATE TABLE `book_order`
(
    `order_id`                    VARCHAR(64)  NOT NULL,
    `order_name`                  VARCHAR(64)  NOT NULL,
    `ship_date`                   DATE NULL,
    `order_at`                    DATETIME     NOT NULL,
    `delivery_date`               DATE         NOT NULL,
    `receiver`                    VARCHAR(20)  NOT NULL,
    `receiver_number`             CHAR(11)     NOT NULL,
    `zip_code`                    CHAR(5)      NOT NULL,
    `address`                     VARCHAR(200) NOT NULL,
    `address_detail`              VARCHAR(200) NOT NULL,
    `orderer`                     VARCHAR(20)  NOT NULL,
    `orderer_number`              CHAR(11)     NOT NULL,
    `orderer_email`               VARCHAR(64)  NOT NULL,
    `use_point`                   BIGINT       NOT NULL DEFAULT 0,
    `total_price`                 BIGINT       NOT NULL,
    `member_id`                   BIGINT NULL,

    CONSTRAINT `book_order_pk` PRIMARY KEY (`order_id`),
    CONSTRAINT `book_order_member_fk` FOREIGN KEY (`member_id`) REFERENCES `member` (`member_id`)
);


CREATE TABLE `book_order_detail`
(
    `order_detail_id`  BIGINT      NOT NULL AUTO_INCREMENT,
    `book_price`       BIGINT      NOT NULL,
    `wrapping_price`   BIGINT      NOT NULL DEFAULT 0,
    `amount`           BIGINT      NOT NULL,
    `wrapping_id`      BIGINT NULL,
    `order_id`         VARCHAR(64) NOT NULL,
    `book_id`          BIGINT      NOT NULL,
    `member_coupon_id` VARCHAR(200) NULL,
    `order_status_id`  BIGINT      NOT NULL,

    CONSTRAINT `book_order_detail_pk` PRIMARY KEY (`order_detail_id`),
    CONSTRAINT `book_order_detail_wrapping_fk` FOREIGN KEY (`wrapping_id`) REFERENCES `wrapping` (`wrapping_id`),
    CONSTRAINT `book_order_detail_order_fk` FOREIGN KEY (`order_id`) REFERENCES `book_order` (`order_id`),
    CONSTRAINT `book_order_detail_book_fk` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`),
    CONSTRAINT `book_order_detail_member_coupon_fk` FOREIGN KEY (`member_coupon_id`) REFERENCES `member_coupon` (`member_coupon_id`),
    CONSTRAINT `book_order_detail_order_status_fk` FOREIGN KEY (`order_status_id`) REFERENCES `book_order_status` (`order_status_id`)
);



CREATE TABLE `review`
(
    `review_id`       BIGINT      NOT NULL AUTO_INCREMENT,
    `member_id`       BIGINT      NOT NULL,
    `book_id`         BIGINT      NOT NULL,
    `order_detail_id` BIGINT      NOT NULL,
    `review_title`    VARCHAR(50) NOT NULL,
    `review_content`  VARCHAR(1000) NULL,
    `registered_at`   DATETIME    NOT NULL,
    `score`           TINYINT     NOT NULL,

    CONSTRAINT `review_pk` PRIMARY KEY (`review_id`),
    CONSTRAINT `review_member_fk` FOREIGN KEY (`member_id`) REFERENCES `member` (`member_id`),
    CONSTRAINT `review_book_fk` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`),
    CONSTRAINT `review_order_detail_fk` FOREIGN KEY (`order_detail_id`) REFERENCES `book_order_detail` (`order_detail_id`)
);

CREATE TABLE `review_file`
(
    `file_id`   BIGINT NOT NULL,
    `review_id` BIGINT NOT NULL,

    CONSTRAINT `review_file_pk` PRIMARY KEY (`file_id`),
    CONSTRAINT `review_file_file_fk` FOREIGN KEY (`file_id`) REFERENCES `file` (`file_id`),
    CONSTRAINT `review_file_review_fk` FOREIGN KEY (`review_id`) REFERENCES `review` (`review_id`)
);

CREATE TABLE `pay`
(
    `pay_id`         BIGINT       NOT NULL AUTO_INCREMENT,
    `payment_key`    VARCHAR(200) NOT NULL,
    `method`         VARCHAR(10)  NOT NULL,
    `status`         VARCHAR(20)  NOT NULL,
    `requested_at`   DATETIME     NOT NULL,
    `approved_at`    DATETIME     NOT NULL,
    `total_amount`   BIGINT       NOT NULL,
    `balance_amount` BIGINT       NOT NULL,
    `order_id`       VARCHAR(64)  NOT NULL,

    CONSTRAINT `pay_pk` PRIMARY KEY (`pay_id`),
    CONSTRAINT `pay_book_order_fk` FOREIGN KEY (`order_id`) REFERENCES `book_order` (`order_id`)
);

