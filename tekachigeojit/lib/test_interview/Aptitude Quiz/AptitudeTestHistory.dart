import 'package:flutter/material.dart';
import 'package:tekachigeojit/services/quiz/QuizHistoryService.dart';
import 'package:intl/intl.dart';
import 'package:tekachigeojit/components/ChatPages/AptitudeAttempt.dart';

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
    dynamic red = theme.colorScheme.error;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        iconTheme: IconThemeData(color: secondary),
        backgroundColor: bg,
        title: Text(
          'Aptitude Test History',
          style: theme.textTheme.titleLarge?.copyWith(color: secondary),
        ),
      ),
      body: buildBody(),
      floatingActionButton: IconButton(
        icon: Icon(Icons.delete, color: red),
        onPressed: _confirmClearConvoHistory,
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsets>(
            const EdgeInsets.all(16),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(
            theme.colorScheme.primary,
          ),
          shape: WidgetStateProperty.all<CircleBorder>(const CircleBorder()),
        ),
      ),
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

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _attempts.length,
      itemBuilder: (context, index) {
        final attempt = _attempts[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Aptitudehistory3step(attemptId: attempt['attemptId']),
                ),
              );
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
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
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: primary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      attempt['score'],
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(Icons.chevron_right, color: secondary),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmClearConvoHistory() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        dynamic primary = Theme.of(context).colorScheme.primary;
        dynamic secondary = Theme.of(context).colorScheme.secondary;
        dynamic blackbg = Theme.of(context).colorScheme.background;
        dynamic black = Theme.of(context).colorScheme.onPrimary;
        dynamic red = Theme.of(context).colorScheme.error;

        return AlertDialog(
          title: Text(
            'Clear Test History',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: primary),
          ),
          backgroundColor: blackbg,
          content: Text(
            'Are you sure you want to clear test history?',
            style: TextStyle(color: primary, fontFamily: "Trebuchet"),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: secondary),
              child: Text(
                'NO',
                style: TextStyle(color: black, fontFamily: "DelaGothicOne"),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final response = await HistoryService().deleteAttempt();
                  if (!mounted) return;
                  if (response.statusCode == 200 ||
                      response.statusCode == 204) {
                    Navigator.of(context).pop();
                    setState(() {
                      _attempts = [];
                      _isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFF8DD300),
                        content: Text(
                          'Test history cleared.',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.black),
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFF8DD300),
                        content: Text(
                          'Failed to clear history: HTTP ${response.statusCode}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.black),
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: const Color(0xFF8DD300),
                      content: Text(
                        'Failed to clear history: $e',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.black),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: red),
              child: Text(
                'YES',
                style: TextStyle(color: primary, fontFamily: "DelaGothicOne"),
              ),
            ),
          ],
        );
      },
    );
  }
}
