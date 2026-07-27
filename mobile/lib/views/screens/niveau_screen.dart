import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/quiz_controller.dart';
import '../../theme/app_theme.dart';
import '../widgets/educle_app_bar.dart';
import 'matiere_screen.dart';

class NiveauScreen extends StatelessWidget {
  const NiveauScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<QuizController>();

    return Scaffold(
      appBar: const EduCleAppBar(labelRetour: 'Accueil'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choisis ton niveau',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              const Text(
                'Le contenu proposé s\'adapte à ton niveau scolaire.',
                style: TextStyle(color: EduCleColors.textSecondary),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: controller.niveaux.isEmpty
                    ? const Center(
                        child: Text(
                          'Aucun niveau disponible.',
                          style: TextStyle(color: EduCleColors.textSecondary),
                        ),
                      )
                    : ListView.separated(
                        itemCount: controller.niveaux.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final niveau = controller.niveaux[index];
                          return _CarteNiveau(
                            niveau: niveau,
                            onTap: () async {
                              await context
                                  .read<QuizController>()
                                  .choisirNiveau(niveau);
                              if (!context.mounted) return;
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const MatiereScreen(),
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

class _CarteNiveau extends StatelessWidget {
  final String niveau;
  final VoidCallback onTap;

  const _CarteNiveau({required this.niveau, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: EduCleColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: EduCleColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: EduCleColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: EduCleColors.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  niveau,
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
