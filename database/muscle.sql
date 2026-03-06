-- =============================================
-- Table : Muscles
-- Description : Stocke les groupes musculaires
--               et leur catégorie
-- =============================================

CREATE TABLE Muscles (
    id          INT          PRIMARY KEY AUTO_INCREMENT,
    nom_muscle  VARCHAR(50)  NOT NULL UNIQUE,
    categorie   VARCHAR(50)  NOT NULL
);
DROP TABLE IF EXISTS Muscles;
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