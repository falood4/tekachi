import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tekachigeojit/services/ChatService.dart';
import 'package:tekachigeojit/components/ChatHistory.dart';

class TechnicalInterviewHistory extends StatefulWidget {
  const TechnicalInterviewHistory({super.key, required this.personaId});
  final int personaId;

  @override
  State<TechnicalInterviewHistory> createState() =>
      _TechnicalInterviewHistoryState();
}

class _TechnicalInterviewHistoryState extends State<TechnicalInterviewHistory> {
  final Chatservice _chatService = Chatservice();
  late List<Map<String, dynamic>> _attempts = [];
  late bool _isLoading = true;
  int index = 0;

  @override
  void initState() {
    super.initState();
    _fetchConversationHistory();
  }

  Future<void> _fetchConversationHistory() async {
    try {
      final attempts = await _chatService.getConversationHistory(
        widget.personaId,
      );
      if (attempts.isEmpty) {
        debugPrint('No conversations found');
      } else {
        debugPrint('Conversations found: ${attempts.length}');
      }
      setState(() {
        _attempts = attempts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        debugPrint('Searching conversations failed: $e');
      });
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMMM dd, yyyy, HH:mm a').format(date);
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
          'Tech Interviews',
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
      return const Center(child: CircularProgressIndicator());
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
                  builder: (context) => ChatHistory(
                    conv_id: attempt['conversationId'],
                    date: attempt['createdAt'],
                  ),
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
                      _formatDate(attempt['createdAt']),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: primary,
                      ),
                    ),
                  ],
                ),

                Icon(Icons.chevron_right, color: secondary),
              ],
            ),
          ),
        );
      },
    );
  }
}
