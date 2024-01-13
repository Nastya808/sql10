CREATE DATABASE database;

CREATE TABLE Categories (
    Id SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL
);

INSERT INTO Categories (Name) VALUES 
('Smartphones'), 
('Laptops'), 
('Accessories');

CREATE TABLE Products (
    Id SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Brand VARCHAR(255),
    Price DECIMAL(10, 2) CHECK (Price >= 0),
    Description TEXT,
    CategoryId INT REFERENCES Categories(Id) ON DELETE CASCADE
);

INSERT INTO Products (Name, Brand, Price, Description, CategoryId) VALUES
('iPhone 12', 'Apple', 799.99, 'Latest iPhone model', 1),
('Samsung Galaxy S21', 'Samsung', 699.99, 'Flagship Android phone', 1),
('MacBook Pro', 'Apple', 1499.99, 'Powerful laptop for professionals', 2);

CREATE TABLE Customers (
    Id SERIAL PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Address TEXT,
    Email VARCHAR(255) UNIQUE NOT NULL
);

INSERT INTO Customers (FirstName, LastName, Address, Email) VALUES
('John', 'Doe', '123 Main St', 'john.doe@example.com'),
('Jane', 'Smith', '456 Oak St', 'jane.smith@example.com');

CREATE TABLE Orders (
    Id SERIAL PRIMARY KEY,
    CustomerId INT REFERENCES Customers(Id) ON DELETE CASCADE,
    EmployeeId INT,
    Date DATE DEFAULT CURRENT_DATE,
    Status VARCHAR(50) CHECK (Status IN ('Pending', 'Shipped', 'Delivered')),
    TotalAmount DECIMAL(10, 2) DEFAULT 0 CHECK (TotalAmount >= 0)
);

INSERT INTO Orders (CustomerId, EmployeeId, Status, TotalAmount) VALUES
(1, NULL, 'Shipped', 499.99),
(1, NULL, 'Pending', 899.99);

CREATE TABLE OrderDetails (
    OrderId INT,
    ProductId INT,
    Quantity INT CHECK (Quantity > 0),
    PRIMARY KEY (OrderId, ProductId),
    FOREIGN KEY (OrderId) REFERENCES Orders(Id) ON DELETE CASCADE,
    FOREIGN KEY (ProductId) REFERENCES Products(Id) ON DELETE CASCADE
);

INSERT INTO OrderDetails (OrderId, ProductId, Quantity) VALUES
(1, 1, 1),
(2, 2, 2);

CREATE TABLE Reviews (
    Id SERIAL PRIMARY KEY,
    ProductId INT REFERENCES Products(Id) ON DELETE CASCADE,
    CustomerId INT REFERENCES Customers(Id) ON DELETE CASCADE,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comment TEXT
);

INSERT INTO Reviews (ProductId, CustomerId, Rating, Comment) VALUES
(1, 1, 5, 'Great phone!'),
(2, 2, 4, 'Good features, but a bit pricey');

CREATE TABLE Employees (
    Id SERIAL PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Position VARCHAR(255) NOT NULL
);

INSERT INTO Employees (FirstName, LastName, Position) VALUES
('Mark', 'Johnson', 'Sales Representative'),
('Emily', 'Miller', 'Customer Service');



-- 1
CREATE OR REPLACE FUNCTION GetGreeting(name VARCHAR(255))
RETURNS VARCHAR(255)
AS $$
BEGIN
    RETURN 'Hello, ' || name || '!';
END;
$$ LANGUAGE plpgsql;

-- 2
CREATE OR REPLACE FUNCTION GetCurrentMinutes()
RETURNS INT
AS $$
BEGIN
    RETURN EXTRACT(MINUTE FROM NOW());
END;
$$ LANGUAGE plpgsql;

-- 3
CREATE OR REPLACE FUNCTION GetCurrentYear()
RETURNS INT
AS $$
BEGIN
    RETURN EXTRACT(YEAR FROM NOW());
END;
$$ LANGUAGE plpgsql;

-- 4
CREATE OR REPLACE FUNCTION GetYearParity()
RETURNS VARCHAR(10)
AS $$
BEGIN
    RETURN CASE WHEN EXTRACT(YEAR FROM NOW()) % 2 = 0 THEN 'Even' ELSE 'Odd' END;
END;
$$ LANGUAGE plpgsql;

-- 5
CREATE OR REPLACE FUNCTION GetNumbersInRange(start_num INT, end_num INT, is_even BOOLEAN)
RETURNS TABLE (number INT)
AS $$
BEGIN
    FOR num IN start_num..end_num
    LOOP
        IF (num % 2 = 0 AND is_even) OR (num % 2 <> 0 AND NOT is_even) THEN
            RETURN NEXT num;
        END IF;
    END LOOP;
    RETURN;
END;
$$ LANGUAGE plpgsql;

-- 6
CREATE OR REPLACE FUNCTION GetMinMaxSum(a INT, b INT, c INT, d INT, e INT)
RETURNS INT
AS $$
BEGIN
    RETURN LEAST(a, b, c, d, e) + GREATEST(a, b, c, d, e);
END;
$$ LANGUAGE plpgsql;

-- 7) 
CREATE OR REPLACE FUNCTION IsPrime(num INT)
RETURNS VARCHAR(3)
AS $$
DECLARE
    i INT;
BEGIN
    IF num < 2 THEN
        RETURN 'no';
    END IF;
    FOR i IN 2..ROUND(SQRT(num))
    LOOP
        IF num % i = 0 THEN
            RETURN 'no';
        END IF;
    END LOOP;
    RETURN 'yes';
END;
$$ LANGUAGE plpgsql;
