# Guide de contribution

Bienvenue ! Ce guide explique comment travailler ensemble sur le projet. Il est
court : lisez-le en entier avant votre première contribution.

## Principe de base

- On travaille **en binôme** (une personne plus à l'aise + une personne qui
  débute). Aucune tâche importante ne repose sur une seule personne.
- On découpe le travail en **petites tâches** finissables en une ou deux séances.
- Rien n'est intégré sans **revue de code**. La revue sert à apprendre, pas à juger.

## Branches

- `main` : version stable. On n'y pousse jamais directement.
- `dev` : branche d'intégration. Les pull requests vont ici.
- Branches de travail : `feat/<groupe>/<description>` pour une fonctionnalité,
  `fix/<groupe>/<description>` pour une correction.
  - Exemples : `feat/front-a/ecran-quiz`, `fix/backend/connexion-compte`.

## Commits

- Messages clairs, en français, au présent.
  - Exemples : « ajoute l'écran de quiz », « corrige le minuteur du mode Rush ».
- Des commits petits et fréquents valent mieux qu'un seul gros commit.

## Pull requests

1. Créez votre branche à partir de `dev`.
2. Faites votre travail en binôme, avec des commits clairs.
3. Ouvrez une pull request **vers `dev`**, en remplissant le modèle.
4. Liez la pull request à son issue (ex. « Closes #12 »).
5. Au moins une autre personne (binôme ou référent) relit et approuve.
6. Une fois approuvée et les tests passés, la pull request est fusionnée.

## Structure en couches (à respecter)

- `presentation/` ne contient que l'interface (écrans, composants).
- `logique/` contient le moteur de quiz et les règles des modes. Elle ne dépend
  pas de l'interface.
- `donnees/` (module « dépôt ») isole l'accès aux données. La logique demande les
  données au dépôt sans savoir où elles sont rangées.

Si vous avez un doute, demandez à votre référent ou posez la question dans une
issue. Mieux vaut demander que de rester bloqué seul.
