import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'educle_logo.dart';

/// En-tête reprenant le motif du site web : lien "< Retour" à gauche,
/// logo EduClé centré, action optionnelle à droite.
class EduCleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String labelRetour;
  final bool afficherRetour;
  final Widget? action;

  const EduCleAppBar({
    super.key,
    this.labelRetour = 'Retour',
    this.afficherRetour = true,
    this.action,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      leadingWidth: afficherRetour ? 104 : 16,
      leading: afficherRetour
          ? TextButton.icon(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.chevron_left_rounded, size: 20),
              label: Text(
                labelRetour,
                style: const TextStyle(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
              style: TextButton.styleFrom(
                foregroundColor: EduCleColors.textPrimary,
              ),
            )
          : null,
      title: const EduCleLogo(taille: 24),
      centerTitle: true,
      actions: [action ?? const SizedBox(width: 48)],
    );
  }
}
