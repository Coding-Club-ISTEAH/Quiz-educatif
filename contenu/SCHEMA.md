# Schéma de la banque de questions — v1

Ce schéma est le **premier contrat figé** du projet. Il est partagé par le groupe
contenu (qui saisit les questions), le web et le futur mobile (qui les affichent).
Toute modification se discute avec la cellule de coordination.

## Champs d'une question

| Champ            | Type     | Obligatoire | Description |
|------------------|----------|-------------|-------------|
| `id`             | texte    | oui         | Identifiant unique. Format : `CODE-NIVEAU-NNN` (ex. `GEO-7E-001`). |
| `niveau`         | liste    | oui         | Une valeur parmi la liste des niveaux ci-dessous. |
| `matiere`        | liste    | oui         | Une valeur parmi la liste des matières ci-dessous. |
| `chapitre`       | texte    | oui         | Nom du chapitre (ex. `Le relief d'Haïti`). |
| `enonce`         | texte    | oui         | La question posée. |
| `choix`          | liste    | oui         | **Exactement 4** propositions. |
| `bonne_reponse`  | lettre   | oui         | La lettre du bon choix : `a`, `b`, `c` ou `d`. |
| `explication`    | texte    | oui         | 2 à 3 phrases : la bonne réponse et le pourquoi. |
| `difficulte`     | liste    | oui         | `Facile`, `Moyen` ou `Difficile`. |

## Niveaux (liste fermée)

`7e`, `8e`, `9e`, `NS1`, `NS2`, `NS3`, `NS4`

## Matières (liste fermée)

Mathématiques, Français, Sciences expérimentales, Sciences sociales, Histoire,
Géographie, Littérature, Espagnol, Anglais, Chimie, Physique,
Connaissances générales, EPS, EEA, ETAP, EC

> Écrivez la matière **exactement** comme ci-dessus (mêmes accents, même
> orthographe). C'est ce qui évite les doublons (« Géo » vs « Géographie »).

### Codes de matière (pour les identifiants)

Utilisez ces abréviations pour la première partie de l'`id` :

| Matière | Code | Matière | Code |
|---------|------|---------|------|
| Mathématiques | MATH | Physique | PHYS |
| Français | FR | Connaissances générales | CG |
| Sciences expérimentales | SE | EPS | EPS |
| Sciences sociales | SS | EEA | EEA |
| Histoire | HIST | ETAP | ETAP |
| Géographie | GEO | EC | EC |
| Littérature | LITT | Espagnol | ESP |
| Anglais | ANG | Chimie | CHIM |

Exemple d'identifiant : une question de Géographie, niveau 7e, la première →
`GEO-7E-001`.

## Règles

- Chaque `id` est unique dans toute la banque.
- Il y a **exactement 4 choix** par question.
- `bonne_reponse` est la lettre (`a`/`b`/`c`/`d`) du choix correct.
- L'explication est adaptée au niveau visé (langue simple pour le fondamental).
- Toute explication est **relue et validée** avant intégration.

## Deux formats

- **Pour le groupe contenu** : un tableur / CSV (voir `exemple-questions.csv`),
  simple à remplir dans Excel. Colonnes :
  `id, niveau, matiere, chapitre, enonce, choix_a, choix_b, choix_c, choix_d, bonne_reponse, explication, difficulte`.
- **Pour les développeurs** : du JSON (voir `exemple-questions.json`), produit à
  partir du CSV par le script d'import du groupe Données. Le fichier
  `schema-question.json` (JSON Schema) valide automatiquement le format.
