import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tekachigeojit/components/ChatPages/ChatHistory.dart';
import 'package:tekachigeojit/services/AuthService.dart';
import 'package:tekachigeojit/services/FullTestService.dart';
import 'package:tekachigeojit/test_interview/3%20Step%20Placement/AptitudeHistory3Step.dart';

class PlacementHistory extends StatefulWidget {
  const PlacementHistory({super.key});

  @override
  State<PlacementHistory> createState() => _PlacementHistoryState();
}

class _PlacementHistoryState extends State<PlacementHistory> {
  final user_id = AuthService().shareUserId();
  late List<Map<String, dynamic>> _attempts = [];
  final fullTestService = FullTestService();
  bool _isLoading = true;
  int index = 0;

  @override
  void initState() {
    super.initState();
    _fetchAttemptHistory();
  }

  Future<void> _fetchAttemptHistory() async {
    try {
      final attempts = await fullTestService.fetchHistory(user_id!);
      if (attempts.isEmpty) {
        debugPrint('No attempts found');
      } else {
        debugPrint('attempts found: ${attempts.length}');
      }
      setState(() {
        _attempts = attempts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        debugPrint('Searching attempts failed: $e');
      });
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMMM dd').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color bg = theme.colorScheme.background;
    final Color lime = theme.colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bg,
        iconTheme: IconThemeData(color: lime),
        title: Text(
          '3 Step Test History',
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
      body: buildBody(),
      floatingActionButton: IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: confirmDelete,
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_attempts.isEmpty) {
      return const Center(
        child: Text('No attempts found', style: TextStyle(color: Colors.white)),
      );
    } else {
      return ListView.builder(
        itemCount: _attempts.length,
        itemBuilder: (context, index) {
          final attempt = _attempts[index];
          return attemptCard(
            attempt['testId'],
            attempt['attemptedOn'],
            attempt['attemptId'],
            attempt['score']?.toString(),
            attempt['techConversationId'],
            attempt['techVerdict'],
            attempt['hrConversationId'],
            attempt['hrVerdict'],
          );
        },
      );
    }
  }

  Widget attemptCard(
    int testId,
    String attemptedOn,
    int? attemptId,
    String? score,
    int? tech_id,
    String? techVerdict,
    int? hr_id,
    String? hrVerdict,
  ) {
    final theme = Theme.of(context);
    final Color bg = theme.colorScheme.background;
    final Color lime = theme.colorScheme.secondary;

    return Container(
      height: 320,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: lime, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatDate(attemptedOn),
            style: theme.textTheme.titleMedium?.copyWith(color: lime),
          ),

          if (hrVerdict == 'HIRED' && techVerdict == 'HIRED')
            Text("HIRED", style: theme.textTheme.titleSmall)
          else
            Text(
              "NOT HIRED",
              style: theme.textTheme.titleSmall?.copyWith(color: Colors.red),
            ),

          Container(
            margin: EdgeInsets.only(top: 20, bottom: 5),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: lime, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: lime,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Aptitude\nTest",
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),

                  ElevatedButton(
                    onPressed: attemptId == null
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Aptitudehistory3step(attemptId: attemptId),
                              ),
                            );
                          },
                    child: Text(
                      attemptId == null ? "FAILED" : (score ?? "INCOMPLETE"),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: lime,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 160,
                height: 100,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    backgroundColor: lime,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: tech_id == null
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatHistory(conv_id: tech_id, personaId: 2),
                            ),
                          );
                        },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Technical", style: theme.textTheme.bodyMedium),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bg,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 4,
                          ),
                        ),
                        onPressed: tech_id == null
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatHistory(
                                      conv_id: tech_id,
                                      personaId: 2,
                                    ),
                                  ),
                                );
                              },

                        child: Text(
                          techVerdict ?? "FAILED",
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: lime,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 160,
                height: 100,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    backgroundColor: lime,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: hr_id == null
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatHistory(conv_id: hr_id, personaId: 3),
                            ),
                          );
                        },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("HR Interview", style: theme.textTheme.bodyMedium),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bg,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 4,
                          ),
                        ),
                        onPressed: hr_id == null
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatHistory(
                                      conv_id: hr_id,
                                      personaId: 3,
                                    ),
                                  ),
                                );
                              },
                        child: Text(
                          hrVerdict ?? "FAILED",
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: lime,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void confirmDelete() {
    final theme = Theme.of(context);
    final Color primary = theme.colorScheme.primary;
    final Color secondary = theme.colorScheme.secondary;
    final Color background = theme.colorScheme.background;
    final Color error = theme.colorScheme.error;
    final Color onPrimary = theme.colorScheme.onPrimary;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: background,
          title: Text(
            'Clear 3 Step History',
            style: theme.textTheme.bodyLarge?.copyWith(color: primary),
          ),
          content: Text(
            'Are you sure you want to clear all attempts?',
            style: theme.textTheme.bodyLarge?.copyWith(color: primary),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: secondary),
              child: Text(
                'CANCEL',
                style: TextStyle(color: onPrimary, fontFamily: 'DelaGothicOne'),
              ),
            ),
            SizedBox.fromSize(size: const Size.fromHeight(10)),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteHistory();
              },
              style: ElevatedButton.styleFrom(backgroundColor: error),
              child: Text(
                'CLEAR',
                style: TextStyle(color: primary, fontFamily: 'DelaGothicOne'),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteHistory() async {
    if (user_id == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF8DD300),
          content: Text(
            'User not authenticated.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.black),
          ),
        ),
      );
      return;
    }

    try {
      final response = await fullTestService.deleteAttempts(user_id!);
      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          _attempts = [];
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF8DD300),
            content: Text(
              '3 step history cleared.',
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
  }
}
