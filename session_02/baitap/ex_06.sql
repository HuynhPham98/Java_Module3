CREATE DATABASE ex_06;
USE ex_06;

CREATE TABLE users(
id INT AUTO_INCREMENT PRIMARY KEY,
fullName VARCHAR(100) NOT NULL,
email VARCHAR(255) NOT NULL,
password VARCHAR(255) NOT NULL,
phone VARCHAR(11) NOT NULL,
permission bit(1) DEFAULT 1,
status bit(1) DEFAULT 1
);

CREATE TABLE address(
id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
receiveAddress VARCHAR(100) NOT NULL,
receiveName VARCHAR(100) NOT NULL,
receivePhone VARCHAR(11) NOT NULL,
isDefault bit(1) DEFAULT 1,
FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE catalog(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
status bit(1) DEFAULT 1
);

CREATE TABLE product(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
price DOUBLE CHECK(price > 0),
stock INT CHECK(stock >= 0),
catalog_id INT NOT NULL,
status bit(1) DEFAULT 1,
FOREIGN KEY(catalog_id) REFERENCES catalog(id)
);

CREATE TABLE orders(
id INT AUTO_INCREMENT PRIMARY KEY,
orderAt DATETIME NOT NULL,
totals DOUBLE CHECK(totals > 0),
user_id INT NOT NULL,
status bit(1) DEFAULT 1,
FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE order_detail(
id INT AUTO_INCREMENT PRIMARY KEY,
order_id INT NOT NULL,
product_id INT NOT NULL,
quantity INT CHECK(quantity > 0),
unit_price DOUBLE CHECK(unit_price > 0),
FOREIGN KEY(order_id) REFERENCES orders(id),
FOREIGN KEY(product_id) REFERENCES product(id)
);

CREATE TABLE shopping_cart(
id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
product_id INT NOT NULL,
quantity INT CHECK(quantity > 0),
FOREIGN KEY(user_id) REFERENCES users(id),
FOREIGN KEY(product_id) REFERENCES product(id)
);

CREATE TABLE wish_list(
user_id INT NOT NULL,
product_id INT NOT NULL,
FOREIGN KEY(user_id) REFERENCES users(id),
FOREIGN KEY(product_id) REFERENCES product(id)
);