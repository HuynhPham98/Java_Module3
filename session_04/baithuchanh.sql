CREATE DATABASE ss04_thuchanh;
USE ss04_thuchanh;

CREATE TABLE Class(
classId INT AUTO_INCREMENT PRIMARY KEY,
className VARCHAR(255) NOT NULL,
startDate DATE NOT NULL,
status BIT(1)
);

INSERT INTO Class(className,startDate,status) VALUES('A1','2008-12-20',1),
('A2','2008-12-22',1),
('B3',current_date,0);

CREATE TABLE Student(
studentId INT AUTO_INCREMENT PRIMARY KEY,
studentName VARCHAR(255) NOT NULL,
address VARCHAR(255),
phone VARCHAR(255),
status BIT(1),
class_id INT NOT NULL,
FOREIGN KEY(class_id) REFERENCES Class(classId)
);

INSERT INTO Student(studentName,address, phone,status,class_id) VALUES ('Hung','Ha Noi','0912113113',1,1);
INSERT INTO Student(studentName,address,status,class_id) VALUES ('Hoa','Hai phong',1,1);
INSERT INTO Student(studentName,address,phone,status,class_id) VALUES('Manh','HCM','0123123123',1,2),
('Lan','HCM','0912345678',0,2);

CREATE TABLE Subject(
subId INT AUTO_INCREMENT PRIMARY KEY,
subName VARCHAR(255) NOT NULL,
credit INT DEFAULT 1 CHECK(credit >= 1),
status BIT(1) DEFAULT 1
);

INSERT INTO Subject(subName,credit,status) VALUES('CF',5,1),('C',6,1),('HDJ',5,1),('RDBMS',10,1);

CREATE TABLE Mark(
markId INT AUTO_INCREMENT PRIMARY KEY,
subjectId INT NOT NULL,
studentId INT NOT NULL,
mark DOUBLE DEFAULT 0 CHECK(mark >= 0 & mark < 100),
examtim INT DEFAULT 1,
FOREIGN KEY(subjectId) REFERENCES Subject(subId),
FOREIGN KEY(studentId) REFERENCES Student(studentId)
);

INSERT INTO Mark(subjectId,studentId,mark,examtim) VALUES
(1, 1, 60, 1),
(1, 2, 40, 2),
(2, 1, 70, 1),
(1, 3, 80, 1),
(2, 3, 90, 1);

-- Hiển thị tổng số lượng sinh viên 

SELECT COUNT(s.studentId) AS totalStudent FROM student AS s;

-- Hiển thị điểm thi lớn nhất của từng môn học.

SELECT sub.subId,sub.subName, MAX(m.mark) AS MaxMark FROM subject AS sub
JOIN mark AS m ON sub.subId = m.subjectId
GROUP BY sub.subid
ORDER BY MaxMark DESC;

-- Hiển thị điểm trung bình học viên có số điểm Tb >= 50 bằng cách sử dụng hàm AVG

SELECT s.studentId,s.studentName, AVG(m.mark) AS Dtb FROM student AS s
JOIN mark AS m ON s.studentId = m.studentId
GROUP BY s.studentId 
HAVING Dtb >= 50
ORDER BY Dtb DESC;

-- Sắp xếp sinh viên theo tên tang dần

SELECT * FROM student AS s
ORDER BY s.studentName;