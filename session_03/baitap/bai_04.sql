CREATE DATABASE bai_04;
USE bai_04;

CREATE TABLE class(
classId INT AUTO_INCREMENT PRIMARY KEY,
className VARCHAR(100) NOT NULL,
startDate VARCHAR(255) NOT NULL,
status BIT(1)
);

INSERT INTO class(className,startDate,status) VALUES
('HN_JV231103','2023-11-03',1),
('HN_JV231229','2023-12-29',1),
('HN_JV230615','2023-06-15',1);

CREATE TABLE student(
studentId INT AUTO_INCREMENT PRIMARY KEY,
studentName VARCHAR(100) NOT NULL,
address VARCHAR(255) NOT NULL,
phone VARCHAR(11) NOT NULL,
class_id INT NOT NULL,
status BIT(1),
FOREIGN KEY(class_id) REFERENCES class(classId)
);

INSERT INTO student(studentName,address,phone,class_id,status) VALUES
('Hồ Da Hùng','Hà Nội','0987654321',1,1),
('Phan Văn Giang','Đà Nẵng','0967811255',1,1),
('Dương Mỹ Huyền','Hà Nội','0385546611',2,1),
('Hoàng Minh Hiếu','Nghệ An','0964425633',2,1),
('Nguyễn Vịnh','Hà Nội','0975123552',3,1),
('Nam Cao','Hà Tĩnh','0919191919',1,1),
('Nguyễn Du','Nghệ An','0353535353',3,1);

CREATE TABLE subject(
subjectId INT AUTO_INCREMENT PRIMARY KEY,
subjectName VARCHAR(100) NOT NULL,
credit INT NOT NULL CHECK(credit > 0),
status BIT(1)
);

INSERT INTO subject(subjectName,credit,status) VALUES
('Toán',3,1),
('Văn',3,1),
('Anh',2,1);

CREATE TABLE mark(
markId INT AUTO_INCREMENT PRIMARY KEY,
student_id INT NOT NULL,
subject_id INT NOT NULL,
mark DOUBLE NOT NULL CHECK(mark >= 0),
examTime DATETIME NOT NULL,
FOREIGN KEY(student_id) REFERENCES student(studentId),
FOREIGN KEY(subject_id) REFERENCES subject(subjectId)
);

INSERT INTO mark(student_id,subject_id,mark,examTime) VALUES
(1,1,7,'2024-05-12'),
(1,1,7,'2024-03-15'),
(2,2,8,'2024-05-15'),
(2,3,9,'2024-03-08'),
(3,3,9,'2024-02-11');

-- Hiển thị tất cả lớp học được sắp xếp theo tên giảm dần

SELECT * FROM class 
ORDER BY className DESC; 

-- Hiển thị tất cả học sinh có address ở “Hà Nội”

SELECT * FROM student
WHERE address = 'Hà Nội';

-- Hiển thị tất cả học sinh thuộc lớp HN-JV231103

SELECT student.*,class.className FROM student
JOIN class ON class.classId = student.class_id
WHERE class.className = 'HN_JV231103';

-- Hiển thị tát cả các môn học có credit trên 2

SELECT * FROM subject sub
WHERE sub.credit > 2;

-- Hiển thị tất cả học sinh có phone bắt đầu bằng số 09 

SELECT * FROM student s
WHERE s.phone LIKE '09%';
