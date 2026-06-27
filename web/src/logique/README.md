# Couche logique

Le moteur de quiz et les règles des modes de jeu. Vérifie les réponses, gère les
minuteurs, calcule le score. Ne dépend ni de l'interface ni de l'emplacement des
données (elle passe par la couche `donnees/`).

- `moteur-quiz/` — déroulement d'une partie, score, résultat.
- `modes/` — paramètres et comportement de Rush, Révision, Bombardement.
