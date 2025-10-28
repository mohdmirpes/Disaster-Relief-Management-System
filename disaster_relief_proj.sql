DROP DATABASE IF EXISTS disaster_relief;
CREATE DATABASE disaster_relief;
USE disaster_relief;

CREATE TABLE DisasterEvent (
  EventID INT AUTO_INCREMENT PRIMARY KEY,
  EventName VARCHAR(100),
  EventType VARCHAR(50),
  Location VARCHAR(100),
  StartDate DATE,
  EndDate DATE,
  Severity VARCHAR(20),
  Status VARCHAR(20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE ReliefCenter (
  CenterID INT AUTO_INCREMENT PRIMARY KEY,
  CenterName VARCHAR(100),
  Location VARCHAR(100),
  Capacity INT,
  ContactNumber VARCHAR(15),
  ManagerName VARCHAR(50),
  OpeningDate DATE,
  Status VARCHAR(20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Donor (
  DonorID INT AUTO_INCREMENT PRIMARY KEY,
  DonorName VARCHAR(100),
  ContactNumber VARCHAR(15),
  Email VARCHAR(100),
  DonorType VARCHAR(50),
  Address VARCHAR(200)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Resource (
  ResourceID INT AUTO_INCREMENT PRIMARY KEY,
  ResourceName VARCHAR(100),
  ResourceType VARCHAR(50),
  Quantity INT,
  Unit VARCHAR(20),
  ExpiryDate DATE,
  CenterID INT DEFAULT NULL,
  FOREIGN KEY (CenterID) REFERENCES ReliefCenter(CenterID) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Donation (
  DonationID INT AUTO_INCREMENT PRIMARY KEY,
  DonorID INT,
  ResourceType VARCHAR(50),
  Quantity INT,
  DonationDate DATE,
  CenterID INT DEFAULT NULL,
  FOREIGN KEY (DonorID) REFERENCES Donor(DonorID) ON DELETE CASCADE,
  FOREIGN KEY (CenterID) REFERENCES ReliefCenter(CenterID) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE DonorSupport (
  DonorSupportID INT AUTO_INCREMENT PRIMARY KEY,
  DonorID INT,
  EventID INT,
  SupportType VARCHAR(50),
  Amount DECIMAL(12,2),
  FOREIGN KEY (DonorID) REFERENCES Donor(DonorID) ON DELETE CASCADE,
  FOREIGN KEY (EventID) REFERENCES DisasterEvent(EventID) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Volunteer (
  VolunteerID INT AUTO_INCREMENT PRIMARY KEY,
  Fname VARCHAR(50),
  Lname VARCHAR(50),
  Gender CHAR(1),
  DOB DATE,
  Phone VARCHAR(15),
  Email VARCHAR(100),
  Skillset VARCHAR(100),
  Availability VARCHAR(20),
  CenterID INT DEFAULT NULL,
  DonorID INT DEFAULT NULL,
  FOREIGN KEY (CenterID) REFERENCES ReliefCenter(CenterID) ON DELETE SET NULL,
  FOREIGN KEY (DonorID) REFERENCES Donor(DonorID) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Request (
  RequestID INT AUTO_INCREMENT PRIMARY KEY,
  EventID INT,
  RequestedBy VARCHAR(100),
  ResourceType VARCHAR(50),
  Quantity INT,
  Priority VARCHAR(20),
  RequestDate DATE,
  Status VARCHAR(20),
  FOREIGN KEY (EventID) REFERENCES DisasterEvent(EventID) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert sample data into all tables

INSERT INTO DisasterEvent (EventName, EventType, Location, StartDate, EndDate, Severity, Status) VALUES
('Kerala Floods 2025', 'Flood', 'Kerala', '2025-08-15', '2025-08-25', 'High', 'Active'),
('Gujarat Earthquake', 'Earthquake', 'Gujarat', '2025-07-10', '2025-07-12', 'Medium', 'Closed'),
('Cyclone Biparjoy', 'Cyclone', 'Mumbai', '2025-06-05', '2025-06-08', 'High', 'Closed'),
('Uttarakhand Landslide', 'Landslide', 'Uttarakhand', '2025-09-01', '2025-09-03', 'Medium', 'Active');

INSERT INTO ReliefCenter (CenterName, Location, Capacity, ContactNumber, ManagerName, OpeningDate, Status) VALUES
('Central Relief Hub', 'Kerala', 500, '9876543210', 'Rajesh Kumar', '2025-08-16', 'Active'),
('Gujarat Aid Center', 'Gujarat', 300, '9876543211', 'Priya Sharma', '2025-07-11', 'Active'),
('Mumbai Shelter', 'Mumbai', 400, '9876543212', 'Amit Patel', '2025-06-06', 'Inactive'),
('Uttarakhand Base Camp', 'Uttarakhand', 250, '9876543213', 'Sunita Reddy', '2025-09-02', 'Active');

INSERT INTO Donor (DonorName, ContactNumber, Email, DonorType, Address) VALUES
('Tata Trust', '9123456789', 'contact@tatatrust.org', 'Corporate', 'Mumbai, Maharashtra'),
('Infosys Foundation', '9123456790', 'info@infosys.org', 'Corporate', 'Bangalore, Karnataka'),
('Dr. Ramesh Verma', '9123456791', 'ramesh@gmail.com', 'Individual', 'Delhi'),
('Global Aid NGO', '9123456792', 'contact@globalaid.org', 'NGO', 'Pune, Maharashtra');

INSERT INTO Resource (ResourceName, ResourceType, Quantity, Unit, ExpiryDate, CenterID) VALUES
('Rice Bags', 'Food', 1000, 'Bags', '2026-08-15', 1),
('Water Bottles', 'Water', 5000, 'Bottles', '2026-12-31', 1),
('Medical Kits', 'Medical', 200, 'Kits', '2027-01-01', 2),
('Blankets', 'Shelter', 800, 'Pieces', NULL, 4);

INSERT INTO Donation (DonorID, ResourceType, Quantity, DonationDate, CenterID) VALUES
(1, 'Food', 500, '2025-08-17', 1),
(2, 'Medical', 100, '2025-07-12', 2),
(3, 'Water', 1000, '2025-06-07', 3),
(4, 'Shelter', 300, '2025-09-03', 4);

INSERT INTO DonorSupport (DonorID, EventID, SupportType, Amount) VALUES
(1, 1, 'Financial', 500000.00),
(2, 2, 'Financial', 300000.00),
(3, 3, 'Financial', 50000.00),
(4, 4, 'Financial', 150000.00);

INSERT INTO Volunteer (Fname, Lname, Gender, DOB, Phone, Email, Skillset, Availability, CenterID, DonorID) VALUES
('Anil', 'Kumar', 'M', '1995-05-15', '9988776655', 'anil@gmail.com', 'Medical', 'Full-time', 1, NULL),
('Pooja', 'Singh', 'F', '1998-03-22', '9988776656', 'pooja@gmail.com', 'Rescue Operations', 'Part-time', 2, NULL),
('Rahul', 'Mehta', 'M', '1992-11-08', '9988776657', 'rahul@gmail.com', 'Logistics', 'Full-time', 3, 1),
('Sneha', 'Desai', 'F', '1996-07-30', '9988776658', 'sneha@gmail.com', 'Communication', 'Part-time', 4, NULL);

INSERT INTO Request (EventID, RequestedBy, ResourceType, Quantity, Priority, RequestDate, Status) VALUES
(1, 'Kerala District Collector', 'Food', 2000, 'High', '2025-08-18', 'Pending'),
(2, 'Gujarat Relief Officer', 'Medical', 500, 'High', '2025-07-11', 'Fulfilled'),
(3, 'Mumbai Municipality', 'Water', 3000, 'Medium', '2025-06-06', 'Fulfilled'),
(4, 'Uttarakhand Admin', 'Shelter', 1000, 'High', '2025-09-02', 'Pending');

-- Display all tables with their contents
SELECT 'DisasterEvent' AS TableName;
SELECT * FROM DisasterEvent;

SELECT 'ReliefCenter' AS TableName;
SELECT * FROM ReliefCenter;

SELECT 'Donor' AS TableName;
SELECT * FROM Donor;

SELECT 'Resource' AS TableName;
SELECT * FROM Resource;

SELECT 'Donation' AS TableName;
SELECT * FROM Donation;

SELECT 'DonorSupport' AS TableName;
SELECT * FROM DonorSupport;

SELECT 'Volunteer' AS TableName;
SELECT * FROM Volunteer;

SELECT 'Request' AS TableName;
SELECT * FROM Request;

