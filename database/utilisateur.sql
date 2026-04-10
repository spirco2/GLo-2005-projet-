-- =============================================
-- Table : Utilisateurs
-- Description : Stocke les profils utilisateurs
-- =============================================

DROP TABLE IF EXISTS Utilisateurs;

CREATE TABLE Utilisateurs (
    id        INT          PRIMARY KEY AUTO_INCREMENT,
    pseudo    VARCHAR(50)  NOT NULL UNIQUE,
    email     VARCHAR(100) NOT NULL UNIQUE,
    mdp_hash  VARCHAR(255) NOT NULL,
    date      DATE         NOT NULL,
    taille    SMALLINT     NOT NULL CHECK (taille BETWEEN 50 AND 250),
    poids     DECIMAL(5,2) NOT NULL CHECK (poids BETWEEN 20 AND 300),
    sexe      ENUM('homme','femme','autre') NOT NULL,
    imc       DECIMAL(4,2)
) AUTO_INCREMENT = 101;

-- =============================================
-- Insertion des 20 utilisateurs
-- =============================================
INSERT INTO Utilisateurs (pseudo, email, mdp_hash, date, taille, poids, sexe) VALUES
('hachim_tib',      'hachim.tib@gmail.com',      'e3b0c44298fc1c14', '2000-05-14', 175, 72.5,  'homme'),
('melvin_roy',      'melvin.roy@gmail.com',       'a87ff679a2f3e71d', '1999-03-22', 180, 85.0,  'homme'),
('sara_leblanc',    'sara.leblanc@gmail.com',     'eccbc87e4b5ce2fe', '2001-07-10', 165, 60.2,  'femme'),
('alex_martin',     'alex.martin@gmail.com',      'c4ca4238a0b92382', '1998-11-05', 178, 78.3,  'homme'),
('jade_tremblay',   'jade.tremblay@gmail.com',    '1679091c5a880faf', '2002-01-30', 162, 55.8,  'femme'),
('noah_gagnon',     'noah.gagnon@gmail.com',      '8f14e45fceea167a', '2000-08-19', 183, 90.1,  'homme'),
('chloe_fortin',    'chloe.fortin@gmail.com',     'c9f0f895fb98ab91', '1997-04-25', 168, 63.4,  'femme'),
('liam_bouchard',   'liam.bouchard@gmail.com',    '45c48cce2e2d7fbd', '2003-12-03', 176, 74.0,  'homme'),
('emma_lavoie',     'emma.lavoie@gmail.com',      'd3d9446802a44259', '2001-09-17', 160, 52.7,  'femme'),
('ethan_cote',      'ethan.cote@gmail.com',       '6512bd43d9caa6e0', '1999-06-08', 185, 95.5,  'homme'),
('olivia_paquin',   'olivia.paquin@gmail.com',    'c20ad4d76fe97759', '2000-02-14', 163, 57.9,  'femme'),
('gabriel_roy',     'gabriel.roy@gmail.com',      'c51ce410c124a10e', '1998-07-21', 179, 82.0,  'homme'),
('zoe_archambault', 'zoe.archambault@gmail.com',  'aab3238922bcc25a', '2002-10-09', 166, 61.1,  'femme'),
('felix_girard',    'felix.girard@gmail.com',     '9bf31c7ff062936a', '1997-05-30', 182, 88.3,  'homme'),
('lea_chartrand',   'lea.chartrand@gmail.com',    'c74d97b01eae257e', '2003-03-15', 161, 54.6,  'femme'),
('william_lemay',   'william.lemay@gmail.com',    '70efdf2ec9b08693', '2001-11-28', 177, 76.8,  'homme'),
('camille_bisson',  'camille.bisson@gmail.com',   '6f4922f45568161a', '1999-08-04', 167, 62.3,  'femme'),
('thomas_nadeau',   'thomas.nadeau@gmail.com',    '1f0e3dad99908345', '2000-04-11', 181, 86.7,  'homme'),
('anais_dupont',    'anais.dupont@gmail.com',     '98f13708210194c4', '2002-06-22', 164, 58.4,  'femme'),
('samuel_bergeron', 'samuel.bergeron@gmail.com',  '3c59dc048e885024', '1998-09-16', 174, 79.2,  'homme');
 SELECT * FROM Utilisateurs;
-- =============================================
-- Procédure : mettre_a_jour_imc
-- Description : Calcule et stocke l'IMC d'un
--               utilisateur dans son profil
-- Paramètre : p_id (INT) - id de l'utilisateur
-- =============================================
DROP PROCEDURE IF EXISTS imc_de_utilisateur;
DELIMITER $$

CREATE PROCEDURE imc_de_utilisateur(IN p_id INT)
BEGIN
    DECLARE v_poids DECIMAL(5,2);
    DECLARE v_taille INT;
    DECLARE v_imc DECIMAL(4,2);

    -- Vérification que l'utilisateur existe
    IF NOT EXISTS (SELECT 1 FROM Utilisateurs WHERE id = p_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Utilisateur introuvable';
    END IF;

    -- Récupérer poids et taille de l'utilisateur
    SELECT poids, taille INTO v_poids, v_taille
    FROM Utilisateurs
    WHERE id = p_id;

    -- Calcul : poids / (taille en mètres)²
    SET v_imc = v_poids / ((v_taille / 100.0) * (v_taille / 100.0));

    -- Mise à jour du profil utilisateur
    UPDATE Utilisateurs
    SET imc = v_imc
    WHERE id = p_id;
END $$

DELIMITER ;

-- =============================================
-- Test : appel de la procédure + vérification
-- =============================================
CALL imc_de_utilisateur(101);
SELECT pseudo, taille, poids, imc FROM Utilisateurs WHERE id = 101;

-- =============================================
-- Indexation : Utilisateurs
-- email et pseudo sont souvent utilisés pour
-- la connexion et la recherche d'utilisateurs
-- =============================================
CREATE INDEX idx_email  ON Utilisateurs(email);
CREATE INDEX idx_pseudo ON Utilisateurs(pseudo);
CREATE INDEX idx_sexe   ON Utilisateurs(sexe);

-- =============================================
-- REQUÊTES AVANCÉES : Utilisateurs
-- =============================================

-- 1. Répartition des utilisateurs par sexe
SELECT sexe, COUNT(*) AS total
FROM Utilisateurs
GROUP BY sexe;

-- 2. IMC moyen par sexe
SELECT sexe, ROUND(AVG(imc), 2) AS imc_moyen
FROM Utilisateurs
WHERE imc IS NOT NULL
GROUP BY sexe;

-- 3. Utilisateurs avec IMC le plus élevé (sous-requête)
SELECT pseudo, poids, taille, imc
FROM Utilisateurs
WHERE imc = (SELECT MAX(imc) FROM Utilisateurs);

-- 4. Utilisateurs en surpoids (IMC > 25)
SELECT pseudo, imc
FROM Utilisateurs
WHERE imc > 25
ORDER BY imc DESC;

-- 5. Utilisateurs sans IMC calculé
SELECT pseudo, poids, taille
FROM Utilisateurs
WHERE imc IS NULL;