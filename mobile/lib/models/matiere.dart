import 'chapitre.dart';

/// Modèle "Matière" du diagramme de classes.
class Matiere {
  final int id;
  final String nom;
  final List<Chapitre> chapitres;

  Matiere({required this.id, required this.nom, this.chapitres = const []});

  factory Matiere.fromMap(Map<String, dynamic> map) {
    return Matiere(id: map['id'] as int, nom: map['nom'] as String);
  }

  Matiere copyWith({List<Chapitre>? chapitres}) {
    return Matiere(id: id, nom: nom, chapitres: chapitres ?? this.chapitres);
  }
}
