import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tekachigeojit/services/ChatService.dart';
import 'package:tekachigeojit/components/ChatPages/ChatHistory.dart';

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
  bool _isLoading = true;
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
        _isLoading = false;
        debugPrint('Searching conversations failed: $e');
      });
    }
  }

  String _formatDate(String dateString) {
    //Month and Date
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMMM dd').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _formatDate2(String dateString) {
    //Time of Day
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('HH:mm a').format(date);
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
    final Color secondary = theme.colorScheme.secondary;
    final Color bg = theme.colorScheme.background;
    final Color red = theme.colorScheme.error;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        title: Text(
          fetchtitle(),
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
    final Color primary = theme.colorScheme.primary;
    final Color secondary = theme.colorScheme.secondary;
    final Color bg = theme.colorScheme.background;

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
                    personaId: widget.personaId,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatDate(attempt['createdAt']),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: primary,
                          ),
                        ),
                        Text(
                          _formatDate2(attempt['createdAt']),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(width: 16),
                Text(
                  attempt['verdict'] ?? '',
                  style:
                      (theme.textTheme.headlineLarge ??
                              theme.textTheme.bodyLarge)
                          ?.copyWith(fontSize: 18),
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
        final Color primary = Theme.of(context).colorScheme.primary;
        final Color secondary = Theme.of(context).colorScheme.secondary;
        final Color blackbg = Theme.of(context).colorScheme.background;
        final Color black = Theme.of(context).colorScheme.onPrimary;
        final Color red = Theme.of(context).colorScheme.error;

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
                Navigator.of(context).pop();
                await Chatservice().clearConvoHistory(widget.personaId);
                await _fetchConversationHistory();
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
