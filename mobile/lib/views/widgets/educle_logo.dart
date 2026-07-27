import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// Logo "E EduClé" repris de l'en-tête du site web, utilisé sur les
/// différents écrans mobiles pour garder une identité visuelle cohérente.
class EduCleLogo extends StatelessWidget {
  final double taille;
  final bool afficherTexte;

  const EduCleLogo({super.key, this.taille = 28, this.afficherTexte = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: taille,
          height: taille,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: EduCleColors.primary,
            borderRadius: BorderRadius.circular(taille * 0.28),
          ),
          child: Text(
            'E',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: taille * 0.55,
            ),
          ),
        ),
        if (afficherTexte) ...[
          const SizedBox(width: 8),
          Text(
            'EduClé',
            style: TextStyle(
              fontSize: taille * 0.6,
              fontWeight: FontWeight.w800,
              color: EduCleColors.textPrimary,
            ),
          ),
        ],
      ],
    );
  }
}
