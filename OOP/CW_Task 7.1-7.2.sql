DROP database IF EXISTS HumanFriends;
CREATE database HumanFriends;
USE HumanFriends;

-- Создание таблиц
DROP TABLE IF EXISTS HumanFriends;
CREATE TABLE HumanFriends (
    id_human_friends INT AUTO_INCREMENT PRIMARY KEY,
    type_human_friends VARCHAR(50)
);

DROP TABLE IF EXISTS Pets;
CREATE TABLE Pets (
    id_pets INT AUTO_INCREMENT PRIMARY KEY,
    type_pets VARCHAR(50),
    id_human_friends INT,
    FOREIGN KEY (id_human_friends) REFERENCES HumanFriends(id_human_friends)
    ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS PackAnimals;
CREATE TABLE PackAnimals (
    id_pack_animals INT AUTO_INCREMENT PRIMARY KEY,
    type_pack_animals VARCHAR(50),
    id_human_friends INT,
    FOREIGN KEY (id_human_friends) REFERENCES HumanFriends(id_human_friends)
    ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Cats;
CREATE TABLE Cats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255),
    BirthDay DATE,
    Commands TEXT,
    id_pets INT,
    FOREIGN KEY (id_pets) REFERENCES Pets(id_pets)
    ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Dogs;
CREATE TABLE Dogs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255),
    BirthDay DATE,
    Commands TEXT,
    id_pets INT,
    FOREIGN KEY (id_pets) REFERENCES Pets(id_pets)
    ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Hamsters;
CREATE TABLE Hamsters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255),
    BirthDay DATE,
    Commands TEXT,
    id_pets INT,
    FOREIGN KEY (id_pets) REFERENCES Pets(id_pets)
    ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Horses;
CREATE TABLE Horses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    BirthDay DATE,
    Commands TEXT,
    id_pack_animals INT,
    FOREIGN KEY (id_pack_animals) REFERENCES PackAnimals(id_pack_animals)
    ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Camels;
CREATE TABLE Camels (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    BirthDay DATE,
    Commands TEXT,
    id_pack_animals INT,
    FOREIGN KEY (id_pack_animals) REFERENCES PackAnimals(id_pack_animals)
    ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Donkeys;
CREATE TABLE Donkeys (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    BirthDay DATE,
    Commands TEXT,
    id_pack_animals INT,
    FOREIGN KEY (id_pack_animals) REFERENCES PackAnimals(id_pack_animals)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Заполнение таблиц данными
INSERT INTO HumanFriends (type_human_friends) 
VALUES ('Pet'), ('PackAnimal');
INSERT INTO Pets (type_pets, id_human_friends) 
VALUES ('Cat', 1), ('Dog', 1), ('Hamster', 1);
INSERT INTO PackAnimals (type_pack_animals, id_human_friends) 
VALUES ('Horse', 2), ('Camel', 2), ('Donkey', 2);

INSERT INTO Cats (name, BirthDay, Commands, id_pets) 
VALUES 
('Smudge', '2020-02-20', 'Sit', 1),
('Oliver', '2020-06-30', 'Meow, Scratch, Jump', 1),
('Whiskers', '2019-05-15', 'Sit, Pounce', 1);

INSERT INTO Dogs (name, BirthDay, Commands, id_pets) 
VALUES 
('Fido', '2020-01-01', 'Sit, Stay, Fetch', 2),
('Buddy', '2018-12-10', 'Sit', 2),
('Bella', '2019-11-11', 'Sit', 2);

INSERT INTO Hamsters (name, BirthDay, Commands, id_pets) 
VALUES 
('Hammy', '2021-03-10', 'Roll, Hide', 3),
('Peanut', '2021-08-01', 'Roll, Spin', 3);

INSERT INTO Horses (name, BirthDay, Commands, id_pack_animals) 
VALUES 
('Thunder', '2015-07-21', 'Trot, Canter, Gallop', 1),
('Storm', '2014-05-05', 'Trot, Canter', 1),
('Blaze', '2016-02-29', 'Trot, Jump, Gallop', 1);

INSERT INTO Camels (name, BirthDay, Commands, id_pack_animals) 
VALUES 
('Sandy', '2016-11-03', 'Walk, Carry Load', 2),
('Dune', '2018-12-12', 'Walk, Sit', 2),
('Sahara', '2015-08-14', 'Walk, Run', 2);

INSERT INTO Donkeys (name, BirthDay, Commands, id_pack_animals) 
VALUES 
('Eeyore', '2017-09-18', 'Walk, Carry Load, Bray', 3),
('Burro', '2019-01-23', 'Walk, Bray, Kick', 3);

SELECT * FROM HumanFriends;
SELECT * FROM Pets;
SELECT * FROM PackAnimals;
SELECT * FROM Cats;
SELECT * FROM Dogs;
SELECT * FROM Hamsters;
SELECT * FROM Horses;
SELECT * FROM Camels;
SELECT * FROM Donkeys;

-- Удаление записей о верблюдах
TRUNCATE TABLE Camels;
SELECT * FROM Camels;

-- Объединение таблиц лошадей и ослов
SELECT id, Name, Birthday, Commands FROM Horses
UNION SELECT  id, Name, Birthday, Commands FROM Donkeys;

-- Создание новой таблицы для животных в возрасте от 1 до 3 лет (с точностью до месяца)
DROP TEMPORARY TABLE IF EXISTS animals;
CREATE TEMPORARY TABLE animals AS 
SELECT *, 'horses' as type FROM Horses
UNION SELECT *, 'donkeys' AS type FROM Donkeys
UNION SELECT *, 'dogs' AS type FROM Dogs
UNION SELECT *, 'cats' AS type FROM Cats
UNION SELECT *, 'hamsters' AS type FROM Hamsters;

DROP TABLE IF EXISTS YoungAnimals;
CREATE TABLE YoungAnimals AS
SELECT id, Name, Birthday, Commands, type, 
TIMESTAMPDIFF(MONTH, Birthday, CURDATE()) AS Age_in_month
FROM animals WHERE Birthday BETWEEN ADDDATE(curdate(), INTERVAL -3 YEAR) AND ADDDATE(CURDATE(), INTERVAL -1 YEAR); 

SELECT * FROM YoungAnimals;

-- Объединение всех созданных таблиц в одну
DROP TABLE IF EXISTS AllAnimals;
CREATE TABLE AllAnimals AS
SELECT id_cats AS id, name, Birthday, Commands, 'Cats' AS type FROM Cats
UNION
SELECT id_dogs AS id, name, Birthday, Commands, 'Dogs' AS type FROM Dogs
UNION
SELECT id_hamsters AS id, name, Birthday, Commands, 'Hamsters' AS type FROM Hamsters
UNION
SELECT id_horses AS id, name, Birthday, Commands, 'Horses' AS type FROM Horses
UNION
SELECT id_donkeys AS id, name, Birthday, Commands, 'Donkeys' AS type FROM Donkeys
UNION
SELECT id AS id, name, Birthday, Commands, type FROM YoungAnimals;

SELECT * FROM AllAnimals;

