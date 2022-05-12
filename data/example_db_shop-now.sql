DROP DATABASE IF EXISTS `db_shop`;
CREATE DATABASE `db_shop` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- product
CREATE TABLE `db_shop`.`products` (
	`id` BIGINT NOT NULL AUTO_INCREMENT,
    `product_name` VARCHAR(255) NOT NULL,
	`category_id` BIGINT NOT NULL,
    `subcategory_id` BIGINT NOT NULL,
    `category_name` VARCHAR(255) NOT NULL,
    `sub_category_name` VARCHAR(255) NOT NULL,
    `previewing` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`id`)
);

-- categories
CREATE TABLE `db_shop`.`categories` (
	`id` BIGINT NOT NULL AUTO_INCREMENT,
    `category_name` VARCHAR(100) NOT NULL,
    `category_icon` VARCHAR(255),
    PRIMARY KEY (`id`)
);

-- sub categories
CREATE TABLE `db_shop`.`subcategories`(
	`id` BIGINT NOT NULL AUTO_INCREMENT,
    `category_id` BIGINT NOT NULL,
    `sub_category_name` VARCHAR(255) NOT NULL,
	PRIMARY KEY (`id`)
);

ALTER TABLE `db_shop`.`products` 
ADD INDEX `fk_category_id_idx` (`category_id` ASC) VISIBLE,
ADD INDEX `fk_sub_category_id_idx` (`subcategory_id` ASC) VISIBLE;
;
ALTER TABLE `db_shop`.`products` 
ADD CONSTRAINT `fk_category_id`
  FOREIGN KEY (`category_id`)
  REFERENCES `db_shop`.`categories` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_sub_category_id`
  FOREIGN KEY (`subcategory_id`)
  REFERENCES `db_shop`.`subcategories` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  
-- products combinations
CREATE TABLE `db_shop`.`products_combinations` (
	`id` BIGINT NOT NULL AUTO_INCREMENT,
    `combination_string` VARCHAR(255) NOT NULL,
    `sku` VARCHAR(100) NOT NULL,
    `price` INT NULL,
    `unique_string_id` VARCHAR(100) NOT NULL,
    `product_id` BIGINT NOT NULL,
    `available` INT NULL,
    PRIMARY KEY (`id`)
);


-- product_stocks
CREATE TABLE `db_shop`.`products_stocks`(
	`id` BIGINT NOT NULL AUTO_INCREMENT,
    `total_stock` INT NULL,
    `unit_price` INT NULL,
    `total_price` INT NULL,
    `products_combination_id` BIGINT NOT NULL,
    PRIMARY KEY (`id`)
);
ALTER TABLE `db_shop`.`products_stocks` 
ADD CONSTRAINT `fk_product_combination_id`
  FOREIGN KEY (`products_combination_id`)
  REFERENCES `db_shop`.`products_combinations` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  
-- product variation option
CREATE TABLE `db_shop`.`products_variations_options` (
	`id` BIGINT NOT NULL AUTO_INCREMENT,
    `product_id` BIGINT NOT NULL,
    `variation_name` VARCHAR(255) NULL,
    PRIMARY KEY (`id`)
);
ALTER TABLE `db_shop`.`products_variations_options` 
ADD INDEX `fk_product_id_idx` (`product_id` ASC) VISIBLE;
;
ALTER TABLE `db_shop`.`products_variations_options` 
ADD CONSTRAINT `fk_product_id`
  FOREIGN KEY (`product_id`)
  REFERENCES `db_shop`.`products` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

-- product_variations_options_value
CREATE TABLE `db_shop`.`products_variations_options_value`(
	`id` BIGINT NOT NULL AUTO_INCREMENT,
    `products_variation_id` BIGINT NOT NULL,
    `variation_name` VARCHAR(100)
);

ALTER TABLE `db_shop`.`products_variations_options_value` 
ADD INDEX `fk_products_variation_id_idx` (`products_variation_id` ASC) VISIBLE;
;
ALTER TABLE `db_shop`.`products_variations_options_value` 
ADD CONSTRAINT `fk_products_variation_id`
  FOREIGN KEY (`products_variation_id`)
  REFERENCES `db_shop`.`products_variations_options` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `db_shop`.`product_images` 
ADD INDEX `fk_product_variation_value_id_idx` (`product_variation_value_id` ASC) VISIBLE;
;
ALTER TABLE `db_shop`.`product_images` 
ADD CONSTRAINT `fk_product_variation_value_id`
  FOREIGN KEY (`product_variation_value_id`)
  REFERENCES `db_shop`.`products_variations_options_value` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `db_shop`.`product_images` 
ADD INDEX `fk_image_gallery_id_idx` (`image_gallery_id` ASC) VISIBLE;
;
ALTER TABLE `db_shop`.`product_images` 
ADD CONSTRAINT `fk_image_gallery_id`
  FOREIGN KEY (`image_gallery_id`)
  REFERENCES `db_shop`.`image_galleries` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


-- product_images
CREATE TABLE `db_shop`.`product_images`(
	`id` BIGINT NOT NULL AUTO_INCREMENT,
    `image_gallery_id` BIGINT NOT NULL,
    `product_variation_value_id` INT NULL,
    `isFeatured` BIGINT(1),
     PRIMARY KEY (`id`)
);



-- image_galleries
CREATE TABLE `db_shop`.`image_galleries` (
	`id` BIGINT NOT NULL AUTO_INCREMENT,
    `small` VARCHAR(255) NULL,
    `medium` VARCHAR(255) NULL,
    `large` VARCHAR(255) NULL,
     PRIMARY KEY (`id`)
);
