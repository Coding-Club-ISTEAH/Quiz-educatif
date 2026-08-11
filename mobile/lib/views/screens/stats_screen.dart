import 'dart:math' as math;

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
  late Future<Map<String, dynamic>> _globaleF;
  late Future<List<Map<String, dynamic>>> _parMatiereF;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  void _charger() {
    final ctrl = context.read<QuizController>();
    _globaleF = ctrl.getMaitriseGlobale();
    _parMatiereF = ctrl.getMaitriseParMatiere();
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
              const SizedBox(height: 6),
              const Text(
                'Basé sur chaque question tentée, agrégé par chapitre puis par matière.',
                style: TextStyle(
                    color: EduCleColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 24),

              // ── Vue d'ensemble ───────────────────────────────────────────
              FutureBuilder<Map<String, dynamic>>(
                future: _globaleF,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ));
                  }
                  final g = snap.data ?? {};
                  final maitrise = (g['maitrise'] as num? ?? 0).toDouble();
                  final reussite = g['reussite'] as num?;
                  return Column(
                    children: [
                      _LegendeBandeau(),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _CarteCirculaire(
                              label: 'Maîtrise globale',
                              sousTitre:
                                  'Toutes les questions (non tentées = 0 %)',
                              valeur: maitrise / 100,
                              couleur: EduCleColors.primary,
                              tooltip:
                                  '${maitrise.round()} %',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: reussite == null
                                ? _CarteVide(
                                    label: 'Réussite',
                                    message: 'Pas encore joué',
                                  )
                                : _CarteCirculaire(
                                    label: 'Réussite',
                                    sousTitre:
                                        'Questions tentées uniquement',
                                    valeur:
                                        reussite.toDouble() / 100,
                                    couleur:
                                        const Color(0xFF10B981),
                                    tooltip:
                                        '${reussite.round()} %',
                                  ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),

              // ── Par matière ──────────────────────────────────────────────
              const _SectionTitre(titre: 'MAÎTRISE PAR MATIÈRE'),
              const SizedBox(height: 12),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _parMatiereF,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final rows = snap.data ?? [];
                  final joues =
                      rows.where((r) => (r['reussite'] != null)).toList();
                  if (joues.isEmpty) {
                    return const _MessageVide(
                      message:
                          'Lance ton premier quiz pour voir tes statistiques ici.',
                    );
                  }
                  return Column(
                    children: rows.map((row) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _CarteMaitrise(row: row),
                      );
                    }).toList(),
                  );
                },
              ),

              // ── Légende ──────────────────────────────────────────────────
              const SizedBox(height: 16),
              _Legende(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bandeau légende maîtrise vs réussite
// ─────────────────────────────────────────────────────────────────────────────

class _LegendeBandeau extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: EduCleColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: EduCleColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: const [
          Icon(Icons.info_outline_rounded,
              size: 16, color: EduCleColors.primary),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              '🧠 Maîtrise = toutes les questions  •  📊 Réussite = questions tentées',
              style: TextStyle(
                  fontSize: 12,
                  color: EduCleColors.primary,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Carte circulaire (donut)
// ─────────────────────────────────────────────────────────────────────────────

class _CarteCirculaire extends StatelessWidget {
  final String label;
  final String sousTitre;
  final double valeur; // 0.0 – 1.0
  final Color couleur;
  final String tooltip;

  const _CarteCirculaire({
    required this.label,
    required this.sousTitre,
    required this.valeur,
    required this.couleur,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (valeur * 100).round();
    final color = _couleurPourPct(pct);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EduCleColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EduCleColors.border),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: CustomPaint(
              painter: _DonutPainter(
                  valeur: valeur.clamp(0, 1).toDouble(),
                  couleur: color,
                  fond: EduCleColors.border),
              child: Center(
                child: Text(
                  '$pct%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            sousTitre,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: EduCleColors.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _CarteVide extends StatelessWidget {
  final String label;
  final String message;
  const _CarteVide({required this.label, required this.message});

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
        children: [
          const Icon(Icons.hourglass_empty_rounded,
              size: 36, color: EduCleColors.border),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: EduCleColors.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Carte par matière
// ─────────────────────────────────────────────────────────────────────────────

class _CarteMaitrise extends StatelessWidget {
  final Map<String, dynamic> row;
  const _CarteMaitrise({required this.row});

  @override
  Widget build(BuildContext context) {
    final nom = row['nom'] as String;
    final maitrise = (row['maitrise'] as num? ?? 0).toDouble();
    final reussite = row['reussite'] as num?;
    final emoji = MatiereStyle.emojiPour(nom);
    final jamaisJoue = reussite == null;
    final mPct = maitrise.round();
    final rPct = reussite?.round();
    final mColor = _couleurPourPct(mPct);

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
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),
              if (jamaisJoue)
                const Text('Pas encore joué',
                    style: TextStyle(
                        color: EduCleColors.textSecondary,
                        fontSize: 12))
              else ...[
                _BadgePct(
                  label: '🧠',
                  pct: mPct,
                  couleur: mColor,
                ),
                const SizedBox(width: 6),
                _BadgePct(
                  label: '📊',
                  pct: rPct!,
                  couleur: _couleurPourPct(rPct),
                ),
              ],
            ],
          ),
          if (!jamaisJoue) ...[
            const SizedBox(height: 10),
            // Barre maîtrise (bleu)
            _BarreDouble(
              maitrise: maitrise / 100,
              reussite: (reussite?.toDouble() ?? 0) / 100,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                _LegendePuce(
                    couleur: EduCleColors.primary, texte: 'Maîtrise $mPct %'),
                const SizedBox(width: 14),
                _LegendePuce(
                    couleur: const Color(0xFF10B981),
                    texte: 'Réussite $rPct %'),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Barre double (maîtrise en arrière-plan, réussite en avant)
// ─────────────────────────────────────────────────────────────────────────────

class _BarreDouble extends StatelessWidget {
  final double maitrise; // 0–1
  final double reussite; // 0–1

  const _BarreDouble({required this.maitrise, required this.reussite});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: maitrise.clamp(0, 1),
            minHeight: 8,
            backgroundColor: EduCleColors.border,
            valueColor:
                const AlwaysStoppedAnimation<Color>(EduCleColors.primary),
          ),
        ),
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: reussite.clamp(0, 1),
              child: Container(
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widgets utilitaires
// ─────────────────────────────────────────────────────────────────────────────

class _BadgePct extends StatelessWidget {
  final String label;
  final int pct;
  final Color couleur;
  const _BadgePct(
      {required this.label, required this.pct, required this.couleur});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: couleur.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label $pct %',
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: couleur),
      ),
    );
  }
}

class _LegendePuce extends StatelessWidget {
  final Color couleur;
  final String texte;
  const _LegendePuce({required this.couleur, required this.texte});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
              color: couleur, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 4),
        Text(texte,
            style: const TextStyle(
                fontSize: 11, color: EduCleColors.textSecondary)),
      ],
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
            Icons.query_stats_rounded,
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

class _Legende extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: EduCleColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EduCleColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Comment ça marche ?',
              style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 13)),
          SizedBox(height: 8),
          _LigneLegende(
              icone: '🧠',
              texte:
                  'Maîtrise : moyenne de toutes les questions (y compris non tentées = 0 %)'),
          SizedBox(height: 4),
          _LigneLegende(
              icone: '📊',
              texte:
                  'Réussite : moyenne uniquement des questions déjà tentées'),
          SizedBox(height: 4),
          _LigneLegende(
              icone: '📐',
              texte:
                  'Chaque niveau est la moyenne du niveau inférieur : question → chapitre → matière → global'),
        ],
      ),
    );
  }
}

class _LigneLegende extends StatelessWidget {
  final String icone;
  final String texte;
  const _LigneLegende({required this.icone, required this.texte});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(icone, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(texte,
              style: const TextStyle(
                  fontSize: 12, color: EduCleColors.textSecondary)),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Donut painter
// ─────────────────────────────────────────────────────────────────────────────

class _DonutPainter extends CustomPainter {
  final double valeur;
  final Color couleur;
  final Color fond;

  const _DonutPainter(
      {required this.valeur,
      required this.couleur,
      required this.fond});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = math.min(cx, cy) - 4;
    const stroke = 8.0;

    final paintFond = Paint()
      ..color = fond
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    final paintArc = Paint()
      ..color = couleur
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(Offset(cx, cy), r, paintFond);

    if (valeur > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        -math.pi / 2,
        2 * math.pi * valeur,
        false,
        paintArc,
      );
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.valeur != valeur || old.couleur != couleur;
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

Color _couleurPourPct(int pct) {
  if (pct >= 70) return EduCleColors.success;
  if (pct >= 40) return const Color(0xFFD97706); // amber
  return EduCleColors.error;
}
