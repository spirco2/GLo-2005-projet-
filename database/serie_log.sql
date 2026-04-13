-- Active: 1774968533356@@127.0.0.1@3306@objectifs
-- =============================================
-- FICHIER 5/5 : serie_log.sql
-- Ordre d'import : 1. muscle → 2. utilisateur → 3. exercice → 4. programme → 5. serie_log
-- =============================================
SET FOREIGN_KEY_CHECKS = 0;
USE db_local;

DROP TABLE IF EXISTS serie_log;
DROP TABLE IF EXISTS record_personnel;

-- =============================================
-- Table : serie_log
-- =============================================
CREATE TABLE serie_log (
    id          INT PRIMARY KEY AUTO_INCREMENT,
    id_seance   INT            NOT NULL,
    id_ex       INT            NOT NULL,
    poids       DECIMAL(5,2)   NOT NULL,
    reps        INT            NOT NULL CHECK (reps > 0),
    rpe         DECIMAL(3,1)   CHECK (rpe BETWEEN 1.0 AND 10.0),
    type_serie  ENUM('normale','drop','echec','warmup') DEFAULT 'normale',

    CONSTRAINT fk_serielog_seance FOREIGN KEY (id_seance)
        REFERENCES seance(id_seance) ON DELETE CASCADE,
    CONSTRAINT fk_serielog_exercice FOREIGN KEY (id_ex)
        REFERENCES exercice(id_ex) ON DELETE RESTRICT
);

-- =============================================
-- Table : record_personnel
-- =============================================
CREATE TABLE record_personnel (
    id              INT PRIMARY KEY AUTO_INCREMENT,
    id_utilisateur  INT            NOT NULL,
    id_ex           INT            NOT NULL,
    poids_max       DECIMAL(5,2)   NOT NULL,
    date_record     DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE (id_utilisateur, id_ex),

    CONSTRAINT fk_pr_utilisateur FOREIGN KEY (id_utilisateur)
        REFERENCES Utilisateurs(id) ON DELETE CASCADE,
    CONSTRAINT fk_pr_exercice FOREIGN KEY (id_ex)
        REFERENCES exercice(id_ex) ON DELETE CASCADE
);

-- =============================================
-- Trigger : update_pr
-- =============================================
DROP TRIGGER IF EXISTS update_pr;
DELIMITER //
CREATE TRIGGER update_pr
AFTER INSERT ON serie_log
FOR EACH ROW
BEGIN
    DECLARE v_user_id    INT;
    DECLARE v_current_pr DECIMAL(5,2);
    DECLARE v_found      INT DEFAULT 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_found = 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erreur dans update_pr : mise à jour du record personnel échouée.';
    END;

    SELECT id_user INTO v_user_id
    FROM seance
    WHERE id_seance = NEW.id_seance;

    IF v_user_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'update_pr : séance introuvable.';
    END IF;

    SET v_found = 1;

    SELECT poids_max INTO v_current_pr
    FROM record_personnel
    WHERE id_utilisateur = v_user_id
      AND id_ex = NEW.id_ex;

    IF v_found = 0 THEN
        INSERT INTO record_personnel (id_utilisateur, id_ex, poids_max, date_record)
        VALUES (v_user_id, NEW.id_ex, NEW.poids, NOW());
    ELSEIF NEW.poids > v_current_pr THEN
        UPDATE record_personnel
        SET poids_max = NEW.poids, date_record = NOW()
        WHERE id_utilisateur = v_user_id AND id_ex = NEW.id_ex;
    END IF;
END //
DELIMITER ;

-- =============================================
-- Seed : 100 séries
-- =============================================
INSERT INTO serie_log (id_seance, id_ex, poids, reps, rpe, type_serie) VALUES
-- Séance 1 (user 101 · Full Body)
(1,  10, 40.00, 15, 5.0, 'warmup'),
(1,  10, 60.00, 10, 7.0, 'normale'),
(1,  10, 70.00,  8, 8.0, 'normale'),
(1,  75, 80.00, 10, 7.0, 'normale'),
(1,  75, 100.00, 8, 8.0, 'normale'),
(1,  12, 20.00, 12, 6.5, 'normale'),
(1,  12, 25.00, 10, 7.5, 'normale'),

-- Séance 2 (user 101 · Full Body)
(2,  10, 60.00, 10, 6.5, 'warmup'),
(2,  10, 72.50,  6, 8.5, 'normale'),
(2,  56, 40.00, 15, 6.0, 'normale'),
(2,  56, 50.00, 12, 7.5, 'normale'),
(2,  37, 10.00, 15, 6.0, 'normale'),
(2,  37, 12.50, 12, 7.0, 'normale'),

-- Séance 3 (user 102 · Split)
(3,  10, 50.00, 12, 6.0, 'warmup'),
(3,  10, 75.00,  8, 7.5, 'normale'),
(3,  23, 0.00,  10, 6.0, 'normale'),
(3,  45, 50.00, 10, 7.0, 'normale'),
(3,  45, 60.00,  8, 8.5, 'normale'),
(3,  18, 0.00,  12, 6.5, 'normale'),

-- Séance 4 (user 103 · PPL)
(4,  68, 0.00,   8, 7.0, 'normale'),
(4,  66, 50.00, 12, 6.5, 'normale'),
(4,  66, 60.00, 10, 7.5, 'normale'),
(4,  64, 20.00, 12, 7.0, 'normale'),
(4,  64, 25.00, 10, 8.0, 'normale'),
(4,  75, 100.00, 8, 7.5, 'normale'),
(4,  75, 120.00, 5, 9.0, 'normale'),

-- Séance 5 (user 101 · progression)
(5,  10, 70.00,  8, 7.0, 'warmup'),
(5,  10, 80.00,  5, 9.0, 'normale'),
(5,  75, 100.00, 6, 7.5, 'normale'),
(5,  75, 110.00, 4, 9.0, 'normale'),
(5,  12, 25.00, 10, 7.0, 'normale'),
(5,  12, 30.00,  8, 8.5, 'normale'),
(5,  43, 25.00, 12, 7.0, 'normale'),
(5,  43, 30.00, 10, 8.0, 'normale'),

-- Séance 6 (user 104 · Force SBD)
(6,  10, 80.00, 10, 7.0, 'warmup'),
(6,  10, 110.00, 5, 8.5, 'normale'),
(6,  10, 120.00, 3, 9.5, 'normale'),
(6,  75, 140.00, 5, 8.0, 'normale'),
(6,  75, 160.00, 3, 9.5, 'echec'),
(6,   8, 60.00, 10, 7.5, 'normale'),

-- Séance 7 (user 102 · Split jour 2)
(7,  10, 75.00,  8, 7.0, 'warmup'),
(7,  10, 85.00,  5, 8.5, 'normale'),
(7,  45, 60.00,  8, 8.0, 'normale'),
(7,  45, 65.00,  6, 9.0, 'normale'),
(7,  51, 0.00,  15, 6.0, 'normale'),
(7,  51, 0.00,  12, 7.5, 'drop'),
(7,  49, 15.00, 12, 7.0, 'normale'),
(7,  49, 20.00, 10, 8.0, 'normale'),

-- Séance 8 (user 105 · Cross-Training)
(8,  17, 0.00,  15, 7.0, 'normale'),
(8,  91, 0.00,  20, 6.0, 'normale'),
(8,  85, 0.00,  10, 8.0, 'normale'),
(8,  88, 0.00,  30, 6.5, 'normale'),
(8,  84, 0.00,   8, 9.0, 'echec'),
(8,  94, 0.00,  12, 7.5, 'normale'),

-- Séance 9 (user 103 · PPL Push)
(9,  10, 80.00, 10, 7.5, 'warmup'),
(9,  10, 95.00,  5, 9.0, 'normale'),
(9,  35, 25.00, 12, 7.0, 'normale'),
(9,  35, 35.00,  8, 8.5, 'normale'),
(9,   5, 20.00, 12, 7.0, 'normale'),
(9,   5, 25.00, 10, 8.0, 'normale'),
(9,  37, 12.00, 15, 6.5, 'normale'),
(9,  37, 15.00, 12, 7.5, 'normale'),

-- Séance 10 (user 106 · Cardio & Abs)
(10, 28, 0.00,  20, 6.0, 'normale'),
(10, 19, 20.00, 15, 6.5, 'normale'),
(10, 25, 0.00,  12, 7.5, 'normale'),
(10, 30, 0.00,  20, 6.0, 'normale'),
(10, 31, 0.00,   1, 7.0, 'normale'),
(10, 22, 15.00, 15, 7.0, 'normale'),

-- Séance 11 (user 101 · Full Body semaine 3)
(11, 10, 80.00,  5, 8.5, 'normale'),
(11, 10, 85.00,  3, 9.5, 'normale'),
(11, 75, 110.00, 5, 8.5, 'normale'),
(11, 75, 115.00, 3, 9.5, 'echec'),
(11, 56, 55.00, 12, 7.5, 'normale'),
(11, 43, 32.50,  8, 8.5, 'normale'),

-- Séance 12 (user 102 · Split semaine 3)
(12, 10, 85.00,  5, 8.0, 'normale'),
(12, 10, 90.00,  3, 9.0, 'normale'),
(12, 20, 0.00,  12, 6.5, 'normale'),
(12, 18, 0.00,  15, 7.0, 'normale'),
(12, 18, 0.00,  20, 8.5, 'drop'),
(12, 45, 67.50,  5, 9.5, 'normale'),

-- Séance 13 (user 107 · Street Workout)
(13, 68, 0.00,  10, 7.5, 'normale'),
(13, 62, 0.00,  12, 7.0, 'normale'),
(13, 23, 0.00,  15, 7.5, 'normale'),
(13, 46, 0.00,  12, 8.0, 'normale'),
(13, 26, 0.00,  15, 7.0, 'normale'),
(13, 32, 0.00,   8, 8.5, 'normale');

-- Index
CREATE INDEX idx_serielog_seance ON serie_log(id_seance);
CREATE INDEX idx_serielog_ex     ON serie_log(id_ex);
CREATE INDEX idx_pr_user_ex     ON record_personnel(id_utilisateur, id_ex);
CREATE INDEX idx_pr_date        ON record_personnel(date_record);

-- Vérification
SELECT * FROM record_personnel ORDER BY date_record DESC LIMIT 10;
-- =============================================
-- SÉRIES SUPPLÉMENTAIRES (séances 14, 15, 16)
-- Porte le total au-delà de 100 tuples
-- =============================================

INSERT INTO serie_log (id_seance, id_ex, poids, reps, rpe, type_serie) VALUES
-- Séance 14 (user 108 · Préparation Marathon)
(14, 91, 0.00,  30, 6.0, 'normale'),
(14, 98, 0.00,  20, 7.0, 'normale'),
(14, 88, 0.00,  50, 6.5, 'normale'),
(14, 95, 0.00,  20, 7.0, 'normale'),

-- Séance 15 (user 105 · Cross-Training)
(15, 17, 0.00,  12, 7.5, 'normale'),
(15, 85, 0.00,  15, 8.0, 'normale'),
(15, 84, 0.00,  10, 8.5, 'echec'),
(15, 88, 0.00,  40, 6.0, 'normale'),

-- Séance 16 (user 101 · Full Body semaine 4)
(16, 10, 85.00,  5, 8.5, 'normale'),
(16, 10, 90.00,  3, 9.5, 'normale'),
(16, 75, 115.00, 4, 9.0, 'normale'),
(16, 56, 60.00, 10, 7.5, 'normale');


-- =============================================================
-- REQUÊTES AVANCÉES (Évaluation GLO-2005)
-- Tables : serie_log, record_personnel, seance, exercice, Utilisateurs
-- =============================================================

-- 1. Volume total soulevé par utilisateur (agrégation + jointure 3 tables)
SELECT u.pseudo,
       SUM(sl.poids * sl.reps) AS volume_total_kg
FROM serie_log sl
JOIN seance       s ON sl.id_seance = s.id_seance
JOIN Utilisateurs u ON s.id_user    = u.id
GROUP BY u.pseudo
ORDER BY volume_total_kg DESC;

-- 2. Top 5 exercices les plus lourds toutes séances confondues
--    (agrégation MAX + jointure 4 tables)
SELECT u.pseudo,
       e.nom            AS exercice,
       MAX(sl.poids)    AS poids_max_kg
FROM serie_log    sl
JOIN seance        s ON sl.id_seance = s.id_seance
JOIN Utilisateurs  u ON s.id_user    = u.id
JOIN exercice      e ON sl.id_ex     = e.id_ex
WHERE sl.type_serie <> 'warmup'
GROUP BY u.pseudo, e.nom
ORDER BY poids_max_kg DESC
LIMIT 5;

-- 3. Détail complet d'une séance (jointure 6 tables)
SELECT u.pseudo,
       e.nom            AS exercice,
       m.nom_muscle     AS muscle,
       sl.poids,
       sl.reps,
       sl.rpe,
       sl.type_serie
FROM serie_log    sl
JOIN seance        s ON sl.id_seance = s.id_seance
JOIN Utilisateurs  u ON s.id_user    = u.id
JOIN exercice      e ON sl.id_ex     = e.id_ex
JOIN cibler        c ON e.id_ex      = c.id_ex
JOIN Muscles       m ON c.id_muscle  = m.id_muscle
WHERE sl.id_seance = 1
ORDER BY e.nom, m.nom_muscle;

-- 4. Utilisateurs ayant battu un PR au cours des 30 derniers jours
--    (sous-requête avec IN)
SELECT pseudo
FROM Utilisateurs
WHERE id IN (
    SELECT id_utilisateur
    FROM record_personnel
    WHERE date_record >= DATE_SUB(NOW(), INTERVAL 30 DAY)
);

-- 5. Historique complet des PR avec nom exercice et pseudo
--    (jointure 3 tables + tri chronologique)
SELECT u.pseudo,
       e.nom            AS exercice,
       rp.poids_max     AS record_kg,
       rp.date_record
FROM record_personnel rp
JOIN Utilisateurs u ON rp.id_utilisateur = u.id
JOIN exercice     e ON rp.id_ex          = e.id_ex
ORDER BY rp.date_record DESC;

-- 6. Nombre de séries par type pour chaque utilisateur
--    (agrégation GROUP BY double + jointure)
SELECT u.pseudo,
       sl.type_serie,
       COUNT(*)         AS nb_series
FROM serie_log    sl
JOIN seance        s ON sl.id_seance = s.id_seance
JOIN Utilisateurs  u ON s.id_user    = u.id
GROUP BY u.pseudo, sl.type_serie
ORDER BY u.pseudo, nb_series DESC;
SET FOREIGN_KEY_CHECKS = 1;