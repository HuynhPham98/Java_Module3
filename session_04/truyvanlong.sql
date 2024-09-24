CREATE DATABASE truyvanlong;
USE truyvanlong;

-- Bảng Class

CREATE TABLE Class(
classId INT AUTO_INCREMENT PRIMARY KEY,
className VARCHAR(255) NOT NULL,
startDate DATE NOT NULL,
status BIT(1)
);

-- Bảng student

CREATE TABLE Student(
studentId INT AUTO_INCREMENT PRIMARY KEY,
studentName VARCHAR(255) NOT NULL,
address VARCHAR(255),
phone VARCHAR(255),
status BIT(1),
class_id INT NOT NULL,
FOREIGN KEY(class_id) REFERENCES Class(classId)
);

-- Bảng Subject

CREATE TABLE Subject(
subId INT AUTO_INCREMENT PRIMARY KEY,
subName VARCHAR(255) NOT NULL,
credit INT DEFAULT 1 CHECK(credit >= 1),
status BIT(1) DEFAULT 1
);

-- Bảng mark(điểm)

CREATE TABLE Mark(
markId INT AUTO_INCREMENT PRIMARY KEY,
subjectId INT NOT NULL,
studentId INT NOT NULL,
mark DOUBLE DEFAULT 0 CHECK(mark >= 0 & mark < 100),
examtim INT DEFAULT 1,
FOREIGN KEY(subjectId) REFERENCES Subject(subId),
FOREIGN KEY(studentId) REFERENCES Student(studentId)
);

-- Thêm dữ liệu 
INSERT INTO Class(className, startDate, status) VALUES
('Math Class', '2024-01-15', 1),
('Science Class', '2024-02-20', 1),
('History Class', '2024-03-10', 1),
('Art Class', '2024-04-05', 0),
('Physics Class', '2024-05-18', 1);

INSERT INTO Student(studentName, address, phone, status, class_id) VALUES
('John Doe', '123 Main St', '0912345678', 1, 1),
('Jane Smith', '456 Oak St', '0923456789', 1, 2),
('Alex Brown', '789 Pine St', '0934567890', 0, 1),
('Emily White', '101 Maple St', '0945678901', 1, 3),
('Michael Green', '202 Cedar St', '0956789012', 0, 4);

INSERT INTO Subject(subName, credit, status) VALUES
('Mathematics', 3, 1),
('Physics', 4, 1),
('Chemistry', 2, 1),
('History', 3, 1),
('Art', 2, 0);

INSERT INTO Mark(subjectId, studentId, mark, examtim) VALUES
(1, 1, 85.5, 1),
(2, 2, 92.0, 2),
(3, 3, 78.0, 1),
(4, 4, 88.5, 1),
(5, 5, 65.0, 2);

-- Ví dụ 1: Tìm sinh viên có điểm trung bình cao nhất

SELECT s.*,AVG(m.mark) AS DTB 
FROM student AS s
JOIN mark AS m ON s.studentId = m.studentId
GROUP BY s.studentId
HAVING s.studentId = (
SELECT m.studentId FROM mark AS m
GROUP BY m.studentId
ORDER BY AVG(m.mark) DESC
LIMIT 1
);

-- cách 2: dùng hàm avg + max

SELECT s.*, AVG(m.mark) AS DTB
FROM student AS s
JOIN mark AS m ON s.studentId = m.studentId
GROUP BY s.studentId
HAVING AVG(m.mark) = (
    SELECT MAX(DTB)
    FROM (
        SELECT AVG(m.mark) AS DTB
        FROM mark AS m
        GROUP BY m.studentId
    ) AS subquery
);

-- Ví dụ 2: Hiển thị thông tin sinh viên có điểm lớn hơn điểm trung bình của tất cả các sinh viên

SELECT s.*, AVG(m.mark) AS dtb 
FROM student AS s
JOIN mark AS m ON s.studentId = m.studentId
GROUP BY s.studentId
HAVING dtb > (
SELECT AVG(m.mark) FROM mark AS m
)
ORDER BY dtb;

-- 