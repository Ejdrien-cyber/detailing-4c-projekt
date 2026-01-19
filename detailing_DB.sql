USE master;
GO

-- Pokud DB existuje, smaû ji (aù je skript opakovateln˝)
IF EXISTS (SELECT * FROM sys.databases WHERE name = N'DetailingDB')
BEGIN
    ALTER DATABASE DetailingDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DetailingDB;
END;
GO

CREATE DATABASE DetailingDB;
GO

USE DetailingDB;
GO

/* =========================
   1) USERS
   ========================= */
CREATE TABLE Users (
    UsersID   INT PRIMARY KEY IDENTITY(1,1),
    email     VARCHAR(100) NOT NULL,
    password  VARCHAR(255) NOT NULL,
    name      VARCHAR(100) NOT NULL,
    phone     VARCHAR(30)  NULL
);
GO


/* =========================
   2) VEHICLES
   ========================= */
CREATE TABLE Vehicles (
    VehicleID      INT PRIMARY KEY IDENTITY(1,1),
    User_ID        INT NOT NULL,
    licence_plate  VARCHAR(20) NOT NULL,
    make           VARCHAR(50) NOT NULL,
    model          VARCHAR(50) NOT NULL,
    color          VARCHAR(30) NULL,

    FOREIGN KEY (User_ID) REFERENCES Users(UsersID)
);
GO


/* =========================
   3) SERVICE CATEGORY (Exterior/Interior)
   ========================= */
CREATE TABLE ServiceCategory (
    CategoryID  INT PRIMARY KEY IDENTITY(1,1),
    code        VARCHAR(30) NOT NULL,
    name        VARCHAR(50) NOT NULL
);
GO


/* =========================
   4) PACKAGES (Classic/Good/Premium)
   ========================= */
CREATE TABLE Packages (
    PackageID   INT PRIMARY KEY IDENTITY(1,1),
    category_id INT NOT NULL,
    name        VARCHAR(50) NOT NULL,
    base_price  DECIMAL(10,2) NOT NULL,
    duration    INT NOT NULL,  -- minut

    FOREIGN KEY (category_id) REFERENCES ServiceCategory(CategoryID)
);
GO


/* =========================
   5) BOOKINGS
   ========================= */
CREATE TABLE Bookings (
    BookingID   INT PRIMARY KEY IDENTITY(1,1),
    User_ID     INT NOT NULL,
    vehicle_id  INT NOT NULL,
    package_id  INT NOT NULL,

    start_at    DATETIME NOT NULL,
    end_at      DATETIME NOT NULL,
    status      VARCHAR(20) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (User_ID)    REFERENCES Users(UsersID),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(VehicleID),
    FOREIGN KEY (package_id) REFERENCES Packages(PackageID)
);
GO


/* =========================
   6) ADDONS
   ========================= */
CREATE TABLE Addons (
    AddonID     INT PRIMARY KEY IDENTITY(1,1),
    name        VARCHAR(80) NOT NULL,
    price       DECIMAL(10,2) NOT NULL
);
GO


/* =========================
   7) BOOKING ADDONS (M:N)
   ========================= */
CREATE TABLE BookingAddons (
    BookingID   INT NOT NULL,
    AddonID     INT NOT NULL,
    unit_price  DECIMAL(10,2) NOT NULL,

    -- sloûen˝ prim·rnÌ klÌË (aby nebyl stejn˝ addon v jednÈ rezervaci 2x)
    PRIMARY KEY (BookingID, AddonID),

    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    FOREIGN KEY (AddonID)   REFERENCES Addons(AddonID)
);
GO


/* =========================
   Z¡KLADNÕ DATA (volitelnÈ)
   ========================= */

-- Kategorie
INSERT INTO ServiceCategory (code, name)
VALUES
('EXTERIOR', 'Exterier'),
('INTERIOR', 'Interier');
GO

-- BalÌËky (p¯Ìklad)
INSERT INTO Packages (category_id, name, base_price, duration)
VALUES
(1, 'Classic', 499.00, 45),
(1, 'Good',    799.00, 70),
(1, 'Premium', 1299.00, 110),

(2, 'Classic', 599.00, 50),
(2, 'Good',    999.00, 90),
(2, 'Premium', 1599.00, 140);
GO

-- Addony (p¯Ìklad)
INSERT INTO Addons (name, price)
VALUES
('Psi chlupy', 300.00),
('Plisen', 500.00),
('Vykaly / silne znecisteni', 700.00);
GO
