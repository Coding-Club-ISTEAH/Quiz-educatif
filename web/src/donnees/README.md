# Couche données

Le module « dépôt » (repository) isole l'accès aux données. Le reste du code
demande « les questions du chapitre X » sans savoir d'où elles viennent.

Important : ce module est conçu dès le départ pour pouvoir communiquer avec un
serveur, afin que l'ajout de la synchronisation mobile (phase 2) soit une simple
extension et non une réécriture.
