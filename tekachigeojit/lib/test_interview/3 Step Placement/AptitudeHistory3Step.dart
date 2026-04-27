import 'package:flutter/material.dart';
import 'package:tekachigeojit/services/quiz/QuizHistoryService.dart';

class Aptitudehistory3step extends StatefulWidget {
  const Aptitudehistory3step({super.key, required this.attemptId});

  final int attemptId;
  @override
  State<Aptitudehistory3step> createState() => _Aptitudehistory3stepState();
}

class _Aptitudehistory3stepState extends State<Aptitudehistory3step> {
  List<Map<String, dynamic>> _answers = [];
  bool isLoading = true;
  int index = 0;

  Future<void> _fetchAptitudeHistory(int attemptId) async {
    final List<Map<String, dynamic>> answers = await HistoryService()
        .getAttemptAnswers(attemptId);
    if (answers.isEmpty) {
      debugPrint('No answers found for attemptId: $attemptId');
    } else {
      debugPrint('Answers found for attemptId $attemptId: ${answers.length}');
    }
    setState(() {
      _answers = answers;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAptitudeHistory(widget.attemptId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color bg = theme.colorScheme.background;
    final Color lime = theme.colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: lime),
        backgroundColor: bg,
        title: Text(
          'Aptitude Answers',
          style: theme.textTheme.titleLarge?.copyWith(color: lime),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: bg,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _answers.isEmpty
          ? const Center(child: Text('No answers found'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _answers.length,
              itemBuilder: (context, index) {
                final answer = _answers[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: bg,
                    border: Border.all(color: lime, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1}. ${answer['qsn'] ?? ''}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Correct: ${answer['correctAnswer'] ?? ''}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        'Your answer: ${answer['userChoice'] ?? ''}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
