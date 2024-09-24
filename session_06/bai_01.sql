CREATE DATABASE ss06_ex01;
USE ss06_ex01;

CREATE TABLE users(
	  id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(100) NOT NULL,
      address VARCHAR(255) NOT NULL,
      phone VARCHAR(11) NOT NULL,
      dateOfBirth DATE NOT NULL,
      status BIT(1) DEFAULT 1
);

CREATE TABLE products(
      id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(100) NOT NULL,
      price DOUBLE NOT NULL CHECK(price > 0),
      stock INT NOT NULL CHECK(stock > 0),
      status BIT(1) DEFAULT 1
);

CREATE TABLE shopping_cart(
      id INT AUTO_INCREMENT PRIMARY KEY,
      user_id INT NOT NULL,
      product_id INT NOT NULL,
      quantity INT NOT NULL CHECK(quantity > 0),
      amount DOUBLE NOT NULL CHECK(amount > 0),
      FOREIGN KEY(user_id) REFERENCES users(id),
      FOREIGN KEY(product_id) REFERENCES products(id)
);

-- Thêm dữ liệu vào bảng users
INSERT INTO users (name, address, phone, dateOfBirth) 
VALUES 
('Nguyen Van A', '123 Le Loi, Ha Noi', '0912345678', '1990-05-10'),
('Tran Thi B', '456 Nguyen Trai, Ho Chi Minh', '0987654321', '1985-03-22'),
('Le Van C', '789 Tran Hung Dao, Da Nang', '0934567890', '1992-07-15');

-- Thêm dữ liệu vào bảng products
INSERT INTO products (name, price, stock) 
VALUES 
('Laptop Dell', 15000000, 10),
('Smartphone Samsung', 7000000, 20),
('TV Sony', 12000000, 5);

-- Thêm dữ liệu vào bảng shopping_cart
INSERT INTO shopping_cart (user_id, product_id, quantity, amount) 
VALUES 
(1, 1, 1, 15000000),
(2, 2, 2, 14000000),
(3, 3, 1, 12000000);

-- Tạo Trigger khi thay đổi giá của sản phẩm thì amount (tổng giá) cũng sẽ phải cập nhật lại

DELIMITER $$

CREATE TRIGGER update_amount_on_price_change
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
    IF NEW.price != OLD.price THEN
        UPDATE shopping_cart
        SET amount = NEW.price * quantity
        WHERE product_id = NEW.id;
    END IF;
END$$

DELIMITER ;

-- Tạo trigger khi xóa product thì những dữ liệu ở bảng shopping_cart có chứa product bị xóa thì cũng phải xóa theo

DELIMITER $$

CREATE TRIGGER delete_shopping_cart_on_product_delete
AFTER DELETE ON products
FOR EACH ROW
BEGIN
    DELETE FROM shopping_cart WHERE product_id = OLD.id;
END$$

DELIMITER ;

-- Khi thêm một sản phẩm vào shopping_cart với số lượng n thì bên product cũng sẽ phải trừ đi số lượng n

DELIMITER $$

CREATE TRIGGER update_stock_on_add_to_cart
AFTER INSERT ON shopping_cart
FOR EACH ROW
BEGIN
    UPDATE products
    SET stock = stock - NEW.quantity
    WHERE id = NEW.product_id;
END$$

DELIMITER ;
