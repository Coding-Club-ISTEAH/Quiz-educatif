import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/quiz_controller.dart';
import '../../theme/app_theme.dart';
import 'home_screen.dart';

const List<String> _kPays = [
  'Haïti', 'Rép. Dominicaine', 'États-Unis', 'Canada', 'France', 'Belgique',
];

const Map<String, List<String>> _kRegions = {
  'Haïti': [
    'Artibonite', 'Centre', 'Grand\'Anse', 'Nippes',
    'Nord', 'Nord-Est', 'Nord-Ouest', 'Ouest', 'Sud', 'Sud-Est',
  ],
  'Rép. Dominicaine': [
    'Cibao Norte', 'Cibao Sur', 'Cibao Nordeste', 'Cibao Noroeste',
    'Valdesia', 'Enriquillo', 'El Valle', 'Yuma', 'Higuamo', 'Ozama',
  ],
  'États-Unis': [
    'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'Californie', 'Caroline du Nord',
    'Caroline du Sud', 'Colorado', 'Connecticut', 'Dakota du Nord', 'Dakota du Sud',
    'Delaware', 'Floride', 'Géorgie', 'Hawaï', 'Idaho', 'Illinois', 'Indiana',
    'Iowa', 'Kansas', 'Kentucky', 'Louisiane', 'Maine', 'Maryland', 'Massachusetts',
    'Michigan', 'Minnesota', 'Mississippi', 'Missouri', 'Montana', 'Nebraska',
    'Nevada', 'New Hampshire', 'New Jersey', 'New Mexico', 'New York', 'Ohio',
    'Oklahoma', 'Oregon', 'Pennsylvanie', 'Rhode Island', 'Tennessee', 'Texas',
    'Utah', 'Vermont', 'Virginie', 'Washington', 'Virginie-Occidentale', 'Wisconsin',
    'Wyoming',
  ],
  'Canada': [
    'Alberta', 'Colombie-Britannique', 'Manitoba', 'Nouveau-Brunswick',
    'Terre-Neuve-et-Labrador', 'Nouvelle-Écosse', 'Ontario',
    'Île-du-Prince-Édouard', 'Québec', 'Saskatchewan',
    'Territoires du Nord-Ouest', 'Nunavut', 'Yukon',
  ],
  'France': [
    'Auvergne-Rhône-Alpes', 'Bourgogne-Franche-Comté', 'Bretagne',
    'Centre-Val de Loire', 'Corse', 'Grand Est', 'Hauts-de-France',
    'Île-de-France', 'Normandie', 'Nouvelle-Aquitaine', 'Occitanie',
    'Pays de la Loire', "Provence-Alpes-Côte d'Azur",
    'Guadeloupe', 'Martinique', 'Guyane', 'La Réunion', 'Mayotte',
  ],
  'Belgique': [
    'Anvers', 'Brabant flamand', 'Brabant wallon', 'Bruxelles-Capitale',
    'Flandre occidentale', 'Flandre orientale', 'Hainaut',
    'Liège', 'Limbourg', 'Luxembourg', 'Namur',
  ],
};

String _labelRegion(String pays) {
  switch (pays) {
    case 'Haïti': return 'Département';
    case 'États-Unis': return 'État';
    case 'Canada': return 'Province / Territoire';
    default: return 'Région';
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _pageCourante = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _allerPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _terminer() async {
    final ctrl = context.read<QuizController>();
    await ctrl.marquerProfilConfigure();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (p) => setState(() => _pageCourante = p),
                children: [
                  _pageBienvenue(),
                  _pageNiveau(),
                  _pageZone(),
                ],
              ),
            ),
            _BarreNavigation(
              pageCourante: _pageCourante,
              nbPages: 3,
              onSuivant: () {
                if (_pageCourante < 2) {
                  _allerPage(_pageCourante + 1);
                } else {
                  _terminer();
                }
              },
              onPasser: _pageCourante == 2 ? _terminer : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _pageBienvenue() {
    return Container(
      decoration: const BoxDecoration(gradient: EduCleColors.bannerGradient),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(26),
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 48,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'EduClé',
            style: TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Ton compagnon de révision',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _FeatBadge(icone: Icons.bolt_rounded, label: 'Rapide'),
              SizedBox(width: 16),
              _FeatBadge(icone: Icons.wifi_off_rounded, label: 'Hors-ligne'),
              SizedBox(width: 16),
              _FeatBadge(icone: Icons.verified_rounded, label: 'Amusant'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pageNiveau() {
    final ctrl = context.watch<QuizController>();
    final annees = ctrl.niveauScolaire == 'Secondaire'
        ? ['NS1', 'NS2', 'NS3', 'NS4']
        : ['7e AF', '8e AF', '9e AF'];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ton niveau',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'On affichera uniquement les matières qui correspondent à ton cycle.',
            style: TextStyle(
              color: EduCleColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          const _LabelSection(texte: 'Cycle'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ChipCycle(
                  label: 'Fondamental',
                  sousTitre: '7e à 9e AF',
                  selectionne: ctrl.niveauScolaire == 'Fondamental',
                  onTap: () => context
                      .read<QuizController>()
                      .changerNiveauScolaire('Fondamental'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ChipCycle(
                  label: 'Secondaire',
                  sousTitre: 'NS1 à NS4',
                  selectionne: ctrl.niveauScolaire == 'Secondaire',
                  onTap: () => context
                      .read<QuizController>()
                      .changerNiveauScolaire('Secondaire'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const _LabelSection(texte: 'Année'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: annees
                .map((a) => _ChipChoix(
                      label: a,
                      selectionne: ctrl.annee == a,
                      onTap: () =>
                          context.read<QuizController>().changerAnnee(a),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _pageZone() {
    final ctrl = context.watch<QuizController>();
    final regions = _kRegions[ctrl.pays] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ta zone',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pour te comparer avec des élèves de ta région.',
            style: TextStyle(
              color: EduCleColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Optionnel — tu pourras le modifier dans les réglages.',
            style: TextStyle(
              color: EduCleColors.textSecondary,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 28),
          const _LabelSection(texte: 'Pays'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _kPays
                .map((p) => _ChipChoix(
                      label: p,
                      selectionne: ctrl.pays == p,
                      onTap: () => context.read<QuizController>().changerPays(p),
                    ))
                .toList(),
          ),
          if (regions.isNotEmpty) ...[
            const SizedBox(height: 24),
            _LabelSection(texte: _labelRegion(ctrl.pays)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: regions
                  .map((r) => _ChipChoix(
                        label: r,
                        selectionne: ctrl.ville == r,
                        onTap: () =>
                            context.read<QuizController>().changerVille(r),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _BarreNavigation extends StatelessWidget {
  final int pageCourante;
  final int nbPages;
  final VoidCallback onSuivant;
  final VoidCallback? onPasser;

  const _BarreNavigation({
    required this.pageCourante,
    required this.nbPages,
    required this.onSuivant,
    this.onPasser,
  });

  @override
  Widget build(BuildContext context) {
    final estDernierePage = pageCourante == nbPages - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: const BoxDecoration(
        color: EduCleColors.surface,
        border: Border(top: BorderSide(color: EduCleColors.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(nbPages, (i) {
              final actif = i == pageCourante;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: actif ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: actif
                      ? EduCleColors.primary
                      : EduCleColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onSuivant,
            child: Text(estDernierePage ? 'Commencer' : 'Suivant'),
          ),
          if (onPasser != null) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: onPasser,
              child: const Text('Passer'),
            ),
          ],
        ],
      ),
    );
  }
}

class _FeatBadge extends StatelessWidget {
  final IconData icone;
  final String label;

  const _FeatBadge({required this.icone, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icone, color: Colors.white70, size: 26),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ChipCycle extends StatelessWidget {
  final String label;
  final String sousTitre;
  final bool selectionne;
  final VoidCallback onTap;

  const _ChipCycle({
    required this.label,
    required this.sousTitre,
    required this.selectionne,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: selectionne ? EduCleColors.primary : EduCleColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selectionne ? EduCleColors.primary : EduCleColors.border,
            width: selectionne ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: selectionne ? Colors.white : EduCleColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sousTitre,
              style: TextStyle(
                fontSize: 12,
                color: selectionne ? Colors.white70 : EduCleColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChipChoix extends StatelessWidget {
  final String label;
  final bool selectionne;
  final VoidCallback onTap;

  const _ChipChoix({
    required this.label,
    required this.selectionne,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        decoration: BoxDecoration(
          color: selectionne ? EduCleColors.primary : EduCleColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selectionne ? EduCleColors.primary : EduCleColors.border,
            width: selectionne ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: selectionne ? Colors.white : EduCleColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _LabelSection extends StatelessWidget {
  final String texte;
  const _LabelSection({required this.texte});

  @override
  Widget build(BuildContext context) {
    return Text(
      texte.toUpperCase(),
      style: const TextStyle(
        color: EduCleColors.textSecondary,
        fontWeight: FontWeight.w700,
        fontSize: 11,
        letterSpacing: 0.6,
      ),
    );
  }
}

