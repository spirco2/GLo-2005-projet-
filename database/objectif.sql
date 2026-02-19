SHOW DATABASES;

CREATE TABLE Objectif (
    id_objectif INT PRIMARY KEY AUTO_INCREMENT,
    id_utilisateur INT NOT NULL,
    type_objectif VARCHAR(100) NOT NULL,
    statut VARCHAR(20) NOT NULL
);
