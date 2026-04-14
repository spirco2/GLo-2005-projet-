# IronTrack - Application Web de Musculation

## Description
IronTrack est une **application web pour la gestion et le suivi des programmes de musculation**.  
Les utilisateurs peuvent créer, modifier et personnaliser leurs programmes d’entraînement, suivre leurs progrès et consulter plusieurs informations utiles pour optimiser leur entraînement.

Cette application illustre une architecture **3 tiers** avec :  
- un **frontend** interactif (HTML, CSS, JavaScript),  
- un **backend Flask** pour la logique métier,  
- une **base de données MySQL** pour stocker utilisateurs, programmes, exercices et historiques.

---

## Stack technique

- **Frontend** : HTML, CSS, JavaScript  
- **Backend** : Python avec Flask  
- **Base de données** : MySQL  
- **Outils** : Git, pycharm 

---
//
## Fonctionnalités principales

- **Gestion des utilisateurs**
  - Création et authentification de comptes
  - Edition du profil personnel
- **Programmes de musculation**
  - Création, modification et suppression de programmes personnalisés
  - Ajout et modification d’exercices par programme
- **Suivi et statistiques**
  - Suivi des performances (poids, répétitions, temps)
  - Historique complet des séances
- **Interface intuitive**
  - Navigation simple et cohérente
  - Validation des entrées et gestion des erreurs côté client et serveur
- **Sécurité**
  - Hashage des mots de passe (bcrypt)
  - Protection des données sensibles
//
---

## Architecture

1. **Frontend (Client)**
   - Pages web interactives pour la gestion des programmes et du suivi
   - Validation des entrées et affichage des erreurs
2. **Backend (Flask)**
   - Routes pour gérer les programmes, utilisateurs et suivi
   - Logique métier et validation des données
   - Gestion des erreurs et communications avec la base de données
3. **Base de données (MySQL)**
   - Tables pour utilisateurs, programmes, exercices et historique
   - Requêtes SQL avancées (jointures, agrégations, procédures stockées)
   - Optimisation via index et normalisation

---

## Installation et exécution

1. Initialisation de la base de données (Niveau 3)
L'ordre d'importation est crucial pour respecter les contraintes d'intégrité référentielle (clés étrangères).

A. Méthode recommandée (PyCharm)
Pour garantir un encodage UTF-8 parfait (gestion des accents), utilisez l'outil "Database" de PyCharm :

Faites un clic droit sur votre instance MySQL dans l'onglet Database.

Sélectionnez "Run SQL Script...".

Sélectionnez les fichiers dans cet ordre strict :

1_muscle.sql (20 muscles)

2_utilisateur.sql (20 profils + Procédure IMC)

3_exercice.sql (100 exercices + 130 liaisons + Procédure Volume)

4_programme.sql (20 programmes + Séances + Trigger Assiduité)

5_serie_log.sql (100+ séries + Records personnels + Trigger PR)

B. Méthode alternative (Terminal MySQL)
Forcez l'encodage avant l'importation pour éviter la corruption des caractères :

SQL
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
DROP DATABASE IF EXISTS db_local;

SOURCE database/1_muscle.sql;
SOURCE database/2_utilisateur.sql;
SOURCE database/3_exercice.sql;
SOURCE database/4_programme.sql;
SOURCE database/5_serie_log.sql;

SET FOREIGN_KEY_CHECKS = 1;
2. Lancer l'application
Bash
pip install -r requirements.txt
python app.py
Accéder à : http://127.0.0.1:5000

Vérification rapide pour l'évaluateur
Le système est pré-peuplé avec des données réalistes permettant de valider immédiatement les exigences du cours  :

Comptes de test : Tous les utilisateurs utilisent le mot de passe IronTrack2026.

Volumétrie : Tables exercice (100 tuples) et serie_log (100+ tuples).

Routines SQL : 2 procédures (imc_de_utilisateur, calculer_volume_seance) et 2 triggers (calcul_assiduite, update_pr) sont opérationnels.

Sécurité : Hachage scrypt via Werkzeug et protection contre l'injection SQL via requêtes paramétrées.
```bash

