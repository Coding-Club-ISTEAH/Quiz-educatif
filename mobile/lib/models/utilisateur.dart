import 'carte_mentale.dart';
import 'chapitre.dart';
import 'matiere.dart';
import 'parametre_partie.dart';
import 'quiz.dart';
import 'resultat.dart';

/// Modèle "Utilisateur" du diagramme de classes.
///
/// `progression` est représenté par Map&lt;int, Résultat&gt; (clé = id du
/// Chapitre) car les clés de Map Dart doivent reposer sur une égalité
/// stable ; utiliser l'id du Chapitre est la traduction technique directe
/// de Map&lt;Chapitre, Résultat&gt;.
class Utilisateur {
  final int id;
  String nom;
  String? niveau;
  String? zone;
  Matiere? matiereSelectionnee;
  Chapitre? chapitreSelectionne;
  final Map<int, Resultat> progression;
  Quiz? quizEnCours;

  Utilisateur({
    required this.id,
    required this.nom,
    this.niveau,
    this.zone,
    Map<int, Resultat>? progression,
  }) : progression = progression ?? {};

  /// + choisirNiveau(niveau : string) : void
  void choisirNiveau(String niveau) {
    this.niveau = niveau;
    matiereSelectionnee = null;
    chapitreSelectionne = null;
  }

  /// + choisirMatière(matière : Matière) : void
  void choisirMatiere(Matiere matiere) {
    matiereSelectionnee = matiere;
    chapitreSelectionne = null;
  }

  /// + choisirChapitre(chapitre : Chapitre) : void
  void choisirChapitre(Chapitre chapitre) {
    chapitreSelectionne = chapitre;
  }

  /// + lancerQuiz(mode : ModeJeu) : Quiz
  Quiz lancerQuiz(ParametrePartie mode) {
    final chapitre = chapitreSelectionne;
    if (chapitre == null) {
      throw StateError('Aucun chapitre sélectionné');
    }
    final quiz = Quiz(
      id: DateTime.now().millisecondsSinceEpoch,
      chapitre: chapitre,
      mode: mode,
      questions: List.of(chapitre.questions),
    );
    quiz.demarrer();
    quizEnCours = quiz;
    return quiz;
  }

  /// + consulterCartes(chapitre : Chapitre) : List&lt;CarteMentale&gt;
  List<CarteMentale> consulterCartes(Chapitre chapitre) {
    return chapitre.cartesMentales;
  }

  /// + reprendreQuiz() : Quiz
  Quiz reprendreQuiz() {
    final quiz = quizEnCours;
    if (quiz == null) {
      throw StateError('Aucun quiz à reprendre');
    }
    return quiz;
  }

  void enregistrerResultat(Chapitre chapitre, Resultat resultat) {
    progression[chapitre.id] = resultat;
    quizEnCours = null;
  }
}
