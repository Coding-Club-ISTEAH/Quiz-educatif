# Guide de contribution

Bienvenue dans le projet ! Ce guide explique **comment travailler ensemble**. Il
est écrit pour tout le monde, y compris si vous débutez complètement avec Git et
GitHub. Lisez-le en entier une fois avant votre première contribution — ensuite,
l'aide-mémoire à la fin suffira.

## Notre façon de travailler

- **En binôme** : une personne plus à l'aise et une personne qui débute. On
  apprend en faisant, et aucune tâche importante ne repose sur une seule personne.
- **Petites tâches** : on découpe le travail en morceaux finissables en une ou
  deux séances. C'est plus motivant et plus facile à relire.
- **La revue de code sert à apprendre**, pas à juger. Recevoir des remarques est
  normal et fait progresser.
- **On ne reste jamais bloqué seul** : on demande à son binôme, à son référent, ou
  dans l'issue.

La règle d'or, simple à retenir :

> **une tâche → une issue → une branche → une pull request.**

---

## 1. Installation (à faire une seule fois)

1. **Créer un compte GitHub** (si vous n'en avez pas) et demander à être ajouté au
   dépôt à votre référent.
2. **Installer Git** : https://git-scm.com/downloads
   - Débutant ? Vous pouvez aussi utiliser **GitHub Desktop**
     (https://desktop.github.com) ou l'onglet Git de **VS Code** : ils font la
     même chose en version visuelle. Les commandes ci-dessous restent la référence.
3. **Configurer votre identité** (une fois) :
   ```bash
   git config --global user.name "Votre Nom"
   git config --global user.email "votre.email@example.com"
   ```
4. **Cloner le dépôt** (télécharger le projet sur votre machine) :
   ```bash
   git clone https://github.com/<organisation>/quiz-educatif.git
   cd quiz-educatif
   ```

Les outils propres au web (Vue.js) ou au mobile (Flutter) s'installent plus tard ;
voir les README des dossiers `web/` et `mobile/`.

---

## 2. Le cycle de travail (à chaque tâche)

À répéter pour **chaque** tâche. Prenons l'exemple de la tâche « écran de quiz »
pour la sous-équipe Front A.

**1. Prendre une tâche.** Choisissez une issue sur le tableau de tâches et
assignez-la-vous (avec votre binôme), pour que personne d'autre ne la prenne.

**2. Se mettre à jour.** Placez-vous sur `dev` et récupérez les derniers
changements :
```bash
git checkout dev
git pull
```

**3. Créer votre branche** à partir de `dev` :
```bash
git checkout -b feat/front-a/ecran-quiz
```

**4. Travailler**, en binôme, sur votre tâche.

**5. Enregistrer votre travail** (un ou plusieurs commits) :
```bash
git add -A
git commit -m "ajoute l'écran de quiz"
```

**6. Envoyer votre branche** sur GitHub :
```bash
git push -u origin feat/front-a/ecran-quiz
```

**7. Ouvrir une pull request.** Sur GitHub, un bouton propose de créer la pull
request. Choisissez-la **vers `dev`**, remplissez le modèle qui s'affiche, et liez
l'issue en écrivant par exemple `Closes #12` dans la description.

**8. Répondre à la revue.** Un binôme ou un référent relit. S'il demande des
changements, modifiez votre code, puis :
```bash
git add -A
git commit -m "corrige le minuteur d'après la revue"
git push
```
La pull request se met à jour automatiquement.

**9. Fusion.** Une fois la pull request approuvée et les tests passés, un référent
la fusionne dans `dev`.

**10. Nettoyer** et repartir d'une base à jour pour la tâche suivante :
```bash
git checkout dev
git pull
```

---

## 3. Conventions de branches

| Branche | Rôle |
|---------|------|
| `main` | Version stable. **On n'y pousse jamais directement.** |
| `dev` | Branche d'intégration. Les pull requests vont ici. |
| `feat/<groupe>/<description>` | Une nouvelle fonctionnalité. |
| `fix/<groupe>/<description>` | Une correction de bug. |

Exemples : `feat/front-a/ecran-quiz`, `feat/backend/endpoint-comptes`,
`fix/front-b/selection-chapitre`. Utilisez des tirets, pas d'espaces ni
d'accents dans les noms de branches.

---

## 4. Conventions de commits

- Messages **clairs, en français, au présent**.
- Un commit = une idée. Des commits petits et fréquents valent mieux qu'un gros.

Bons exemples :
- `ajoute l'écran de résultats`
- `corrige le calcul du score en mode Rush`
- `met à jour le schéma des questions`

À éviter : `modif`, `update`, `wip`, `ça marche enfin`.

---

## 5. Les pull requests

Une bonne pull request est :

- **Petite et focalisée** : une seule chose à la fois. Plus c'est petit, plus
  c'est facile et rapide à relire.
- **Liée à une issue** (`Closes #12`).
- **Dirigée vers `dev`**, jamais vers `main`.
- **Accompagnée du modèle rempli** (il s'affiche automatiquement).
- **Relue et approuvée** par au moins une autre personne avant fusion.

---

## 6. La revue de code

C'est notre principal outil d'apprentissage et de qualité.

**Quand on vous relit :** accueillez les remarques sans les prendre mal. Tout le
monde passe par là, même les plus expérimentés. Posez des questions si une remarque
n'est pas claire.

**Quand vous relisez le code d'un autre :** soyez bienveillant et concret.
Expliquez le *pourquoi* d'une suggestion. Vérifiez surtout :

- Est-ce que ça fait ce que demande l'issue ?
- Est-ce que ça respecte la structure en couches (voir section 7) ?
- Est-ce clair et lisible ?
- Est-ce testé ?

Un « bien joué » quand c'est mérité fait autant de bien qu'une correction.

---

## 7. Où mettre mon code (structure en couches)

L'application sépare trois responsabilités. Respecter cette séparation est ce qui
permet à 55 personnes de travailler sans tout casser.

- **`presentation/`** — l'interface : écrans et composants. Pas de logique métier
  ici ; cette couche appelle la couche logique.
- **`logique/`** — le moteur de quiz et les règles des modes (vérifier une réponse,
  minuteurs, score). Elle ne dépend **ni** de l'interface **ni** de l'endroit où
  sont rangées les données.
- **`donnees/`** — le module « dépôt », qui isole l'accès aux données. Le reste du
  code demande « les questions du chapitre X » sans savoir d'où elles viennent.

En cas de doute sur l'endroit où placer votre code, demandez à votre référent
plutôt que de deviner.

---

## 8. Quand ça coince

- **Conflit de fusion** (« merge conflict ») : pas de panique, ça arrive. Mettez à
  jour votre branche depuis `dev` (`git checkout dev && git pull`, puis revenez sur
  votre branche et `git merge dev`) et résolvez les parties signalées. Si vous
  n'êtes pas sûr, demandez à un référent **avant** de valider.
- **Vous êtes bloqué** : demandez à votre binôme, écrivez dans l'issue, ou
  contactez votre référent. Ne restez pas bloqué seul plus de quelques minutes.
- **Vous avez poussé sur la mauvaise branche** ou fait une erreur : ne supprimez
  rien dans la panique, demandez de l'aide. Presque tout se rattrape avec Git.

---

## 9. Aide-mémoire des commandes

```bash
# Se mettre à jour avant de commencer
git checkout dev
git pull

# Créer sa branche de travail
git checkout -b feat/mon-groupe/ma-tache

# Enregistrer son travail
git add -A
git commit -m "message clair au présent"

# Envoyer sa branche (la première fois)
git push -u origin feat/mon-groupe/ma-tache
# Les fois suivantes
git push

# Voir où on en est
git status
git branch
```

Merci de contribuer — et bon code !
