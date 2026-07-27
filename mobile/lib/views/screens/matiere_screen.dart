import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/quiz_controller.dart';
import '../../models/matiere.dart';
import '../../theme/app_theme.dart';
import '../widgets/educle_app_bar.dart';
import 'chapitre_screen.dart';
import 'mode_jeu_screen.dart';

class MatiereScreen extends StatefulWidget {
  const MatiereScreen({super.key});

  @override
  State<MatiereScreen> createState() => _MatiereScreenState();
}

class _MatiereScreenState extends State<MatiereScreen> {
  String _recherche = '';

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<QuizController>();
    final matieres = controller.matieres
        .where(
          (m) => m.nom.toLowerCase().contains(_recherche.toLowerCase()),
        )
        .toList();

    return Scaffold(
      appBar: const EduCleAppBar(labelRetour: 'Accueil'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thématiques',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              const Text(
                'Choisis la matière que tu veux réviser.',
                style: TextStyle(color: EduCleColors.textSecondary),
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (v) => setState(() => _recherche = v),
                decoration: InputDecoration(
                  hintText: 'Rechercher une matière...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: EduCleColors.surface,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: EduCleColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: EduCleColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: EduCleColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _CarteSVT(
                onTap: () async {
                  final chapitre = await context
                      .read<QuizController>()
                      .choisirThemeSVT();
                  if (!context.mounted) return;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ModeJeuScreen(chapitre: chapitre),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: matieres.isEmpty
                    ? const Center(
                        child: Text(
                          'Aucune matière disponible.',
                          style: TextStyle(color: EduCleColors.textSecondary),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              childAspectRatio: 1.05,
                            ),
                        itemCount: matieres.length,
                        itemBuilder: (context, index) {
                          final matiere = matieres[index];
                          return _CarteMatiere(
                            matiere: matiere,
                            onTap: () async {
                              await context
                                  .read<QuizController>()
                                  .choisirMatiere(matiere);
                              if (!context.mounted) return;
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const ChapitreScreen(),
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

class _CarteSVT extends StatelessWidget {
  final VoidCallback onTap;
  const _CarteSVT({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF00695C),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('🔬', style: TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SVT — Sciences de la Vie et de la Terre',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Biologie · Géologie · Astronomie réunies',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CarteMatiere extends StatelessWidget {
  final Matiere matiere;
  final VoidCallback onTap;

  const _CarteMatiere({required this.matiere, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final style = MatiereStyle.pour(matiere.nom);

    return Material(
      color: EduCleColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: EduCleColors.border),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: style.couleur.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(style.icone, color: style.couleur, size: 26),
              ),
              const SizedBox(height: 10),
              Text(
                matiere.nom,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: style.couleur,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
