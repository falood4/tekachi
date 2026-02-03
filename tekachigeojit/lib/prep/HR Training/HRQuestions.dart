import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/NavBar.dart';

class HrTrainingScreen extends StatelessWidget {
  const HrTrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final double baseFontSize = size.width * 0.045;
    final double verticalPadding = size.height * 0.02;

    final Map<String, List<String>> categorizedQuestions = {
      "Basic introduction": [
        "Tell me about yourself.",
        "Walk me through your resume.",
        "Why should we hire you?",
        "What do you know about our company?",
        "Why do you want to work here?",
      ],
      "Strengths & weaknesses": [
        "What are your strengths?",
        "What are your weaknesses?",
        "How are you working to improve your weaknesses?",
        "What skills set you apart from other candidates?",
      ],
      "Work style & attitude": [
        "How would you describe your work ethic?",
        "Do you prefer working independently or in a team?",
        "How do you prioritize your work?",
        "How do you handle multiple deadlines?",
        "Are you more of a leader or a follower?",
      ],
      "Pressure & challenges": [
        "Can you work under pressure?",
        "Describe a stressful situation and how you handled it.",
        "How do you handle failure?",
        "Tell me about a time you made a mistake at work.",
        "How do you deal with criticism?",
      ],
      "Motivation & goals": [
        "What motivates you to do a good job?",
        "What are your short-term goals?",
        "What are your long-term goals?",
        "Where do you see yourself in five years?",
        "What does success mean to you?",
      ],
      "Company & role fit": [
        "Why should we not hire you?",
        "What are your expectations from this role?",
        "What would your previous manager say about you?",
        "Why are you leaving your current job?",
        "What kind of work environment do you prefer?",
      ],
      "Behavioural questions": [
        "Tell me about a time you handled conflict at work.",
        "Describe a situation where you showed leadership.",
        "Have you ever disagreed with your manager? How did you handle it?",
        "Tell me about a time you missed a deadline.",
        "Give an example of when you went above and beyond.",
      ],
      "Ethics & professionalism": [
        "How do you handle confidential information?",
        "What would you do if you saw a colleague behaving unethically?",
        "Have you ever faced an ethical dilemma at work?",
      ],
      "Flexibility & availability": [
        "How do you feel about working nights and weekends?",
        "Are you willing to relocate?",
        "Are you open to travel?",
        "Are you comfortable with flexible work hours?",
      ],
      "Compensation & closure": [
        "What are your salary expectations?",
        "What benefits are important to you?",
        "When can you join?",
        "Do you have any questions for us?",
      ],
    };

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF84B200)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "HR Training",
          style: TextStyle(
            color: Color(0xFF8DD300),
            fontFamily: "RussoOne",
            fontSize: 0.075 * screenWidth,
          ),
        ),
      ),

      /// Body
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.06,
            vertical: verticalPadding,
          ),
          child: ListView.builder(
            itemCount: categorizedQuestions.length,
            itemBuilder: (context, categoryIndex) {
              final category = categorizedQuestions.keys.elementAt(
                categoryIndex,
              );
              final questions = categorizedQuestions[category]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: verticalPadding),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: Color(0xFF8DD300),
                        fontSize: baseFontSize * 1.2,
                        fontFamily: "Trebuchet",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...List.generate(questions.length, (questionIndex) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: verticalPadding,
                        left: size.width * 0.03,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "•  ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              height: 1.4,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              questions[questionIndex],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: baseFontSize,
                                fontFamily: "Trebuchet",
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: verticalPadding * 1.5),
                ],
              );
            },
          ),
        ),
      ),

      /// Bottom Navigation Bar
      bottomNavigationBar: NavBar(),
    );
  }
}
