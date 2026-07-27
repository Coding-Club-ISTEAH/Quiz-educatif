import 'package:flutter/material.dart';

import '../../models/chapitre.dart';
import '../../theme/app_theme.dart';
import '../widgets/educle_app_bar.dart';

/// UC2 - Consulter les cartes mentales/reminders.
class CartesMentalesScreen extends StatefulWidget {
  final Chapitre chapitre;

  const CartesMentalesScreen({super.key, required this.chapitre});

  @override
  State<CartesMentalesScreen> createState() => _CartesMentalesScreenState();
}

class _CartesMentalesScreenState extends State<CartesMentalesScreen> {
  final _controller = PageController();
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final cartes = widget.chapitre.cartesMentales;

    return Scaffold(
      appBar: const EduCleAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Text(
                widget.chapitre.titre,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: cartes.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, index) {
                  final carte = cartes[index];
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: EduCleColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: EduCleColors.border),
                      ),
                      child: Center(
                        child: Text(
                          carte.contenu,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '${_page + 1} / ${cartes.length}',
                style: const TextStyle(
                  color: EduCleColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
