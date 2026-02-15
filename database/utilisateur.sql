CREATE DATABASE DB_LOCAL;
USE DB_LOCAL;
CREATE TABLE utilisateur (
    id INT PRIMARY KEY,
    nom VARCHAR(100),
    age INT,
    taille DOUBLE,
    poids DOUBLE,
    niveau ENUM('debutant', 'intermediaire', 'avance')
);

ALTER TABLE utilisateur
MODIFY COLUMN id INT AUTO_INCREMENT;

INSERT INTO utilisateur (nom, age, taille, poids, niveau) VALUES
('Alice', 25, 1.65, 60, 'debutant'),
('Bob', 30, 1.80, 75, 'intermediaire');


SELECT * FROM utilisateur;