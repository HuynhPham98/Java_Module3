CREATE DATABASE ss06_ex03;
USE ss06_ex03;

CREATE TABLE users(
      id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(100) NOT NULL,
      myMoney DOUBLE NOT NULL CHECK(myMoney > 0),
      address VARCHAR(255) NOT NULL,
      phone VARCHAR(11) NOT NULL,
      dateOfBirth DATE NOT NULL,
      status BIT(1) DEFAULT 1
);

CREATE TABLE transfer(
      sender_id INT NOT NULL,
      receiver_id INT NOT NULL,
      money DOUBLE NOT NULL CHECK(money > 0),
      transfer_date DATETIME NOT NULL,
      FOREIGN KEY(sender_id) REFERENCES users(id),
      FOREIGN KEY(receiver_id) REFERENCES users(id)
);

-- Thêm dữ liệu vào bảng users
INSERT INTO users (name, myMoney, address, phone, dateOfBirth) 
VALUES 
('Nguyen Van A', 5000000, '123 Le Loi, Ha Noi', '0912345678', '1990-05-10'),
('Tran Thi B', 3000000, '456 Nguyen Trai, Ho Chi Minh', '0987654321', '1985-03-22'),
('Le Van C', 10000000, '789 Tran Hung Dao, Da Nang', '0934567890', '1992-07-15');

-- Thêm dữ liệu vào bảng transfer
INSERT INTO transfer (sender_id, receiver_id, money, transfer_date) 
VALUES 
(1, 2, 1000000, '2024-09-24 14:30:00'),
(2, 3, 500000, '2024-09-24 15:00:00'),
(3, 1, 2000000, '2024-09-24 16:00:00');

-- Tạo transaction (phiên giao dịnh) khi gửi tiền đến tài khoản người nếu vượt quá số tiền trong tài khoản 
-- thì sẽ (rollback) trở lại vị trí ban đầu khi bắt đầu giao dịnh

DELIMITER $$

CREATE PROCEDURE transfer_money(
    IN p_sender_id INT,
    IN p_receiver_id INT,
    IN p_amount DECIMAL(10, 2)
)
BEGIN
    DECLARE sender_balance DECIMAL(10, 2);
    
    -- Bắt đầu transaction
    START TRANSACTION;
    
    -- Kiểm tra nếu người gửi và người nhận là cùng một người
    IF p_sender_id = p_receiver_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sender and receiver cannot be the same person';
        ROLLBACK;
    ELSE
        -- Lấy số dư của người gửi
        SELECT myMoney INTO sender_balance 
        FROM users 
        WHERE id = p_sender_id 
        FOR UPDATE;
        
        -- Kiểm tra xem số tiền gửi có vượt quá số dư hiện tại không
        IF sender_balance < p_amount THEN
            -- Nếu vượt quá, rollback và đưa ra thông báo lỗi
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient funds for transfer';
            ROLLBACK;
        ELSE
            -- Trừ tiền từ tài khoản người gửi
            UPDATE users 
            SET myMoney = myMoney - p_amount 
            WHERE id = p_sender_id;
            
            -- Cộng tiền vào tài khoản người nhận
            UPDATE users 
            SET myMoney = myMoney + p_amount 
            WHERE id = p_receiver_id;
            
            -- Thêm giao dịch vào bảng transfer
            INSERT INTO transfer (sender_id, receiver_id, money, transfer_date) 
            VALUES (p_sender_id, p_receiver_id, p_amount, NOW());
            
            -- Xác nhận transaction
            COMMIT;
        END IF;
    END IF;
END$$

DELIMITER ;
