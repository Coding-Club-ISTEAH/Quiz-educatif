import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/quiz_controller.dart';
import '../../theme/app_theme.dart';
import '../widgets/educle_app_bar.dart';
import 'chapitre_detail_screen.dart';
import 'mode_jeu_screen.dart';
import 'reglages_screen.dart';

class ChapitreScreen extends StatelessWidget {
  const ChapitreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<QuizController>();
    final matiere = controller.utilisateur.matiereSelectionnee;
    final emoji = MatiereStyle.emojiPour(matiere?.nom ?? '');

    return Scaffold(
      appBar: EduCleAppBar(
        action: IconButton(
          icon: const Icon(
            Icons.settings_outlined,
            color: EduCleColors.textSecondary,
          ),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ReglagesScreen()),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: EduCleColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(emoji, style: const TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          matiere?.nom ?? '',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).maybePop(),
                          child: const Text(
                            'Changer de matière',
                            style: TextStyle(
                              color: EduCleColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _CarteTout(
                onTap: () async {
                  final chapitre = await context
                      .read<QuizController>()
                      .choisirTousLesChapitres();
                  if (!context.mounted) return;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          ChapitreDetailScreen(chapitre: chapitre),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'CHAPITRES',
                style: TextStyle(
                  color: EduCleColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: controller.chapitres.isEmpty
                    ? const Center(
                        child: Text(
                          'Aucun chapitre disponible.',
                          style: TextStyle(color: EduCleColors.textSecondary),
                        ),
                      )
                    : ListView.separated(
                        itemCount: controller.chapitres.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final chapitre = controller.chapitres[index];
                          return _CarteChapitre(
                            numero: index + 1,
                            titre: chapitre.titre,
                            onTap: () async {
                              final chapitreComplet = await context
                                  .read<QuizController>()
                                  .choisirChapitre(chapitre);
                              if (!context.mounted) return;
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ChapitreDetailScreen(
                                      chapitre: chapitreComplet),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CarteTout extends StatelessWidget {
  final VoidCallback onTap;

  const _CarteTout({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: EduCleColors.primary.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: EduCleColors.primary, width: 1.5),
          ),
          child: Row(
            children: [
              const Icon(Icons.grid_view_rounded, color: EduCleColors.primary),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Tout — tous les chapitres',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: EduCleColors.primary,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: EduCleColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CarteChapitre extends StatelessWidget {
  final int numero;
  final String titre;
  final VoidCallback onTap;

  const _CarteChapitre({
    required this.numero,
    required this.titre,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: EduCleColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: EduCleColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: EduCleColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$numero',
                  style: const TextStyle(
                    color: EduCleColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  titre,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: EduCleColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
