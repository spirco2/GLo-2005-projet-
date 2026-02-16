CREATE DATABASE BD_LOCAL;
USE BD_LOCAL;

CREATE TABLE programme (
  nom_programme VARCHAR(255) NOT NULL,
    description TEXT,
    duree_semaines INT,
    difficulte ENUM('Debutant', 'Intermediaire', 'Avance')
);

INSERT INTO programme (nom_programme, description, duree_semaines, difficulte)
VALUES ('Push Pull Leg', 'Ce programme pour débutants comprend trois séances
d''entraînement hebdomadaires: poussée (pectoraux,
épaules et triceps),
traction (dos et biceps)
et jambes (quadriceps, ischio-jambiers,
fessiers et mollets', 8, 'Debutant');

SELECT * FROM programme