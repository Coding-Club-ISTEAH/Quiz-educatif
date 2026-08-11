import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/database_helper.dart';
import '../../theme/app_theme.dart';

const String _kAdminPassword = 'educle2025';

// ─────────────────────────────────────────────────────────────────────────────
// Entry point — shows password dialog, then body
// ─────────────────────────────────────────────────────────────────────────────

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool _authenticated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showPasswordDialog());
  }

  Future<void> _showPasswordDialog() async {
    final controller = TextEditingController();
    bool obscure = true;
    String? errorText;

    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setDialogState) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.admin_panel_settings_rounded,
                    color: EduCleColors.primary),
                SizedBox(width: 8),
                Text('Administration'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Entrez le mot de passe administrateur pour continuer.',
                  style: TextStyle(
                      color: EduCleColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  obscureText: obscure,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    errorText: errorText,
                    suffixIcon: IconButton(
                      icon: Icon(
                          obscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () =>
                          setDialogState(() => obscure = !obscure),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (_) {
                    if (controller.text == _kAdminPassword) {
                      Navigator.of(ctx).pop(true);
                    } else {
                      setDialogState(() => errorText = 'Mot de passe incorrect');
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.text == _kAdminPassword) {
                    Navigator.of(ctx).pop(true);
                  } else {
                    setDialogState(
                        () => errorText = 'Mot de passe incorrect');
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: EduCleColors.primary),
                child: const Text('Entrer',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        });
      },
    );

    if (!mounted) return;
    if (ok == true) {
      setState(() => _authenticated = true);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_authenticated) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return const _AdminBody();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Main admin body with tabs
// ─────────────────────────────────────────────────────────────────────────────

class _AdminBody extends StatelessWidget {
  const _AdminBody();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Administration'),
          backgroundColor: EduCleColors.primaryDark,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.white,
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.quiz_rounded), text: 'Questions'),
              Tab(icon: Icon(Icons.person_rounded), text: 'Utilisateur'),
              Tab(icon: Icon(Icons.bar_chart_rounded), text: 'Statistiques'),
              Tab(icon: Icon(Icons.import_export_rounded), text: 'Export/Import'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _QuestionsTab(),
            _UtilisateurTab(),
            _StatistiquesTab(),
            _ExportImportTab(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 1 — Questions CRUD
// ─────────────────────────────────────────────────────────────────────────────

class _QuestionsTab extends StatefulWidget {
  const _QuestionsTab();

  @override
  State<_QuestionsTab> createState() => _QuestionsTabState();
}

class _QuestionsTabState extends State<_QuestionsTab> {
  final _db = DatabaseHelper.instance;
  List<Map<String, dynamic>> _matieres = [];
  Map<String, dynamic>? _matiere;
  List<Map<String, dynamic>> _chapitres = [];
  Map<String, dynamic>? _chapitre;
  List<Map<String, dynamic>> _questions = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadMatieres();
  }

  Future<void> _loadMatieres() async {
    final rows = await _db.adminGetMatieres();
    setState(() => _matieres = rows);
  }

  Future<void> _selectMatiere(Map<String, dynamic> m) async {
    setState(() {
      _matiere = m;
      _chapitre = null;
      _questions = [];
      _loading = true;
    });
    final rows = await _db.adminGetChapitres(m['id'] as int);
    setState(() {
      _chapitres = rows;
      _loading = false;
    });
  }

  Future<void> _selectChapitre(Map<String, dynamic> c) async {
    setState(() {
      _chapitre = c;
      _loading = true;
    });
    final rows = await _db.adminGetQuestions(c['id'] as int);
    setState(() {
      _questions = rows;
      _loading = false;
    });
  }

  Future<void> _refresh() async {
    if (_chapitre != null) {
      final rows = await _db.adminGetQuestions(_chapitre!['id'] as int);
      setState(() => _questions = rows);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left panel — matières & chapitres
        SizedBox(
          width: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: EduCleColors.background,
                padding: const EdgeInsets.all(10),
                child: const Text('MATIÈRES',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: EduCleColors.textSecondary,
                        letterSpacing: 0.6)),
              ),
              Expanded(
                child: ListView(
                  children: [
                    for (final m in _matieres)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InkWell(
                            onTap: () => _selectMatiere(m),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              color: _matiere?['id'] == m['id']
                                  ? EduCleColors.primary.withValues(alpha: 0.1)
                                  : null,
                              child: Text(
                                m['nom'] as String,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: _matiere?['id'] == m['id']
                                      ? FontWeight.w700
                                      : FontWeight.normal,
                                  color: _matiere?['id'] == m['id']
                                      ? EduCleColors.primary
                                      : EduCleColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                          if (_matiere?['id'] == m['id'])
                            for (final c in _chapitres)
                              InkWell(
                                onTap: () => _selectChapitre(c),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 22,
                                      right: 12,
                                      top: 7,
                                      bottom: 7),
                                  color: _chapitre?['id'] == c['id']
                                      ? EduCleColors.primary.withValues(alpha: 0.08)
                                      : null,
                                  child: Text(
                                    c['titre'] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _chapitre?['id'] == c['id']
                                          ? EduCleColors.primary
                                          : EduCleColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(width: 1),
        // Right panel — questions list
        Expanded(
          child: Column(
            children: [
              if (_chapitre != null)
                Container(
                  color: EduCleColors.background,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _chapitre!['titre'] as String,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: EduCleColors.textPrimary),
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Ajouter'),
                        onPressed: () async {
                          await _showQuestionDialog(context, null);
                          await _refresh();
                        },
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _chapitre == null
                        ? Center(
                            child: Text(
                              _matiere == null
                                  ? 'Choisissez une matière'
                                  : 'Choisissez un chapitre',
                              style: const TextStyle(
                                  color: EduCleColors.textSecondary),
                            ),
                          )
                        : _questions.isEmpty
                            ? const Center(
                                child: Text('Aucune question dans ce chapitre',
                                    style: TextStyle(
                                        color: EduCleColors.textSecondary)))
                            : ListView.separated(
                                padding: const EdgeInsets.all(12),
                                itemCount: _questions.length,
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 1),
                                itemBuilder: (ctx, i) {
                                  final q = _questions[i];
                                  return ListTile(
                                    dense: true,
                                    title: Text(
                                      q['enonce'] as String,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      q['niveau_complexite'] as String,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: _complexiteColor(
                                            q['niveau_complexite'] as String),
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              size: 18,
                                              color: EduCleColors.primary),
                                          tooltip: 'Modifier',
                                          onPressed: () async {
                                            await _showQuestionDialog(
                                                context, q);
                                            await _refresh();
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              size: 18,
                                              color: EduCleColors.error),
                                          tooltip: 'Supprimer',
                                          onPressed: () async {
                                            await _confirmDelete(
                                                context, q['id'] as int);
                                            await _refresh();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _complexiteColor(String niveau) {
    switch (niveau) {
      case 'Facile':
        return EduCleColors.success;
      case 'Difficile':
        return EduCleColors.error;
      default:
        return EduCleColors.textSecondary;
    }
  }

  Future<void> _showQuestionDialog(
      BuildContext context, Map<String, dynamic>? existing) async {
    final enonce = TextEditingController(
        text: existing?['enonce'] as String? ?? '');
    final choix = List.generate(4, (i) {
      final raw = existing != null
          ? (jsonDecode(existing['choix'] as String) as List)[i] as String
          : '';
      return TextEditingController(text: raw);
    });
    final bonneReponse =
        TextEditingController(text: existing?['bonne_reponse'] as String? ?? '');
    final explication =
        TextEditingController(text: existing?['explication'] as String? ?? '');
    String niveau = existing?['niveau_complexite'] as String? ?? 'Moyen';

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setSt) {
        return AlertDialog(
          title: Text(existing == null ? 'Nouvelle question' : 'Modifier'),
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: enonce,
                    maxLines: 3,
                    decoration:
                        const InputDecoration(labelText: 'Énoncé *', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  const Text('Choix de réponse',
                      style: TextStyle(
                          fontSize: 12, color: EduCleColors.textSecondary)),
                  const SizedBox(height: 6),
                  for (int i = 0; i < 4; i++) ...[
                    TextField(
                      controller: choix[i],
                      decoration: InputDecoration(
                        labelText: 'Choix ${i + 1}',
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  TextField(
                    controller: bonneReponse,
                    decoration: const InputDecoration(
                        labelText: 'Bonne réponse *',
                        border: OutlineInputBorder(),
                        helperText: 'Doit correspondre exactement à l\'un des choix'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: explication,
                    maxLines: 2,
                    decoration: const InputDecoration(
                        labelText: 'Explication',
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: niveau,
                    decoration: const InputDecoration(
                        labelText: 'Difficulté',
                        border: OutlineInputBorder()),
                    items: ['Facile', 'Moyen', 'Difficile']
                        .map((d) =>
                            DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (v) => setSt(() => niveau = v!),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () async {
                final e = enonce.text.trim();
                final br = bonneReponse.text.trim();
                if (e.isEmpty || br.isEmpty) return;
                final c = choix.map((t) => t.text.trim()).toList();
                if (existing == null) {
                  await DatabaseHelper.instance.adminAddQuestion(
                    chapitreId: _chapitre!['id'] as int,
                    enonce: e,
                    choix: c,
                    bonneReponse: br,
                    explication: explication.text.trim(),
                    niveauComplexite: niveau,
                  );
                } else {
                  await DatabaseHelper.instance.adminUpdateQuestion(
                    id: existing['id'] as int,
                    enonce: e,
                    choix: c,
                    bonneReponse: br,
                    explication: explication.text.trim(),
                    niveauComplexite: niveau,
                  );
                }
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: EduCleColors.primary),
              child: Text(existing == null ? 'Créer' : 'Enregistrer',
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _confirmDelete(BuildContext context, int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la question ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style:
                ElevatedButton.styleFrom(backgroundColor: EduCleColors.error),
            child: const Text('Supprimer',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await DatabaseHelper.instance.adminDeleteQuestion(id);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 2 — Utilisateur & données
// ─────────────────────────────────────────────────────────────────────────────

class _UtilisateurTab extends StatefulWidget {
  const _UtilisateurTab();

  @override
  State<_UtilisateurTab> createState() => _UtilisateurTabState();
}

class _UtilisateurTabState extends State<_UtilisateurTab> {
  Map<String, dynamic>? _prefs;
  Map<String, dynamic>? _stats;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final prefs = await DatabaseHelper.instance.adminGetUserPrefs();
    final stats = await DatabaseHelper.instance.getStatsGlobales();
    setState(() {
      _prefs = prefs;
      _stats = stats;
      _loading = false;
    });
  }

  Future<void> _resetData(String table, String label) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Réinitialiser $label ?'),
        content: const Text('Toutes les données seront effacées.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style:
                ElevatedButton.styleFrom(backgroundColor: EduCleColors.error),
            child:
                const Text('Réinitialiser', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await DatabaseHelper.instance.adminResetTable(table);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label réinitialisé.')));
    }
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    final prefs = _prefs ?? {};
    final stats = _stats ?? {};
    final nbQuiz = stats['nb_quiz'] ?? 0;
    final totalQ = stats['total_questions'] ?? 0;
    final correct = stats['total_correctes'] ?? 0;
    final pct = totalQ > 0 ? (correct * 100 ~/ totalQ) : 0;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _SectionHeader(titre: 'Profil utilisateur'),
        _InfoCard(children: [
          _InfoRow('Niveau', prefs['niveau_scolaire']?.toString() ?? '-'),
          _InfoRow('Année', prefs['annee']?.toString() ?? '-'),
          _InfoRow('Pays', prefs['pays']?.toString() ?? '-'),
          _InfoRow('Région', prefs['ville']?.toString() ?? '-'),
          _InfoRow('Zone', prefs['zone']?.toString() ?? '-'),
          _InfoRow('Difficulté préférée', prefs['difficulte']?.toString() ?? '-'),
        ]),
        const SizedBox(height: 24),
        _SectionHeader(titre: 'Activité globale'),
        _InfoCard(children: [
          _InfoRow('Quiz complétés', '$nbQuiz'),
          _InfoRow('Questions répondues', '$totalQ'),
          _InfoRow('Taux de réussite', '$pct %'),
        ]),
        const SizedBox(height: 24),
        _SectionHeader(titre: 'Réinitialisation'),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: EduCleColors.border),
          ),
          child: Column(
            children: [
              _ResetTile(
                titre: 'Progression des chapitres',
                sousTitre: 'Efface les scores par chapitre',
                onReset: () => _resetData('progression', 'la progression'),
              ),
              const Divider(height: 1),
              _ResetTile(
                titre: 'Historique des scores',
                sousTitre: 'Efface tous les scores enregistrés',
                onReset: () => _resetData('scores', 'les scores'),
              ),
              const Divider(height: 1),
              _ResetTile(
                titre: 'Statistiques des questions',
                sousTitre: 'Réinitialise les compteurs par question',
                onReset: () =>
                    _resetData('statistiques_questions', 'les statistiques'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 3 — Statistiques
// ─────────────────────────────────────────────────────────────────────────────

class _StatistiquesTab extends StatefulWidget {
  const _StatistiquesTab();

  @override
  State<_StatistiquesTab> createState() => _StatistiquesTabState();
}

class _StatistiquesTabState extends State<_StatistiquesTab> {
  List<Map<String, dynamic>> _statsMatieres = [];
  List<Map<String, dynamic>> _questionsFailles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final sm = await DatabaseHelper.instance.getStatsByMatiere();
    final qf = await DatabaseHelper.instance.adminGetQuestionsFailles(limit: 10);
    setState(() {
      _statsMatieres = sm;
      _questionsFailles = qf;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _SectionHeader(titre: 'Performance par matière'),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: EduCleColors.border),
          ),
          child: Column(
            children: [
              for (int i = 0; i < _statsMatieres.length; i++) ...[
                if (i > 0) const Divider(height: 1),
                _MatiereStat(row: _statsMatieres[i]),
              ],
              if (_statsMatieres.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Aucune donnée disponible.',
                      style: TextStyle(color: EduCleColors.textSecondary)),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _SectionHeader(titre: 'Questions les plus échouées (Top 10)'),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: EduCleColors.border),
          ),
          child: Column(
            children: [
              for (int i = 0; i < _questionsFailles.length; i++) ...[
                if (i > 0) const Divider(height: 1),
                _QuestionFailleTile(row: _questionsFailles[i]),
              ],
              if (_questionsFailles.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Aucune donnée disponible.',
                      style: TextStyle(color: EduCleColors.textSecondary)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MatiereStat extends StatelessWidget {
  final Map<String, dynamic> row;
  const _MatiereStat({required this.row});

  @override
  Widget build(BuildContext context) {
    final nom = row['nom'] as String;
    final nbT = (row['nb_total'] as int?) ?? 0;
    final nbC = (row['nb_correctes'] as int?) ?? 0;
    final pct = nbT > 0 ? (nbC / nbT) : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(nom,
                      style:
                          const TextStyle(fontWeight: FontWeight.w600))),
              Text('$nbC / $nbT',
                  style: const TextStyle(
                      color: EduCleColors.textSecondary, fontSize: 13)),
              const SizedBox(width: 8),
              Text('${(pct * 100).round()} %',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: pct >= 0.7
                          ? EduCleColors.success
                          : pct >= 0.4
                              ? const Color(0xFFD97706)
                              : EduCleColors.error)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct.toDouble(),
              minHeight: 6,
              backgroundColor: EduCleColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(pct >= 0.7
                  ? EduCleColors.success
                  : pct >= 0.4
                      ? const Color(0xFFD97706)
                      : EduCleColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionFailleTile extends StatelessWidget {
  final Map<String, dynamic> row;
  const _QuestionFailleTile({required this.row});

  @override
  Widget build(BuildContext context) {
    final enonce = row['enonce'] as String;
    final nbAff = (row['nb_affichee'] as int?) ?? 0;
    final nbC = (row['nb_correcte'] as int?) ?? 0;
    final pct = nbAff > 0 ? ((nbC / nbAff) * 100).round() : 0;

    return ListTile(
      dense: true,
      title:
          Text(enonce, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text('Affiché $nbAff fois — $nbC correctes ($pct %)'),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: EduCleColors.errorBg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text('$pct %',
            style: const TextStyle(
                color: EduCleColors.error,
                fontWeight: FontWeight.w700,
                fontSize: 12)),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 4 — Export / Import
// ─────────────────────────────────────────────────────────────────────────────

class _ExportImportTab extends StatefulWidget {
  const _ExportImportTab();

  @override
  State<_ExportImportTab> createState() => _ExportImportTabState();
}

class _ExportImportTabState extends State<_ExportImportTab> {
  bool _exporting = false;
  bool _importing = false;
  String? _exportPreview;
  final _importController = TextEditingController();

  @override
  void dispose() {
    _importController.dispose();
    super.dispose();
  }

  Future<void> _export() async {
    setState(() => _exporting = true);
    try {
      final data = await DatabaseHelper.instance.adminExportQuestions();
      final json = const JsonEncoder.withIndent('  ').convert(data);
      setState(() => _exportPreview = json);
    } finally {
      setState(() => _exporting = false);
    }
  }

  Future<void> _copyToClipboard() async {
    if (_exportPreview == null) return;
    await Clipboard.setData(ClipboardData(text: _exportPreview!));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copié dans le presse-papier.')),
      );
    }
  }

  Future<void> _import() async {
    final text = _importController.text.trim();
    if (text.isEmpty) return;

    List<dynamic> parsed;
    try {
      parsed = jsonDecode(text) as List<dynamic>;
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('JSON invalide. Vérifiez le format.'),
            backgroundColor: EduCleColors.error),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Importer des questions ?'),
        content: Text(
            '${parsed.length} questions seront ajoutées dans la base de données.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
                backgroundColor: EduCleColors.primary),
            child: const Text('Importer',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _importing = true);
    int imported = 0;
    try {
      for (final item in parsed) {
        final map = item as Map<String, dynamic>;
        final chapitreId = map['chapitre_id'] as int?;
        if (chapitreId == null) continue;
        await DatabaseHelper.instance.adminAddQuestion(
          chapitreId: chapitreId,
          enonce: map['enonce'] as String? ?? '',
          choix: List<String>.from(map['choix'] as List? ?? []),
          bonneReponse: map['bonne_reponse'] as String? ?? '',
          explication: map['explication'] as String? ?? '',
          niveauComplexite: map['niveau_complexite'] as String? ?? 'Moyen',
        );
        imported++;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$imported questions importées avec succès.')),
        );
        _importController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erreur lors de l\'import : $e'),
              backgroundColor: EduCleColors.error),
        );
      }
    } finally {
      setState(() => _importing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _SectionHeader(titre: 'Exporter les questions'),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: EduCleColors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Exporte toutes les questions en JSON. Vous pouvez copier le résultat et le sauvegarder dans un fichier.',
                  style: TextStyle(
                      color: EduCleColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton.icon(
                      icon: _exporting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white))
                          : const Icon(Icons.download_rounded),
                      label: const Text('Générer l\'export',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: EduCleColors.primary),
                      onPressed: _exporting ? null : _export,
                    ),
                    if (_exportPreview != null) ...[
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.copy_rounded),
                        label: const Text('Copier'),
                        onPressed: _copyToClipboard,
                      ),
                    ],
                  ],
                ),
                if (_exportPreview != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: EduCleColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: EduCleColors.border),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        _exportPreview!,
                        style: const TextStyle(
                            fontFamily: 'monospace', fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _SectionHeader(titre: 'Importer des questions'),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: EduCleColors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Collez un tableau JSON de questions. Chaque entrée doit avoir : chapitre_id, enonce, choix (tableau de 4 réponses), bonne_reponse, explication, niveau_complexite.',
                  style: TextStyle(
                      color: EduCleColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _importController,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    hintText: '[{"chapitre_id": 1, "enonce": "...", ...}]',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: _importing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.upload_rounded),
                  label: const Text('Importer',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: EduCleColors.primary),
                  onPressed: _importing ? null : _import,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String titre;
  const _SectionHeader({required this.titre});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        titre.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: EduCleColors.textSecondary,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: EduCleColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            for (int i = 0; i < children.length; i++) ...[
              if (i > 0) const Divider(height: 1),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
              child: Text(label,
                  style: const TextStyle(
                      color: EduCleColors.textSecondary, fontSize: 13))),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: EduCleColors.textPrimary)),
        ],
      ),
    );
  }
}

class _ResetTile extends StatelessWidget {
  final String titre;
  final String sousTitre;
  final VoidCallback onReset;
  const _ResetTile(
      {required this.titre,
      required this.sousTitre,
      required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titre,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(sousTitre,
                    style: const TextStyle(
                        color: EduCleColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          TextButton(
            onPressed: onReset,
            style:
                TextButton.styleFrom(foregroundColor: EduCleColors.error),
            child: const Text('Réinitialiser'),
          ),
        ],
      ),
    );
  }
}
