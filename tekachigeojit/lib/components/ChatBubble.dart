import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message_text,
    required this.isUser,
  });
  final String message_text;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;

    if (isUser) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 50,
          minHeight: 50,
          maxWidth: screenwidth * 0.6,
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(message_text),
        ),
      );
    } else {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 50,
          minHeight: 50,
          maxWidth: screenwidth * 0.6,
          maxHeight: screenheight * 0.75,
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(message_text),
        ),
      );
    }
  }
}
