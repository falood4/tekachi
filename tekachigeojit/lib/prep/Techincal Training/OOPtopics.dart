import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/NavBar.dart';
import 'package:tekachigeojit/services/TopicService.dart';
import 'package:tekachigeojit/components/topic_popup_dialog.dart';

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
    final theme = Theme.of(context);
    dynamic white = theme.colorScheme.primary;
    dynamic lime = theme.colorScheme.secondary;
    dynamic blackbg = theme.colorScheme.background;

    return Scaffold(
      backgroundColor: blackbg,
      bottomNavigationBar: NavBar(),
      appBar: AppBar(
        backgroundColor: blackbg,
        iconTheme: const IconThemeData(color: Color(0xFF8DD300)),
        title: Text(
          'Technical Training',
          style: theme.textTheme.titleLarge?.copyWith(color: lime),
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
          final theme = Theme.of(context);

          return Container(
            margin: EdgeInsets.all(screenWidth * 0.05),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Object Oriented Programming',
                    style: theme.textTheme.titleMedium?.copyWith(color: white),
                  ),
                  SizedBox(height: screenWidth * 0.05),

                  GridView.count(
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
                ],
              ),
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
      showTopicPopupDialog(context, topicTitle: title, topicId: topicId);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    child: Text(
      title,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
        fontSize: screenWidth * 0.04,
        fontFamily: "Trebuchet",
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
