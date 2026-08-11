import 'chapitre.dart';
import 'parametre_partie.dart';
import 'question.dart';
import 'reponse_enregistree.dart';
import 'resultat.dart';

/// Modèle "Quiz" du diagramme de classes.
class Quiz {
  final int id;
  final Chapitre chapitre;
  final ParametrePartie mode;
  final List<Question> questions;
  int score;
  int tempsRestant;

  int indexCourant;
  final List<Question> reponsesCorrectes;
  final List<Question> reponsesIncorrectes;
  final List<ReponseEnregistree> historique;
  bool termine;

  Quiz({
    required this.id,
    required this.chapitre,
    required this.mode,
    required this.questions,
    this.score = 0,
    int? tempsRestant,
    this.indexCourant = 0,
    List<Question>? reponsesCorrectes,
    List<Question>? reponsesIncorrectes,
    List<ReponseEnregistree>? historique,
    this.termine = false,
  }) : tempsRestant = tempsRestant ?? mode.dureeTotale ?? mode.tempsParQuestion,
       reponsesCorrectes = reponsesCorrectes ?? [],
       reponsesIncorrectes = reponsesIncorrectes ?? [],
       historique = historique ?? [];

  Question? get questionCourante =>
      indexCourant < questions.length ? questions[indexCourant] : null;

  /// + démarrer() : void
  void demarrer() {
    indexCourant = 0;
    score = 0;
    reponsesCorrectes.clear();
    reponsesIncorrectes.clear();
    termine = false;
    tempsRestant = mode.dureeTotale ?? mode.tempsParQuestion;
  }

  static double _difficulteMultiplier(String niveau) {
    switch (niveau) {
      case 'Facile':
        return 0.5;
      case 'Difficile':
        return 1.5;
      default:
        return 1.0;
    }
  }

  /// + répondre(question : Question, réponse : string) : bool
  /// [tempsRestantAuClic] est le temps restant au moment où le joueur a répondu.
  bool repondre(Question question, String reponse, int tempsRestantAuClic) {
    final correcte = question.verifierReponse(reponse);
    if (correcte) {
      final estBombardement = mode.dureeTotale != null;
      final diff = _difficulteMultiplier(question.niveauComplexite);
      final base = (10 * mode.multiplicateurScore * diff).round();
      int bonus = 0;
      if (!estBombardement && mode.tempsParQuestion > 0) {
        bonus = (tempsRestantAuClic / mode.tempsParQuestion * 10).round().clamp(0, 10);
      }
      score += base + bonus;
      reponsesCorrectes.add(question);
    } else {
      reponsesIncorrectes.add(question);
    }
    historique.add(
      ReponseEnregistree(
        question: question,
        reponseUtilisateur: reponse,
        correcte: correcte,
        tempsUtilise: mode.dureeTotale != null
            ? 0
            : mode.tempsParQuestion - tempsRestantAuClic,
      ),
    );
    return correcte;
  }

  void passerQuestionSuivante() {
    indexCourant++;
    if (mode.dureeTotale != null) {
      // Mode à durée globale (ex : Bombardement) : on boucle sur les
      // questions disponibles, seul le temps global détermine la fin.
      if (indexCourant >= questions.length) {
        indexCourant = 0;
      }
    } else if (indexCourant >= questions.length) {
      termine = true;
    } else {
      tempsRestant = mode.tempsParQuestion;
    }
  }

  /// Marque le quiz comme terminé (utilisé quand le temps global est
  /// écoulé, par exemple en mode Bombardement).
  void forcerFin() {
    termine = true;
  }

  /// + afficherRésultat() : Résultat
  Resultat afficherResultat() {
    return Resultat(
      score: score,
      total: questions.length,
      reponsesCorrectes: reponsesCorrectes,
      reponsesIncorrectes: reponsesIncorrectes,
      historique: historique,
    );
  }
}
