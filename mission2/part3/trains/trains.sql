CREATE TABLE Train (
    num INT NOT NULL,
    type VARCHAR(64) NOT NULL,
    PRIMARY KEY (num)
);

CREATE TABLE Agent (
    empno INT NOT NULL,
    address VARCHAR(64) NOT NULL,
    name VARCHAR(64) NOT NULL,
    PRIMARY KEY (empno)
);

CREATE TABLE Line (
    code VARCHAR(15) NOT NULL,
    birthDate DATE NOT NULL,
    PRIMARY KEY (code)
);

CREATE TABLE Station (
    name VARCHAR(32) NOT NULL,
    director INT NOT NULL,
    location VARCHAR(64) NOT NULL,
    PRIMARY KEY (name),
    FOREIGN KEY (director) REFERENCES Agent(empno)
);

CREATE TABLE Travel (
    train INT NOT NULL,
    line VARCHAR(15) NOT NULL,
    driver INT NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    FOREIGN KEY (train) REFERENCES Train(num),
    FOREIGN KEY (line) REFERENCES Line(code) ON DELETE CASCADE,
    FOREIGN KEY (driver) REFERENCES Agent(empno),
    UNIQUE(train, line, driver, date, time) ON CONFLICT REPLACE
);

CREATE TABLE Section (
    line VARCHAR(15) NOT NULL,
    start VARCHAR(32) NOT NULL,
    arrival VARCHAR(32) NOT NULL,
    orderNum INT NOT NULL,
    length DECIMAL(7, 3),
    FOREIGN KEY (line) REFERENCES Line(code) ON DELETE CASCADE,
    FOREIGN KEY (start) REFERENCES Station(name) ON DELETE CASCADE,
    FOREIGN KEY (arrival) REFERENCES Station(name) ON DELETE CASCADE,
    UNIQUE(line, start, arrival, orderNum) ON CONFLICT REPLACE
);
