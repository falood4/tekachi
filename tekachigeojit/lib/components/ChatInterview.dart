import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tekachigeojit/components/NavBar.dart';
import 'package:tekachigeojit/components/ChatBubble.dart';
import 'package:tekachigeojit/services/ChatService.dart';
import 'package:tekachigeojit/services/FullTestService.dart';
import 'package:tekachigeojit/test/3%20Step%20Placement/PlacementResult.dart';

class ChatInterview extends StatefulWidget {
  const ChatInterview({
    super.key,
    this.initialMessage,
    required this.personaId,
    required this.is3step,
  });

  final String? initialMessage;
  final int? personaId;
  final bool is3step;

  @override
  State<ChatInterview> createState() => _ChatInterviewState();
}

class _ChatInterviewState extends State<ChatInterview> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _isWaiting = false;

  @override
  void initState() {
    super.initState();
    final String? initial = widget.initialMessage?.trim();
    if (initial != null && initial.isNotEmpty) {
      _messages.add(_ChatMessage(text: initial, isUser: "ASSISTANT"));
    }
  }

  Widget _buildMessage(String text, String isUser, String timestamp) {
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
            _formatTime(timestamp),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _addMessage(String text, String isUser) {
    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: isUser));
    });
    _scrollToBottom(isUser);
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
    setState(() => _isWaiting = true);

    try {
      if (widget.personaId == 2) {
        final String response = await Chatservice().newTechMessage(messageText);
        setState(() => _isWaiting = false);
        _addMessage(response, "ASSISTANT");
      } else {
        final String response = await Chatservice().newHrMessage(messageText);
        setState(() => _isWaiting = false);
        _addMessage(response, "ASSISTANT");
      }
    } catch (e) {
      setState(() => _isWaiting = false);
      if (!mounted) return;
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

  void _scrollToBottom(String isUser) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && isUser == "USER") {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.pixels + 500,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }

  Future<void> _handleContinue(BuildContext context) async {
    try {
      final String verdict = await Chatservice().getVerdict();
      if (widget.personaId == 2) {
        FullTestService().setTechChatId(Chatservice().shareConvId());

        if (!mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Loading interview...',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        }
        final String reply = await Chatservice().startConversation(3);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ChatInterview(
              initialMessage: reply,
              personaId: 3,
              is3step: true,
            ),
          ),
        );
      } else if (widget.personaId == 3) {
        FullTestService().setHRVerdict(verdict);
        FullTestService().setHrChatId(Chatservice().shareConvId());
        Chatservice().clearConvId();

        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const PlacementResult()),
        );
      }
    } catch (e) {
      debugPrint('Continue error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to proceed. Please try again.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
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
          onPressed: () async {
            if (widget.personaId == 1) {
              Navigator.pop(context);
            } else {
              try {
                await Chatservice().getVerdict();
                debugPrint('getVerdict success');
              } catch (e) {
                debugPrint('getVerdict error: $e');
              } finally {
                Chatservice().clearConvId();
                if (mounted) Navigator.pop(context);
              }
            }
          },
        ),

        title: Text(
          "AI Interview",
          style: theme.textTheme.titleLarge?.copyWith(color: secondary),
        ),

        actions: [
          if ((widget.personaId == 2 || widget.personaId == 3) &&
              widget.is3step)
            Container(
              margin: const EdgeInsets.only(right: 12),
              child: ElevatedButton(
                onPressed: () => _handleContinue(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: background,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: secondary, width: 1.5),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: theme.textTheme.bodyMedium?.copyWith(color: secondary),
                ),
              ),
            ),
        ],
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
                  return _buildMessage(
                    message.text,
                    message.isUser,
                    message.timestamp,
                  );
                },
              ),
            ),

            if (_isWaiting)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 16,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
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
  final String timestamp = DateTime.now().toIso8601String();
}
