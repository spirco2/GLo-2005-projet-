-- =============================================
-- FICHIER 2/5 : utilisateur.sql
-- Ordre d'import : 1. muscle → 2. utilisateur → 3. exercice → 4. programme → 5. serie_log
-- Mot de passe commun : IronTrack2026
-- =============================================
SET FOREIGN_KEY_CHECKS = 0;
USE db_local;

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
    imc       DECIMAL(5,2)
) AUTO_INCREMENT = 101;

-- =============================================
-- 20 utilisateurs — hash Werkzeug (scrypt)
-- Mot de passe : IronTrack2026
-- =============================================
INSERT INTO Utilisateurs (pseudo, email, mdp_hash, date, taille, poids, sexe) VALUES
('hachim_tib',      'hachim.tib@gmail.com',      'scrypt:32768:8:1$kHXdq3qmr7B7AGEw$2bfc37d40c7c68aa72410e654266bfc8ee43e7c5bf0a67cc75889e17bb69603277c28728c22cc6524c5fb9b9598bdbf06c9f40c924fcdab19e24c64c85b01139', '2000-05-14', 175, 72.50, 'homme'),
('melvin_roy',      'melvin.roy@gmail.com',       'scrypt:32768:8:1$kHXdq3qmr7B7AGEw$2bfc37d40c7c68aa72410e654266bfc8ee43e7c5bf0a67cc75889e17bb69603277c28728c22cc6524c5fb9b9598bdbf06c9f40c924fcdab19e24c64c85b01139', '1999-03-22', 180, 85.00, 'homme'),
('sara_leblanc',    'sara.leblanc@gmail.com',     'scrypt:32768:8:1$kHXdq3qmr7B7AGEw$2bfc37d40c7c68aa72410e654266bfc8ee43e7c5bf0a67cc75889e17bb69603277c28728c22cc6524c5fb9b9598bdbf06c9f40c924fcdab19e24c64c85b01139', '2001-07-10', 165, 60.20, 'femme'),
('alex_martin',     'alex.martin@gmail.com',      'scrypt:32768:8:1$kHXdq3qmr7B7AGEw$2bfc37d40c7c68aa72410e654266bfc8ee43e7c5bf0a67cc75889e17bb69603277c28728c22cc6524c5fb9b9598bdbf06c9f40c924fcdab19e24c64c85b01139', '1998-11-05', 178, 78.30, 'homme'),
('jade_tremblay',   'jade.tremblay@gmail.com',    'scrypt:32768:8:1$kHXdq3qmr7B7AGEw$2bfc37d40c7c68aa72410e654266bfc8ee43e7c5bf0a67cc75889e17bb69603277c28728c22cc6524c5fb9b9598bdbf06c9f40c924fcdab19e24c64c85b01139', '2002-01-30', 162, 55.80, 'femme'),
('noah_gagnon',     'noah.gagnon@gmail.com',      'scrypt:32768:8:1$kHXdq3qmr7B7AGEw$2bfc37d40c7c68aa72410e654266bfc8ee43e7c5bf0a67cc75889e17bb69603277c28728c22cc6524c5fb9b9598bdbf06c9f40c924fcdab19e24c64c85b01139', '2000-08-19', 183, 90.10, 'homme'),
('chloe_fortin',    'chloe.fortin@gmail.com',     'scrypt:32768:8:1$kHXdq3qmr7B7AGEw$2bfc37d40c7c68aa72410e654266bfc8ee43e7c5bf0a67cc75889e17bb69603277c28728c22cc6524c5fb9b9598bdbf06c9f40c924fcdab19e24c64c85b01139', '1997-04-25', 168, 63.40, 'femme'),
('liam_bouchard',   'liam.bouchard@gmail.com',    'scrypt:32768:8:1$kHXdq3qmr7B7AGEw$2bfc37d40c7c68aa72410e654266bfc8ee43e7c5bf0a67cc75889e17bb69603277c28728c22cc6524c5fb9b9598bdbf06c9f40c924fcdab19e24c64c85b01139', '2003-12-03', 176, 74.00, 'homme'),
('emma_lavoie',     'emma.lavoie@gmail.com',      'scrypt:32768:8:1$kHXdq3qmr7B7AGEw$2bfc37d40c7c68aa72410e654266bfc8ee43e7c5bf0a67cc75889e17bb69603277c28728c22cc6524c5fb9b9598bdbf06c9f40c924fcdab19e24c64c85b01139', '2001-09-17', 160, 52.70, 'femme'),
('ethan_cote',      'ethan.cote@gmail.com',       'scrypt:32768:8:1$kHXdq3qmr7B7AGEw$2bfc37d40c7c68aa72410e654266bfc8ee43e7c5bf0a67cc75889e17bb69603277c28728c22cc6524c5fb9b9598bdbf06c9f40c924fcdab19e24c64c85b01139', '1999-06-08', 185, 95.50, 'homme'),
('olivia_paquin',   'olivia.paquin@gmail.com',    'scrypt:32768:8:1$kHXdq3qmr7B7AGEw$2bfc37d40c7c68aa72410e654266bfc8ee43e7c5bf0a67cc75889e17bb69603277c28728c22cc6524c5fb9b9598bdbf06c9f40c924fcdab19e24c64c85b01139', '2000-02-14', 163, 57.90, 'femme'),
('gabriel_roy',     'gabriel.roy@gmail.com',      'scrypt:32768:8:1$kHXdq3qmr7B7AGEw$2bfc37d40c7c68aa72410e654266bfc8ee43e7c5bf0a67cc75889e17bb69603277c28728c22cc6524c5fb9b9598bdbf06c9f40c924fcdab19e24c64c85b01139', '1998-07-21', 179, 82.00, 'homme'),
('zoe_archambault', 'zoe.archambault@gmail.com',  'scrypt:32768:8:1$kHXdq3qmr7B7AGEw$2bfc37d40c7c68aa72410e654266bfc8ee43e7c5bf0a67cc75889e17bb69603277c28728c22cc6524c5fb9b9598bdbf06c9f40c924fcdab19e24c64c85b01139', '2002-10-09', 166, 61.10, 'femme'),
('felix_girard',    'felix.girard@gmail.com',     'scrypt:32768:8:1$kHXdq3qmr7B7AGEw$2bfc37d40c7c68aa72410e654266bfc8ee43e7c5bf0a67cc75889e17bb69603277c28728c22cc6524c5fb9b9598bdbf06c9f40c924fcdab19e24c64c85b01139', '1997-05-30', 182, 88.30, 'homme'),
('lea_chartrand',   'lea.chartrand@gmail.com',    'scrypt:32768:8:1$kHXdq3qmr7B7AGEw$2bfc37d40c7c68aa72410e654266bfc8ee43e7c5bf0a67cc75889e17bb69603277c28728c22cc6524c5fb9b9598bdbf06c9f40c924fcdab19e24c64c85b01139', '2003-03-15', 161, 54.60, 'femme'),
('william_lemay',   'william.lemay@gmail.com',    'scrypt:32768:8:1$kHXdq3qmr7B7AGEw$2bfc37d40c7c68aa72410e654266bfc8ee43e7c5bf0a67cc75889e17bb69603277c28728c22cc6524c5fb9b9598bdbf06c9f40c924fcdab19e24c64c85b01139', '2001-11-28', 177, 76.80, 'homme'),
('camille_bisson',  'camille.bisson@gmail.com',   'scrypt:32768:8:1$kHXdq3qmr7B7AGEw$2bfc37d40c7c68aa72410e654266bfc8ee43e7c5bf0a67cc75889e17bb69603277c28728c22cc6524c5fb9b9598bdbf06c9f40c924fcdab19e24c64c85b01139', '1999-08-04', 167, 62.30, 'femme'),
('thomas_nadeau',   'thomas.nadeau@gmail.com',    'scrypt:32768:8:1$kHXdq3qmr7B7AGEw$2bfc37d40c7c68aa72410e654266bfc8ee43e7c5bf0a67cc75889e17bb69603277c28728c22cc6524c5fb9b9598bdbf06c9f40c924fcdab19e24c64c85b01139', '2000-04-11', 181, 86.70, 'homme'),
('anais_dupont',    'anais.dupont@gmail.com',     'scrypt:32768:8:1$kHXdq3qmr7B7AGEw$2bfc37d40c7c68aa72410e654266bfc8ee43e7c5bf0a67cc75889e17bb69603277c28728c22cc6524c5fb9b9598bdbf06c9f40c924fcdab19e24c64c85b01139', '2002-06-22', 164, 58.40, 'femme'),
('samuel_bergeron', 'samuel.bergeron@gmail.com',  'scrypt:32768:8:1$kHXdq3qmr7B7AGEw$2bfc37d40c7c68aa72410e654266bfc8ee43e7c5bf0a67cc75889e17bb69603277c28728c22cc6524c5fb9b9598bdbf06c9f40c924fcdab19e24c64c85b01139', '1998-09-16', 174, 79.20, 'homme');

-- =============================================
-- Procédure : imc_de_utilisateur
-- =============================================
DROP PROCEDURE IF EXISTS imc_de_utilisateur;
DELIMITER $$
CREATE PROCEDURE imc_de_utilisateur(IN p_id INT)
BEGIN
    DECLARE v_poids DECIMAL(5,2);
    DECLARE v_taille INT;
    DECLARE v_imc DECIMAL(5,2);

    IF NOT EXISTS (SELECT 1 FROM Utilisateurs WHERE id = p_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Utilisateur introuvable';
    END IF;

    SELECT poids, taille INTO v_poids, v_taille
    FROM Utilisateurs WHERE id = p_id;

    SET v_imc = v_poids / ((v_taille / 100.0) * (v_taille / 100.0));

    UPDATE Utilisateurs SET imc = v_imc WHERE id = p_id;
END $$
DELIMITER ;

-- Test
CALL imc_de_utilisateur(101);
SELECT pseudo, taille, poids, imc FROM Utilisateurs WHERE id = 101;

-- Index
CREATE INDEX idx_email  ON Utilisateurs(email);
CREATE INDEX idx_pseudo ON Utilisateurs(pseudo);
CREATE INDEX idx_sexe   ON Utilisateurs(sexe);

SET FOREIGN_KEY_CHECKS = 1;