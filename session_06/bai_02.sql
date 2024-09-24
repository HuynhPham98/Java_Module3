CREATE DATABASE ss06_ex02;
USE ss06_ex02;

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

-- Tạo Transaction khi thêm sản phẩm vào giỏ hàng thì kiểm tra xem stock của products có đủ số lượng không nếu không thì rollback

DELIMITER $$

CREATE PROCEDURE add_to_cart(IN p_user_id INT, IN p_product_id INT, IN p_quantity INT)
BEGIN
    DECLARE product_stock INT;
    
    -- Bắt đầu transaction
    START TRANSACTION;
    
    -- Kiểm tra số lượng tồn kho của sản phẩm
    SELECT stock INTO product_stock FROM products WHERE id = p_product_id FOR UPDATE;
    
    -- Nếu tồn kho nhỏ hơn số lượng yêu cầu, rollback và thoát
    IF product_stock < p_quantity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not enough stock for this product';
        ROLLBACK;
    ELSE
        -- Thêm sản phẩm vào giỏ hàng
        INSERT INTO shopping_cart(user_id, product_id, quantity, amount)
        VALUES (p_user_id, p_product_id, p_quantity, 
                (SELECT price FROM products WHERE id = p_product_id) * p_quantity);
        
        -- Cập nhật số lượng tồn kho của sản phẩm
        UPDATE products SET stock = stock - p_quantity WHERE id = p_product_id;
        
        -- Xác nhận giao dịch
        COMMIT;
    END IF;
END$$

DELIMITER ;

-- Tạo Transaction khi xóa sản phẩm trong giỏ hàng thì trả lại số lượng cho products

DELIMITER $$

CREATE PROCEDURE remove_from_cart(IN p_cart_id INT)
BEGIN
    DECLARE product_id INT;
    DECLARE cart_quantity INT;
    
    -- Bắt đầu transaction
    START TRANSACTION;
    
    -- Lấy thông tin sản phẩm và số lượng từ giỏ hàng
    SELECT product_id, quantity INTO product_id, cart_quantity FROM shopping_cart WHERE id = p_cart_id FOR UPDATE;
    
    -- Xóa sản phẩm khỏi giỏ hàng
    DELETE FROM shopping_cart WHERE id = p_cart_id;
    
    -- Cập nhật số lượng sản phẩm trong kho
    UPDATE products SET stock = stock + cart_quantity WHERE id = product_id;
    
    -- Xác nhận giao dịch
    COMMIT;
END$$

DELIMITER ;
