import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.messageText,
    required this.isUser,
  });
  final String messageText;
  final String isUser;

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    if (isUser == "USER") {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 50,
          minHeight: 50,
          maxWidth: screenwidth * 0.7,
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            messageText,
            softWrap: true,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
      );
    } else {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 50,
          minHeight: 50,
          maxWidth: screenwidth * 0.7,
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            messageText,
            softWrap: true,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
      );
    }
  }
}
