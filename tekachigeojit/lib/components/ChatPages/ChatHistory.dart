import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tekachigeojit/components/Widgets/ChatBubble.dart';
import 'package:tekachigeojit/services/ChatService.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({super.key, required this.conv_id, this.personaId});
  final int? conv_id;
  final int? personaId;

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  final Chatservice _chatService = Chatservice();
  late List<Map<String, dynamic>> _attempts = [];
  bool _isLoading = true;
  int index = 0;

  @override
  void initState() {
    super.initState();
    _fetchChatHistory();
  }

  Future<void> _fetchChatHistory() async {
    try {
      final attempts = await _chatService.getChatHistory(widget.conv_id);
      if (attempts.isEmpty) {
        debugPrint('No messages found');
      } else {
        debugPrint('Messages found: ${attempts.length}');
      }
      setState(() {
        _attempts = attempts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        debugPrint('Searching messages failed: $e');
      });
    }
  }

  String _formatTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color secondary = theme.colorScheme.secondary;
    final Color bg = theme.colorScheme.background;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        title: Text(
          "Chat History",
          style: theme.textTheme.titleLarge?.copyWith(color: secondary),
        ),
        iconTheme: IconThemeData(color: secondary),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final int trimmedCount = (widget.personaId == 2 || widget.personaId == 3)
        ? 2
        : 0;
    final int itemCount = (_attempts.length - trimmedCount).clamp(
      0,
      _attempts.length,
    );

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final attempt = _attempts[index];
        return _buildMessage(
          attempt['content'],
          attempt['role'],
          attempt['createdAt'],
        );
      },
    );
  }

  Widget _buildMessage(String text, String isUser, String time) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      alignment: isUser == "USER"
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isUser == "USER"
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          ChatBubble(messageText: text, isUser: isUser),
          SizedBox(height: 5),
          Text(
            _formatTime(time),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
