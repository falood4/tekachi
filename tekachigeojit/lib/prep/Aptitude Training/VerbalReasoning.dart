import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/NavBar.dart';
import 'package:tekachigeojit/components/TopicPopup2.dart';
import 'package:tekachigeojit/services/TopicService.dart';

class VerbalReasoning extends StatefulWidget {
  const VerbalReasoning({super.key});

  @override
  State<VerbalReasoning> createState() => _VerbalReasoningState();
}

class _VerbalReasoningState extends State<VerbalReasoning> {
  late Future<Map<String, int>> _topicsFuture;

  @override
  void initState() {
    super.initState();
    _topicsFuture = Topicservice().fetchTopicsMap(301, 307);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(),
      body: FutureBuilder<Map<String, int>>(
        future: _topicsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final topics = snapshot.data!;

          return GridView.count(
            crossAxisCount: 2,
            children: topics.entries.map((entry) {
              return _topicButton(context, entry.key, entry.value);
            }).toList(),
          );
        },
      ),
    );
  }
}

Widget _topicButton(BuildContext context, String title, int topicId) {
  final screenWidth = MediaQuery.of(context).size.width;

  return ElevatedButton(
    onPressed: () {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'Close',
        barrierColor: Colors.black54,
        transitionDuration: const Duration(milliseconds: 180),
        pageBuilder: (context, animation, secondaryAnimation) {
          return Center(
            child: TopicPopup(topicTitle: title, topicId: topicId),
          );
        },
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.9, end: 1.0).animate(curved),
              child: child,
            ),
          );
        },
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFD9D9D9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    child: Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontSize: screenWidth * 0.04,
        fontFamily: "Trebuchet",
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
