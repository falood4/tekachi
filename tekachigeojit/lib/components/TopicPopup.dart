import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tekachigeojit/services/TopicService.dart';

class TopicPopup extends StatefulWidget {
  final String topicTitle;
  final int topicId;

  const TopicPopup({
    super.key,
    required this.topicTitle,
    required this.topicId,
  });

  @override
  State<TopicPopup> createState() => _TopicPopupState();
}

class _TopicPopupState extends State<TopicPopup> {
  // You can now initialize your future here or in initState
  late Future<String> _contentFuture;

  @override
  void initState() {
    super.initState();
    _contentFuture = Topicservice().fetchTopicContent(widget.topicId);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: screenHeight * 0.8),
          child: Container(
            width: screenWidth * 0.8,
            padding: EdgeInsets.all(screenWidth * 0.05),
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.topicTitle,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth * 0.06,
                    fontFamily: "DelaGothicOne",
                  ),
                ),

                const SizedBox(height: 16),

                Flexible(
                  child: SingleChildScrollView(
                    child: FutureBuilder<String>(
                      future: _contentFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF8DD300),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        return Text(
                          snapshot.data ?? 'No content found.',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontFamily: "Trebuchet",
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8DD300),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.1,
                      vertical: screenHeight * 0.02,
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.04,
                      fontFamily: "DelaGothicOne",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
