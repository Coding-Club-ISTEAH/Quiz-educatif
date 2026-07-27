import 'package:flutter/material.dart';

import '../../models/chapitre.dart';
import '../../theme/app_theme.dart';
import '../widgets/educle_app_bar.dart';
import 'apprentissage_screen.dart';
import 'cartes_mentales_screen.dart';
import 'mode_jeu_screen.dart';

/// Écran intermédiaire après UC1 (sélection du chapitre) : permet d'aller
/// vers UC2 (cartes mentales) ou de lancer un quiz (UC3/UC4/UC5).
class ChapitreDetailScreen extends StatelessWidget {
  final Chapitre chapitre;

  const ChapitreDetailScreen({super.key, required this.chapitre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EduCleAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chapitre.titre,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                '${chapitre.questions.length} question(s) • '
                '${chapitre.cartesMentales.length} carte(s) mentale(s)',
                style: const TextStyle(color: EduCleColors.textSecondary),
              ),
              const Spacer(),
              _CarteAction(
                icone: Icons.style_rounded,
                titre: 'Cartes mentales',
                sousTitre: 'Relis rapidement les notions essentielles.',
                couleur: const Color(0xFF8E24AA),
                actif: chapitre.cartesMentales.isNotEmpty,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CartesMentalesScreen(chapitre: chapitre),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              _CarteAction(
                icone: Icons.school_rounded,
                titre: 'Mode apprentissage',
                sousTitre: 'Résumé + flashcards Q&A à retourner.',
                couleur: const Color(0xFF0288D1),
                actif: chapitre.questions.isNotEmpty ||
                    chapitre.cartesMentales.isNotEmpty,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          ApprentissageScreen(chapitre: chapitre),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              _CarteAction(
                icone: Icons.play_arrow_rounded,
                titre: 'Lancer un quiz',
                sousTitre: 'Choisis un mode de jeu et teste-toi.',
                couleur: EduCleColors.primary,
                rempli: true,
                actif: chapitre.questions.isNotEmpty,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ModeJeuScreen(chapitre: chapitre),
                    ),
                  );
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CarteAction extends StatelessWidget {
  final IconData icone;
  final String titre;
  final String sousTitre;
  final Color couleur;
  final bool actif;
  final bool rempli;
  final VoidCallback onTap;

  const _CarteAction({
    required this.icone,
    required this.titre,
    required this.sousTitre,
    required this.couleur,
    required this.actif,
    required this.onTap,
    this.rempli = false,
  });

  @override
  Widget build(BuildContext context) {
    final couleurEffective = actif ? couleur : EduCleColors.textSecondary;

    return Material(
      color: rempli ? couleurEffective.withValues(alpha: actif ? 1 : 0.4) : EduCleColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: actif ? onTap : null,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: rempli
                ? null
                : Border.all(color: EduCleColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: rempli
                      ? Colors.white.withValues(alpha: 0.2)
                      : couleurEffective.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icone,
                  color: rempli ? Colors.white : couleurEffective,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titre,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: rempli ? Colors.white : EduCleColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      sousTitre,
                      style: TextStyle(
                        fontSize: 12,
                        color: rempli
                            ? Colors.white70
                            : EduCleColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: rempli ? Colors.white : EduCleColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
