import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/NavBar.dart';
import 'package:tekachigeojit/components/TopicPopup.dart';


class LogicalReasoning extends StatelessWidget {
  const LogicalReasoning({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final LogicalTopics = [
      "Number Series",
      "Statement and Assumption",
      "Logical Deduction",
      "Logical Problems",
    ];

    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
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
      bottomNavigationBar: NavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Logical Reasoning',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.05,
                    fontFamily: "Trebuchet",
                  ),
                ),
                SizedBox(height: screenWidth * 0.05),
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: screenWidth * 0.05,
                  mainAxisSpacing: screenWidth * 0.05,
                  childAspectRatio: 1.5,
                  children: List.generate(LogicalTopics.length, (index) {
                    final topic = LogicalTopics[index];
                    return _topicButton(context, topic);
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topicButton(BuildContext context, String title) {
    final screenWidth = MediaQuery.of(context).size.width;

    final topicContents = {
      "Number Series": '''
1. Series: 2, 1, 1/2, 1/4, ...

A. 1/3
B. 1/8
C. 2/8
D. 1/16

Answer: Option D — Each term is half the previous term. 

2. Series: 7, 10, 8, 11, 9, 12, ...

A. 7
B. 10
C. 12
D. 13

Answer: Option D — Alternating increase and decrease pattern. 

3. Series: 36, 34, 30, 28, 24, ...

A. 20
B. 22
C. 23
D. 26

Answer: Option A — Alternating subtraction of 2 and 4. ''',

      "Statement and Assumption": '''
1. Statement: “You are appointed as a programmer with a one-year probation period; performance will be reviewed at the end.”

I. Performance is usually unknown at appointment.
II. Individuals try to prove their worth during probation.

A. Only I is implicit
B. Only II is implicit
C. Either I or II is implicit
D. Neither is implicit
E. Both are implicit

Answer: Option E — Both assumptions are implicit. 

2. Statement: “It is desirable to put the child in school at age 5 or so.”

I. Early schooling helps development.
II. Children below age 5 cannot be enrolled.

A. If only assumption I is implicit
B. If only assumption II is implicit
C. If either I or II is implicit
D. If neither I nor II is implicit
E. If both I and II are implicit

Answer: Option A — Only Assumption I follows. ''',

      "Logical Deduction": '''
1. Statements:
No women teacher can play.
Some women teachers are athletes.

Conclusions:
I. Male athletes can play.
II. Some athletes can play.

A. Only I follows
B. Only II follows
C. Either follows
D. Neither follows
E. Both follow

Answer: Option D — Neither conclusion follows. 

2. Statements:
All bags are cakes.
All lamps are cakes.

Conclusions:
I. Some lamps are bags.
II. No lamp is bag.

A. If only conclusion I follows
B. If only conclusion II follows
C. If either I or II follows
D. If neither I nor II follows
E. If both I and II follow

Answer: Option C — Either I or II follows. ''',

      "Logical Problems": '''
1. Tanya is older than Eric.

Cliff is older than Tanya.
Eric is older than Cliff.

Conclusion: If first two are true, third is:

A. true
B. false
C. uncertain

Answer: Option B — False, because Eric is youngest. 

2. Blueberries cost more than strawberries.
Blueberries cost less than raspberries.
Raspberries cost more than strawberries and blueberries.

Conclusion: If first two true, the third statement is:

A. true
B. false
C. uncertain

Answer: Option A — True; raspberries are most expensive. 

3. All trees in park are flowering.
Some trees are dogwoods.

Conclusion: If first two are true, are all dogwoods flowering?

A. True
B. False
C. Uncertain

Answer: Yes — True; dogwoods are flowering trees
''',
    };

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
              child: TopicPopup(
                topicTitle: title,
                topicContents: {title: topicContents[title]!},
              ),
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
}
