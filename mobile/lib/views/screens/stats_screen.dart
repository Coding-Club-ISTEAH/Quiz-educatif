import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/quiz_controller.dart';
import '../../theme/app_theme.dart';
import '../widgets/educle_app_bar.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  late Future<Map<String, dynamic>> _statsGlobalesFuture;
  late Future<List<Map<String, dynamic>>> _statsByMatiereFuture;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  void _charger() {
    final controller = context.read<QuizController>();
    _statsGlobalesFuture = controller.getStatsGlobales();
    _statsByMatiereFuture = controller.getStatsByMatiere();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EduCleAppBar(labelRetour: 'Retour'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => setState(_charger),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
            children: [
              Text(
                'Statistiques',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              FutureBuilder<Map<String, dynamic>>(
                future: _statsGlobalesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final stats = snapshot.data ?? {};
                  final nbQuiz = stats['nb_quiz'] as int? ?? 0;
                  final scoreTotal = stats['score_total'] as int? ?? 0;
                  final totalCorrectes = stats['total_correctes'] as int? ?? 0;
                  final totalQuestions = stats['total_questions'] as int? ?? 0;
                  final tauxGlobal = totalQuestions > 0
                      ? totalCorrectes / totalQuestions
                      : 0.0;

                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _CarteStatGlobale(
                              icone: Icons.emoji_events_rounded,
                              couleur: EduCleColors.primary,
                              label: 'Score total',
                              valeur: '$scoreTotal pts',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _CarteStatGlobale(
                              icone: Icons.quiz_rounded,
                              couleur: const Color(0xFF10B981),
                              label: 'Quiz joués',
                              valeur: '$nbQuiz',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _CarteReussite(
                        nbCorrectes: totalCorrectes,
                        nbTotal: totalQuestions,
                        ratio: tauxGlobal,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),
              const _SectionTitre(titre: 'MAÎTRISE PAR MATIÈRE'),
              const SizedBox(height: 12),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _statsByMatiereFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final stats = snapshot.data ?? [];
                  if (stats.isEmpty) {
                    return const _MessageVide(
                      message: 'Lance ton premier quiz pour voir tes statistiques ici.',
                    );
                  }
                  return Column(
                    children: stats.map((row) {
                      final nom = row['nom'] as String;
                      final nbCorrect = row['nb_correctes'] as int? ?? 0;
                      final nbTotal = row['nb_total'] as int? ?? 0;
                      final scoreTotal = row['score_total'] as int? ?? 0;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _CarteMaitrise(
                          nom: nom,
                          nbCorrectes: nbCorrect,
                          nbTotal: nbTotal,
                          scoreTotal: scoreTotal,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitre extends StatelessWidget {
  final String titre;
  const _SectionTitre({required this.titre});

  @override
  Widget build(BuildContext context) {
    return Text(
      titre,
      style: const TextStyle(
        color: EduCleColors.textSecondary,
        fontWeight: FontWeight.w700,
        fontSize: 12,
        letterSpacing: 0.6,
      ),
    );
  }
}

class _CarteStatGlobale extends StatelessWidget {
  final IconData icone;
  final Color couleur;
  final String label;
  final String valeur;

  const _CarteStatGlobale({
    required this.icone,
    required this.couleur,
    required this.label,
    required this.valeur,
  });

  @override
  Widget build(BuildContext context) {
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: couleur.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icone, color: couleur, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            valeur,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: EduCleColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _CarteReussite extends StatelessWidget {
  final int nbCorrectes;
  final int nbTotal;
  final double ratio;

  const _CarteReussite({
    required this.nbCorrectes,
    required this.nbTotal,
    required this.ratio,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EduCleColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EduCleColors.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: ratio,
                  strokeWidth: 6,
                  backgroundColor: EduCleColors.border,
                  color: EduCleColors.primary,
                ),
                Text(
                  '${(ratio * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Taux de réussite global',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$nbCorrectes bonnes réponses sur $nbTotal',
                style: const TextStyle(
                  color: EduCleColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CarteMaitrise extends StatelessWidget {
  final String nom;
  final int nbCorrectes;
  final int nbTotal;
  final int scoreTotal;

  const _CarteMaitrise({
    required this.nom,
    required this.nbCorrectes,
    required this.nbTotal,
    required this.scoreTotal,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = nbTotal > 0 ? nbCorrectes / nbTotal : 0.0;
    final emoji = MatiereStyle.emojiPour(nom);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: EduCleColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: EduCleColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  nom,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                '$scoreTotal pts',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: EduCleColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6,
              backgroundColor: EduCleColors.border,
              color: EduCleColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                nbTotal > 0
                    ? '$nbCorrectes / $nbTotal bonnes réponses'
                    : 'Pas encore joué',
                style: const TextStyle(
                  color: EduCleColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              Text(
                '${(ratio * 100).round()}%',
                style: const TextStyle(
                  color: EduCleColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MessageVide extends StatelessWidget {
  final String message;
  const _MessageVide({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          const Icon(
            Icons.bar_chart_rounded,
            size: 48,
            color: EduCleColors.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: EduCleColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
