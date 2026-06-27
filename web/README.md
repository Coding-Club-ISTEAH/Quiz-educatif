# Application web (Vue.js) — Phase 1

Version web en ligne : comptes, jeu en ligne, classements. Premier terrain
d'apprentissage du club.

## Couches (dans `src/`)

- `presentation/` — écrans et composants Vue (l'interface vue par l'élève).
- `logique/` — moteur de quiz et règles des trois modes (Rush, Révision,
  Bombardement). Indépendant de l'interface.
- `donnees/` — module « dépôt » : accès aux données (API du backend), isolé du
  reste. Conçu pour pouvoir évoluer vers la synchronisation mobile.

## Démarrer (à compléter par le groupe Frontend)

Le groupe Frontend initialise ici le projet Vue.js et documente les commandes
d'installation et de lancement.
