import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/NavBar.dart';

class DataInterpretation extends StatelessWidget {
  const DataInterpretation({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final DataTopics = [
      "Table Charts",
      "Bar Charts",
      "Pie Charts",
      "Line Charts",
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
                  'Data Interpretation Aptitude',
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
                  children: List.generate(DataTopics.length, (index) {
                    final topic = DataTopics[index];
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
    return ElevatedButton(
      onPressed: () {
        showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel: 'Close',
          barrierColor: Colors.black54,
          transitionDuration: const Duration(milliseconds: 180),
          pageBuilder: (context, animation, secondaryAnimation) {
            return Center(child: TopicPopup(topicTitle: title));
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

class TopicPopup extends StatelessWidget {
  final String topicTitle;

  const TopicPopup({super.key, required this.topicTitle});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final topicContents = {
      'Table Charts': [
        Image(image: AssetImage('assets/prepfigs/datafigs/tablegraph.png')),
        '''

1.What is the average amount of interest per year which the company had to pay during this period?

A. Rs. 32.43 lakhs
B. Rs. 33.72 lakhs
C. Rs. 34.18 lakhs
D. Rs. 36.66 lakhs

Answer: Option D

Explanation:
Average amount of interest paid by the Company during the given period
= Rs.	[	23.4 + 32.5 + 41.6 + 36.4 + 49.4 / 5]	lakhs
= Rs.	[	183.3	/ 5]	lakhs
= Rs. 36.66 lakhs.


2. The total expenditure of the company over these items during the year 2000 is?

A. Rs. 544.44 lakhs

B. Rs. 501.11 lakhs

C. Rs. 446.46 lakhs

D. Rs. 478.87 lakhs

Answer: Option A

Explanation:
Total expenditure of the Company during 2000

    = Rs. (324 + 101 + 3.84 + 41.6 + 74) lakhs

    = Rs. 544.44 lakhs.
''',
      ],

      'Bar Charts': [
        Image(image: AssetImage('assets/prepfigs/datafigs/barchart.png')),
        ''' 
1. What is the ratio of the total sales of branch B2 for both years to the total sales of branch B4 for both years?

A. 2:3

B. 3:5

C. 4:5

D. 7:9
Answer: Option

Explanation:
Required ratio =	(75 + 65)/(85 + 95)	=	140/180	=	7/9


2.What is the average sales of all the branches (in thousand numbers) for the year 2000?

A. 73

B. 80

C. 83

D. 88
Answer: Option B

Explanation:
Average sales of all the six branches (in thousand numbers) for the year 2000

=	1 / 6	x [80 + 75 + 95 + 85 + 75 + 70]
= 80.''',
      ],

      'Pie Charts': [
        Image(image: AssetImage('assets/prepfigs/datafigs/piechart.png')),
        '''
1.The price of the book is marked 20% above the C.P. If the marked price of the book is Rs. 180, then what is the cost of the paper used in a single copy of the book?

A.Rs. 36

B.Rs. 37.50

C.Rs. 42

D.Rs. 44.25

Answer: Option B

Explanation:
Clearly, marked price of the book = 120% of C.P.

Also, cost of paper = 25% of C.P

Let the cost of paper for a single book be Rs. n.

Then, 120 : 25 = 180 : n  
=> n = Rs.(	25 x 180/120 )	
= Rs. 37.50 .

2. What is the central angle of the sector corresponding to the expenditure incurred on Royalty?

A.15°

B.24°

C.54°

D.48°

Answer: Option C

Explanation:
Central angle corresponding to Royalty	= (15% of 360)°
=	(	15/100	x 360	)	°
= 54°.
 ''',
      ],

      'Line Charts': [
        Image(image: AssetImage('assets/prepfigs/datafigs/linechart.png')),
        ''' 
1. For which of the following pairs of years the total exports from the three Companies together are equal?

A. 1995 and 1998

B. 1996 and 1998

C. 1997 and 1998

D. 1995 and 1996

Answer: Option D

Explanation:
Total exports of the three Companies X, Y and Z together, during various years are:

In 1993 = Rs. (30 + 80 + 60) crores = Rs. 170 crores.

In 1994 = Rs. (60 + 40 + 90) crores = Rs. 190 crores.

In 1995 = Rs. (40 + 60 + 120) crores = Rs. 220 crores.

In 1996 = Rs. (70 + 60 + 90) crores = Rs. 220 crores.

In 1997 = Rs. (100 + 80 + 60) crores = Rs. 240 crores.

In 1998 = Rs. (50 + 100 + 80) crores = Rs. 230 crores.

In 1999 = Rs. (120 + 140 + 100) crores = Rs. 360 crores.

Clearly, the total exports of the three Companies X, Y and Z together are same during the years 1995 and 1996.

2. In how many of the given years, were the exports from Company Z more than the average annual exports over the given years?

A. 2

B. 3

C. 4

D. 5

Answer: Option C

Explanation:
Average annual exports of Company Z during the given period

=	1/7	x (60 + 90 + 120 + 90 + 60 + 80 + 100)
= Rs.	(	600/7	)	crores
= Rs. 85.71 crores.''',
      ],
    };

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        child: Container(
          width: screenWidth * 0.8,
          height: screenHeight * 0.6,
          padding: EdgeInsets.all(screenWidth * 0.05),
          decoration: BoxDecoration(
            color: Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                topicTitle,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth * 0.06,
                  fontFamily: "DelaGothicOne",
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          topicContents[topicTitle] is List &&
                                  topicContents[topicTitle]!.isNotEmpty &&
                                  topicContents[topicTitle]![0] is Image
                              ? topicContents[topicTitle]![0] as Image
                              : SizedBox.shrink(),
                          Text(
                            (topicContents[topicTitle] as List?)
                                    ?.elementAt(1)
                                    ?.toString() ??
                                'Content not available',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: "Trebuchet",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8DD300),
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
    );
  }
}
