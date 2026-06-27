# Schéma de la banque de questions

Ce schéma est le **premier contrat à figer**. Il est partagé par le groupe
contenu (qui saisit les questions), le web et le futur mobile (qui les affichent).
Toute modification se discute avec la cellule de coordination.

## Champs d'une question

| Champ            | Type     | Obligatoire | Description |
|------------------|----------|-------------|-------------|
| `id`             | texte    | oui         | Identifiant unique (ex. `GEO-7E-001`). |
| `niveau`         | texte    | oui         | `7e`, `8e`, `9e`, `NS1`, `NS2`, `NS3`, `NS4`. |
| `matiere`        | texte    | oui         | Nom de la matière (ex. `Géographie`). |
| `chapitre`       | texte    | oui         | Nom du chapitre (ex. `Le relief d'Haïti`). |
| `enonce`         | texte    | oui         | La question posée. |
| `choix`          | liste    | oui         | Les propositions (3 à 4 recommandé). |
| `bonne_reponse`  | texte    | oui         | La lettre du bon choix : `a`, `b`, `c` ou `d`. |
| `explication`    | texte    | oui         | 2 à 3 phrases : la bonne réponse et le pourquoi. |
| `difficulte`     | texte    | oui         | `Facile`, `Moyen` ou `Difficile`. |

## Règles

- Chaque `id` est unique dans toute la banque.
- `bonne_reponse` doit correspondre à un des choix fournis.
- L'explication est adaptée au niveau visé (langue simple pour le fondamental).
- Toute explication est **relue et validée** avant intégration.

## Deux formats

- **Pour le groupe contenu** : un tableur / CSV (voir `exemple-questions.csv`),
  simple à remplir dans Excel. Colonnes :
  `id, niveau, matiere, chapitre, enonce, choix_a, choix_b, choix_c, choix_d, bonne_reponse, explication, difficulte`.
- **Pour les développeurs** : du JSON (voir `exemple-questions.json`), produit à
  partir du CSV par le script d'import du groupe Données.

Le `schema-question.json` (JSON Schema) permet de valider automatiquement le
format d'une question.
