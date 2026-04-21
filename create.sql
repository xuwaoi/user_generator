CREATE TABLE locales (
    code VARCHAR(10) PRIMARY KEY,
    name TEXT
);

CREATE TABLE names (
    id SERIAL PRIMARY KEY,
    name TEXT,
    gender TEXT,
    locale VARCHAR(10)
);

CREATE TABLE surnames (
    id SERIAL PRIMARY KEY,
    surname TEXT,
    locale VARCHAR(10)
);

CREATE TABLE cities (
    id SERIAL PRIMARY KEY,
    city TEXT,
    locale VARCHAR(100)
);
CREATE TABLE streets (
    id SERIAL PRIMARY KEY,
    street TEXT,
    locale VARCHAR(10)
);
CREATE TABLE email_domains (
    id SERIAL PRIMARY KEY,
    domain TEXT
);
CREATE TABLE phone_formats (
    id SERIAL PRIMARY KEY,
    format TEXT,
    locale VARCHAR(10)
);
CREATE TABLE eye_colors (
    id SERIAL PRIMARY KEY,
    color TEXT
);
CREATE TABLE titles (
    id SERIAL PRIMARY KEY,
    title TEXT,
    gender TEXT,
    locale VARCHAR(10)
);
INSERT INTO locales VALUES
('en_US','English'),
('de_DE','German');

INSERT INTO names (name, gender, locale) VALUES
('John','male','en_US'),
('Emily','female','en_US'),
('Hans','male','de_DE'),
('Anna','female','de_DE');

INSERT INTO surnames (surname, locale) VALUES
('Smith','en_US'),
('Johnson','en_US'),
('Müller','de_DE'),
('Schmidt','de_DE');

INSERT INTO cities (city, locale) VALUES
('New York','en_US'),
('Berlin','de_DE');

INSERT INTO streets (street, locale) VALUES
('Main Street','en_US'),
('Hauptstraße','de_DE');

INSERT INTO email_domains (domain) VALUES
('gmail.com'),
('yahoo.com');

INSERT INTO eye_colors (color) VALUES
('blue'),('green'),('brown'),
('gray'),('hazel'),('amber');

INSERT INTO titles (title, gender, locale) VALUES
('Mr.','male','en_US'),
('Ms.','female','en_US'),
('Herr','male','de_DE'),
('Frau','female','de_DE');
