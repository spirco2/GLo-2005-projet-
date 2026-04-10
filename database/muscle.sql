-- =============================================
-- Table : Muscles
-- Description : Stocke les groupes musculaires
--               et leur catégorie
-- =============================================
CREATE DATABASE db_local;
DROP TABLE IF EXISTS Muscles;

CREATE TABLE Muscles (
    id_muscle   INT          PRIMARY KEY AUTO_INCREMENT,
    nom_muscle  VARCHAR(50)  NOT NULL UNIQUE,
    categorie   VARCHAR(50)  NOT NULL
);

-- =============================================
-- Insertion des 20 muscles
-- =============================================
INSERT INTO Muscles (nom_muscle, categorie) VALUES
-- Dos
('Grand dorsal',         'Dos'),
('Trapèzes',             'Dos'),
('Lombaires',            'Dos'),
-- Poitrine
('Pectoraux supérieurs', 'Poitrine'),
('Pectoraux inférieurs', 'Poitrine'),
-- Épaules
('Deltoïdes antérieurs', 'Épaules'),
('Deltoïdes latéraux',   'Épaules'),
-- Bras
('Biceps',               'Bras'),
('Triceps',              'Bras'),
('Avant-bras',           'Bras'),
-- Core
('Abdominaux',           'Core'),
('Obliques',             'Core'),
-- Jambes
('Quadriceps',           'Jambes'),
('Ischio-jambiers',      'Jambes'),
('Fessiers',             'Jambes'),
-- Cardio
('Cœur',                 'Cardio'),
('Poumons',              'Cardio'),
-- Full Body
('Full Body',            'Full Body'),
('Full Body Haut',       'Full Body'),
('Full Body Bas',        'Full Body');

-- Vérification
SELECT * FROM Muscles;

CREATE INDEX idx_categorie ON Muscles(categorie);

-- =============================================
-- REQUÊTES AVANCÉES : Muscles
-- =============================================

-- 1. Nombre de muscles par catégorie
SELECT categorie, COUNT(*) AS nb_muscles
FROM Muscles
GROUP BY categorie
ORDER BY nb_muscles DESC;

-- 2. Liste complète triée par catégorie
SELECT categorie, nom_muscle
FROM Muscles
ORDER BY categorie, nom_muscle;

-- 3. Muscles travaillés par un exercice donné (jointure avec exercice)
SELECT e.nom AS exercice, m.nom_muscle, m.categorie
FROM exercice e
JOIN cibler c ON e.id_ex = c.id_ex
JOIN Muscles m ON c.id_muscle = m.id_muscle
WHERE e.id_ex = 10;

-- 4. Catégorie la plus travaillée dans tout le projet
SELECT m.categorie, COUNT(*) AS nb_fois_ciblee
FROM cibler c
JOIN Muscles m ON c.id_muscle = m.id_muscle
GROUP BY m.categorie
ORDER BY nb_fois_ciblee DESC;
