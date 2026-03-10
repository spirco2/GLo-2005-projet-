DROP TABLE IF EXISTS serie_log;
DROP TABLE IF EXISTS record_personnel;


-- =============================================================================
-- TABLE : serie_log
-- Enregistre chaque série effectuée lors d'une séance d'entraînement.
-- =============================================================================
CREATE TABLE serie_log (
    id          INT PRIMARY KEY AUTO_INCREMENT,
    id_seance   INT            NOT NULL,
    id_ex       INT            NOT NULL,
    poids       DECIMAL(5,2)   NOT NULL,
    reps        INT            NOT NULL CHECK (reps > 0),
    rpe         DECIMAL(3,1)   CHECK (rpe BETWEEN 1.0 AND 10.0),
    type_serie  ENUM('normale','drop','echec','warmup') DEFAULT 'normale',

    -- Contraintes d'intégrité référentielle
    CONSTRAINT fk_serielog_seance FOREIGN KEY (id_seance)
        REFERENCES seance(id_seance) ON DELETE CASCADE,

    CONSTRAINT fk_serielog_exercice FOREIGN KEY (id_ex)
        REFERENCES exercice(id_ex) ON DELETE RESTRICT
);


-- =============================================================================
-- TABLE : record_personnel
-- Stocke le record personnel (poids maximum soulevé) par utilisateur et exercice.
-- Mise à jour automatiquement par le trigger update_pr.
-- =============================================================================
CREATE TABLE record_personnel (
    id              INT PRIMARY KEY AUTO_INCREMENT,
    id_utilisateur  INT            NOT NULL,
    id_ex           INT            NOT NULL,
    poids_max       DECIMAL(5,2)   NOT NULL,
    date_record     DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Un seul PR par combinaison utilisateur + exercice
    UNIQUE (id_utilisateur, id_ex),

    CONSTRAINT fk_pr_utilisateur FOREIGN KEY (id_utilisateur)
        REFERENCES utilisateurs(id) ON DELETE CASCADE,

    CONSTRAINT fk_pr_exercice FOREIGN KEY (id_ex)
        REFERENCES exercice(id_ex) ON DELETE CASCADE
);


-- =============================================================================
-- TRIGGER : update_pr
-- Déclenché après chaque INSERT dans serie_log.
-- Vérifie si le poids soulevé dépasse le record personnel existant de
-- l'utilisateur pour cet exercice. Si oui, met à jour le PR. Si aucun PR
-- n'existe encore, en crée un nouveau.
-- Gère les erreurs : annule l'opération si la séance est introuvable.
-- =============================================================================
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

-- TEST update_pr
-- Étape 1 : état avant (aucun PR)
SELECT * FROM record_personnel;

-- Étape 2 : insérer une première série → doit créer un PR
INSERT INTO serie_log (id_seance, id_ex, poids, reps, rpe, type_serie)
VALUES (1, 10, 80.00, 8, 8.0, 'normale');

-- Vérifier que le PR a été créé
SELECT * FROM record_personnel WHERE id_ex = 10;

-- Étape 3 : insérer une série avec poids INFÉRIEUR → aucun changement
INSERT INTO serie_log (id_seance, id_ex, poids, reps, rpe, type_serie)
VALUES (1, 10, 60.00, 10, 7.0, 'normale');

-- Vérifier que le PR n'a PAS changé (doit rester 70.00)
SELECT * FROM record_personnel WHERE id_ex = 10;

-- Étape 4 : insérer une série avec poids SUPÉRIEUR → PR battu
INSERT INTO serie_log (id_seance, id_ex, poids, reps, rpe, type_serie)
VALUES (2, 10, 85.00, 5, 9.0, 'normale');

-- Vérifier que le PR a été mis à jour (doit passer à 85.00)
SELECT * FROM record_personnel WHERE id_ex = 10;


-- =============================================================================
-- SEED : serie_log — 100 tuples
-- =============================================================================

INSERT INTO serie_log (id_seance, id_ex, poids, reps, rpe, type_serie) VALUES

-- Séance 1  (user 101 · programme Full Body Débutant)
(1,  10, 40.00, 15, 5.0, 'warmup'),
(1,  10, 60.00, 10, 7.0, 'normale'),
(1,  10, 70.00,  8, 8.0, 'normale'),
(1,  75, 80.00, 10, 7.0, 'normale'),
(1,  75, 100.00, 8, 8.0, 'normale'),
(1,  12, 20.00, 12, 6.5, 'normale'),
(1,  12, 25.00, 10, 7.5, 'normale'),

-- Séance 2  (user 101 · programme Full Body Débutant)
(2,  10, 60.00, 10, 6.5, 'warmup'),
(2,  10, 72.50,  6, 8.5, 'normale'),
(2,  56, 40.00, 15, 6.0, 'normale'),
(2,  56, 50.00, 12, 7.5, 'normale'),
(2,  37, 10.00, 15, 6.0, 'normale'),
(2,  37, 12.50, 12, 7.0, 'normale'),

-- Séance 3  (user 102 · programme Split 4 Jours)
(3,  10, 50.00, 12, 6.0, 'warmup'),
(3,  10, 75.00,  8, 7.5, 'normale'),
(3,  23, 0.00,  10, 6.0, 'normale'),
(3,  45, 50.00, 10, 7.0, 'normale'),
(3,  45, 60.00,  8, 8.5, 'normale'),
(3,  18, 0.00,  12, 6.5, 'normale'),

-- Séance 4  (user 103 · programme PPL)
(4,  68, 0.00,   8, 7.0, 'normale'),
(4,  66, 50.00, 12, 6.5, 'normale'),
(4,  66, 60.00, 10, 7.5, 'normale'),
(4,  64, 20.00, 12, 7.0, 'normale'),
(4,  64, 25.00, 10, 8.0, 'normale'),
(4,  75, 100.00, 8, 7.5, 'normale'),
(4,  75, 120.00, 5, 9.0, 'normale'),

-- Séance 5  (user 101 · Full Body - progression)
(5,  10, 70.00,  8, 7.0, 'warmup'),
(5,  10, 80.00,  5, 9.0, 'normale'),
(5,  75, 100.00, 6, 7.5, 'normale'),
(5,  75, 110.00, 4, 9.0, 'normale'),
(5,  12, 25.00, 10, 7.0, 'normale'),
(5,  12, 30.00,  8, 8.5, 'normale'),
(5,  43, 25.00, 12, 7.0, 'normale'),
(5,  43, 30.00, 10, 8.0, 'normale'),

-- Séance 6  (user 104 · Force Athlétique SBD)
(6,  10, 80.00, 10, 7.0, 'warmup'),
(6,  10, 110.00, 5, 8.5, 'normale'),
(6,  10, 120.00, 3, 9.5, 'normale'),
(6,  75, 140.00, 5, 8.0, 'normale'),
(6,  75, 160.00, 3, 9.5, 'echec'),
(6,   8, 60.00, 10, 7.5, 'normale'),

-- Séance 7  (user 102 · Split - jour 2)
(7,  10, 75.00,  8, 7.0, 'warmup'),
(7,  10, 85.00,  5, 8.5, 'normale'),
(7,  45, 60.00,  8, 8.0, 'normale'),
(7,  45, 65.00,  6, 9.0, 'normale'),
(7,  51, 0.00,  15, 6.0, 'normale'),
(7,  51, 0.00,  12, 7.5, 'drop'),
(7,  49, 15.00, 12, 7.0, 'normale'),
(7,  49, 20.00, 10, 8.0, 'normale'),

-- Séance 8  (user 105 · Cross-Training)
(8,  17, 0.00,  15, 7.0, 'normale'),
(8,  91, 0.00,  20, 6.0, 'normale'),
(8,  85, 0.00,  10, 8.0, 'normale'),
(8,  88, 0.00,  30, 6.5, 'normale'),
(8,  84, 0.00,   8, 9.0, 'echec'),
(8,  94, 0.00,  12, 7.5, 'normale'),

-- Séance 9  (user 103 · PPL - Push)
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

-- Séance 11 (user 101 · Full Body - semaine 3)
(11, 10, 80.00,  5, 8.5, 'normale'),
(11, 10, 85.00,  3, 9.5, 'normale'),
(11, 75, 110.00, 5, 8.5, 'normale'),
(11, 75, 115.00, 3, 9.5, 'echec'),
(11, 56, 55.00, 12, 7.5, 'normale'),
(11, 43, 32.50,  8, 8.5, 'normale'),

-- Séance 12 (user 102 · Split - semaine 3)
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
