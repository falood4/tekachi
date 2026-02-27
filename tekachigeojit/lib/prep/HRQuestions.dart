import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/NavBar.dart';

class HrTrainingScreen extends StatelessWidget {
  const HrTrainingScreen({super.key});

  static const Map<String, String> basicIntroductionQA = {
    "Tell me about yourself.":
        "Give a brief professional summary highlighting your background, key skills, and recent experience relevant to the role.",

    "Walk me through your resume.":
        "Explain your education, work experience, major projects, and how each step prepared you for this position.",

    "Why should we hire you?":
        "Focus on your strengths, relevant skills, and how you can add value to the company compared to other candidates.",

    "What do you know about our company?":
        "Mention the company’s products, services, values, recent achievements, and how they align with your career goals.",

    "Why do you want to work here?":
        "Talk about your interest in the role, company culture, growth opportunities, and how it fits your long-term plans.",
  };
  static const Map<String, String> strengthsWeaknessesQA = {
    "What are your strengths?":
        "Highlight 2–3 strengths relevant to the job and support them with brief examples.",

    "What are your weaknesses?":
        "Mention a genuine but non-critical weakness and explain how you're actively improving it.",

    "How are you working to improve your weaknesses?":
        "Describe specific steps, courses, or habits you’ve adopted to improve.",

    "What skills set you apart from other candidates?":
        "Focus on unique skills, certifications, or experiences that align closely with the role.",
  };
  static const Map<String, String> workStyleAttitudeQA = {
    "How would you describe your work ethic?":
        "Explain your dedication, reliability, and consistency in delivering quality work.",

    "Do you prefer working independently or in a team?":
        "Show flexibility by explaining you can adapt to both environments effectively.",

    "How do you prioritize your work?":
        "Mention task management methods like deadlines, impact assessment, or productivity tools.",

    "How do you handle multiple deadlines?":
        "Talk about planning, time management, and breaking tasks into manageable parts.",

    "Are you more of a leader or a follower?":
        "Explain that you can lead when necessary and collaborate effectively when part of a team.",
  };
  static const Map<String, String> pressureChallengesQA = {
    "Can you work under pressure?":
        "Provide an example where you successfully handled high-pressure situations.",

    "Describe a stressful situation and how you handled it.":
        "Use the STAR method to explain the situation, actions taken, and outcome.",

    "How do you handle failure?":
        "Explain how you analyze mistakes, learn from them, and improve moving forward.",

    "Tell me about a time you made a mistake at work.":
        "Be honest, explain how you corrected it, and what you learned from it.",

    "How do you deal with criticism?":
        "Show that you value constructive feedback and use it to grow professionally.",
  };
  static const Map<String, String> motivationGoalsQA = {
    "What motivates you to do a good job?":
        "Discuss personal drive, growth opportunities, and delivering value to the organization.",

    "What are your short-term goals?":
        "Share realistic goals aligned with skill development and job performance.",

    "What are your long-term goals?":
        "Explain your career aspirations and how they align with the company’s vision.",

    "Where do you see yourself in five years?":
        "Talk about growth, leadership potential, and contributing significantly to the company.",

    "What does success mean to you?":
        "Define success in terms of growth, impact, and achieving meaningful results.",
  };
  static const Map<String, String> companyRoleFitQA = {
    "Why should we not hire you?":
        "Turn this into a self-awareness answer by discussing a minor weakness you’re improving.",

    "What are your expectations from this role?":
        "Discuss growth opportunities, learning, and contributing effectively to the team.",

    "What would your previous manager say about you?":
        "Highlight positive traits such as reliability, teamwork, and performance.",

    "Why are you leaving your current job?":
        "Focus on growth opportunities and new challenges, not negative experiences.",

    "What kind of work environment do you prefer?":
        "Describe a productive, collaborative, and goal-oriented environment.",
  };
  static const Map<String, String> behaviouralQA = {
    "Tell me about a time you handled conflict at work.":
        "Use the STAR method to explain the situation and how you resolved it professionally.",

    "Describe a situation where you showed leadership.":
        "Share a specific example where you guided a team or initiative successfully.",

    "Have you ever disagreed with your manager? How did you handle it?":
        "Explain how you respectfully communicated your perspective and reached a solution.",

    "Tell me about a time you missed a deadline.":
        "Be honest, explain the cause, how you resolved it, and what you learned.",

    "Give an example of when you went above and beyond.":
        "Describe a time you exceeded expectations and contributed extra value.",
  };
  static const Map<String, String> ethicsProfessionalismQA = {
    "How do you handle confidential information?":
        "Explain your commitment to integrity and following company policies strictly.",

    "What would you do if you saw a colleague behaving unethically?":
        "State that you would follow company reporting procedures responsibly.",

    "Have you ever faced an ethical dilemma at work?":
        "Describe the situation and how you chose the ethical course of action.",
  };
  static const Map<String, String> flexibilityAvailabilityQA = {
    "How do you feel about working nights and weekends?":
        "Express flexibility while maintaining healthy work-life balance boundaries.",

    "Are you willing to relocate?":
        "Answer honestly and explain your openness depending on career growth opportunities.",

    "Are you open to travel?":
        "Clarify your flexibility regarding business travel if required.",

    "Are you comfortable with flexible work hours?":
        "Show adaptability while emphasizing productivity and responsibility.",
  };
  static const Map<String, String> compensationClosureQA = {
    "What are your salary expectations?":
        "Provide a researched salary range and express openness to discussion.",

    "What benefits are important to you?":
        "Mention professional growth, health benefits, and work-life balance.",

    "When can you join?": "Clearly state your notice period or availability.",

    "Do you have any questions for us?":
        "Ask thoughtful questions about team structure, expectations, or growth opportunities.",
  };

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final double baseFontSize = size.width * 0.045;
    final double verticalPadding = size.height * 0.02;

    final theme = Theme.of(context);
    dynamic lime = theme.colorScheme.secondary;
    dynamic blackbg = theme.colorScheme.background;

    return Scaffold(
      backgroundColor: blackbg,
      appBar: AppBar(
        backgroundColor: blackbg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: lime),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "HR Training",
          style: TextStyle(
            color: lime,
            fontFamily: "RussoOne",
            fontSize: 0.075 * screenWidth,
          ),
        ),
      ),

      /// Body
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.06,
              vertical: verticalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Basic Introduction",
                  style: TextStyle(
                    color: lime,
                    fontFamily: "RussoOne",
                    fontSize: baseFontSize * 1.4,
                  ),
                ),
                SizedBox(height: verticalPadding),
                buildQuestionList(basicIntroductionQA, context),

                Text(
                  "Strengths & Weaknesses",
                  style: TextStyle(
                    color: lime,
                    fontFamily: "RussoOne",
                    fontSize: baseFontSize * 1.4,
                  ),
                ),
                SizedBox(height: verticalPadding),
                buildQuestionList(strengthsWeaknessesQA, context),

                Text(
                  "Work Style & Attitude",
                  style: TextStyle(
                    color: lime,
                    fontFamily: "RussoOne",
                    fontSize: baseFontSize * 1.4,
                  ),
                ),
                SizedBox(height: verticalPadding),
                buildQuestionList(workStyleAttitudeQA, context),

                Text(
                  "Pressure & Challenges",
                  style: TextStyle(
                    color: lime,
                    fontFamily: "RussoOne",
                    fontSize: baseFontSize * 1.4,
                  ),
                ),
                SizedBox(height: verticalPadding),
                buildQuestionList(pressureChallengesQA, context),

                Text(
                  "Motivation & Goals",
                  style: TextStyle(
                    color: lime,
                    fontFamily: "RussoOne",
                    fontSize: baseFontSize * 1.4,
                  ),
                ),
                SizedBox(height: verticalPadding),
                buildQuestionList(motivationGoalsQA, context),

                Text(
                  "Company & Role Fit",
                  style: TextStyle(
                    color: lime,
                    fontFamily: "RussoOne",
                    fontSize: baseFontSize * 1.4,
                  ),
                ),
                SizedBox(height: verticalPadding),
                buildQuestionList(companyRoleFitQA, context),

                Text(
                  "Company & Role Fit",
                  style: TextStyle(
                    color: lime,
                    fontFamily: "RussoOne",
                    fontSize: baseFontSize * 1.4,
                  ),
                ),
                SizedBox(height: verticalPadding),
                buildQuestionList(behaviouralQA, context),

                Text(
                  "Ethics & Professionalism",
                  style: TextStyle(
                    color: lime,
                    fontFamily: "RussoOne",
                    fontSize: baseFontSize * 1.4,
                  ),
                ),
                SizedBox(height: verticalPadding),
                buildQuestionList(ethicsProfessionalismQA, context),

                Text(
                  "Flexibility & Availability",
                  style: TextStyle(
                    color: lime,
                    fontFamily: "RussoOne",
                    fontSize: baseFontSize * 1.4,
                  ),
                ),
                SizedBox(height: verticalPadding),
                buildQuestionList(flexibilityAvailabilityQA, context),

                Text(
                  "Compensation & Closure",
                  style: TextStyle(
                    color: lime,
                    fontFamily: "RussoOne",
                    fontSize: baseFontSize * 1.4,
                  ),
                ),
                SizedBox(height: verticalPadding),
                buildQuestionList(compensationClosureQA, context),
              ],
            ),
          ),
        ),
      ),

      /// Bottom Navigation Bar
      bottomNavigationBar: NavBar(),
    );
  }

  Widget buildQuestionList(Map<String, String> questionMap, context) {
    final size = MediaQuery.of(context).size;
    final double baseFontSize = size.width * 0.045;
    final double verticalPadding = size.height * 0.02;

    return Column(
      children: questionMap.entries.map((entry) {
        final question = entry.key;
        final answer = entry.value;

        final theme = Theme.of(context);
        dynamic black = theme.colorScheme.onPrimary;
        dynamic surface = theme.colorScheme.surface;
        dynamic lime = theme.colorScheme.secondary;

        return Padding(
          padding: EdgeInsets.only(bottom: verticalPadding),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              collapsedBackgroundColor: surface,
              collapsedIconColor: black,

              backgroundColor: lime,
              title: Text(question, style: theme.textTheme.bodyMedium),
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    answer,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: baseFontSize * 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
