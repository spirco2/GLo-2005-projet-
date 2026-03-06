-- Active: 1772587047178@@127.0.0.1@3306@objectif_sport
CREATE TABLE Muscles (
    id          INT PRIMARY KEY AUTO_INCREMENT,
    nom_muscle  VARCHAR(50) NOT NULL UNIQUE,
    categorie      VARCHAR(50) NOT NULL
);

INSERT INTO Muscles (nom_muscle, categorie) VALUES
('Grand dorsal', 'Dos'),
('Trapèzes', 'Dos'),
('Lombaires', 'Dos'),
('Pectoraux supérieurs', 'Poitrine'),
('Pectoraux inférieurs', 'Poitrine'),
('Deltoïdes antérieurs', 'Épaules'),
('Deltoïdes latéraux', 'Épaules'),
('Biceps', 'Bras'),
('Triceps', 'Bras'),
('Avant-bras', 'Bras'),
('Abdominaux', 'Core'),
('Obliques', 'Core'),
('Quadriceps', 'Jambes'),
('Ischio-jambiers', 'Jambes'),
('Fessiers', 'Jambes');
SELECT * FROM Muscles;
