USE master;
GO

-- Tạo database ChildVaccine2 nếu chưa tồn tại
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'ChildVaccine2')
    CREATE DATABASE ChildVaccine2;
GO

USE ChildVaccine2;
GO

-- Xóa các bảng nếu đã tồn tại (theo thứ tự phụ thuộc)
DROP TABLE IF EXISTS tblServiceAppointments;
DROP TABLE IF EXISTS tblPackageDetails;
DROP TABLE IF EXISTS tblServices;
DROP TABLE IF EXISTS tblNotifications;
DROP TABLE IF EXISTS tblPackages;
DROP TABLE IF EXISTS tblReports;
DROP TABLE IF EXISTS tblFeedback;
DROP TABLE IF EXISTS tblAppointments;
DROP TABLE IF EXISTS tblChildVaccineNotes;


--------------------------------------------------------------------------------
-- 1) Tạo bảng tblCustomers
--------------------------------------------------------------------------------
CREATE TABLE tblCustomers (
    userID NVARCHAR(20) PRIMARY KEY,
    password NVARCHAR(50) NOT NULL,
    fullName NVARCHAR(100),
    roleID NVARCHAR(20) NOT NULL,
    email NVARCHAR(100),
    address NVARCHAR(200),
    phone NVARCHAR(15),
    status BIT NOT NULL DEFAULT 1
);
GO

--------------------------------------------------------------------------------
-- 2) Tạo bảng tblCenters
--------------------------------------------------------------------------------
CREATE TABLE tblCenters (
    centerID INT PRIMARY KEY IDENTITY(1,1),
    centerName NVARCHAR(100) NOT NULL,
    address NVARCHAR(255) NOT NULL,
    phoneNumber NVARCHAR(15) NOT NULL,
    email NVARCHAR(100),
    operatingHours NVARCHAR(50),
    description NVARCHAR(MAX)
);
GO

--------------------------------------------------------------------------------
-- 3) Tạo bảng tblChildren
--------------------------------------------------------------------------------
CREATE TABLE tblChildren (
    childID INT PRIMARY KEY IDENTITY(1,1),
    userID NVARCHAR(20) NOT NULL,
    childName NVARCHAR(100) NOT NULL,
    dateOfBirth DATE NOT NULL,
    gender NVARCHAR(10),
    FOREIGN KEY (userID) REFERENCES tblCustomers(userID)
);
GO

--------------------------------------------------------------------------------
-- 4) Tạo bảng tblVaccines
--------------------------------------------------------------------------------
CREATE TABLE tblVaccines (
    vaccineID INT PRIMARY KEY IDENTITY(1,1),
    vaccineName NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(10, 2) NOT NULL,
    recommendedAge NVARCHAR(50),
    status NVARCHAR(20) NOT NULL DEFAULT 'Active'
);
GO

--------------------------------------------------------------------------------
-- 5) Tạo bảng tblAppointments
--------------------------------------------------------------------------------
CREATE TABLE tblAppointments (
    appointmentID INT PRIMARY KEY IDENTITY(1,1),
    childID INT NOT NULL,
    centerID INT NOT NULL,
    appointmentDate DATE NOT NULL,
    serviceType NVARCHAR(50) NOT NULL DEFAULT 'Tiem le',
    notificationStatus NVARCHAR(20) DEFAULT 'Not pending',
    status NVARCHAR(20) NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (childID) REFERENCES tblChildren(childID),
    FOREIGN KEY (centerID) REFERENCES tblCenters(centerID)
);
GO

--------------------------------------------------------------------------------
-- 7) Tạo bảng tblFeedback
--------------------------------------------------------------------------------
CREATE TABLE tblFeedback (
    feedbackID INT PRIMARY KEY IDENTITY(1,1),
    userID NVARCHAR(20) NOT NULL,
    centerID INT NOT NULL,
    feedbackText NVARCHAR(MAX),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    feedbackDate DATE NOT NULL,
    FOREIGN KEY (userID) REFERENCES tblCustomers(userID),
    FOREIGN KEY (centerID) REFERENCES tblCenters(centerID)
);
GO

--------------------------------------------------------------------------------
-- 8) Tạo bảng tblReports
--------------------------------------------------------------------------------
CREATE TABLE tblReports (
    reportID INT PRIMARY KEY IDENTITY(1,1),
    centerID INT NOT NULL,
    reportDate DATE NOT NULL,
    totalAppointments INT,
    totalRevenue DECIMAL(10, 2),
    FOREIGN KEY (centerID) REFERENCES tblCenters(centerID)
);
GO

--------------------------------------------------------------------------------
-- 9) Tạo bảng tblPackages
--------------------------------------------------------------------------------
CREATE TABLE tblPackages (
    packageID INT PRIMARY KEY IDENTITY(1,1),
    packageName NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(10, 2) NOT NULL,
    status NVARCHAR(20) NOT NULL DEFAULT 'Active'
);
GO

--------------------------------------------------------------------------------
-- 10) Tạo bảng tblNotifications
--------------------------------------------------------------------------------
CREATE TABLE tblNotifications (
    notificationID INT PRIMARY KEY IDENTITY(1,1),
    userID NVARCHAR(20) NOT NULL,
    notificationDate DATETIME NOT NULL DEFAULT GETDATE(),
    notificationText NVARCHAR(MAX) NOT NULL,
    isRead BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (userID) REFERENCES tblCustomers(userID)
);
GO

--------------------------------------------------------------------------------
-- 11) Tạo bảng tblServices
--------------------------------------------------------------------------------
CREATE TABLE tblServices (
    serviceID INT PRIMARY KEY IDENTITY(1,1),
    serviceName NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(10, 2) NOT NULL,
    status NVARCHAR(20) NOT NULL DEFAULT 'Active'
);
GO

--------------------------------------------------------------------------------
-- 12) Tạo bảng tblPackageDetails
--------------------------------------------------------------------------------
CREATE TABLE tblPackageDetails (
    packageDetailID INT PRIMARY KEY IDENTITY(1,1),
    packageID INT NOT NULL,
    vaccineID INT NOT NULL,
    FOREIGN KEY (packageID) REFERENCES tblPackages(packageID),
    FOREIGN KEY (vaccineID) REFERENCES tblVaccines(vaccineID)
);
GO

--------------------------------------------------------------------------------
-- 13) Tạo bảng tblServiceAppointments
--------------------------------------------------------------------------------
CREATE TABLE tblServiceAppointments (
    serviceAppointmentID INT PRIMARY KEY IDENTITY(1,1),
    appointmentID INT NOT NULL,
    serviceID INT NOT NULL,
    FOREIGN KEY (appointmentID) REFERENCES tblAppointments(appointmentID),
    FOREIGN KEY (serviceID) REFERENCES tblServices(serviceID)
);
GO

--------------------------------------------------------------------------------
-- 14) Tạo bảng tblChildVaccineNotes
--------------------------------------------------------------------------------
CREATE TABLE tblChildVaccineNotes (
    noteID INT PRIMARY KEY IDENTITY(1,1),
    vaccineID INT NOT NULL,
    note NVARCHAR(MAX) NOT NULL,
    FOREIGN KEY (vaccineID) REFERENCES tblVaccines(vaccineID)
);
GO

-------------------------------------------------------------------------------
-- INSERT DATA
-------------------------------------------------------------------------------

-- 1) Dữ liệu cho tblCustomers
INSERT INTO tblCustomers (userID, password, fullName, roleID, email, address, phone, status) 
VALUES 
('admin', '2', 'Tran Gia Huy', 'AD', 'admin@example.com', '123 Main St', '0123456789', 1),
('cus1', '1', 'Huynh Cong Hoa', 'AD', 'cus1@example.com', '456 Street', '0987654321', 1),
('cus2', '1', 'Ho Quoc Trung', 'US', 'cus2@example.com', '789 Street', '0989654321', 1),
('cus3', '1', 'Nhat Long', 'US', 'cus3@example.com', '10JQ Street', '0987254321', 1),
('cus4', '1', 'Nhat Huy', 'US', 'cus4@example.com', 'QKA Street', '0981654321', 1),
('cus5', '1', 'Nguyen Van A', 'US', 'nguyenvana@gmail.com', 'So 10 Hoang Dieu, Ha Noi', '0912345678', 1),
('cus6', '1', 'Tran Thi B', 'US', 'tranthib@gmail.com', 'So 5 Le Loi, TP.HCM', '0987654321', 1);
GO

-- 2) Dữ liệu cho tblCenters
INSERT INTO tblCenters (centerName, address, phoneNumber, email, operatingHours, description)
VALUES	
('VNVC Ha Noi', 'So 180 Truong Chinh, Ha Noi', '0243-1234567', 'hanoi@vnvc.vn', '08:00 - 18:00', 'Trung tam tiem chung VNVC tai Ha Noi'),
('VNVC Ho Chi Minh', 'So 198 Nguyen Thi Minh Khai, Quan 1, TP.HCM', '0283-9876543', 'hcm@vnvc.vn', '08:00 - 18:00', 'Trung tam tiem chung VNVC tai TP.HCM');
GO

-- 3) Dữ liệu cho tblChildren
INSERT INTO tblChildren (userID, childName, dateOfBirth, gender)
VALUES
('admin', 'Nguyen Thi C', '2018-03-25', 'Female'),
('cus1', 'Tran Van D', '2019-08-10', 'Male');
GO

-- 4) Dữ liệu cho tblVaccines
INSERT INTO tblVaccines (vaccineName, description, price, recommendedAge, status)  
VALUES  
('Vaccine bach hau', 'Phong ngua benh bach hau o tre em', 500000, '2 thang tuoi tro len', 'Active'),  
('Vaccine uon van', 'Phong chong benh uon van', 450000, '2 thang tuoi tro len', 'Active'),  
('Vaccine ho ga', 'Phong ngua benh ho ga', 400000, '2 thang tuoi tro len', 'Active'),  
('Vaccine viem gan B', 'Phong benh viem gan B', 550000, '2 thang tuoi tro len', 'Active'),  
('Vaccine quai bi', 'Phong ngua benh quai bi', 600000, '1 tuoi tro len', 'Active'),  
('Vaccine soi', 'Phong benh soi', 600000, '1 tuoi tro len', 'Active'),  
('Vaccine rubella', 'Phong benh rubella', 700000, '1 tuoi tro len', 'Active'),  
('Vaccine viem nao mo cau', 'Phong benh viem nao mo cau', 800000, '6 thang tuoi tro len', 'Active'),  
('Vaccine thuong han', 'Phong benh thuong han', 900000, '6 thang tuoi tro len', 'Active'),  
('Vaccine rotavirus', 'Phong benh tieu chay do rotavirus', 1000000, '2 thang tuoi tro len', 'Active'),  
('Vaccine HPV', 'Phong ngua ung thu co tu cung', 1500000, '9 tuoi tro len', 'Active'),  
('Vaccine phoi cau', 'Phong ngua benh viem phoi', 1200000, '2 thang tuoi tro len', 'Active'),  
('Vaccine phoi viem', 'Phong benh viem phoi', 1100000, '2 thang tuoi tro len', 'Active'),  
('Vaccine viem gan A', 'Phong benh viem gan A', 1000000, '1 tuoi tro len', 'Active'),  
('Vaccine HIB', 'Phong ngua benh viem mang nao HIB', 900000, '2 thang tuoi tro len', 'Active'),  
('Vaccine tieu duong', 'Phong ngua benh tieu duong', 2000000, '6 tuoi tro len', 'Active'),  
('Vaccine rota 5 trong 1', 'Phong benh do rota virus', 3000000, '2 thang tuoi tro len', 'Active'),  
('Vaccine thuy dau', 'Phong benh thuy dau', 800000, '1 tuoi tro len', 'Active'),  
('Vaccine quai bi-soi-rubella', 'Phong ngua quai bi, soi va rubella', 2000000, '1 tuoi tro len', 'Active'),  
('Vaccine phoi phuc hop', 'Phong cac benh viem phoi va benh lien quan', 2500000, '6 thang tuoi tro len', 'Active');
GO

-- 5) Dữ liệu cho tblChildVaccineNotes
INSERT INTO tblChildVaccineNotes (vaccineID, note)
VALUES
(1, N'Nên tiêm lúc trẻ 2, 3, 4 tháng tuổi và nhắc lại lúc 18 tháng. Thường kết hợp với uốn ván, ho gà trong gói 5 trong 1.'),
(2, N'Tiêm nhắc cùng bạch hầu, ho gà (5 trong 1). Lịch tiêm 2, 3, 4 tháng tuổi và nhắc lúc 18 tháng.'),
(3, N'Ho gà thường tiêm chung với bạch hầu, uốn ván. Lịch tiêm tương tự các vaccine trên.'),
(4, N'Cần tiêm liều sơ sinh (24h đầu sau sinh) và các liều tiếp theo lúc 2, 3, 4 tháng tuổi.'),
(5, N'Nên tiêm mũi đầu khi trẻ đủ 12 tháng tuổi. Tiêm nhắc lúc 4-6 tuổi.'),
(6, N'Tiêm mũi đầu lúc 9 tháng hoặc 12 tháng. Nhắc lại lúc 18 tháng.'),
(7, N'Tiêm lúc 12 tháng. Thường tiêm phối hợp trong mũi Sởi - Quai bị - Rubella (MMR).'),
(8, N'Tiêm phòng cho trẻ từ 6 tháng đến 2 tuổi, có thể nhắc lại khi trẻ lớn hơn.'),
(9, N'Trẻ từ 6 tháng trở lên, tiêm 1 liều, nhắc lại sau mỗi 2-3 năm nếu nguy cơ cao.'),
(10, N'Ngừa tiêu chảy cấp do Rota. Tiêm đường uống khi trẻ 2, 3, 4 tháng tuổi.'),
(11, N'Trẻ gái từ 9 tuổi trở lên, thường tiêm 2 hoặc 3 liều tùy loại vaccine.'),
(12, N'Tiêm cho trẻ từ 2 tháng tuổi, có thể tiêm nhắc ở 12-15 tháng.'),
(13, N'Tiêm phòng các chủng phế cầu khuẩn gây viêm phổi, lịch tiêm tương tự phế cầu.'),
(14, N'Tiêm cho trẻ từ 1 tuổi, nhắc lại sau 6-12 tháng tùy loại vaccine.'),
(15, N'Ngừa viêm màng não do Haemophilus influenzae type b. Tiêm khi trẻ 2, 3, 4 tháng và nhắc lúc 18 tháng.'),
(16, N'Đây là vaccine thử nghiệm (giả định). Dành cho trẻ từ 6 tuổi trở lên theo chỉ định bác sĩ.'),
(17, N'Tiêm ngừa 5 chủng rotavirus khác nhau. Thường dùng đường uống khi trẻ 2, 3, 4 tháng tuổi.'),
(18, N'Tiêm cho trẻ từ 12-15 tháng tuổi, nhắc lại 4-6 tuổi nếu cần.'),
(19, N'Tiêm 3 trong 1 (MMR) lúc 12-15 tháng, nhắc lại lúc 4-6 tuổi.'),
(20, N'Phòng viêm phổi và các bệnh liên quan. Thường bắt đầu từ 6 tháng tuổi, tùy phác đồ.');
GO

--------------------------------------------------------------------------------
-- 6) Dữ liệu tblAppointments (quan trọng để hiển thị "X" hay "Tiêm Chủng")
--    Tạo một số lịch hẹn cho childID=1 và childID=2, với ngày 2025 (trước hoặc sau hôm nay)
--------------------------------------------------------------------------------
INSERT INTO tblAppointments (childID, centerID, appointmentDate, serviceType, notificationStatus, status)
VALUES
-- Cho childID=1
(1, 1, '2025-02-15', 'Single Vaccination (Tiêm lẻ)', 'Not pending', 'Pending'),
(1, 1, '2025-03-01', 'Full Package (Trọn Gói)', 'Not pending', 'Pending'),
-- Cho childID=2
(2, 2, '2025-03-10', 'Personalization (Cá nhân hóa)', 'Not pending', 'Confirmed'),
-- Thêm 1 lịch trước ngày 2025-02-27 (để hiển thị "X")
(1, 1, '2025-02-01', 'Single Vaccination (Tiêm lẻ)', 'Not pending', 'Done');
GO

--------------------------------------------------------------------------------
-- 7) Dữ liệu cho tblFeedback
--------------------------------------------------------------------------------
INSERT INTO tblFeedback (userID, centerID, feedbackText, rating, feedbackDate)
VALUES
('admin', 1, N'Dịch vụ tốt, nhân viên nhiệt tình.', 5, '2025-01-05'),
('cus1', 2, N'Trung tâm sạch sẽ, an toàn.', 4, '2025-01-06');
GO

--------------------------------------------------------------------------------
-- 8) Dữ liệu cho tblPackages
--------------------------------------------------------------------------------
INSERT INTO tblPackages (packageName, description, price, status)
VALUES
('Goi 5 trong 1', N'Bao gồm các mũi tiêm 5 trong 1', 2500000, 'Active'),
('Goi phong cum', N'Bao gồm các mũi tiêm phòng cúm mùa', 1200000, 'Active');
GO

--------------------------------------------------------------------------------
-- 9) Dữ liệu cho tblNotifications
--------------------------------------------------------------------------------
INSERT INTO tblNotifications (userID, notificationDate, notificationText, isRead)
VALUES
('admin', '2025-01-10', N'Lịch tiêm của bé Nguyễn Thị C vào ngày 2025-02-15 tại VNVC Hà Nội', 0),
('cus1', '2025-01-12', N'Lịch tiêm của bé Trần Văn D vào ngày 2025-03-01 tại VNVC Hồ Chí Minh', 0),
('cus1', '2025-01-15', N'Lịch tiêm của bé Trần Văn D vào ngày 2025-03-10 tại VNVC Hà Nội', 1);
GO

--------------------------------------------------------------------------------
-- 10) Dữ liệu cho tblServices
--------------------------------------------------------------------------------
INSERT INTO tblServices (serviceName, description, price, status)
VALUES
('Tiem Vaccine', N'Dịch vụ tiêm lẻ các loại vaccine', 500000, 'Active'),
('Tu Van', N'Tư vấn các loại vaccine và lịch tiêm', 200000, 'Active'),
('Giam sat suc khoe', N'Dịch vụ kiểm tra và giám sát sức khỏe trước khi tiêm', 300000, 'Active');
GO

--------------------------------------------------------------------------------
-- 11) Dữ liệu cho tblPackageDetails
--------------------------------------------------------------------------------
INSERT INTO tblPackageDetails (packageID, vaccineID)
VALUES
(1, 1),
(2, 2);
GO

--------------------------------------------------------------------------------
-- 12) Dữ liệu cho tblServiceAppointments
--------------------------------------------------------------------------------
INSERT INTO tblServiceAppointments (appointmentID, serviceID)
VALUES
(1, 1),
(2, 2),
(2, 3);
GO

----------------------------------------------------------------------------------
-- 13) Dữ liệu cho tblReport
----------------------------------------------------------------------------------
-- tblReports
INSERT INTO tblReports (centerID, reportDate, totalAppointments, totalRevenue)
VALUES
(1, '2025-01-01', 10, 7500000),
(2, '2025-01-02', 15, 12000000),
(2, '2025-01-03', 20, 15000000),
(1, '2025-01-04', 12, 9000000),
(2, '2025-01-05', 18, 13500000),
(1, '2025-01-06', 22, 16500000),
(1, '2025-01-07', 8, 6000000),
(2, '2025-01-08', 14, 10500000),
(2, '2025-01-09', 25, 18000000),
(1, '2025-01-10', 10, 7500000),
(2, '2025-01-11', 17, 12750000),
(1, '2025-01-12', 21, 15750000);
GO


--------------------------------------------------------------------------------
-- Script hoàn tất
--------------------------------------------------------------------------------
PRINT 'Done: Database ChildVaccine2 schema & sample data created successfully!';
GO

----------------
--Test
----------------
-- Tạo bảng lưu phản ứng sau tiêm

DROP TABLE IF EXISTS tblVaccineReactions;
CREATE TABLE tblVaccineReactions (
    reactionID INT PRIMARY KEY IDENTITY(1,1),
    appointmentID INT NOT NULL,
    reactionText NVARCHAR(MAX) NULL,
    reactionDate DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (appointmentID) REFERENCES tblAppointments(appointmentID) ON DELETE CASCADE
);
GO

CREATE TABLE tblDoctor (
    doctorID VARCHAR(50) PRIMARY KEY,
    doctorName NVARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    roleID VARCHAR(10) DEFAULT 'Doctor',
    email VARCHAR(50),
    address NVARCHAR(100),
    phone VARCHAR(20),
    status BIT DEFAULT 1
);


INSERT INTO tblDoctor (doctorID, password, doctorName, roleID, email, address, phone, status) 
VALUES 
('doc1', '2', 'Nguyen Cong Son', 'doctor', 'doc1@example.com', '123 NY St', '036945978', 1),
('doc2', '2', 'Ly Thien Long', 'doctor', 'doc2@example.com', '456  NY Street', '046987123', 1),
('doc3', '2', 'Ly Cao Cuong', 'doctor', 'doc3@example.com', '789 NY Street', '014632879', 1)

ALTER TABLE tblAppointments
ADD vaccineID INT;
GO

ALTER TABLE tblAppointments
ADD CONSTRAINT FK_tblAppointments_tblVaccines
FOREIGN KEY (vaccineID) REFERENCES tblVaccines(vaccineID);
GO


