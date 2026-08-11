import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/quiz_controller.dart';
import '../../theme/app_theme.dart';
import 'reglages_screen.dart';

class ClassementScreen extends StatefulWidget {
  const ClassementScreen({super.key});

  @override
  State<ClassementScreen> createState() => _ClassementScreenState();
}

class _ClassementScreenState extends State<ClassementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 104,
        leading: TextButton.icon(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.chevron_left_rounded, size: 20),
          label: const Text(
            'Retour',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          style: TextButton.styleFrom(
            foregroundColor: EduCleColors.textPrimary,
          ),
        ),
        title: const Text(
          'Classement',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          unselectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          labelColor: EduCleColors.primary,
          unselectedLabelColor: EduCleColors.textSecondary,
          indicatorColor: EduCleColors.primary,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: 'Général'),
            Tab(text: 'Matières'),
            Tab(text: 'Zone'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: const [
            _OngletGeneral(),
            _OngletMatieres(),
            _OngletZone(),
          ],
        ),
      ),
    );
  }
}

class _OngletGeneral extends StatefulWidget {
  const _OngletGeneral();

  @override
  State<_OngletGeneral> createState() => _OngletGeneralState();
}

class _OngletGeneralState extends State<_OngletGeneral> {
  late Future<List<Map<String, dynamic>>> _scoresFuture;
  late Future<Map<String, dynamic>> _statsFuture;

  @override
  void initState() {
    super.initState();
    final c = context.read<QuizController>();
    _scoresFuture = c.getScores();
    _statsFuture = c.getStatsGlobales();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([_statsFuture, _scoresFuture]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data;
        final stats = (data?[0] as Map<String, dynamic>?) ?? {};
        final scores =
            (data?[1] as List<Map<String, dynamic>>?) ?? [];
        final scoreTotal = stats['score_total'] as int? ?? 0;

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          children: [
            _CarteScoreTotal(scoreTotal: scoreTotal),
            const SizedBox(height: 24),
            const _SectionTitre(titre: 'HISTORIQUE DES QUIZ'),
            const SizedBox(height: 12),
            if (scores.isEmpty)
              const _MessageVide(
                message: 'Pas encore de quiz enregistrés.\nLance un quiz pour voir ton historique !',
              )
            else
              ...scores.map((s) => _LigneScore(score: s)),
          ],
        );
      },
    );
  }
}

class _OngletMatieres extends StatefulWidget {
  const _OngletMatieres();

  @override
  State<_OngletMatieres> createState() => _OngletMatieresState();
}

class _OngletMatieresState extends State<_OngletMatieres> {
  late Future<List<Map<String, dynamic>>> _statsFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = context.read<QuizController>().getStatsByMatiere();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _statsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final stats = snapshot.data ?? [];
        final avecScores = stats.where((r) => (r['score_total'] as int? ?? 0) > 0).toList();

        if (avecScores.isEmpty) {
          return const _MessageVide(
            message: 'Lance des quiz pour voir ton classement par matière.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          itemCount: avecScores.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final row = avecScores[index];
            final nom = row['nom'] as String;
            final scoreTotal = row['score_total'] as int? ?? 0;
            final nbCorrect = row['nb_correctes'] as int? ?? 0;
            final nbTotal = row['nb_total'] as int? ?? 0;
            final emoji = MatiereStyle.emojiPour(nom);

            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: EduCleColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: index == 0
                      ? EduCleColors.primary
                      : EduCleColors.border,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: index == 0
                          ? EduCleColors.primary.withValues(alpha: 0.1)
                          : EduCleColors.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: index == 0
                            ? EduCleColors.primary
                            : EduCleColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(emoji, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nom,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '$nbCorrect / $nbTotal bonnes réponses',
                          style: const TextStyle(
                            color: EduCleColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
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
            );
          },
        );
      },
    );
  }
}

class _OngletZone extends StatelessWidget {
  const _OngletZone();

  @override
  Widget build(BuildContext context) {
    final zone = context.watch<QuizController>().zone;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: EduCleColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: EduCleColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  color: EduCleColors.primary,
                  size: 40,
                ),
                const SizedBox(height: 12),
                Text(
                  zone.isEmpty ? 'Zone non définie' : zone,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: zone.isEmpty
                        ? EduCleColors.textSecondary
                        : EduCleColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ta zone te permettra de te comparer avec des élèves de ta région.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: EduCleColors.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ReglagesScreen()),
                  ),
                  icon: const Icon(Icons.edit_rounded, size: 16),
                  label: Text(zone.isEmpty ? 'Définir ma zone' : 'Modifier ma zone'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: EduCleColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: EduCleColors.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.hourglass_top_rounded,
                  color: EduCleColors.textSecondary,
                  size: 28,
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Classement par zone',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Bientôt disponible — le classement en ligne arrivera dans une prochaine version.',
                        style: TextStyle(
                          color: EduCleColors.textSecondary,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CarteScoreTotal extends StatelessWidget {
  final int scoreTotal;
  const _CarteScoreTotal({required this.scoreTotal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: EduCleColors.bannerGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mon score total',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            '$scoreTotal pts',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Score local — cumulé depuis le début',
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _LigneScore extends StatelessWidget {
  final Map<String, dynamic> score;
  const _LigneScore({required this.score});

  @override
  Widget build(BuildContext context) {
    final pts = score['score'] as int? ?? 0;
    final mode = score['mode_nom'] as String? ?? '';
    final nbCorrect = score['nb_correctes'] as int? ?? 0;
    final nbTotal = score['nb_total'] as int? ?? 0;
    final dateStr = score['date'] as String? ?? '';
    final date = dateStr.isNotEmpty ? DateTime.tryParse(dateStr) : null;

    Color modeColor;
    switch (mode) {
      case 'Rush':
        modeColor = const Color(0xFFEF4444);
      case 'Révision':
        modeColor = const Color(0xFF10B981);
      case 'Bombardement':
        modeColor = const Color(0xFFF59E0B);
      default:
        modeColor = EduCleColors.primary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: EduCleColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EduCleColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: modeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              mode,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: modeColor,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$nbCorrect / $nbTotal bonnes réponses',
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$pts pts',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: EduCleColors.primary,
                ),
              ),
              if (date != null)
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: EduCleColors.textSecondary,
                  ),
                ),
            ],
          ),
        ],
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
            Icons.emoji_events_rounded,
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
