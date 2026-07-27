import 'package:flutter/material.dart';

/// Palette et styles inspirés du design web d'EduClé, adaptés au mobile.
class EduCleColors {
  EduCleColors._();

  static const Color primary = Color(0xFF2F6FED);
  static const Color primaryDark = Color(0xFF101B33);
  static const Color primaryDarkEnd = Color(0xFF1F3A66);

  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Colors.white;
  static const Color border = Color(0xFFE3E6EC);

  static const Color textPrimary = Color(0xFF10131A);
  static const Color textSecondary = Color(0xFF6B7280);

  static const Color success = Color(0xFF16A34A);
  static const Color successBg = Color(0xFFE9F9EF);
  static const Color error = Color(0xFFDC2626);
  static const Color errorBg = Color(0xFFFCEBEB);

  static const Color rush = Color(0xFFE53935);
  static const Color revision = Color(0xFF2F6FED);
  static const Color bombardement = Color(0xFF111827);

  static const LinearGradient bannerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primaryDarkEnd],
  );
}

/// Icône + couleur associées à une matière, pour retrouver l'esprit de la
/// grille "Thématiques" du site web sur les listes mobiles.
class MatiereStyle {
  final IconData icone;
  final Color couleur;

  const MatiereStyle(this.icone, this.couleur);

  static const MatiereStyle _defaut = MatiereStyle(
    Icons.menu_book_rounded,
    EduCleColors.primary,
  );

  static const Map<String, MatiereStyle> _styles = {
    'mathématiques': MatiereStyle(Icons.calculate_rounded, Color(0xFF2F6FED)),
    'mathematiques': MatiereStyle(Icons.calculate_rounded, Color(0xFF2F6FED)),
    'français': MatiereStyle(Icons.menu_book_rounded, Color(0xFF1E3A8A)),
    'francais': MatiereStyle(Icons.menu_book_rounded, Color(0xFF1E3A8A)),
    'biologie': MatiereStyle(Icons.biotech_rounded, Color(0xFF2E7D32)),
    'géologie': MatiereStyle(Icons.terrain_rounded, Color(0xFF795548)),
    'geologie': MatiereStyle(Icons.terrain_rounded, Color(0xFF795548)),
    'sciences sociales': MatiereStyle(Icons.map_rounded, Color(0xFF1565C0)),
    "histoire d'haïti": MatiereStyle(Icons.account_balance_rounded, Color(0xFF7B241C)),
    'histoire universelle': MatiereStyle(Icons.public_rounded, Color(0xFF5E35B1)),
    'littérature haïtienne': MatiereStyle(Icons.auto_stories_rounded, Color(0xFF8E24AA)),
    'litterature haitienne': MatiereStyle(Icons.auto_stories_rounded, Color(0xFF8E24AA)),
    'littérature universelle': MatiereStyle(Icons.auto_stories_rounded, Color(0xFF6A1B9A)),
    'litterature universelle': MatiereStyle(Icons.auto_stories_rounded, Color(0xFF6A1B9A)),
    'espagnol': MatiereStyle(Icons.language_rounded, Color(0xFFD32F2F)),
    'anglais': MatiereStyle(Icons.abc_rounded, Color(0xFF37474F)),
    'chimie': MatiereStyle(Icons.science_outlined, Color(0xFF6A1B9A)),
    'physique': MatiereStyle(Icons.bolt_rounded, Color(0xFF5E35B1)),
    'connaissances générales': MatiereStyle(
      Icons.lightbulb_rounded,
      Color(0xFFF9A825),
    ),
    'connaissances generales': MatiereStyle(
      Icons.lightbulb_rounded,
      Color(0xFFF9A825),
    ),
    'eps': MatiereStyle(Icons.directions_run_rounded, Color(0xFFEF6C00)),
    'eea': MatiereStyle(Icons.eco_rounded, Color(0xFF2E7D32)),
    'culture générale': MatiereStyle(Icons.lightbulb_rounded, Color(0xFFF9A825)),
    'culture generale': MatiereStyle(Icons.lightbulb_rounded, Color(0xFFF9A825)),
    'svt': MatiereStyle(Icons.biotech_rounded, Color(0xFF00695C)),
    'astronomie': MatiereStyle(Icons.stars_rounded, Color(0xFF283593)),
  };

  static MatiereStyle pour(String nom) {
    return _styles[nom.toLowerCase().trim()] ?? _defaut;
  }

  static const Map<String, String> _emojis = {
    'mathématiques': '🧮',
    'mathematiques': '🧮',
    'français': '📖',
    'francais': '📖',
    'biologie': '🧬',
    'géologie': '🪨',
    'geologie': '🪨',
    'sciences sociales': '🗺️',
    "histoire d'haïti": '📜',
    'histoire universelle': '🌍',
    'littérature haïtienne': '🪶',
    'litterature haitienne': '🪶',
    'littérature universelle': '📚',
    'litterature universelle': '📚',
    'chimie': '⚗️',
    'physique': '⚛️',
    'connaissances générales': '💡',
    'connaissances generales': '💡',
    'eps': '🏃',
    'eea': '🎨',
    'etap': '🛠️',
    'ec': '⚖️',
    'culture générale': '💡',
    'culture generale': '💡',
    'svt': '🔬',
    'astronomie': '🔭',
  };

  static String emojiPour(String nom) {
    return _emojis[nom.toLowerCase().trim()] ?? '📚';
  }

  static const Map<String, String> _images = {
    'mathématiques':                                         'assets/matieres/Maths.jpg',
    'communication française':                               'assets/matieres/comm_francaise.webp',
    'communication créole':                                  'assets/matieres/Creole.webp',
    'éducation à la citoyenneté':                           'assets/matieres/citoyennete.webp',
    'éducation esthétique et artistique':                   'assets/matieres/artist_palette_3d.png',
    'éducation physique et sportive':                       'assets/matieres/eps.jpg',
    'biologie':                                             'assets/matieres/biologie.jpg',
    'géologie':                                             'assets/matieres/geologie.jpg',
    'sciences sociales':                                    'assets/matieres/Geographie.jpg',
    'éducation à la technologie et aux activités productives': 'assets/matieres/etap.jpg',
    'physique':                                             'assets/matieres/physique.jpg',
    'chimie':                                               'assets/matieres/chimie.webp',
    "histoire d'haïti":                                     'assets/matieres/Histoire_Haiti.webp',
    'histoire universelle':                                  'assets/matieres/Histoire_Uni.jpg',
    'économie':                                             'assets/matieres/economie.webp',
    'philosophie':                                          'assets/matieres/philosophie.jpg',
    'informatique':                                         'assets/matieres/informatique.jpg',
    'littérature haïtienne':                                'assets/matieres/Litterature_Haiti.webp',
    'littérature universelle':                              'assets/matieres/Litterature_Uni.jpg',
    'culture générale':                                     'assets/matieres/Culture_gen.webp',
  };

  static String? imagePour(String nom) => _images[nom.toLowerCase().trim()];
}

ThemeData buildEduCleTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: EduCleColors.primary,
    primary: EduCleColors.primary,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: EduCleColors.background,
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontWeight: FontWeight.w800,
        color: EduCleColors.textPrimary,
      ),
      headlineSmall: TextStyle(
        fontWeight: FontWeight.w800,
        color: EduCleColors.textPrimary,
      ),
      titleLarge: TextStyle(
        fontWeight: FontWeight.w800,
        color: EduCleColors.textPrimary,
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.w700,
        color: EduCleColors.textPrimary,
      ),
      bodyMedium: TextStyle(color: EduCleColors.textPrimary),
      bodySmall: TextStyle(color: EduCleColors.textSecondary),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: EduCleColors.background,
      foregroundColor: EduCleColors.textPrimary,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: EduCleColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: EduCleColors.border),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: EduCleColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: EduCleColors.primary,
        side: const BorderSide(color: EduCleColors.primary, width: 1.5),
        minimumSize: const Size.fromHeight(52),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: EduCleColors.primary,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: EduCleColors.border,
      thickness: 1,
      space: 1,
    ),
  );
}
