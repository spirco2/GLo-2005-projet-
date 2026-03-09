
DROP TABLE IF EXISTS cibler;
DROP TABLE IF EXISTS exercice;
DROP TABLE IF EXISTS muscle;

-- Table de Hakim (reproduite pour la compatibilité des FK)
CREATE TABLE muscle (
    id_muscle INT PRIMARY KEY AUTO_INCREMENT,
    nom_muscle VARCHAR(50) NOT NULL
);


CREATE TABLE exercice (
    id_ex INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL,
    equipement VARCHAR(100),
    description TEXT,
    difficulte VARCHAR(50)
);

-- Table de liaison
CREATE TABLE cibler (
    id_ex INT,
    id_muscle INT,
    PRIMARY KEY (id_ex, id_muscle),
    FOREIGN KEY (id_ex) REFERENCES exercice(id_ex) ON DELETE CASCADE,
    FOREIGN KEY (id_muscle) REFERENCES muscle(id_muscle) ON DELETE CASCADE
);



INSERT INTO muscle (id_muscle, nom_muscle) VALUES
(1, 'Pectoraux'), (2, 'Dos'), (3, 'Épaules'), (4, 'Triceps'), (5, 'Biceps'),
(6, 'Avant-bras'), (7, 'Trapèzes'), (8, 'Lombaires'), (9, 'Abdominaux'),
(10, 'Obliques'), (11, 'Quadriceps'), (12, 'Ischio-jambiers'), (13, 'Fessiers'),
(14, 'Mollets'), (15, 'Adducteurs'), (16, 'Abducteurs'), (17, 'Cardio'), (18, 'Full Body');



INSERT INTO exercice (id_ex, nom, equipement, description, difficulte) VALUES
(1, 'Extension mollets debout (Haltère)', 'Haltère', 'Élevez-vous sur la pointe des pieds en tenant des haltères.', 'Intermédiaire'),
(2, 'Curl Biceps 21', 'Barre', '7 reps partielles bas, 7 haut, puis 7 complètes.', 'Avancé'),
(3, 'Ciseaux abdominaux', 'Aucun', 'Allongé, croisez alternativement vos jambes tendues.', 'Débutant'),
(4, 'Roue abdominale', 'Autres', 'Roulez vers l''avant en gainage total puis revenez.', 'Avancé'),
(5, 'Arnold Press', 'Haltère', 'Développé épaules avec rotation des paumes.', 'Intermédiaire'),
(6, 'Squat pistolet assisté', 'Aucun', 'Squat sur une seule jambe avec appui.', 'Avancé'),
(7, 'Hyperextension 45°', 'Machine', 'Extension du buste pour renforcer les lombaires.', 'Débutant'),
(8, 'Good Morning (Barre)', 'Barre', 'Penchez le buste en avant avec barre sur les épaules.', 'Intermédiaire'),
(9, 'Curl derrière le dos (Câble)', 'Machine', 'Tirage poulie basse, coudes en arrière du buste.', 'Intermédiaire'),
(10, 'Développé couché (Barre)', 'Barre', 'Poussez la barre au-dessus de la poitrine.', 'Débutant'),
(11, 'Développé couché (Smith)', 'Machine', 'Développé sur banc avec barre guidée.', 'Débutant'),
(12, 'Curl biceps (Barre)', 'Barre', 'Flexion classique des coudes debout.', 'Débutant'),
(13, 'Curl biceps (Câble)', 'Machine', 'Flexion des bras à la poulie basse.', 'Débutant'),
(14, 'Curl biceps (Haltères)', 'Haltère', 'Flexion alternée des bras avec haltères.', 'Débutant'),
(15, 'Curl biceps (Machine)', 'Machine', 'Flexion des bras sur machine guidée.', 'Débutant'),
(16, 'Squat fendu bulgare', 'Haltère', 'Fente avec le pied arrière surélevé.', 'Intermédiaire'),
(17, 'Burpee classique', 'Aucun', 'Enchaînement squat, pompe et saut.', 'Avancé'),
(18, 'Pec Deck', 'Machine', 'Rapprochement des bras pour isoler les pectoraux.', 'Débutant'),
(19, 'Crunch à la poulie', 'Machine', 'Enroulement du buste avec corde poulie haute.', 'Intermédiaire'),
(20, 'Écartés poulie haute', 'Machine', 'Croisement des mains devant le bassin.', 'Intermédiaire'),
(21, 'Pull-through', 'Machine', 'Extension de hanche dos à la machine.', 'Intermédiaire'),
(22, 'Woodchopper (Câble)', 'Machine', 'Rotation diagonale du buste pour les obliques.', 'Intermédiaire'),
(23, 'Dips larges', 'Poids de corps', 'Flexions sur barres parallèles, buste penché.', 'Intermédiaire'),
(24, 'Dips assistés', 'Machine', 'Dips avec aide au contrepoids.', 'Débutant'),
(25, 'Relevé de jambes suspendu', 'Aucun', 'Levez vos jambes tendues suspendu à la barre.', 'Avancé'),
(26, 'Élévation genoux suspendu', 'Aucun', 'Ramenez les genoux vers la poitrine suspendu.', 'Intermédiaire'),
(27, 'Relevé de jambes (Chaise romaine)', 'Machine', 'En appui sur les coudes, levez les jambes.', 'Débutant'),
(28, 'Crunch vélo', 'Aucun', 'Rotation buste coude-genou opposé.', 'Débutant'),
(29, 'Flexion latérale haltère', 'Haltère', 'Inclinaison latérale du buste avec poids.', 'Débutant'),
(30, 'Russian Twist (Corps)', 'Aucun', 'Rotations du buste assis au sol.', 'Intermédiaire'),
(31, 'Planche latérale', 'Aucun', 'Maintien aligné sur un seul avant-bras.', 'Débutant'),
(32, 'Windshield Wipers', 'Barre', 'Rotation des jambes suspendu à la barre.', 'Avancé'),
(33, 'Twist russe (Pondéré)', 'Haltère', 'Rotations du buste avec charge.', 'Intermédiaire'),
(34, 'Gainage oblique (Côté)', 'Aucun', 'Statique sur le côté, hanches levées.', 'Débutant'),
(35, 'Développé militaire', 'Haltère', 'Poussez les haltères au-dessus de la tête.', 'Intermédiaire'),
(36, 'Élévation latérale machine', 'Machine', 'Élevez les bras latéralement sur machine.', 'Débutant'),
(37, 'Élévation latérale haltères', 'Haltère', 'Levez les bras latéralement debout.', 'Débutant'),
(38, 'Arnold Press assis', 'Haltère', 'Développé épaules avec rotation, assis.', 'Intermédiaire'),
(39, 'Élévation latérale assise', 'Haltère', 'Isolation épaules sans élan.', 'Intermédiaire'),
(40, 'Élévation latérale poulie', 'Machine', 'Tirage unilatéral à la poulie basse.', 'Intermédiaire'),
(41, 'Face Pull (Corde)', 'Machine', 'Tirage corde vers le front, coudes ouverts.', 'Intermédiaire'),
(42, 'D. Militaire Smith Machine', 'Machine', 'Développé épaules guidé.', 'Débutant'),
(43, 'EZ Bar Curl', 'Barre', 'Curl avec barre cambrée.', 'Débutant'),
(44, 'Curl Concentration', 'Haltère', 'Assis, coude calé contre l''intérieur de la cuisse.', 'Débutant'),
(45, 'Développé couché serré', 'Barre', 'Mains rapprochées pour cibler les triceps.', 'Intermédiaire'),
(46, 'Pompe diamant', 'Aucun', 'Pompe avec mains jointes en triangle.', 'Avancé'),
(47, 'Extension triceps poulie', 'Machine', 'Extension bras au-dessus de la tête.', 'Intermédiaire'),
(48, 'Dips machine assis', 'Machine', 'Poussez les poignées vers le bas.', 'Débutant'),
(49, 'Extension triceps haltère', 'Haltère', 'Extension derrière la tête à deux mains.', 'Débutant'),
(50, 'Dips assistés triceps', 'Machine', 'Buste vertical pour focus triceps.', 'Débutant'),
(51, 'Triceps Pressdown', 'Machine', 'Poussez la barre vers le bas poulie haute.', 'Débutant'),
(52, 'Curl poignet (Barre)', 'Barre', 'Barre dans le dos, flexion des poignets.', 'Intermédiaire'),
(53, 'Curl poignet (Haltères)', 'Haltère', 'Enroulez vos poignets, avant-bras sur banc.', 'Débutant'),
(54, 'Wrist Roller', 'Autres', 'Enroulez une corde lestée par rotation.', 'Intermédiaire'),
(55, 'Fente latérale corps', 'Aucun', 'Pas latéral et flexion d''une jambe.', 'Débutant'),
(56, 'Leg Extension', 'Machine', 'Extension des jambes assis.', 'Débutant'),
(57, 'Fente inversée barre', 'Barre', 'Pas arrière et flexion genou.', 'Intermédiaire'),
(58, 'SDT Roumain Barre', 'Barre', 'Extension hanche, jambes semi-tendues.', 'Intermédiaire'),
(59, 'SDT Roumain Haltères', 'Haltère', 'SDT roumain avec haltères.', 'Intermédiaire'),
(60, 'Abducteurs machine', 'Machine', 'Écartez les jambes vers l''extérieur.', 'Débutant'),
(61, 'Adducteurs machine', 'Machine', 'Resserrez les jambes vers l''intérieur.', 'Débutant'),
(62, 'Chin Up (Traction)', 'Aucun', 'Traction paumes face à vous.', 'Intermédiaire'),
(63, 'Chin Up assisté', 'Machine', 'Traction supination avec contrepoids.', 'Débutant'),
(64, 'Rowing bûcheron', 'Haltère', 'Tirage unilatéral en appui sur banc.', 'Intermédiaire'),
(65, 'Tirage poitrine bande', 'Autres', 'Tirage vertical à genoux avec élastique.', 'Débutant'),
(66, 'Tirage poitrine poulie', 'Machine', 'Tirage vertical assis barre longue.', 'Débutant'),
(67, 'Traction négative', 'Aucun', 'Contrôlez uniquement la descente lente.', 'Intermédiaire'),
(68, 'Traction classique', 'Aucun', 'Traction prise large en pronation.', 'Avancé'),
(69, 'Traction prise large', 'Aucun', 'Traction mains très écartées.', 'Avancé'),
(70, 'Rowing assis large', 'Machine', 'Tirage horizontal avec barre coudée.', 'Intermédiaire'),
(71, 'Rowing assis V-Grip', 'Machine', 'Tirage horizontal poignée serrée.', 'Débutant'),
(72, 'Rowing unilatéral poulie', 'Machine', 'Tirage horizontal d''un seul bras.', 'Intermédiaire'),
(73, 'Superman Hold', 'Aucun', 'Maintenez bras et jambes décollés au sol.', 'Débutant'),
(74, 'Banc à lombaires', 'Machine', 'Extensions du dos sur support.', 'Débutant'),
(75, 'Soulevé de terre', 'Barre', 'Levage de barre du sol aux hanches.', 'Avancé'),
(76, 'Trap Bar Deadlift', 'Barre', 'SDT avec barre hexagonale.', 'Intermédiaire'),
(77, 'Frog Pumps', 'Aucun', 'Relevé de bassin, pieds joints au sol.', 'Débutant'),
(78, 'Élévation latérale jambe', 'Aucun', 'Levez la jambe latéralement debout.', 'Débutant'),
(79, 'Hip Thrust Machine', 'Machine', 'Extension hanche barre guidée.', 'Intermédiaire'),
(80, 'Front Lever Hold', 'Aucun', 'Maintien horizontal suspendu.', 'Expert'),
(81, 'Front Lever Raise', 'Aucun', 'Montée en planche suspendue.', 'Expert'),
(82, 'Muscle Up', 'Aucun', 'Traction suivie d''un dip sur barre.', 'Expert'),
(83, 'Wall Ball', 'Autres', 'Squat et lancer de medecine ball.', 'Intermédiaire'),
(84, 'Air Bike (Assault)', 'Machine', 'Poussez et pédalez simultanément.', 'Intermédiaire'),
(85, 'Battle Ropes', 'Autres', 'Ondulations de cordes lourdes au sol.', 'Intermédiaire'),
(86, 'Boxe (Sac de frappe)', 'Autres', 'Frappes de poings continues.', 'Débutant'),
(87, 'Vélo elliptique', 'Machine', 'Simulateur de course sans impact.', 'Débutant'),
(88, 'Corde à sauter', 'Autres', 'Sauts rapides pour le rythme cardiaque.', 'Débutant'),
(89, 'Rameur Concept2', 'Machine', 'Tirage complet assis.', 'Intermédiaire'),
(90, 'Spinning', 'Machine', 'Cyclisme haute intensité.', 'Intermédiaire'),
(91, 'Course sur tapis', 'Machine', 'Course à pied sur tapis roulant.', 'Débutant'),
(92, 'HSPU (Handstand)', 'Aucun', 'Pompe en équilibre contre mur.', 'Expert'),
(93, 'Pike Pushup', 'Aucun', 'Pompe épaules, hanches levées.', 'Intermédiaire'),
(94, 'Fente sautée', 'Aucun', 'Fente avec saut explosif alterné.', 'Avancé'),
(95, 'Fente marchée', 'Aucun', 'Pas en fente sur une distance.', 'Débutant'),
(96, 'Extension mollet 1 jambe', 'Aucun', 'Élévation sur une pointe de pied.', 'Débutant'),
(97, 'Burpee over barbell', 'Barre', 'Burpee et saut latéral par-dessus barre.', 'Avancé'),
(98, 'Stairmaster', 'Machine', 'Montée de marches mécanique.', 'Intermédiaire'),
(99, 'Shrugs (Haltères)', 'Haltère', 'Haussez les épaules vers les oreilles.', 'Débutant'),
(100, 'Tirage menton (Barre)', 'Barre', 'Tirez la barre vers le menton.', 'Intermédiaire');



INSERT INTO cibler (id_ex, id_muscle) VALUES
(1, 14), (2, 5), (3, 9), (3, 10), (4, 9), (5, 3), (5, 4), (6, 11), (6, 13), (7, 8),
(8, 8), (8, 12), (9, 5), (10, 1), (10, 4), (11, 1), (12, 5), (13, 5), (14, 5), (15, 5),
(16, 11), (16, 13), (17, 18), (18, 1), (19, 9), (20, 1), (21, 13), (21, 8), (22, 10),
(23, 1), (23, 4), (24, 1), (24, 4), (25, 9), (26, 9), (27, 9), (28, 9), (28, 10),
(29, 10), (30, 10), (31, 10), (32, 10), (33, 10), (34, 10), (35, 3), (35, 4), (36, 3),
(37, 3), (38, 3), (39, 3), (40, 3), (41, 3), (41, 7), (42, 3), (42, 4), (43, 5),
(44, 5), (45, 4), (45, 1), (46, 4), (46, 1), (47, 4), (48, 4), (49, 4), (50, 4),
(51, 4), (52, 6), (53, 6), (54, 6), (55, 11), (55, 13), (55, 15), (56, 11), (57, 11),
(58, 12), (58, 8), (59, 12), (59, 13), (60, 16), (61, 15), (62, 2), (62, 5), (63, 2),
(63, 5), (64, 2), (64, 5), (65, 2), (66, 2), (66, 5), (67, 2), (68, 2), (68, 3),
(69, 2), (69, 3), (70, 2), (70, 7), (71, 2), (72, 2), (73, 8), (74, 8), (75, 13),
(75, 8), (76, 13), (76, 11), (77, 13), (78, 16), (79, 13), (80, 18), (81, 18),
(82, 18), (83, 18), (84, 17), (85, 17), (86, 17), (87, 17), (88, 17), (89, 17),
(89, 2), (90, 17), (91, 17), (92, 3), (93, 3), (94, 11), (94, 17), (95, 11),
(96, 14), (97, 18), (98, 17), (99, 7), (100, 7);


SELECT * FROM exercice ;
DELIMITER //

CREATE PROCEDURE calculer_volume_seance(IN p_id_seance INT)
BEGIN
    -- Calcul du volume total pour la séance donnée
    -- On utilise une jointure pour récupérer le poids de l'utilisateur si c'est du poids du corps
    UPDATE Seances s
    SET s.volume_total = (
        SELECT SUM(
            CASE
                WHEN e.equipement = 'Bodyweight' THEN (u.poids + sl.poids) * sl.reps
                ELSE sl.poids * sl.reps
            END
        )
        FROM Serie_log sl
        JOIN Exercices e ON sl.id_exercice = e.id
        JOIN Utilisateurs u ON s.id_u = u.id
        WHERE sl.id_seance = p_id_seance
    )
    WHERE s.id = p_id_seance;
END //

DELIMITER ;