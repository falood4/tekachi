import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tekachigeojit/prep/Aptitude%20Training/AptitudeHome.dart';
import 'package:tekachigeojit/components/NavBar.dart';import 'package:tekachigeojit/components/TopicPopup.dart';


class VerbalReasoning extends StatelessWidget {
  const VerbalReasoning({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final VerbalTopics = [
      "Ordering of Words",
      "Sentence Improvement",
      "Ordering of Sentences",
      "Spotting Errors",
      "Change of Speech",
      "Verbal Analogies",
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
            fontFamily: "Trebuchet",
            fontSize: 0.075 * screenWidth,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AptitudeHome()),
            );
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
                  'Verbal Reasoning',
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
                  children: List.generate(VerbalTopics.length, (index) {
                    final topic = VerbalTopics[index];
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
      'Ordering of Words': '''
Read each sentence to find out whether there is any grammatical error in it. The error, if any will be in one part of the sentence. The letter of that part is the answer.

1. When he
P :	did not know
Q :	he was nervous and
R :	heard the hue and cry at midnight
S :	what to do
The Proper sequence should be: 

A. RQPS

B. QSPR

C. SQPR

D. PQRS

Answer: Option A

2. The grocer
P :	did not listen to the protests of customer
Q :	who was in the habit of weighing less
R :	whom he had cheated
S :	with great audacity
The Proper sequence should be:

A. PRSQ

B. QSPR

C. QPRS

D. PQSR

Answer: Option C

3. People
P :	at his dispensary
Q :	went to him
R :	of all professions
S :	for medicine and treatment
The Proper sequence should be:

A. QPRS

B. RPQS

C. RQSP

D.QRPS

Answer: Option C



''',

      "Sentence Improvement": '''
1.The workers are hell bent at getting what is due to them.

A. hell bent on getting

B. hell bent for getting

C. hell bent upon getting

D. No improvement

Answer: Option D

2. his powerful desire brought about his downfall.

A. His intense desire

B. His desire for power

C. His fatal desire

D. No improvement
 
Answer: Option B

3. He could not look anything in the dark room.

A. look at

B. see

C. see through

D. No improvement

Answer: Option Bs
''',

      "Ordering of Sentences": '''
In questions below, each passage consist of six sentences. The first and sixth sentence are given in the begining. The middle four sentences in each have been removed and jumbled up. These are labelled as P, Q, R and S. Find out the proper order for the four sentences.

1.
S1:	In the middle of one side of the square sits the Chairman of the committee, the most important person in the room.
P :	For a committee is not just a mere collection of individuals.
Q :	On him rests much of the responsibility for the success or failure of the committee.
R :	While this is happening we have an opportunity to get the 'feel' of this committe.
S :	As the meeting opens, he runs briskly through a number of formalities.
S6:	From the moment its members meet, it begins to have a sort nebulous life of its own.
The Proper sequence should be:

A. RSQP

B. PQRS

C. SQPR

D. QSRP

Answer: Option D

2.
S1:	When a satellite is launched, the rocket begins by going slowly upwards through the air.
P :	However, the higher it goes, the less air it meets.
Q :	As the rocket goes higher, it travels faster.
R :	For the atmosphere becomes thinner.
S :	As a result there is less friction.
S6:	Consequently, the rocket still does not become too hot.
The Proper sequence should be:

A. QPRS

B. QSPR

C. PQRS

D. PQSR

Answer: Option A
''',

      "Verbal Analogies": '''
Each question consist of two words which have a certain relationship to each other followed by four pairs of related words, Select the pair which has the same relationship.

1.
DIVA:OPERA

A. producer:theatre

B. director:drama

C. conductor:bus

D. thespian:play

Answer: Option D

2.
LIGHT:BLIND

A. speech:dumb

B. language:deaf

C. tongue:sound

D. voice:vibration

Answer: Option A

3.
HOPE:ASPIRES

A. love:elevates

B. film:flam

C. fib:lie

D. fake:ordinary

Answer: Option C
''',

      "Spotting Errors": '''
Read each sentence to find out whether there is any grammatical error in it. The error, if any will be in one part of the sentence. The letter of that part is the answer. 

1.
A. We discussed about the problem so thoroughly

B. on the eve of the examination

C. that I found it very easy to work it out

D. No error.

Answer: Option A

2.
A.An Indian ship

B.laden with merchandise

C.got drowned in the Pacific Ocean.

D. No error.

Answer: Option C

3.
A. You can get

B. all the information that you want

C. in this book.

D. No error.

Answer: Option B
''',

      "Change of Speech": '''
n the questions below the sentences have been given in Direct/Indirect speech. From the given alternatives, choose the one which best expresses the given sentence in Indirect/Direct speech.

1. "If you don't keep quiet I shall shoot you", he said to her in a calm voice.

A. He warned her to shoot if she didn't keep quiet calmly.

B. He said calmly that I shall shoot you if you don't be quiet.

C. He warned her calmly that he would shoot her if she didn't keep quiet.

D. Calmly he warned her that be quiet or else he will have to shoot her.

Answer: Option C


2. His father ordered him to go to his room and study.

A. His father said, "Go to your room and study."

B. His father said to him, "Go and study in your room."

C. His father shouted, "Go right now to your study room"

D. His father said firmly, "Go and study in your room."

Answer: Option A

3. She said that her brother was getting married.

A. She said, "Her brother is getting married."

B. She told, "Her brother is getting married."

C. She said, "My brother is getting married."

D. She said, "My brother was getting married."

Answer: Option C
''',

      "Selecting Words": '''
1. Fate smiles ...... those who untiringly grapple with stark realities.

A. with  
B. over  
C. on  D. 
round
Answer: Option A.

2. The grapes are now ...... enough to be picked.
A. ready  
B. mature  
C. ripe  
D. advanced

Answer: Option C.

3. I saw a ...... of cows in the field.
A. group  
B. herd  
C. swarm  D. 
flock

Answer: Option B.
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
                topicContents: topicContents,
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
