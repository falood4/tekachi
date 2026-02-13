import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/NavBar.dart';
import 'package:tekachigeojit/components/TopicPopup2.dart';
import 'package:tekachigeojit/services/TopicService.dart';

class OOPtopics extends StatefulWidget {
  const OOPtopics({super.key});

  @override
  State<OOPtopics> createState() => _OOPtopicsState();
}

class _OOPtopicsState extends State<OOPtopics> {
  late Future<Map<String, int>> _topicsFuture;

  @override
  void initState() {
    super.initState();
    _topicsFuture = Topicservice().fetchTopicsMap(601, 611);
  }

  double get screenWidth => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
      bottomNavigationBar: NavBar(),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
        iconTheme: const IconThemeData(color: Color(0xFF8DD300)),
        title: Text(
          'Aptitude Training',
          style: TextStyle(
            color: const Color(0xFF8DD300),
            fontFamily: "RussoOne",
            fontSize: 0.075 * screenWidth,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
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

          return Container(
            margin: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verbal Reasoning',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.05,
                    fontFamily: "Trebuchet",
                  ),
                ),
                SizedBox(height: screenWidth * 0.05),

                Expanded(
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: screenWidth * 0.05,
                    mainAxisSpacing: screenWidth * 0.05,
                    childAspectRatio: 1.5,
                    children: topics.entries.map((entry) {
                      return _topicButton(context, entry.key, entry.value);
                    }).toList(),
                  ),
                ),
              ],
            ),
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
