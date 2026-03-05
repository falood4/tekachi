import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tekachigeojit/components/ChatBubble.dart';
import 'package:tekachigeojit/services/ChatService.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({super.key, required this.conv_id, required this.date});
  final int conv_id;
  final String date;

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  final Chatservice _chatService = Chatservice();
  late List<Map<String, dynamic>> _attempts = [];
  late bool _isLoading = true;
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
        debugPrint('Searching messages failed: $e');
      });
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy, hh:mm').format(date);
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
          _formatDate(widget.date),
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

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _attempts.length,
      itemBuilder: (context, index) {
        final attempt = _attempts[index];
        return _buildMessage(attempt['content'], attempt['role']);
      },
    );
  }

  Widget _buildMessage(String text, String isUser) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      alignment: isUser == "USER"
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: ChatBubble(message_text: text, isUser: isUser),
    );
  }
}
