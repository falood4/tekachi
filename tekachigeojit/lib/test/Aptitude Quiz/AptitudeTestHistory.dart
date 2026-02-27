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
    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
        title: const Text(
          'Aptitude Test History',
          style: TextStyle(
            fontFamily: 'DelaGothicOne',
            color: Color(0xFF8DD300),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF8DD300)),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF8DD300)),
      );
    }

    if (_attempts.isEmpty) {
      return const Center(
        child: Text(
          'No attempts yet',
          style: TextStyle(
            color: Colors.white70,
            fontFamily: 'Trebuchet',
            fontSize: 18,
          ),
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
              backgroundColor: const Color.fromRGBO(35, 35, 35, 1.0),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFF8DD300), width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8DD300),
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
                  style: const TextStyle(
                    fontFamily: 'Trebuchet',
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 100),
                Text(
                  attempt['score'],
                  style: const TextStyle(
                    fontFamily: 'DelaGothicOne',
                    color: Color(0xFF8DD300),
                    fontSize: 22,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.chevron_right, color: Color(0xFF8DD300)),
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

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF8DD300)),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: screenheight * 0.6,
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
    if (answers.$1 == answers.$2) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Text(
              "$index. $questionText",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Trebuchet",
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Your Answer: ${answers.$2} ✅',
              style: TextStyle(
                color: const Color.fromARGB(255, 113, 254, 118),
                fontFamily: "Trebuchet",
                fontSize: 14,
              ),
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
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Trebuchet",
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Your Wrong Answer: ${answers.$1} ❌',
              style: TextStyle(
                color: const Color.fromARGB(255, 248, 108, 98),
                fontFamily: "Trebuchet",
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Correct Answer: ${answers.$2}',
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Trebuchet",
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }
  }
}
