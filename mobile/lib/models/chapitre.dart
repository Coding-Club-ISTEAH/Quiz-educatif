import 'carte_mentale.dart';
import 'question.dart';

/// Modèle "Chapitre" du diagramme de classes.
class Chapitre {
  final int id;
  final String titre;
  final List<CarteMentale> cartesMentales;
  final List<Question> questions;

  Chapitre({
    required this.id,
    required this.titre,
    this.cartesMentales = const [],
    this.questions = const [],
  });

  factory Chapitre.fromMap(Map<String, dynamic> map) {
    return Chapitre(id: map['id'] as int, titre: map['titre'] as String);
  }

  Chapitre copyWith({
    List<CarteMentale>? cartesMentales,
    List<Question>? questions,
  }) {
    return Chapitre(
      id: id,
      titre: titre,
      cartesMentales: cartesMentales ?? this.cartesMentales,
      questions: questions ?? this.questions,
    );
  }
}
