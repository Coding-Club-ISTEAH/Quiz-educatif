# Backend (serveur + API) — Phase 1

Serveur exposant l'API dont dépend la version web : comptes, authentification,
sauvegarde et lecture de la progression, et plus tard les classements.

La technologie (langage, framework, base de données) est choisie par le groupe
Backend. L'essentiel : définir tôt le **contrat d'API** (endpoints et format des
données) et le partager avec le groupe Frontend.

Une cellule « synchronisation » conçoit en parallèle la remontée de la progression
depuis le mobile (gestion des conflits, connexions interrompues), en vue de la
phase 2.
