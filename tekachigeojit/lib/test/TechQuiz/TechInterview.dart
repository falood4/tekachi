import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/NavBar.dart';
import 'package:tekachigeojit/components/ChatBubble.dart';
import 'package:tekachigeojit/services/ChatService.dart';

class TechInterview extends StatefulWidget {
  const TechInterview({super.key});

  @override
  State<TechInterview> createState() => _TechInterviewState();
}

class _TechInterviewState extends State<TechInterview> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocus = FocusNode();
  final List<_ChatMessage> _messages = [];

  Widget _buildMessage(String text, bool isUser) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ChatBubble(message_text: text, isUser: isUser),
    );
  }

  void _addMessage(String text, bool isUser) {
    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: isUser));
    });
  }

  Future<void> sendMessage() async {
    final String messageText = _messageController.text.trim();
    if (messageText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your reply is empty', style: TextStyle(fontSize: 14)),
        ),
      );
      return;
    }

    _addMessage(messageText, true);
    _messageController.clear();

    try {
      final String response = await Chatservice().newTechMessage(messageText);
      _addMessage(response, false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'An error occurred while sending the message. Please try again.',
          ),
        ),
      );
      debugPrint('error: $e');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = theme.colorScheme.background;
    final secondary = theme.colorScheme.secondary;
    final primary = theme.colorScheme.primary;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: background,
      bottomNavigationBar: NavBar(),
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: secondary),
          onPressed: () {
            Navigator.pop(context);
            Chatservice().endConversation();
          },
        ),
        title: Text(
          "Technical Interview",
          style: theme.textTheme.titleLarge?.copyWith(color: secondary),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessage(message.text, message.isUser);
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: screenWidth * 0.8),
                  child: TextField(
                    controller: _messageController,
                    focusNode: _messageFocus,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: primary),
                    decoration: InputDecoration(
                      hintText: 'Type your message here',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(148, 158, 158, 158),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: 50,
                  height: 50,
                  child: IconButton(
                    onPressed: () => sendMessage(),
                    icon: Icon(Icons.send_rounded, size: 30, color: primary),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        secondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  _ChatMessage({required this.text, required this.isUser});

  final String text;
  final bool isUser;
}
