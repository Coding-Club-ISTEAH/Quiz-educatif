/// Modèle "ParamètrePartie" du diagramme de classes.
class ParametrePartie {
  final int id;
  final String nom; // "Rush", "Révision", "Bombardement"
  final int tempsParQuestion;
  final bool feedbackImmediat;
  final int? dureeTotale; // optionnel, pour Bombardement
  final double multiplicateurScore;

  const ParametrePartie({
    required this.id,
    required this.nom,
    required this.tempsParQuestion,
    required this.feedbackImmediat,
    this.dureeTotale,
    required this.multiplicateurScore,
  });

  static const rush = ParametrePartie(
    id: 1,
    nom: 'Rush',
    tempsParQuestion: 10,
    feedbackImmediat: false,
    multiplicateurScore: 1.0,
  );

  static const revision = ParametrePartie(
    id: 2,
    nom: 'Révision',
    tempsParQuestion: 20,
    feedbackImmediat: true,
    multiplicateurScore: 0.5,
  );

  static const bombardement = ParametrePartie(
    id: 3,
    nom: 'Bombardement',
    tempsParQuestion: 0,
    feedbackImmediat: false,
    dureeTotale: 60,
    multiplicateurScore: 1.67,
  );

  static const modes = [rush, revision, bombardement];
}
