UPDATE names
SET gender = CASE
    WHEN gender = 'boy' THEN 'male'
    WHEN gender = 'girl' THEN 'female'
    ELSE gender
END;

UPDATE names
SET locale = 'de_DE'
WHERE id IN (
    SELECT id FROM names
    WHERE locale = 'en_US'
    LIMIT 150000
);
UPDATE cities
SET locale = 'en_US'
WHERE id IN (
    SELECT id FROM cities
    WHERE locale = 'United States'   
);
UPDATE cities
SET locale = 'de_DE'
WHERE id IN (
    SELECT id FROM cities
    WHERE locale = 'Germany'
);

INSERT INTO email_domains(domain) VALUES
('gmail.com'),
('yahoo.com'),
('outlook.com'),
('hotmail.com'),
('icloud.com'),
('mail.com'),
('gmx.de'),
('web.de');


select * from names 