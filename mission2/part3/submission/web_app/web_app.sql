CREATE TABLE CUSTOMER (
    Username VARCHAR(15) NOT NULL,
    Password VARCHAR(15) NOT NULL,
    Fname VARCHAR(15) NOT NULL,
    Minit VARCHAR(1) NOT NULL,
    Lname VARCHAR(15) NOT NULL,
    Credit_card VARCHAR(16) NOT NULL,
    House_number INT NOT NULL,
    Street VARCHAR(20) NOT NULL,
    City VARCHAR(15) NOT NULL,
    Country VARCHAR(15) NOT NULL,
    PRIMARY KEY (Username)
);

CREATE TABLE VEHICLE (
    Id INT NOT NULL,
    Owner VARCHAR(15) NOT NULL,
    Capacity INT NOT NULL,
    Type TEXT CHECK( State IN ('Car', 'Truck', 'Bicycle', 'Electric Scooter')) NOT NULL,
    State TEXT CHECK( State IN ('Moving', 'Stationary')) NOT NULL,
    Longitude DECIMAL(10,8),
    Latitude DECIMAL(11,8),
    PRIMARY KEY (Id),
    FOREIGN KEY(Owner) REFERENCES CUSTOMER(Username) ON DELETE CASCADE,
    CONSTRAINT coordinates CHECK
    (
     State = "Moving"
     OR Latitude IS NOT NULL AND Longitude IS NOT NULL
    )
);

CREATE TABLE RENTAL_SLOT (
    VehicleId INT NOT NULL,
    Renter VARCHAR(15) NOT NULL,
    Start_time DATETIME NOT NULL,
    End_Time DATETIME NOT NULL,
    Slongitude DECIMAL(10,8) NOT NULL,
    Slatitude DECIMAL(11,8) NOT NULL,
    Elongitude DECIMAL(10,8) NOT NULL,
    Elatitude DECIMAL(11,8) NOT NULL,
    State TEXT CHECK( State IN ('Accepted', 'Denied', 'Pending')) NOT NULL,
    Price DECIMAL(10,2) NOT NULL DEFAULT 0,
    FOREIGN KEY(VehicleId) REFERENCES VEHICLE(Id) ON DELETE CASCADE,
    FOREIGN KEY(Renter) REFERENCES CUSTOMER(Username) ON DELETE CASCADE,
    UNIQUE(VehicleId, Renter, Start_time) ON CONFLICT REPLACE
);

CREATE TABLE WANTS_TO_JOIN (
    VehicleId INT NOT NULL,
    Renter VARCHAR(15) NOT NULL,
    Start_time DATETIME NOT NULL,
    Joiner VARCHAR(15) NOT NULL,
    State TEXT CHECK( State IN ('Accepted', 'Denied', 'Pending')) NOT NULL,
    FOREIGN KEY(VehicleId) REFERENCES VEHICLE(Id) ON DELETE CASCADE,
    FOREIGN KEY(Renter) REFERENCES CUSTOMER(Username) ON DELETE CASCADE,
    FOREIGN KEY(Joiner) REFERENCES CUSTOMER(Username) ON DELETE CASCADE,
    UNIQUE(VehicleId, Renter, Start_time, Joiner) ON CONFLICT REPLACE
);

CREATE TABLE FRIENDS_WITH (
    Username1 VARCHAR(15) NOT NULL,
    Username2 VARCHAR(15) NOT NULL,
    FOREIGN KEY(Username1) REFERENCES CUSTOMER(Username) ON DELETE CASCADE,
    FOREIGN KEY(Username2) REFERENCES CUSTOMER(Username) ON DELETE CASCADE,
    UNIQUE(Username1, Username2) ON CONFLICT REPLACE
);