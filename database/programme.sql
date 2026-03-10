CREATE DATABASE IF NOT EXISTS db_local;
USE db_local;

DROP TABLE IF EXISTS seance;
DROP TABLE IF EXISTS statistiques_utilisateurs;
DROP TABLE IF EXISTS programme;

-- Table Programme : structure théorique
CREATE TABLE programme (
    id_programme INT PRIMARY KEY AUTO_INCREMENT,
    nom_programme VARCHAR(100) NOT NULL,
    description_p TEXT,
    duree_semaines INT
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

SELECT * FROM programme;