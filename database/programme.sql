
CREATE DATABASE BD_LOCAL;
USE BD_LOCAL;



DROP TABLE IF EXISTS seance;
DROP TABLE IF EXISTS programme;

-- Table Programme : La structure théorique (20 Tuples)
CREATE TABLE programme (
    id_programme INT PRIMARY KEY AUTO_INCREMENT,
    nom_programme VARCHAR(100) NOT NULL,
    description_p TEXT,
    duree_semaines INT
);

-- Table Seance : L'occurrence réelle (50 Tuples)
-- Contient les attributs temporels et de performance
CREATE TABLE seance (
    id_seance INT PRIMARY KEY AUTO_INCREMENT,
    id_user INT NOT NULL, -- FK vers la table User (quand elle sera prête)
    id_programme INT NOT NULL,
    date_debut DATETIME,
    date_fin DATETIME,
    duree TIME,
    volume_total FLOAT DEFAULT 0, -- Sera mis à jour par vos fonctions
    FOREIGN KEY (id_programme) REFERENCES programme(id_programme) ON DELETE CASCADE
);
INSERT INTO programme (id_programme, nom_programme, description_p, duree_semaines) VALUES
(1, 'Full Body Débutant', 'Apprentissage des mouvements polyarticulaires de base.', 8),
(2, 'Split 4 Jours Hypertrophie', 'Isolation musculaire poussée pour gain de masse.', 12),
(3, 'Push Pull Legs (PPL)', 'Organisation par chaîne musculaire pour athlètes intermédiaires.', 10),
(4, 'Upper / Lower Split', 'Alternance haut et bas du corps pour fréquence élevée.', 8),
(5, 'Force Athlétique (SBD)', 'Focus sur le Squat, Bench et Deadlift (Force pure).', 12),
(6, 'Bodyweight Mastery', 'Entraînement complet sans matériel, focus calisthénie.', 6),
(7, 'Cross-Training Blast', 'Mélange de force, cardio et gymnastique.', 4),
(8, 'Powerbuilding', 'Combinaison de force athlétique et d''esthétique.', 10),
(9, 'Spécial Dos & Posture', 'Renforcement de la chaîne postérieure et correction posturale.', 8),
(10, 'Cardio & Abs Shred', 'Haute intensité pour la perte de gras et le core.', 6),
(11, 'Volume Allemand (10x10)', 'Méthode GVT pour briser les plateaux de croissance.', 4),
(12, 'Street Workout Intro', 'Bases des tractions, dips et gainage profond.', 8),
(13, 'Mobilité & Flow', 'Récupération active et amélioration des amplitudes.', 4),
(14, 'Explosivité & Détente', 'Travail de pliométrie pour sportifs de haut niveau.', 6),
(15, 'Préparation Marathon', 'Renforcement spécifique pour coureurs de fond.', 12),
(16, 'Réathlétisation Genoux', 'Protocole post-blessure pour membres inférieurs.', 8),
(17, 'Circuit Training HIIT', 'Enchaînements rapides pour endurance métabolique.', 4),
(18, 'Force Bras & Grip', 'Spécialisation biceps, triceps et force de préhension.', 6),
(19, 'Sénior Fitness', 'Maintien de la masse musculaire et équilibre.', 52),
(20, 'Finisseur Explosif', 'Séances courtes et intenses en fin de cycle.', 2);
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
SELECT * FROM programme ;
SELECT * FROM seance ;




--Pour afficher rapidement la liste des programmes par leur nom
CREATE INDEX idx_programme_nom ON programme(nom_programme);

