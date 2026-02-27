import 'package:flutter/material.dart';
import 'package:tekachigeojit/services/HistoryService.dart';
import 'package:intl/intl.dart';

class AptitudeTestHistory extends StatefulWidget {
  const AptitudeTestHistory({super.key});

  @override
  State<AptitudeTestHistory> createState() => _AptitudeTestHistoryState();
}

class _AptitudeTestHistoryState extends State<AptitudeTestHistory> {
  final HistoryService _historyService = HistoryService();
  List<Map<String, dynamic>> _attempts = [];
  bool _isLoading = true;
  int index = 0;

  @override
  void initState() {
    super.initState();
    _fetchAttemptHistory();
  }

  Future<void> _fetchAttemptHistory() async {
    try {
      final attempts = await _historyService.getAttemptHistory();
      setState(() {
        _attempts = attempts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    dynamic secondary = theme.colorScheme.secondary;
    dynamic bg = theme.colorScheme.background;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        title: Text(
          'Aptitude Test History',
          style: theme.textTheme.titleLarge?.copyWith(color: secondary),
        ),
        iconTheme: IconThemeData(color: secondary),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    final theme = Theme.of(context);
    dynamic primary = theme.colorScheme.primary;
    dynamic secondary = theme.colorScheme.secondary;
    dynamic bg = theme.colorScheme.background;

    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: secondary));
    }

    if (_attempts.isEmpty) {
      return Center(
        child: Text(
          'No attempts yet',
          style: theme.textTheme.bodyMedium?.copyWith(color: primary),
        ),
      );
    }

    final screenHeight = MediaQuery.of(context).size.height;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _attempts.length,
      itemBuilder: (context, index) {
        final attempt = _attempts[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ElevatedButton(
            onPressed: () {
              showAnswers(attempt['attemptId'], screenHeight);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: bg,
              foregroundColor: primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(color: secondary, width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: secondary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '#${index + 1}',
                    style: const TextStyle(
                      fontFamily: 'DelaGothicOne',
                      color: Color.fromRGBO(20, 20, 20, 1.0),
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  _formatDate(attempt['attemptedOn']),
                  style: theme.textTheme.bodyMedium?.copyWith(color: primary),
                ),
                const SizedBox(width: 100),
                Text(
                  attempt['score'],
                  style: theme.textTheme.headlineLarge?.copyWith(fontSize: 22),
                ),
                const SizedBox(width: 10),
                Icon(Icons.chevron_right, color: secondary),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showAnswers(int attemptId, double screenheight) async {
    final List<Map<String, dynamic>> reviewAnswers = await HistoryService()
        .getAttemptAnswers(attemptId);
    final bg = Theme.of(context).colorScheme.background;
    final secondary = Theme.of(context).colorScheme.secondary;

    showModalBottomSheet(
      context: context,
      backgroundColor: bg,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: secondary),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: screenheight * 0.75,
              child: ListView.builder(
                itemCount: reviewAnswers.length,
                itemBuilder: (context, index) {
                  final entry = reviewAnswers[index];
                  return _answerReviewCard(index, entry['qsn'] as String, (
                    entry['userChoice'] as String,
                    entry['correctAnswer'] as String,
                  ));
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _answerReviewCard(
    int index,
    String questionText,
    (String, String) answers,
  ) {
    index++;
    dynamic primary = Theme.of(context).colorScheme.primary;
    dynamic secondary = Theme.of(context).colorScheme.secondary;
    dynamic error = Theme.of(context).colorScheme.error;

    if (answers.$1 == answers.$2) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Text(
              "$index. $questionText",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: primary),
            ),
            const SizedBox(height: 5),
            Text(
              'Your Answer: ${answers.$2} ✅',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: secondary),
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Text(
              "$index. $questionText",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: primary),
            ),
            const SizedBox(height: 5),
            Text(
              'Your Wrong Answer: ${answers.$1} ❌',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: error),
            ),
            const SizedBox(height: 5),
            Text(
              'Correct Answer: ${answers.$2}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: primary),
            ),
          ],
        ),
      );
    }
  }
}
