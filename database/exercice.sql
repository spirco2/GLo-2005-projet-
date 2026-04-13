-- Active: 1774968533356@@127.0.0.1@3306@objectifs
-- =============================================
-- FICHIER 3/5 : exercice.sql
-- Ordre d'import : 1. muscle → 2. utilisateur → 3. exercice → 4. programme → 5. serie_log
-- Associations musculaires corrigées
-- =============================================
SET FOREIGN_KEY_CHECKS = 0;
USE db_local;

DROP TABLE IF EXISTS cibler;
DROP TABLE IF EXISTS exercice;

CREATE TABLE exercice (
    id_ex       INT PRIMARY KEY AUTO_INCREMENT,
    nom         VARCHAR(255) NOT NULL,
    equipement  VARCHAR(100),
    description TEXT,
    difficulte  VARCHAR(50)
);

CREATE TABLE cibler (
    id_ex    INT,
    id_muscle INT,
    PRIMARY KEY (id_ex, id_muscle),
    CONSTRAINT fk_cibler_exercice FOREIGN KEY (id_ex)
        REFERENCES exercice(id_ex)   ON DELETE CASCADE,
    CONSTRAINT fk_cibler_muscle   FOREIGN KEY (id_muscle)
        REFERENCES Muscles(id_muscle) ON DELETE CASCADE
);

-- =============================================
-- 100 exercices
-- =============================================
INSERT INTO exercice (id_ex, nom, equipement, description, difficulte) VALUES
(1,  'Extension mollets debout (Haltère)', 'Haltère',        'Élevez-vous sur la pointe des pieds en tenant des haltères.', 'Intermédiaire'),
(2,  'Curl Biceps 21',                     'Barre',          '7 reps partielles bas, 7 haut, puis 7 complètes.', 'Avancé'),
(3,  'Ciseaux abdominaux',                 'Aucun',          'Allongé, croisez alternativement vos jambes tendues.', 'Débutant'),
(4,  'Roue abdominale',                    'Autres',         'Roulez vers l''avant en gainage total puis revenez.', 'Avancé'),
(5,  'Arnold Press',                       'Haltère',        'Développé épaules avec rotation des paumes.', 'Intermédiaire'),
(6,  'Squat pistolet assisté',             'Aucun',          'Squat sur une seule jambe avec appui.', 'Avancé'),
(7,  'Hyperextension 45°',                'Machine',        'Extension du buste pour renforcer les lombaires.', 'Débutant'),
(8,  'Good Morning (Barre)',               'Barre',          'Penchez le buste en avant avec barre sur les épaules.', 'Intermédiaire'),
(9,  'Curl derrière le dos (Câble)',       'Machine',        'Tirage poulie basse, coudes en arrière du buste.', 'Intermédiaire'),
(10, 'Développé couché (Barre)',           'Barre',          'Poussez la barre au-dessus de la poitrine.', 'Débutant'),
(11, 'Développé couché (Smith)',           'Machine',        'Développé sur banc avec barre guidée.', 'Débutant'),
(12, 'Curl biceps (Barre)',                'Barre',          'Flexion classique des coudes debout.', 'Débutant'),
(13, 'Curl biceps (Câble)',                'Machine',        'Flexion des bras à la poulie basse.', 'Débutant'),
(14, 'Curl biceps (Haltères)',             'Haltère',        'Flexion alternée des bras avec haltères.', 'Débutant'),
(15, 'Curl biceps (Machine)',              'Machine',        'Flexion des bras sur machine guidée.', 'Débutant'),
(16, 'Squat fendu bulgare',                'Haltère',        'Fente avec le pied arrière surélevé.', 'Intermédiaire'),
(17, 'Burpee classique',                   'Aucun',          'Enchaînement squat, pompe et saut.', 'Avancé'),
(18, 'Pec Deck',                           'Machine',        'Rapprochement des bras pour isoler les pectoraux.', 'Débutant'),
(19, 'Crunch à la poulie',                 'Machine',        'Enroulement du buste avec corde poulie haute.', 'Intermédiaire'),
(20, 'Écartés poulie haute',               'Machine',        'Croisement des mains devant le bassin.', 'Intermédiaire'),
(21, 'Pull-through',                       'Machine',        'Extension de hanche dos à la machine.', 'Intermédiaire'),
(22, 'Woodchopper (Câble)',                'Machine',        'Rotation diagonale du buste pour les obliques.', 'Intermédiaire'),
(23, 'Dips larges',                        'Poids de corps',  'Flexions sur barres parallèles, buste penché.', 'Intermédiaire'),
(24, 'Dips assistés',                      'Machine',        'Dips avec aide au contrepoids.', 'Débutant'),
(25, 'Relevé de jambes suspendu',          'Aucun',          'Levez vos jambes tendues suspendu à la barre.', 'Avancé'),
(26, 'Élévation genoux suspendu',          'Aucun',          'Ramenez les genoux vers la poitrine suspendu.', 'Intermédiaire'),
(27, 'Relevé de jambes (Chaise romaine)',  'Machine',        'En appui sur les coudes, levez les jambes.', 'Débutant'),
(28, 'Crunch vélo',                        'Aucun',          'Rotation buste coude-genou opposé.', 'Débutant'),
(29, 'Flexion latérale haltère',           'Haltère',        'Inclinaison latérale du buste avec poids.', 'Débutant'),
(30, 'Russian Twist (Corps)',              'Aucun',          'Rotations du buste assis au sol.', 'Intermédiaire'),
(31, 'Planche latérale',                   'Aucun',          'Maintien aligné sur un seul avant-bras.', 'Débutant'),
(32, 'Windshield Wipers',                  'Barre',          'Rotation des jambes suspendu à la barre.', 'Avancé'),
(33, 'Twist russe (Pondéré)',              'Haltère',        'Rotations du buste avec charge.', 'Intermédiaire'),
(34, 'Gainage oblique (Côté)',             'Aucun',          'Statique sur le côté, hanches levées.', 'Débutant'),
(35, 'Développé militaire',                'Haltère',        'Poussez les haltères au-dessus de la tête.', 'Intermédiaire'),
(36, 'Élévation latérale machine',         'Machine',        'Élevez les bras latéralement sur machine.', 'Débutant'),
(37, 'Élévation latérale haltères',        'Haltère',        'Levez les bras latéralement debout.', 'Débutant'),
(38, 'Arnold Press assis',                 'Haltère',        'Développé épaules avec rotation, assis.', 'Intermédiaire'),
(39, 'Élévation latérale assise',          'Haltère',        'Isolation épaules sans élan.', 'Intermédiaire'),
(40, 'Élévation latérale poulie',          'Machine',        'Tirage unilatéral à la poulie basse.', 'Intermédiaire'),
(41, 'Face Pull (Corde)',                  'Machine',        'Tirage corde vers le front, coudes ouverts.', 'Intermédiaire'),
(42, 'D. Militaire Smith Machine',         'Machine',        'Développé épaules guidé.', 'Débutant'),
(43, 'EZ Bar Curl',                        'Barre',          'Curl avec barre cambrée.', 'Débutant'),
(44, 'Curl Concentration',                 'Haltère',        'Assis, coude calé contre l''intérieur de la cuisse.', 'Débutant'),
(45, 'Développé couché serré',             'Barre',          'Mains rapprochées pour cibler les triceps.', 'Intermédiaire'),
(46, 'Pompe diamant',                      'Aucun',          'Pompe avec mains jointes en triangle.', 'Avancé'),
(47, 'Extension triceps poulie',           'Machine',        'Extension bras au-dessus de la tête.', 'Intermédiaire'),
(48, 'Dips machine assis',                 'Machine',        'Poussez les poignées vers le bas.', 'Débutant'),
(49, 'Extension triceps haltère',          'Haltère',        'Extension derrière la tête à deux mains.', 'Débutant'),
(50, 'Dips assistés triceps',              'Machine',        'Buste vertical pour focus triceps.', 'Débutant'),
(51, 'Triceps Pressdown',                  'Machine',        'Poussez la barre vers le bas poulie haute.', 'Débutant'),
(52, 'Curl poignet (Barre)',               'Barre',          'Barre dans le dos, flexion des poignets.', 'Intermédiaire'),
(53, 'Curl poignet (Haltères)',            'Haltère',        'Enroulez vos poignets, avant-bras sur banc.', 'Débutant'),
(54, 'Wrist Roller',                       'Autres',         'Enroulez une corde lestée par rotation.', 'Intermédiaire'),
(55, 'Fente latérale corps',               'Aucun',          'Pas latéral et flexion d''une jambe.', 'Débutant'),
(56, 'Leg Extension',                      'Machine',        'Extension des jambes assis.', 'Débutant'),
(57, 'Fente inversée barre',               'Barre',          'Pas arrière et flexion genou.', 'Intermédiaire'),
(58, 'SDT Roumain Barre',                  'Barre',          'Extension hanche, jambes semi-tendues.', 'Intermédiaire'),
(59, 'SDT Roumain Haltères',               'Haltère',        'SDT roumain avec haltères.', 'Intermédiaire'),
(60, 'Abducteurs machine',                 'Machine',        'Écartez les jambes vers l''extérieur.', 'Débutant'),
(61, 'Adducteurs machine',                 'Machine',        'Resserrez les jambes vers l''intérieur.', 'Débutant'),
(62, 'Chin Up (Traction)',                 'Aucun',          'Traction paumes face à vous.', 'Intermédiaire'),
(63, 'Chin Up assisté',                    'Machine',        'Traction supination avec contrepoids.', 'Débutant'),
(64, 'Rowing bûcheron',                    'Haltère',        'Tirage unilatéral en appui sur banc.', 'Intermédiaire'),
(65, 'Tirage poitrine bande',              'Autres',         'Tirage vertical à genoux avec élastique.', 'Débutant'),
(66, 'Tirage poitrine poulie',             'Machine',        'Tirage vertical assis barre longue.', 'Débutant'),
(67, 'Traction négative',                  'Aucun',          'Contrôlez uniquement la descente lente.', 'Intermédiaire'),
(68, 'Traction classique',                 'Aucun',          'Traction prise large en pronation.', 'Avancé'),
(69, 'Traction prise large',               'Aucun',          'Traction mains très écartées.', 'Avancé'),
(70, 'Rowing assis large',                 'Machine',        'Tirage horizontal avec barre coudée.', 'Intermédiaire'),
(71, 'Rowing assis V-Grip',                'Machine',        'Tirage horizontal poignée serrée.', 'Débutant'),
(72, 'Rowing unilatéral poulie',           'Machine',        'Tirage horizontal d''un seul bras.', 'Intermédiaire'),
(73, 'Superman Hold',                      'Aucun',          'Maintenez bras et jambes décollés au sol.', 'Débutant'),
(74, 'Banc à lombaires',                   'Machine',        'Extensions du dos sur support.', 'Débutant'),
(75, 'Soulevé de terre',                   'Barre',          'Levage de barre du sol aux hanches.', 'Avancé'),
(76, 'Trap Bar Deadlift',                  'Barre',          'SDT avec barre hexagonale.', 'Intermédiaire'),
(77, 'Frog Pumps',                         'Aucun',          'Relevé de bassin, pieds joints au sol.', 'Débutant'),
(78, 'Élévation latérale jambe',           'Aucun',          'Levez la jambe latéralement debout.', 'Débutant'),
(79, 'Hip Thrust Machine',                 'Machine',        'Extension hanche barre guidée.', 'Intermédiaire'),
(80, 'Front Lever Hold',                   'Aucun',          'Maintien horizontal suspendu.', 'Expert'),
(81, 'Front Lever Raise',                  'Aucun',          'Montée en planche suspendue.', 'Expert'),
(82, 'Muscle Up',                          'Aucun',          'Traction suivie d''un dip sur barre.', 'Expert'),
(83, 'Wall Ball',                          'Autres',         'Squat et lancer de medecine ball.', 'Intermédiaire'),
(84, 'Air Bike (Assault)',                 'Machine',        'Poussez et pédalez simultanément.', 'Intermédiaire'),
(85, 'Battle Ropes',                       'Autres',         'Ondulations de cordes lourdes au sol.', 'Intermédiaire'),
(86, 'Boxe (Sac de frappe)',               'Autres',         'Frappes de poings continues.', 'Débutant'),
(87, 'Vélo elliptique',                    'Machine',        'Simulateur de course sans impact.', 'Débutant'),
(88, 'Corde à sauter',                     'Autres',         'Sauts rapides pour le rythme cardiaque.', 'Débutant'),
(89, 'Rameur Concept2',                    'Machine',        'Tirage complet assis.', 'Intermédiaire'),
(90, 'Spinning',                           'Machine',        'Cyclisme haute intensité.', 'Intermédiaire'),
(91, 'Course sur tapis',                   'Machine',        'Course à pied sur tapis roulant.', 'Débutant'),
(92, 'HSPU (Handstand)',                   'Aucun',          'Pompe en équilibre contre mur.', 'Expert'),
(93, 'Pike Pushup',                        'Aucun',          'Pompe épaules, hanches levées.', 'Intermédiaire'),
(94, 'Fente sautée',                       'Aucun',          'Fente avec saut explosif alterné.', 'Avancé'),
(95, 'Fente marchée',                      'Aucun',          'Pas en fente sur une distance.', 'Débutant'),
(96, 'Extension mollet 1 jambe',           'Aucun',          'Élévation sur une pointe de pied.', 'Débutant'),
(97, 'Burpee over barbell',                'Barre',          'Burpee et saut latéral par-dessus barre.', 'Avancé'),
(98, 'Stairmaster',                        'Machine',        'Montée de marches mécanique.', 'Intermédiaire'),
(99, 'Shrugs (Haltères)',                  'Haltère',        'Haussez les épaules vers les oreilles.', 'Débutant'),
(100,'Tirage menton (Barre)',              'Barre',          'Tirez la barre vers le menton.', 'Intermédiaire');

-- =============================================
-- Table de liaison CORRIGÉE : cibler
-- Mapping : id_muscle réf. → muscle.sql
--   1=Grand dorsal, 2=Trapèzes, 3=Lombaires,
--   4=Pectoraux sup, 5=Pectoraux inf, 6=Deltoïdes ant, 7=Deltoïdes lat,
--   8=Biceps, 9=Triceps, 10=Avant-bras, 11=Abdominaux, 12=Obliques,
--   13=Quadriceps, 14=Ischio-jambiers, 15=Fessiers, 16=Mollets,
--   17=Cardio, 18=Full Body, 19=Adducteurs, 20=Abducteurs
-- =============================================
INSERT INTO cibler (id_ex, id_muscle) VALUES
-- Mollets
(1, 16),
-- Biceps
(2, 8),
-- Core
(3, 11), (3, 12),
(4, 11),
-- Épaules (Arnold Press → Deltoïdes ant + lat)
(5, 6), (5, 7),
-- Jambes
(6, 13), (6, 15),
-- Lombaires
(7, 3),
(8, 3), (8, 14),
-- Biceps
(9, 8),
-- Développé couché → Pectoraux sup + Triceps (CORRIGÉ)
(10, 4), (10, 9),
(11, 4), (11, 9),
-- Curls biceps
(12, 8), (13, 8), (14, 8), (15, 8),
-- Squat bulgare
(16, 13), (16, 15),
-- Burpee
(17, 18),
-- Pec Deck → Pectoraux sup + inf (CORRIGÉ)
(18, 4), (18, 5),
-- Core
(19, 11),
-- Écartés → Pectoraux sup + inf (CORRIGÉ)
(20, 4), (20, 5),
-- Pull-through
(21, 15), (21, 14),
-- Woodchopper
(22, 12),
-- Dips larges → Pectoraux + Triceps (CORRIGÉ)
(23, 4), (23, 9),
(24, 4), (24, 9),
-- Core suspendu
(25, 11), (26, 11), (27, 11),
(28, 11), (28, 12),
(29, 12), (30, 12), (31, 12), (32, 12), (33, 12), (34, 12),
-- Épaules (Développé militaire → Deltoïdes ant + Triceps)
(35, 6), (35, 9),
(36, 7), (37, 7),
(38, 6), (38, 7),
(39, 7), (40, 7),
-- Face Pull → Deltoïdes lat + Trapèzes (CORRIGÉ)
(41, 7), (41, 2),
-- D. Militaire Smith → Deltoïdes ant + Triceps
(42, 6), (42, 9),
-- Curls
(43, 8), (44, 8),
-- Développé serré → Triceps + Pectoraux sup (CORRIGÉ)
(45, 9), (45, 4),
(46, 9), (46, 4),
-- Triceps isolation
(47, 9), (48, 9), (49, 9), (50, 9), (51, 9),
-- Avant-bras
(52, 10), (53, 10), (54, 10),
-- Fente latérale
(55, 13), (55, 15), (55, 19),
-- Leg Extension
(56, 13),
-- Fente inversée
(57, 13), (57, 15),
-- SDT Roumain
(58, 14), (58, 3),
(59, 14), (59, 15),
-- Abducteurs / Adducteurs
(60, 20),
(61, 19),
-- Tractions et Chin Ups → Dos + Biceps (CORRIGÉ)
(62, 1), (62, 8),
(63, 1), (63, 8),
(64, 1), (64, 8),
-- Tirages dos
(65, 1),
(66, 1), (66, 8),
(67, 1),
(68, 1), (68, 7),
(69, 1), (69, 7),
-- Rowing
(70, 1), (70, 2),
(71, 1),
(72, 1),
-- Lombaires
(73, 3), (74, 3),
-- Soulevé de terre → Ischio + Fessiers + Lombaires (CORRIGÉ)
(75, 15), (75, 14), (75, 3),
(76, 13), (76, 15),
-- Fessiers
(77, 15),
-- Abducteurs
(78, 20),
-- Hip Thrust
(79, 15),
-- Full Body avancé
(80, 18), (81, 18), (82, 18),
-- Cross-Training
(83, 18),
-- Cardio
(84, 17), (85, 17), (86, 17), (87, 17), (88, 17),
(89, 17), (89, 1),
(90, 17), (91, 17),
-- Épaules avancé
(92, 6), (92, 9),
(93, 6),
-- Jambes explosif
(94, 13), (94, 17),
(95, 13), (95, 15),
-- Mollets
(96, 16),
-- Full Body explosif
(97, 18),
-- Cardio
(98, 17),
-- Trapèzes
(99, 2),
(100, 2), (100, 6);

-- =============================================
-- Procédure : calculer_volume_seance
-- =============================================
DROP PROCEDURE IF EXISTS calculer_volume_seance;
DELIMITER //
CREATE PROCEDURE calculer_volume_seance(IN p_id_seance INT)
BEGIN
    UPDATE seance s
    SET s.volume_total = (
        SELECT COALESCE(SUM(
            CASE
                WHEN e.equipement IN ('Aucun', 'Poids de corps') THEN (u.poids + sl.poids) * sl.reps
                ELSE sl.poids * sl.reps
            END
        ), 0)
        FROM serie_log sl
        JOIN exercice e ON sl.id_ex = e.id_ex
        JOIN Utilisateurs u ON s.id_user = u.id
        WHERE sl.id_seance = p_id_seance
    )
    WHERE s.id_seance = p_id_seance;
END //
DELIMITER ;

-- Index
CREATE INDEX idx_exercice_equipement ON exercice(equipement);
CREATE INDEX idx_exercice_nom        ON exercice(nom);
CREATE INDEX idx_exercice_difficulte ON exercice(difficulte);
CREATE INDEX idx_cibler_muscle       ON cibler(id_muscle);

-- Vérification
SELECT e.nom, GROUP_CONCAT(m.nom_muscle SEPARATOR ', ') AS muscles
FROM exercice e
JOIN cibler c ON e.id_ex = c.id_ex
JOIN Muscles m ON c.id_muscle = m.id_muscle
WHERE e.id_ex IN (10, 23, 45, 62, 75)
GROUP BY e.id_ex;

SET FOREIGN_KEY_CHECKS = 1;