USE db_local;

DROP TABLE IF EXISTS seance;
DROP TABLE IF EXISTS statistiques_utilisateurs;

-- Table pour suivre l'assiduité des utilisateurs
CREATE TABLE statistiques_utilisateurs (
    id_user               INT PRIMARY KEY,
    semaines_consecutives INT DEFAULT 0,
    CONSTRAINT fk_stats_user FOREIGN KEY (id_user)
        REFERENCES Utilisateurs(id) ON DELETE CASCADE
);

-- Table Seance : occurrences réelles
CREATE TABLE seance (
    id_seance INT PRIMARY KEY AUTO_INCREMENT,
    id_user INT NOT NULL,
    id_programme INT NOT NULL,
    date_debut DATETIME,
    date_fin DATETIME,
    duree TIME,
    volume_total FLOAT DEFAULT 0,
    CONSTRAINT fk_seance_user FOREIGN KEY (id_user)
        REFERENCES Utilisateurs(id) ON DELETE CASCADE,
    CONSTRAINT fk_seance_prog FOREIGN KEY (id_programme)
        REFERENCES programme(id_programme) ON DELETE CASCADE
);

-- Initialisation des utilisateurs présents dans les séances
INSERT INTO statistiques_utilisateurs (id_user, semaines_consecutives) VALUES
(101, 0), (102, 0), (103, 0), (104, 0), (105, 0),
(106, 0), (107, 0), (108, 0), (109, 0), (110, 0);

INSERT INTO seance (id_user, id_programme, date_debut, date_fin, duree, volume_total) VALUES
(101, 1, '2026-01-05 10:00:00', '2026-01-05 11:15:00', '01:15:00', 0),
(101, 1, '2026-01-07 10:00:00', '2026-01-07 11:10:00', '01:10:00', 0),
(102, 2, '2026-01-08 18:30:00', '2026-01-08 20:00:00', '01:30:00', 0),
(103, 3, '2026-01-10 09:00:00', '2026-01-10 10:45:00', '01:45:00', 0),
(101, 1, '2026-01-12 10:00:00', '2026-01-12 11:20:00', '01:20:00', 0),
(104, 5, '2026-01-13 14:00:00', '2026-01-13 16:00:00', '02:00:00', 0),
(102, 2, '2026-01-15 18:00:00', '2026-01-15 19:30:00', '01:30:00', 0),
(105, 7, '2026-01-16 07:00:00', '2026-01-16 07:50:00', '00:50:00', 0),
(103, 3, '2026-01-18 10:00:00', '2026-01-18 11:45:00', '01:45:00', 0),
(106, 10, '2026-01-19 12:15:00', '2026-01-19 13:00:00', '00:45:00', 0),

(101, 1, '2026-01-21 10:00:00', '2026-01-21 11:15:00', '01:15:00', 0),
(102, 2, '2026-01-22 18:00:00', '2026-01-22 19:30:00', '01:30:00', 0),
(107, 12, '2026-01-23 15:00:00', '2026-01-23 16:30:00', '01:30:00', 0),
(108, 15, '2026-01-24 08:00:00', '2026-01-24 10:00:00', '02:00:00', 0),
(105, 7, '2026-01-25 09:00:00', '2026-01-25 09:55:00', '00:55:00', 0),

(101, 1, '2026-01-28 10:00:00', '2026-01-28 11:15:00', '01:15:00', 0),
(102, 2, '2026-01-29 18:00:00', '2026-01-29 19:30:00', '01:30:00', 0),
(109, 18, '2026-01-30 17:00:00', '2026-01-30 18:00:00', '01:00:00', 0),
(110, 20, '2026-01-31 11:00:00', '2026-01-31 11:45:00', '00:45:00', 0),
(101, 1, '2026-02-02 10:00:00', '2026-02-02 11:20:00', '01:20:00', 0),
(102, 2, '2026-02-03 18:00:00', '2026-02-03 19:30:00', '01:30:00', 0),
(103, 3, '2026-02-04 10:00:00', '2026-02-04 11:45:00', '01:45:00', 0),
(104, 5, '2026-02-05 14:00:00', '2026-02-05 16:10:00', '02:10:00', 0),
(105, 7, '2026-02-06 07:00:00', '2026-02-06 08:00:00', '01:00:00', 0),
(106, 10, '2026-02-07 12:15:00', '2026-02-07 13:00:00', '00:45:00', 0),
(107, 12, '2026-02-08 15:00:00', '2026-02-08 16:45:00', '01:45:00', 0),
(108, 15, '2026-02-09 08:00:00', '2026-02-09 10:00:00', '02:00:00', 0),
(109, 18, '2026-02-10 17:00:00', '2026-02-10 18:15:00', '01:15:00', 0),
(110, 20, '2026-02-11 11:00:00', '2026-02-11 11:40:00', '00:40:00', 0),
(101, 2, '2026-02-12 10:00:00', '2026-02-12 11:30:00', '01:30:00', 0),
(102, 3, '2026-02-13 18:00:00', '2026-02-13 19:45:00', '01:45:00', 0),
(103, 4, '2026-02-14 09:00:00', '2026-02-14 10:30:00', '01:30:00', 0),
(104, 6, '2026-02-15 14:00:00', '2026-02-15 15:30:00', '01:30:00', 0),
(105, 8, '2026-02-16 07:00:00', '2026-02-16 08:30:00', '01:30:00', 0),
(106, 11, '2026-02-17 12:15:00', '2026-02-17 13:45:00', '01:30:00', 0),
(107, 13, '2026-02-18 15:00:00', '2026-02-18 16:00:00', '01:00:00', 0),
(108, 16, '2026-02-19 08:00:00', '2026-02-19 09:30:00', '01:30:00', 0),
(109, 19, '2026-02-20 17:00:00', '2026-02-20 18:00:00', '01:00:00', 0),
(110, 4, '2026-02-21 11:00:00', '2026-02-21 12:15:00', '01:15:00', 0),
(101, 5, '2026-02-22 10:00:00', '2026-02-22 12:30:00', '02:30:00', 0),
(102, 6, '2026-02-23 18:00:00', '2026-02-23 19:30:00', '01:30:00', 0),
(103, 7, '2026-02-24 10:00:00', '2026-02-24 11:00:00', '01:00:00', 0),
(104, 8, '2026-02-25 14:00:00', '2026-02-25 15:30:00', '01:30:00', 0),
(105, 9, '2026-02-26 07:00:00', '2026-02-26 08:15:00', '01:15:00', 0),
(106, 12, '2026-02-27 12:15:00', '2026-02-27 13:15:00', '01:00:00', 0),
(107, 14, '2026-02-28 15:00:00', '2026-02-28 16:15:00', '01:15:00', 0),
(108, 17, '2026-03-01 08:00:00', '2026-03-01 09:00:00', '01:00:00', 0),
(109, 20, '2026-03-02 17:00:00', '2026-03-02 17:45:00', '00:45:00', 0),
(110, 1, '2026-03-03 11:00:00', '2026-03-03 12:20:00', '01:20:00', 0),
(101, 3, '2026-03-04 10:00:00', '2026-03-04 11:50:00', '01:50:00', 0);

DELIMITER //

CREATE TRIGGER calcul_assiduite
AFTER INSERT ON seance
FOR EACH ROW
BEGIN
    UPDATE statistiques_utilisateurs
    SET semaines_consecutives = IF(
        EXISTS (
            SELECT 1
            FROM seance
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


-- TEST calcul_assiduite
-- Étape 1 : voir l'état actuel avant le test
SELECT * FROM statistiques_utilisateurs WHERE id_user = 101;

-- Étape 2 : insérer une séance dans la même semaine qu'une séance existante
-- user 101 a déjà une séance le 2026-03-04, donc on insère le 2026-03-05
INSERT INTO seance (id_user, id_programme, date_debut, date_fin, duree, volume_total)
VALUES (101, 1, '2026-03-05 10:00:00', '2026-03-05 11:00:00', '01:00:00', 0);

-- Étape 3 : vérifier que semaines_consecutives a augmenté
SELECT * FROM statistiques_utilisateurs WHERE id_user = 101;

-- Étape 4 : insérer une séance HORS de la fenêtre de 7 jours (gap de plus d'une semaine)
INSERT INTO seance (id_user, id_programme, date_debut, date_fin, duree, volume_total)
VALUES (101, 1, '2026-03-20 10:00:00', '2026-03-20 11:00:00', '01:00:00', 0);

-- Étape 5 : vérifier que semaines_consecutives est remis à 1
SELECT * FROM statistiques_utilisateurs WHERE id_user = 101;


SELECT * FROM seance;
SELECT * FROM statistiques_utilisateurs;