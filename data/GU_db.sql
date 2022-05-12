DROP DATABASE IF EXISTS `inventory` ;

CREATE DATABASE `inventory` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- user 
CREATE TABLE `inventory`.`users` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `roleId` SMALLINT NOT NULL,
  `firstName` VARCHAR(50) NULL DEFAULT NULL,
  `username` VARCHAR(50) NULL DEFAULT NULL,
  `mobile` VARCHAR(15) NULL,
  `email` VARCHAR(50) NULL,
  `passwordHash` VARCHAR(32) NOT NULL,
  `registeredAt` DATETIME NOT NULL,
  `lastLogin` DATETIME NULL DEFAULT NULL,
  `intro` TINYTEXT NULL DEFAULT NULL,
  `profile` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_username` (`username` ASC),
  UNIQUE INDEX `uq_mobile` (`mobile` ASC),
  
  UNIQUE INDEX `uq_email` (`email` ASC) );
  
  
  -- product 
  CREATE TABLE `inventory`.`products` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(75) NOT NULL,
  `summary` TINYTEXT NULL,
  `type` SMALLINT(6) NOT NULL DEFAULT 0,
  `createdAt` DATETIME NOT NULL,
  `updatedAt` DATETIME NULL DEFAULT NULL,
  `content` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`) 
);

  
  
-- inventory
CREATE TABLE `inventory`.`inventories` (
	`id` BIGINT NOT NULL AUTO_INCREMENT,
    `productId` BIGINT NOT NULL,
    `sizeId` BIGINT NOT NULL,
    `colorId` BIGINT NOT NULL,
    `quantity` INT ,
    PRIMARY KEY (`id`),
    INDEX `idx_inventories` (`productId` ASC),
    UNIQUE INDEX `uq_inventories` (`productId` ASC)
    )
ENGINE = InnoDB;



-- color
CREATE TABLE `inventory`.`colors` (
	`id` BIGINT NOT NULL AUTO_INCREMENT,
    `color` VARCHAR(50),
    PRIMARY KEY (`id`)
);


-- size
CREATE TABLE `inventory`.`sizes` (
	`id` BIGINT NOT NULL AUTO_INCREMENT,
    `size` VARCHAR(50),
    PRIMARY KEY (`id`)
);

-- product_meta
CREATE TABLE `inventory`.`product_metas` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `productId` BIGINT NOT NULL,
  `key` VARCHAR(50) NOT NULL,
  `content` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_meta_product` (`productId` ASC),
  UNIQUE INDEX `uq_product_meta` (`productId` ASC, `key` ASC),
  CONSTRAINT `fk_meta_product`
    FOREIGN KEY (`productId`)
    REFERENCES `inventory`.`products` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- category
CREATE TABLE `inventory`.`categories` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(75) NOT NULL,
  `metaTitle` VARCHAR(100) NULL DEFAULT NULL,
  `slug` VARCHAR(100) NOT NULL,
  `content` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`));

  
-- product_category
CREATE TABLE `inventory`.`product_categories` (
  `productId` BIGINT NOT NULL,
  `categoryId` BIGINT NOT NULL,
  PRIMARY KEY (`productId`, `categoryId`),
  INDEX `idx_pc_category` (`categoryId` ASC),
  INDEX `idx_pc_product` (`productId` ASC),
  CONSTRAINT `fk_pc_product`
    FOREIGN KEY (`productId`)
    REFERENCES `inventory`.`products` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pc_category`
    FOREIGN KEY (`categoryId`)
    REFERENCES `inventory`.`categories` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
  
-- brand
  CREATE TABLE `inventory`.`brands` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(75) NOT NULL,
  `summary` TINYTEXT NULL,
  `createdAt` DATETIME NOT NULL,
  `updatedAt` DATETIME NULL DEFAULT NULL,
  `content` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`) 
);

-- order table

CREATE TABLE `inventory`.`orders` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `userId` BIGINT NOT NULL,
  `type` SMALLINT(6) NOT NULL DEFAULT 0,
  `status` SMALLINT(6) NOT NULL DEFAULT 0,
  `subTotal` FLOAT NOT NULL DEFAULT 0,
  `itemDiscount` FLOAT NOT NULL DEFAULT 0,
  `tax` FLOAT NOT NULL DEFAULT 0,
  `shipping` FLOAT NOT NULL DEFAULT 0,
  `total` FLOAT NOT NULL DEFAULT 0,
  `promo` VARCHAR(50) NULL DEFAULT NULL,
  `discount` FLOAT NOT NULL DEFAULT 0,
  `grandTotal` FLOAT NOT NULL DEFAULT 0,
  `createdAt` DATETIME NOT NULL,
  `updatedAt` DATETIME NULL DEFAULT NULL,
  `content` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_order_user` (`userId` ASC),
  CONSTRAINT `fk_order_user`
    FOREIGN KEY (`userId`)
    REFERENCES `inventory`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
    
-- address

CREATE TABLE `inventory`.`addresses` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `userId` BIGINT NULL DEFAULT NULL,
  `orderId` BIGINT NULL DEFAULT NULL,
  `firstName` VARCHAR(50) NULL DEFAULT NULL,
  `lastName` VARCHAR(50) NULL DEFAULT NULL,
  `mobile` VARCHAR(15) NULL,
  `email` VARCHAR(50) NULL,
  `city` VARCHAR(50) NULL DEFAULT NULL,
  `province` VARCHAR(50) NULL DEFAULT NULL,
  `country` VARCHAR(50) NULL DEFAULT NULL,
  `createdAt` DATETIME NOT NULL,
  `updatedAt` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_address_user` (`userId` ASC),
  CONSTRAINT `fk_address_users`
    FOREIGN KEY (`userId`)
    REFERENCES `inventory`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

ALTER TABLE `inventory`.`addresses` 
ADD INDEX `idx_address_order` (`orderId` ASC);
ALTER TABLE `inventory`.`addresses` 
ADD CONSTRAINT `fk_address_order`
  FOREIGN KEY (`orderId`)
  REFERENCES `inventory`.`orders` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  
-- item
CREATE TABLE `inventory`.`items` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `productId` BIGINT NOT NULL,
  `brandId` BIGINT NOT NULL,
  `supplierId` BIGINT NOT NULL,
  `orderId` BIGINT NOT NULL,
  `sku` VARCHAR(100) NOT NULL,
  `mrp` FLOAT NOT NULL DEFAULT 0,
  `discount` FLOAT NOT NULL DEFAULT 0,
  `price` FLOAT NOT NULL DEFAULT 0,
  `quantity` SMALLINT(6) NOT NULL DEFAULT 0,
  `sold` SMALLINT(6) NOT NULL DEFAULT 0,
  `available` SMALLINT(6) NOT NULL DEFAULT 0,
  `defective` SMALLINT(6) NOT NULL DEFAULT 0,
  `createdBy` BIGINT NOT NULL,
  `updatedBy` BIGINT DEFAULT NULL,
  `createdAt` DATETIME NOT NULL,
  `updatedAt` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_item_product` (`productId` ASC),
  CONSTRAINT `fk_item_product`
    FOREIGN KEY (`productId`)
    REFERENCES `inventory`.`products` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

ALTER TABLE `inventory`.`items` 
ADD INDEX `idx_item_brand` (`brandId` ASC);
ALTER TABLE `inventory`.`items` 
ADD CONSTRAINT `fk_item_brand`
  FOREIGN KEY (`brandId`)
  REFERENCES `inventory`.`brands` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `inventory`.`items` 
ADD INDEX `idx_item_user` (`supplierId` ASC);
ALTER TABLE `inventory`.`items` 
ADD CONSTRAINT `fk_item_user`
  FOREIGN KEY (`supplierId`)
  REFERENCES `inventory`.`users` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `inventory`.`items` 
ADD INDEX `idx_item_order` (`orderId` ASC);
ALTER TABLE `inventory`.`items` 
ADD CONSTRAINT `fk_item_order`
  FOREIGN KEY (`orderId`)
  REFERENCES `inventory`.`orders` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
-- transaction
CREATE TABLE `inventory`.`order_items` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `productId` BIGINT NOT NULL,
  `itemId` BIGINT NOT NULL,
  `orderId` BIGINT NOT NULL,
  `sku` VARCHAR(100) NOT NULL,
  `price` FLOAT NOT NULL DEFAULT 0,
  `discount` FLOAT NOT NULL DEFAULT 0,
  `quantity` SMALLINT(6) NOT NULL DEFAULT 0,
  `createdAt` DATETIME NOT NULL,
  `updatedAt` DATETIME NULL DEFAULT NULL,
  `content` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_order_item_product` (`productId` ASC),
  CONSTRAINT `fk_order_item_product`
    FOREIGN KEY (`productId`)
    REFERENCES `inventory`.`products` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

ALTER TABLE `inventory`.`order_items` 
ADD INDEX `idx_order_item_item` (`itemId` ASC);
ALTER TABLE `inventory`.`order_items` 
ADD CONSTRAINT `fk_order_item_item`
  FOREIGN KEY (`itemId`)
  REFERENCES `inventory`.`items` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `inventory`.`order_items` 
ADD INDEX `idx_order_item_order` (`orderId` ASC);
ALTER TABLE `inventory`.`order_items` 
ADD CONSTRAINT `fk_order_item_order`
  FOREIGN KEY (`orderId`)
  REFERENCES `inventory`.`orders` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  
  -- add fk_inventory _color_size
  
  ALTER TABLE `inventory`.`products` 
ADD CONSTRAINT `fk_inventories`
  FOREIGN KEY (`id`)
  REFERENCES `inventory`.`inventories` (`productId`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `inventory`.`inventories` 
ADD INDEX `fk_color_idx` (`colorId` ASC) VISIBLE,
ADD INDEX `fk_size_idx` (`sizeId` ASC) VISIBLE;
;
ALTER TABLE `inventory`.`inventories` 
ADD CONSTRAINT `fk_color`
  FOREIGN KEY (`colorId`)
  REFERENCES `inventory`.`colors` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_size`
  FOREIGN KEY (`sizeId`)
  REFERENCES `inventory`.`sizes` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
