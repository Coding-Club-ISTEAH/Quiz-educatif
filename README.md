# Projet Quiz Éducatif — Coding Club ISTEAH

Application éducative de quiz pour les élèves haïtiens du fondamental (7e à 9e) et
du secondaire (jusqu'à NS4). Interface en français, modes de jeu ludiques, et
fonctionnement hors ligne sur mobile.

## Approche par phases

- **Phase 1 — Web (en ligne).** Premier terrain d'apprentissage du club. Comptes,
  jeu en ligne, classements. Dossier `web/` et `backend/`.
- **Phase 2 — Mobile (hors ligne + synchronisation).** Application Flutter, usage
  quotidien des élèves. Dossier `mobile/` (démarré plus tard).

## Structure du dépôt

```
quiz-educatif/
├── contenu/        Banque de questions (schéma commun + contenu)
├── web/            Application web Vue.js (phase 1)
│   └── src/
│       ├── presentation/   Couche présentation (écrans, composants)
│       ├── logique/        Couche logique (moteur de quiz, modes)
│       └── donnees/        Couche données (module « dépôt »)
├── backend/        Serveur + API (comptes, progression, classements)
├── mobile/         Application Flutter (phase 2)
├── docs/           Conception, plan de travail, diagrammes
└── .github/        Modèles de pull request et d'issues
```

L'architecture sépare trois responsabilités : **présentation**, **logique** et
**données**. Le module « dépôt » (`web/src/donnees/depot/`) isole l'accès aux
données et est conçu pour pouvoir parler à un serveur plus tard, afin que le
passage au mobile soit une extension et non une réécriture.

## Le premier contrat à figer

Avant de coder les fonctionnalités, l'équipe fige le **schéma de la banque de
questions** : voir `contenu/SCHEMA.md`. Il est partagé par le contenu, le web et
le mobile.

## Démarrer

1. Lire `CONTRIBUTING.md` (branches, commits, pull requests, binômes).
2. Choisir une tâche sur le tableau de tâches (GitHub Projects / Issues).
3. Travailler en binôme sur une branche dédiée, puis ouvrir une pull request.

## Documentation

Les documents du projet sont dans `docs/` : document de conception, plan de
travail, et planning (Gantt + diagramme d'activité).
