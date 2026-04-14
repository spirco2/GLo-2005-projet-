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
-- =============================================
-- REQUÊTES AVANCÉES (Évaluation GLO-2005)
-- Table : Muscles + jointures avec cibler, exercice
-- =============================================

-- 1. Nombre de muscles par catégorie (agrégation GROUP BY)
SELECT categorie, COUNT(*) AS nb_muscles
FROM Muscles
GROUP BY categorie
ORDER BY nb_muscles DESC;

-- 2. Liste complète triée par catégorie (tri multi-colonnes)
SELECT categorie, nom_muscle
FROM Muscles
ORDER BY categorie, nom_muscle;

-- 3. Muscles travaillés par un exercice donné (jointure 3 tables)
SELECT e.nom AS exercice, m.nom_muscle, m.categorie
FROM exercice e
JOIN cibler c ON e.id_ex = c.id_ex
JOIN Muscles m ON c.id_muscle = m.id_muscle
WHERE e.id_ex = 10;

-- 4. Catégorie la plus travaillée dans tout le projet
--    (agrégation + jointure + tri)
SELECT m.categorie, COUNT(*) AS nb_fois_ciblee
FROM cibler c
JOIN Muscles m ON c.id_muscle = m.id_muscle
GROUP BY m.categorie
ORDER BY nb_fois_ciblee DESC;

-- 5. Muscles jamais ciblés par aucun exercice (sous-requête NOT IN)
SELECT nom_muscle, categorie
FROM Muscles
WHERE id_muscle NOT IN (
    SELECT DISTINCT id_muscle FROM cibler
);

-- 6. Nombre d'exercices par muscle individuel (jointure + agrégation)
SELECT m.nom_muscle,
       m.categorie,
       COUNT(c.id_ex) AS nb_exercices
FROM Muscles m
LEFT JOIN cibler c ON m.id_muscle = c.id_muscle
GROUP BY m.id_muscle
ORDER BY nb_exercices DESC;
SET FOREIGN_KEY_CHECKS = 1;