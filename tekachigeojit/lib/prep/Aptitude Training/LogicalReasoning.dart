import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/NavBar.dart';
import 'package:tekachigeojit/services/TopicService.dart';
import 'package:tekachigeojit/components/topic_popup_dialog.dart';

class LogicalReasoning extends StatefulWidget {
  const LogicalReasoning({super.key});

  @override
  State<LogicalReasoning> createState() => _LogicalReasoningState();
}

class _LogicalReasoningState extends State<LogicalReasoning> {
  late Future<Map<String, int>> _topicsFuture;

  @override
  void initState() {
    super.initState();
    _topicsFuture = Topicservice().fetchTopicsMap(201, 204);
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
      appBar: AppBar(
        backgroundColor: blackbg,
        iconTheme: IconThemeData(color: white),
        title: Text(
          'Aptitude Training',
          style: theme.textTheme.titleLarge?.copyWith(color: lime),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
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

          return Container(
            margin: EdgeInsets.all(screenWidth * 0.05),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Logical Reasoning',
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
  final theme = Theme.of(context);
  final surface = theme.colorScheme.surface;
  return ElevatedButton(
    onPressed: () {
      showTopicPopupDialog(context, topicTitle: title, topicId: topicId);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    child: Text(title, style: theme.textTheme.bodyMedium),
  );
}
