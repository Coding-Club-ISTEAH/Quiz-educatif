import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../models/chapitre.dart';
import '../../models/question.dart';
import '../../theme/app_theme.dart';
import '../widgets/educle_app_bar.dart';
import 'mode_jeu_screen.dart';

// ──────────────────────────────────────────────────────────────────────
// UC : Mode Apprentissage
// 1. Cartes résumé  (cartes_mentales)
// 2. Flashcards Q&A (questions, retournables au tap)
// ──────────────────────────────────────────────────────────────────────

const _kPurple = Color(0xFF7B1FA2);
const _kGreen  = Color(0xFF2E7D32);

class ApprentissageScreen extends StatefulWidget {
  final Chapitre chapitre;
  const ApprentissageScreen({super.key, required this.chapitre});

  @override
  State<ApprentissageScreen> createState() => _ApprentissageScreenState();
}

class _ApprentissageScreenState extends State<ApprentissageScreen> {
  final _pageCtrl = PageController();
  int _page = 0;
  final Map<int, bool> _flipped = {}; // index question → retourné ?

  int get _nc    => widget.chapitre.cartesMentales.length;
  int get _nq    => widget.chapitre.questions.length;
  int get _total => _nc + _nq;
  bool get _onResume => _page < _nc;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _goTo(int p) => _pageCtrl.animateToPage(
        p,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );

  void _showFinSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _FinSheet(chapitre: widget.chapitre),
    );
  }

  @override
  Widget build(BuildContext context) {
    final qi      = _onResume ? 0 : _page - _nc;
    final accent  = _onResume ? _kPurple : EduCleColors.primary;
    final label   = _onResume
        ? 'Résumé  —  ${_page + 1} / $_nc'
        : 'Flashcard  —  ${qi + 1} / $_nq';
    final icon    = _onResume ? Icons.style_rounded : Icons.quiz_rounded;

    return Scaffold(
      backgroundColor: EduCleColors.background,
      appBar: const EduCleAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // ── En-tête + progression ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chapitre.titre,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(children: [
                    Icon(icon, size: 14, color: accent),
                    const SizedBox(width: 5),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: accent,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _total == 0 ? 0 : (_page + 1) / _total,
                      minHeight: 5,
                      backgroundColor: EduCleColors.border,
                      valueColor: AlwaysStoppedAnimation(accent),
                    ),
                  ),
                ],
              ),
            ),

            // ── Contenu paginé ────────────────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _pageCtrl,
                itemCount: _total,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) {
                  if (i < _nc) {
                    return _ResumePage(
                      contenu: widget.chapitre.cartesMentales[i].contenu,
                      index: i,
                      total: _nc,
                    );
                  }
                  final idx = i - _nc;
                  return _FlashPage(
                    key: ValueKey('flash_$idx'),
                    question: widget.chapitre.questions[idx],
                    isFlipped: _flipped[idx] ?? false,
                    onFlip: () => setState(
                      () => _flipped[idx] = !(_flipped[idx] ?? false),
                    ),
                  );
                },
              ),
            ),

            // ── Navigation ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Row(children: [
                if (_page > 0)
                  Expanded(
                    child: _NavBtn(
                      label: 'Précédent',
                      icon: Icons.arrow_back_rounded,
                      filled: false,
                      onTap: () => _goTo(_page - 1),
                    ),
                  )
                else
                  const Spacer(),
                const SizedBox(width: 12),
                Expanded(
                  child: _NavBtn(
                    label: _page < _total - 1 ? 'Suivant' : 'Terminer',
                    icon: _page < _total - 1
                        ? Icons.arrow_forward_rounded
                        : Icons.check_circle_rounded,
                    filled: true,
                    onTap: _page < _total - 1
                        ? () => _goTo(_page + 1)
                        : _showFinSheet,
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────
// Page résumé (carte mentale)
// ──────────────────────────────────────────────────────────────────────
class _ResumePage extends StatelessWidget {
  final String contenu;
  final int index, total;
  const _ResumePage({
    required this.contenu,
    required this.index,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: _kPurple.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _kPurple.withValues(alpha: 0.28),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _kPurple.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lightbulb_rounded,
                color: _kPurple,
                size: 28,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              contenu,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.55,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Glisse pour continuer →',
              style: TextStyle(
                fontSize: 12,
                color: _kPurple.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────
// Flashcard Q&A (retournable)
// ──────────────────────────────────────────────────────────────────────
class _FlashPage extends StatefulWidget {
  final Question question;
  final bool isFlipped;
  final VoidCallback onFlip;

  const _FlashPage({
    required this.question,
    required this.isFlipped,
    required this.onFlip,
    super.key,
  });

  @override
  State<_FlashPage> createState() => _FlashPageState();
}

class _FlashPageState extends State<_FlashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  bool _showBack = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    // Sync initial state without animation
    if (widget.isFlipped) {
      _ctrl.value = 1.0;
      _showBack = true;
    }
    _ctrl.addListener(_syncFace);
  }

  void _syncFace() {
    final newBack = _ctrl.value >= 0.5;
    if (newBack != _showBack) setState(() => _showBack = newBack);
  }

  @override
  void didUpdateWidget(_FlashPage old) {
    super.didUpdateWidget(old);
    if (widget.isFlipped != old.isFlipped) {
      widget.isFlipped ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.removeListener(_syncFace);
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: GestureDetector(
        onTap: widget.onFlip,
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) {
            // Front:  rotate 0 → π/2  (disappears to the right)
            // Back:  rotate π/2 → 0  (appears from the left, counter-flipped)
            final angle = _ctrl.value * math.pi;

            if (!_showBack) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle),
                child: _buildFront(),
              );
            } else {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle - math.pi),
                child: _buildBack(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildFront() {
    return _CardShell(
      borderColor: EduCleColors.border,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: EduCleColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.question.niveauComplexite,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: EduCleColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.question.enonce,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.touch_app_rounded,
                size: 16, color: EduCleColors.textSecondary),
            const SizedBox(width: 5),
            const Text(
              'Appuyer pour révéler la réponse',
              style: TextStyle(
                fontSize: 13,
                color: EduCleColors.textSecondary,
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildBack() {
    return _CardShell(
      borderColor: const Color(0xFF43A047).withValues(alpha: 0.45),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF43A047),
              size: 36,
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF43A047).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                widget.question.bonneReponse,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: _kGreen,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              widget.question.explication,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: EduCleColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.touch_app_rounded,
                  size: 14, color: EduCleColors.textSecondary),
              const SizedBox(width: 5),
              const Text(
                'Appuyer pour revoir la question',
                style: TextStyle(
                  fontSize: 12,
                  color: EduCleColors.textSecondary,
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────
// Conteneur carte (partagé)
// ──────────────────────────────────────────────────────────────────────
class _CardShell extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  const _CardShell({required this.child, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: EduCleColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ──────────────────────────────────────────────────────────────────────
// Bouton de navigation bas
// ──────────────────────────────────────────────────────────────────────
class _NavBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;
  const _NavBtn(
      {required this.label,
      required this.icon,
      required this.filled,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (filled) {
      return ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: EduCleColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: EduCleColors.textPrimary,
        side: const BorderSide(color: EduCleColors.border),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────
// Feuille de fin
// ──────────────────────────────────────────────────────────────────────
class _FinSheet extends StatelessWidget {
  final Chapitre chapitre;
  const _FinSheet({required this.chapitre});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: EduCleColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.celebration_rounded,
                size: 30, color: EduCleColors.primary),
          ),
          const SizedBox(height: 14),
          Text(
            'Révision terminée !',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'Tu as parcouru toutes les cartes de ce chapitre.\nPrêt(e) à te tester ?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: EduCleColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop(); // fermer le sheet
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => ModeJeuScreen(chapitre: chapitre),
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Lancer le quiz'),
              style: ElevatedButton.styleFrom(
                backgroundColor: EduCleColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.of(context)
                .popUntil((route) => route.isFirst),
            child: const Text(
              'Retour à l\'accueil',
              style: TextStyle(color: EduCleColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
