-- =============================================
-- FICHIER 4/5 : programme.sql
-- Ordre d'import : 1. muscle → 2. utilisateur → 3. exercice → 4. programme → 5. serie_log
-- Inclut : programme, composer, seance, statistiques_utilisateurs, trigger calcul_assiduite
-- =============================================
SET FOREIGN_KEY_CHECKS = 0;
USE db_local;

DROP TABLE IF EXISTS composer;
DROP TABLE IF EXISTS seance;
DROP TABLE IF EXISTS statistiques_utilisateurs;
DROP TABLE IF EXISTS programme;

-- =============================================
-- Table programme (avec id_createur natif)
-- =============================================
CREATE TABLE programme (
    id_programme   INT PRIMARY KEY AUTO_INCREMENT,
    nom_programme  VARCHAR(100) NOT NULL,
    description_p  TEXT,
    duree_semaines INT,
    id_createur    INT NULL,
    CONSTRAINT fk_programme_createur FOREIGN KEY (id_createur)
        REFERENCES Utilisateurs(id) ON DELETE SET NULL
);

INSERT INTO programme (id_programme, nom_programme, description_p, duree_semaines) VALUES
(1,  'Full Body Débutant',          'Apprentissage des mouvements polyarticulaires de base.', 8),
(2,  'Split 4 Jours Hypertrophie',  'Isolation musculaire poussée pour gain de masse.', 12),
(3,  'Push Pull Legs (PPL)',         'Organisation par chaîne musculaire pour athlètes intermédiaires.', 10),
(4,  'Upper / Lower Split',         'Alternance haut et bas du corps pour fréquence élevée.', 8),
(5,  'Force Athlétique (SBD)',       'Focus sur le Squat, Bench et Deadlift (Force pure).', 12),
(6,  'Bodyweight Mastery',           'Entraînement complet sans matériel, focus calisthénie.', 6),
(7,  'Cross-Training Blast',         'Mélange de force, cardio et gymnastique.', 4),
(8,  'Powerbuilding',                'Combinaison de force athlétique et d''esthétique.', 10),
(9,  'Spécial Dos & Posture',        'Renforcement de la chaîne postérieure et correction posturale.', 8),
(10, 'Cardio & Abs Shred',           'Haute intensité pour la perte de gras et le core.', 6),
(11, 'Volume Allemand (10x10)',       'Méthode GVT pour briser les plateaux de croissance.', 4),
(12, 'Street Workout Intro',          'Bases des tractions, dips et gainage profond.', 8),
(13, 'Mobilité & Flow',               'Récupération active et amélioration des amplitudes.', 4),
(14, 'Explosivité & Détente',         'Travail de pliométrie pour sportifs de haut niveau.', 6),
(15, 'Préparation Marathon',           'Renforcement spécifique pour coureurs de fond.', 12),
(16, 'Réathlétisation Genoux',         'Protocole post-blessure pour membres inférieurs.', 8),
(17, 'Circuit Training HIIT',          'Enchaînements rapides pour endurance métabolique.', 4),
(18, 'Force Bras & Grip',              'Spécialisation biceps, triceps et force de préhension.', 6),
(19, 'Sénior Fitness',                 'Maintien de la masse musculaire et équilibre.', 52),
(20, 'Finisseur Explosif',             'Séances courtes et intenses en fin de cycle.', 2);

-- =============================================
-- Table composer (programme ↔ exercice)
-- =============================================
CREATE TABLE composer (
    id_programme INT NOT NULL,
    id_ex        INT NOT NULL,
    ordre        INT DEFAULT 0,
    PRIMARY KEY (id_programme, id_ex),
    CONSTRAINT fk_composer_programme FOREIGN KEY (id_programme)
        REFERENCES programme(id_programme) ON DELETE CASCADE,
    CONSTRAINT fk_composer_exercice FOREIGN KEY (id_ex)
        REFERENCES exercice(id_ex) ON DELETE CASCADE
);

-- Prog 1 : Full Body Débutant
INSERT INTO composer (id_programme, id_ex, ordre) VALUES
(1,10,1),(1,75,2),(1,56,3),(1,35,4),(1,12,5),(1,7,6),(1,28,7);

-- Prog 2 : Split 4 Jours
INSERT INTO composer (id_programme, id_ex, ordre) VALUES
(2,10,1),(2,20,2),(2,18,3),(2,45,4),(2,51,5),(2,66,6),(2,64,7),(2,14,8),(2,56,9),(2,58,10),(2,79,11),(2,37,12);

-- Prog 3 : PPL
INSERT INTO composer (id_programme, id_ex, ordre) VALUES
(3,10,1),(3,35,2),(3,37,3),(3,45,4),(3,68,5),(3,64,6),(3,62,7),(3,43,8),(3,75,9),(3,56,10),(3,59,11),(3,1,12);

-- Prog 4 : Upper / Lower
INSERT INTO composer (id_programme, id_ex, ordre) VALUES
(4,10,1),(4,66,2),(4,35,3),(4,12,4),(4,51,5),(4,75,6),(4,56,7),(4,79,8),(4,1,9);

-- Prog 5 : Force Athlétique
INSERT INTO composer (id_programme, id_ex, ordre) VALUES
(5,10,1),(5,75,2),(5,76,3),(5,8,4),(5,45,5),(5,64,6);

-- Prog 6 : Bodyweight
INSERT INTO composer (id_programme, id_ex, ordre) VALUES
(6,68,1),(6,23,2),(6,46,3),(6,93,4),(6,25,5),(6,6,6),(6,31,7);

-- Prog 7 : Cross-Training
INSERT INTO composer (id_programme, id_ex, ordre) VALUES
(7,17,1),(7,83,2),(7,85,3),(7,88,4),(7,84,5),(7,94,6);

-- Prog 8 : Powerbuilding
INSERT INTO composer (id_programme, id_ex, ordre) VALUES
(8,10,1),(8,75,2),(8,35,3),(8,66,4),(8,14,5),(8,47,6),(8,56,7);

-- Prog 9 : Dos & Posture
INSERT INTO composer (id_programme, id_ex, ordre) VALUES
(9,68,1),(9,66,2),(9,70,3),(9,64,4),(9,41,5),(9,74,6),(9,73,7);

-- Prog 10 : Cardio & Abs
INSERT INTO composer (id_programme, id_ex, ordre) VALUES
(10,91,1),(10,84,2),(10,88,3),(10,28,4),(10,25,5),(10,30,6),(10,22,7);

-- Prog 11 : Volume Allemand
INSERT INTO composer (id_programme, id_ex, ordre) VALUES
(11,10,1),(11,66,2),(11,56,3),(11,58,4),(11,35,5);

-- Prog 12 : Street Workout
INSERT INTO composer (id_programme, id_ex, ordre) VALUES
(12,68,1),(12,62,2),(12,23,3),(12,46,4),(12,26,5),(12,31,6);

-- Prog 14 : Explosivité
INSERT INTO composer (id_programme, id_ex, ordre) VALUES
(14,94,1),(14,17,2),(14,83,3),(14,97,4),(14,6,5);

-- Prog 15 : Marathon
INSERT INTO composer (id_programme, id_ex, ordre) VALUES
(15,91,1),(15,98,2),(15,88,3),(15,95,4),(15,1,5);

-- Prog 16 : Réathlétisation
INSERT INTO composer (id_programme, id_ex, ordre) VALUES
(16,56,1),(16,61,2),(16,60,3),(16,95,4),(16,96,5);

-- Prog 17 : Circuit HIIT
INSERT INTO composer (id_programme, id_ex, ordre) VALUES
(17,17,1),(17,85,2),(17,84,3),(17,94,4),(17,88,5),(17,30,6);

-- Prog 18 : Force Bras
INSERT INTO composer (id_programme, id_ex, ordre) VALUES
(18,2,1),(18,12,2),(18,44,3),(18,45,4),(18,47,5),(18,52,6),(18,54,7);

-- Prog 19 : Sénior
INSERT INTO composer (id_programme, id_ex, ordre) VALUES
(19,87,1),(19,95,2),(19,56,3),(19,74,4),(19,37,5);

-- Prog 20 : Finisseur
INSERT INTO composer (id_programme, id_ex, ordre) VALUES
(20,17,1),(20,85,2),(20,84,3);

-- =============================================
-- statistiques_utilisateurs
-- =============================================
CREATE TABLE statistiques_utilisateurs (
    id_user               INT PRIMARY KEY,
    semaines_consecutives INT DEFAULT 0,
    CONSTRAINT fk_stats_user FOREIGN KEY (id_user)
        REFERENCES Utilisateurs(id) ON DELETE CASCADE
);

INSERT INTO statistiques_utilisateurs (id_user, semaines_consecutives) VALUES
(101,0),(102,0),(103,0),(104,0),(105,0),(106,0),(107,0),(108,0),(109,0),(110,0);

-- =============================================
-- Table seance (volume_total DECIMAL natif)
-- =============================================
CREATE TABLE seance (
    id_seance    INT PRIMARY KEY AUTO_INCREMENT,
    id_user      INT NOT NULL,
    id_programme INT NOT NULL,
    date_debut   DATETIME,
    date_fin     DATETIME,
    duree        TIME,
    volume_total DECIMAL(10,2) DEFAULT 0,
    CONSTRAINT fk_seance_user FOREIGN KEY (id_user)
        REFERENCES Utilisateurs(id) ON DELETE CASCADE,
    CONSTRAINT fk_seance_prog FOREIGN KEY (id_programme)
        REFERENCES programme(id_programme) ON DELETE CASCADE
);

INSERT INTO seance (id_user, id_programme, date_debut, date_fin, duree, volume_total) VALUES
(101, 1,  '2026-01-05 10:00:00', '2026-01-05 11:15:00', '01:15:00', 0),
(101, 1,  '2026-01-07 10:00:00', '2026-01-07 11:10:00', '01:10:00', 0),
(102, 2,  '2026-01-08 18:30:00', '2026-01-08 20:00:00', '01:30:00', 0),
(103, 3,  '2026-01-10 09:00:00', '2026-01-10 10:45:00', '01:45:00', 0),
(101, 1,  '2026-01-12 10:00:00', '2026-01-12 11:20:00', '01:20:00', 0),
(104, 5,  '2026-01-13 14:00:00', '2026-01-13 16:00:00', '02:00:00', 0),
(102, 2,  '2026-01-15 18:00:00', '2026-01-15 19:30:00', '01:30:00', 0),
(105, 7,  '2026-01-16 07:00:00', '2026-01-16 07:50:00', '00:50:00', 0),
(103, 3,  '2026-01-18 10:00:00', '2026-01-18 11:45:00', '01:45:00', 0),
(106, 10, '2026-01-19 12:15:00', '2026-01-19 13:00:00', '00:45:00', 0),
(101, 1,  '2026-01-21 10:00:00', '2026-01-21 11:15:00', '01:15:00', 0),
(102, 2,  '2026-01-22 18:00:00', '2026-01-22 19:30:00', '01:30:00', 0),
(107, 12, '2026-01-23 15:00:00', '2026-01-23 16:30:00', '01:30:00', 0),
(108, 15, '2026-01-24 08:00:00', '2026-01-24 10:00:00', '02:00:00', 0),
(105, 7,  '2026-01-25 09:00:00', '2026-01-25 09:55:00', '00:55:00', 0),
(101, 1,  '2026-01-28 10:00:00', '2026-01-28 11:15:00', '01:15:00', 0),
(102, 2,  '2026-01-29 18:00:00', '2026-01-29 19:30:00', '01:30:00', 0),
(109, 18, '2026-01-30 17:00:00', '2026-01-30 18:00:00', '01:00:00', 0),
(110, 20, '2026-01-31 11:00:00', '2026-01-31 11:45:00', '00:45:00', 0),
(101, 1,  '2026-02-02 10:00:00', '2026-02-02 11:20:00', '01:20:00', 0),
(102, 2,  '2026-02-03 18:00:00', '2026-02-03 19:30:00', '01:30:00', 0),
(103, 3,  '2026-02-04 10:00:00', '2026-02-04 11:45:00', '01:45:00', 0),
(104, 5,  '2026-02-05 14:00:00', '2026-02-05 16:10:00', '02:10:00', 0),
(105, 7,  '2026-02-06 07:00:00', '2026-02-06 08:00:00', '01:00:00', 0),
(106, 10, '2026-02-07 12:15:00', '2026-02-07 13:00:00', '00:45:00', 0),
(107, 12, '2026-02-08 15:00:00', '2026-02-08 16:45:00', '01:45:00', 0),
(108, 15, '2026-02-09 08:00:00', '2026-02-09 10:00:00', '02:00:00', 0),
(109, 18, '2026-02-10 17:00:00', '2026-02-10 18:15:00', '01:15:00', 0),
(110, 20, '2026-02-11 11:00:00', '2026-02-11 11:40:00', '00:40:00', 0),
(101, 2,  '2026-02-12 10:00:00', '2026-02-12 11:30:00', '01:30:00', 0),
(102, 3,  '2026-02-13 18:00:00', '2026-02-13 19:45:00', '01:45:00', 0),
(103, 4,  '2026-02-14 09:00:00', '2026-02-14 10:30:00', '01:30:00', 0),
(104, 6,  '2026-02-15 14:00:00', '2026-02-15 15:30:00', '01:30:00', 0),
(105, 8,  '2026-02-16 07:00:00', '2026-02-16 08:30:00', '01:30:00', 0),
(106, 11, '2026-02-17 12:15:00', '2026-02-17 13:45:00', '01:30:00', 0),
(107, 13, '2026-02-18 15:00:00', '2026-02-18 16:00:00', '01:00:00', 0),
(108, 16, '2026-02-19 08:00:00', '2026-02-19 09:30:00', '01:30:00', 0),
(109, 19, '2026-02-20 17:00:00', '2026-02-20 18:00:00', '01:00:00', 0),
(110, 4,  '2026-02-21 11:00:00', '2026-02-21 12:15:00', '01:15:00', 0),
(101, 5,  '2026-02-22 10:00:00', '2026-02-22 12:30:00', '02:30:00', 0),
(102, 6,  '2026-02-23 18:00:00', '2026-02-23 19:30:00', '01:30:00', 0),
(103, 7,  '2026-02-24 10:00:00', '2026-02-24 11:00:00', '01:00:00', 0),
(104, 8,  '2026-02-25 14:00:00', '2026-02-25 15:30:00', '01:30:00', 0),
(105, 9,  '2026-02-26 07:00:00', '2026-02-26 08:15:00', '01:15:00', 0),
(106, 12, '2026-02-27 12:15:00', '2026-02-27 13:15:00', '01:00:00', 0),
(107, 14, '2026-02-28 15:00:00', '2026-02-28 16:15:00', '01:15:00', 0),
(108, 17, '2026-03-01 08:00:00', '2026-03-01 09:00:00', '01:00:00', 0),
(109, 20, '2026-03-02 17:00:00', '2026-03-02 17:45:00', '00:45:00', 0),
(110, 1,  '2026-03-03 11:00:00', '2026-03-03 12:20:00', '01:20:00', 0),
(101, 3,  '2026-03-04 10:00:00', '2026-03-04 11:50:00', '01:50:00', 0);

-- =============================================
-- Trigger : calcul_assiduite
-- =============================================
DELIMITER //
CREATE TRIGGER calcul_assiduite
AFTER INSERT ON seance
FOR EACH ROW
BEGIN
    UPDATE statistiques_utilisateurs
    SET semaines_consecutives = IF(
        EXISTS (
            SELECT 1 FROM seance
            WHERE id_user = NEW.id_user
              AND id_seance <> NEW.id_seance
              AND date_debut >= DATE_SUB(NEW.date_debut, INTERVAL 7 DAY)
              AND date_debut < NEW.date_debut
        ),
        semaines_consecutives + 1,
        1
    )
    WHERE id_user = NEW.id_user;
END //
DELIMITER ;

-- Index
CREATE INDEX idx_nom_programme    ON programme(nom_programme);
CREATE INDEX idx_composer_prog    ON composer(id_programme);
CREATE INDEX idx_composer_ex      ON composer(id_ex);
CREATE INDEX idx_seance_user_date ON seance(id_user, date_debut);
CREATE INDEX idx_seance_programme ON seance(id_programme);
CREATE INDEX idx_seance_date_only ON seance(date_debut);

-- Vérification
SELECT p.nom_programme, COUNT(c.id_ex) AS nb_exercices
FROM programme p
LEFT JOIN composer c ON p.id_programme = c.id_programme
GROUP BY p.id_programme
ORDER BY p.id_programme;

SET FOREIGN_KEY_CHECKS = 1;