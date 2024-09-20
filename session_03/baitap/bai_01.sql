CREATE DATABASE bai_01;
USE bai_01;

CREATE TABLE product(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
created DATE NOT NULL
);

INSERT INTO product(name,created) VALUES('Quần dài','1990-05-12'),('Áo dài','2005-10-05'),('Mũ phớt','1995-07-07');

CREATE TABLE color(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
status BIT(1) DEFAULT 1
);

INSERT INTO color(name,status) VALUES('Red',1),('Blue',1),('Green',1);

CREATE TABLE size(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
status BIT(1)
);

INSERT INTO size(name,status) VALUES('X',1),('M',1),('L',1),('XL',1),('XXL',1);

CREATE TABLE product_detail(
id INT AUTO_INCREMENT PRIMARY KEY,
product_id INT NOT NULL,
color_id INT NOT NULL,
size_id INT NOT NULL,
price DOUBLE CHECK(price > 0) NOT NULL,
stock INT CHECK(stock > 0) NOT NULL,
status BIT(1),
FOREIGN KEY(product_id) REFERENCES product(id),
FOREIGN KEY(color_id) REFERENCES color(id),
FOREIGN KEY(size_id) REFERENCES size(id)
);

INSERT INTO product_detail(product_id,color_id,size_id,price,stock,status) VALUES (1,1,1,1200,5,1),(2,1,1,1500,2,1),(1,2,3,500,3,1),
(1,2,3,1600,3,0),(3,1,4,1200,5,1),(3,1,4,1200,6,1),(2,3,5,2000,10,0);

-- hiển thị thông tin sản phẩm có giá > 1200

SELECT product_detail.id,product.name,color.name,size.name,product_detail.price,product_detail.stock 
FROM product_detail
JOIN product ON product_detail.product_id = product.id
JOIN color ON product_detail.color_id = color.id
JOIN size ON product_detail.size_id = size.id
WHERE product_detail.price > 1200;

-- hiển thị thông tin tất cả các màu

SELECT * FROM color;

-- hiển thị thông tin tất cả các size

SELECT * FROM size;

-- hiểu thị thông tin các sản phẩm chi tiết có mã sp = 1

SELECT product_detail.id,product_detail.product_id,color.name,size.name,product_detail.price,product_detail.stock
FROM product_detail
JOIN product ON product_detail.product_id = product.id
JOIN color ON product_detail.color_id = color.id
JOIN size ON product_detail.size_id = size.id
WHERE product_detail.product_id = 1;