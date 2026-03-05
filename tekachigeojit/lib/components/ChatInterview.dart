import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/NavBar.dart';
import 'package:tekachigeojit/components/ChatBubble.dart';
import 'package:tekachigeojit/services/ChatService.dart';

class ChatInterview extends StatefulWidget {
  const ChatInterview({super.key, this.initialMessage, this.personaId});

  final String? initialMessage;
  final int? personaId;

  @override
  State<ChatInterview> createState() => _ChatInterviewState();
}

class _ChatInterviewState extends State<ChatInterview> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    final String? initial = widget.initialMessage?.trim();
    if (initial != null && initial.isNotEmpty) {
      _messages.add(_ChatMessage(text: initial, isUser: "ASSISTANT"));
    }
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

  void _addMessage(String text, String isUser) {
    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: isUser));
    });
    _scrollToBottom();
  }

  

  Future<void> sendMessage() async {
    final theme = Theme.of(context);
    final String messageText = _messageController.text.trim();
    if (messageText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFF141414),
          content: Text(
            'Your reply is empty',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.black),
          ),
        ),
      );
      return;
    }

    _addMessage(messageText, "USER");
    _messageController.clear();

    try {
      if (widget.personaId == 2) {
        final String response = await Chatservice().newTechMessage(messageText);
        _addMessage(response, "ASSISTANT");
      } else {
        final String response = await Chatservice().newHrMessage(messageText);
        _addMessage(response, "ASSISTANT");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error occurred while sending the message. Please try again.',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.black),
          ),
        ),
      );
      debugPrint('error: $e');
      return;
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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
            Chatservice().clearConvId();
          },
        ),
        title: Text(
          "AI Interview",
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
                controller: _scrollController,
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
  final String isUser;
}
