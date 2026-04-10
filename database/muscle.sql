-- =============================================
-- FICHIER 1/5 : muscle.sql
-- Ordre d'import : 1. muscle → 2. utilisateur → 3. exercice → 4. programme → 5. serie_log
-- =============================================
SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS db_local;
USE db_local;

DROP TABLE IF EXISTS cibler;
DROP TABLE IF EXISTS Muscles;

CREATE TABLE Muscles (
    id_muscle   INT          PRIMARY KEY AUTO_INCREMENT,
    nom_muscle  VARCHAR(50)  NOT NULL UNIQUE,
    categorie   VARCHAR(50)  NOT NULL
);

-- =============================================
-- 20 muscles répartis en 8 catégories
-- =============================================
INSERT INTO Muscles (id_muscle, nom_muscle, categorie) VALUES
(1,  'Grand dorsal',         'Dos'),
(2,  'Trapèzes',             'Dos'),
(3,  'Lombaires',            'Dos'),
(4,  'Pectoraux supérieurs', 'Poitrine'),
(5,  'Pectoraux inférieurs', 'Poitrine'),
(6,  'Deltoïdes antérieurs', 'Épaules'),
(7,  'Deltoïdes latéraux',   'Épaules'),
(8,  'Biceps',               'Bras'),
(9,  'Triceps',              'Bras'),
(10, 'Avant-bras',           'Bras'),
(11, 'Abdominaux',           'Core'),
(12, 'Obliques',             'Core'),
(13, 'Quadriceps',           'Jambes'),
(14, 'Ischio-jambiers',      'Jambes'),
(15, 'Fessiers',             'Jambes'),
(16, 'Mollets',              'Jambes'),
(17, 'Cardio',               'Cardio'),
(18, 'Full Body',            'Full Body'),
(19, 'Adducteurs',           'Jambes'),
(20, 'Abducteurs',           'Jambes');

-- Index
CREATE INDEX idx_categorie ON Muscles(categorie);

-- Vérification
SELECT * FROM Muscles;

SET FOREIGN_KEY_CHECKS = 1;