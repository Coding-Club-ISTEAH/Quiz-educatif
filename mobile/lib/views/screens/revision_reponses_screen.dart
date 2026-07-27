import 'package:flutter/material.dart';

import '../../models/reponse_enregistree.dart';
import '../../models/resultat.dart';
import '../../theme/app_theme.dart';
import '../widgets/educle_app_bar.dart';

/// Reprend la page web "Révision de tes réponses" : chaque question du
/// quiz, la réponse donnée, la bonne réponse si besoin, et l'explication.
class RevisionReponsesScreen extends StatelessWidget {
  final Resultat resultat;
  final String? matiereNom;

  const RevisionReponsesScreen({
    super.key,
    required this.resultat,
    this.matiereNom,
  });

  @override
  Widget build(BuildContext context) {
    final sousTitre = [
      '${resultat.reponsesCorrectes.length}/${resultat.total} bonnes réponses',
      if (matiereNom != null) matiereNom!,
    ].join(' · ');

    return Scaffold(
      appBar: const EduCleAppBar(labelRetour: 'Résultats'),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          itemCount: resultat.historique.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Révision de tes réponses',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sousTitre,
                    style: const TextStyle(color: EduCleColors.textSecondary),
                  ),
                ],
              );
            }
            final entree = resultat.historique[index - 1];
            return _CarteQuestion(numero: index, entree: entree);
          },
        ),
      ),
    );
  }
}

class _CarteQuestion extends StatelessWidget {
  final int numero;
  final ReponseEnregistree entree;

  const _CarteQuestion({required this.numero, required this.entree});

  @override
  Widget build(BuildContext context) {
    final question = entree.question;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EduCleColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EduCleColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'QUESTION $numero',
                style: const TextStyle(
                  color: EduCleColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 0.4,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: entree.correcte
                      ? EduCleColors.successBg
                      : EduCleColors.errorBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  entree.correcte ? 'Correct' : 'Incorrect',
                  style: TextStyle(
                    color: entree.correcte
                        ? EduCleColors.success
                        : EduCleColors.error,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            question.enonce,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
          ),
          const SizedBox(height: 12),
          _LigneReponse(
            libelle: 'Ta réponse',
            valeur: entree.reponseUtilisateur.isEmpty
                ? 'Aucune réponse'
                : entree.reponseUtilisateur,
            couleurFond: entree.correcte
                ? EduCleColors.successBg
                : EduCleColors.errorBg,
            couleurTexte: entree.correcte
                ? EduCleColors.success
                : EduCleColors.error,
          ),
          if (!entree.correcte) ...[
            const SizedBox(height: 8),
            _LigneReponse(
              libelle: 'Bonne réponse',
              valeur: question.bonneReponse,
              couleurFond: EduCleColors.successBg,
              couleurTexte: EduCleColors.success,
            ),
          ],
          const SizedBox(height: 12),
          const Text(
            'Explication',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            question.explication,
            style: const TextStyle(
              color: EduCleColors.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _LigneReponse extends StatelessWidget {
  final String libelle;
  final String valeur;
  final Color couleurFond;
  final Color couleurTexte;

  const _LigneReponse({
    required this.libelle,
    required this.valeur,
    required this.couleurFond,
    required this.couleurTexte,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: couleurFond,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            libelle,
            style: const TextStyle(
              color: EduCleColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          Flexible(
            child: Text(
              valeur,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: couleurTexte,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
