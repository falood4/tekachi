import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tekachigeojit/services/ChatService.dart';
import 'package:tekachigeojit/components/ChatHistory.dart';

class InterviewHistory extends StatefulWidget {
  const InterviewHistory({
    super.key,
    required this.personaId,
    required this.title,
  });
  final int personaId;
  final String title;

  @override
  State<InterviewHistory> createState() => _InterviewHistoryState();
}

class _InterviewHistoryState extends State<InterviewHistory> {
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

  String fetchtitle() {
    if (widget.personaId == 1) {
      return 'Mentor History';
    } else if (widget.personaId == 2) {
      return 'Tech Interviews';
    } else {
      return 'HR Interviews';
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
        backgroundColor: bg,
        title: Text(
          fetchtitle(),
          style: theme.textTheme.titleLarge?.copyWith(color: secondary),
        ),
      ),
      body: SafeArea(child: buildBody()),
      floatingActionButton: FloatingActionButton(
        onPressed: _confirmClearConvoHistory,
        child: IconButton(
          icon: Icon(Icons.delete, color: red),
          onPressed: _confirmClearConvoHistory,
          style: ButtonStyle(
            shape: WidgetStateProperty.all<CircleBorder>(const CircleBorder()),
          ),
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
      return const Center(child: CircularProgressIndicator());
    } else if (!_isLoading && _attempts.isEmpty) {
      return Center(
        child: Text(
          'No interview history found.',
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
            'Clear Interview History',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: primary),
          ),
          backgroundColor: blackbg,
          content: Text(
            'Are you sure you want to clear interview history?',
            style: TextStyle(color: primary, fontFamily: "Trebuchet"),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: secondary),
              child: Text(
                'CANCEL',
                style: TextStyle(color: black, fontFamily: "DelaGothicOne"),
              ),
            ),
            SizedBox.fromSize(size: const Size.fromHeight(10)),
            ElevatedButton(
              onPressed: () async {
                Chatservice().clearConvoHistory(widget.personaId);
                Navigator.of(context).pop();
                await _fetchConversationHistory();
                setState(() {});
              },
              style: ElevatedButton.styleFrom(backgroundColor: red),
              child: Text(
                'CLEAR',
                style: TextStyle(color: primary, fontFamily: "DelaGothicOne"),
              ),
            ),
          ],
        );
      },
    );
  }
}
