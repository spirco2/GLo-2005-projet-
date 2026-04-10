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
- **Outils** : Git, VS Code  

---

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

1. **Cloner le projet**
```bash
git clone https://github.com/spirco2/GLo-2005-projet-.git
cd GLo-2005-projet-
