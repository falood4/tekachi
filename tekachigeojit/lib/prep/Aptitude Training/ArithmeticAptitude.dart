import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/TopicPopup.dart';
import 'package:tekachigeojit/components/NavBar.dart';

class ArithmeticAptitude extends StatelessWidget {
  const ArithmeticAptitude({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final ArithmeticTopics = [
      "Problems on Trains",
      "Time and Distance",
      // ...existing topics...
    ];

    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
      appBar: AppBar(
        // ...existing appBar code...
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
                  'Arithmetic Aptitude',
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
                  children: List.generate(ArithmeticTopics.length, (index) {
                    final topic = ArithmeticTopics[index];
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
      'Problems on Trains': '''
• Speed = Distance / Time.
• Convert km/hr to m/sec: (x km/hr) = (x × 5) / 18 m/sec
• Convert m/sec to km/hr: (x m/sec) = (x × 18) / 5 km/hr
• Time taken by a train of length L to pass a stationary object = L / speed (when speed in m/sec)
• Time for train length L to pass object of length B = (L + B) / relative speed
• Relative speed (same direction) = (u − v) m/s
• Relative speed (opposite direction) = (u + v) m/s
• Two trains lengths a & b moving opposite: time to cross = (a + b) / (u + v)
• Two trains lengths a & b moving same direction: time faster overtakes slower = (a + b) / (u − v)
• If two trains start towards each other from points A and B and after crossing take a & b seconds to reach B and A respectively,
  then (Speed of A) : (Speed of B) = b : a
''',

      "Time and Distance": '''
• Speed = Distance / Time.
• Time = Distance / Speed
• Distance = Speed × Time
• km/hr to m/sec: x km/hr = (x × 5) / 18 m/sec
• m/sec to km/hr: x m/sec = (x × 18) / 5 km/hr
• If speeds of A and B are in ratio a : b, then times taken for same distance are b : a
• Average speed for equal distances at x and y = (2xy) / (x + y) km/hr
''',

      "Time and Work": '''
• If A can finish work in n days, then A’s 1 day’s work = 1/n
• If A’s 1 day’s work is 1/n, then total days to finish work = n
• If A is k times as efficient as B, then A:B work done ratio is k:1 and time ratio is 1:k
''',

      "Height and Distance": '''
• In a right triangle:
  sin θ = Opposite / Hypotenuse,
  cos θ = Adjacent / Hypotenuse,
  tan θ = Opposite / Adjacent
• Cosec θ = 1 / sin θ, sec θ = 1 / cos θ, cot θ = 1 / tan θ
• Trig identities: sin²θ + cos²θ = 1;
  1 + tan²θ = sec²θ;
  1 + cot²θ = cosec²θ
• Standard T-ratio values for angles:  
  sin 30° = 1/2; cos 30° = √3 / 2; tan 30° = 1/√3;  
  sin 45° = √2 / 2; cos 45° = √2 / 2; tan 45° = 1;  
  sin 60° = √3 / 2; cos 60° = 1/2; tan 60° = √3
''',

      "Simple Interest": '''
Let Principal = P, Rate = R% p.a., Time = T years
• Simple Interest (S.I.) = (P × R × T) / 100
• P = (100 × S.I.) / (R × T)
• R = (100 × S.I.) / (P × T)
• T = (100 × S.I.) / (P × R)
''',

      "Compound Interest": '''
Let Principal = P, Rate = R% p.a., Number of periods = n
• Amount (compounded annually) = P × (1 + R/100)^n
• Compound Interest (C.I.) = Amount − P
• If interest is compounded half yearly: Amount = P × (1 + (R/2)/100)^(2n)
• If interest is compounded quarterly: Amount = P × (1 + (R/4)/100)^(4n)
• For different annual rates R1, R2, …: Amount = P × Π (1 + Ri/100)
''',

      "Profit and Loss": '''
Let C.P. = Cost Price, S.P. = Selling Price
• Gain = S.P. − C.P.
• Loss = C.P. − S.P.
• Gain % = (Gain × 100) / C.P.
• Loss % = (Loss × 100) / C.P.
• S.P. = ((100 + Gain %) × C.P.) / 100
• S.P. = ((100 − Loss %) × C.P.) / 100
• C.P. = (100 × S.P.) / (100 + Gain %) or (100 × S.P.) / (100 − Loss %)
      ''',
      "Percentage": '''
• x% means x/100  
• To express x% as a fraction: x% = x / 100  
• To express a fraction a/b as a percentage: (a/b) × 100%  
• Percentage Increase/Decrease:  
  Increase % = ((New − Old) / Old) × 100  
  Decrease % = ((Old − New) / Old) × 100
''',
      "Problems on Ages": '''
• If the current age is x, then n times the age is n×x  
• Present age after n years = x + n  
• Present age n years ago = x − n  
• Ages in ratio a:b can be expressed as a×k and b×k  
• Fraction of age (eg, 1/n of age) = x/n
''',
      "Average": '''
• Average = (Sum of observations) / (Number of observations)  
• Average Speed for equal distances at speeds x and y = (2xy)/(x + y)
''',
      "Area": '''
• Area of rectangle = Length × Breadth  
• Perimeter of rectangle = 2(Length + Breadth)  
• Area of square = (side)^2  
• Area of triangle = 1/2 × base × height;  
  also = √[s(s − a)(s − b)(s − c)] (Heron’s formula)  
• Area of parallelogram = base × height  
• Area of trapezium = 1/2 × (sum of parallel sides) × distance between them  
• Area of circle = πR^2  
• Circumference of circle = 2πR
''',
      "Volume and Surface Area": '''
• CUBOID: Volume = l×b×h, Surface area = 2(lb + bh + hl), Diagonal = √(l^2 + b^2 + h^2)  
• CUBE: Volume = a^3, Surface area = 6a^2, Diagonal = √3×a  
• CYLINDER: Volume = πr^2h, Curved surface area = 2πrh, Total surface area = 2πr(h + r)  
• CONE: Slant height l = √(h^2 + r^2), Volume = (1/3)πr^2h, Curved surface area = πrl, Total surface area = πrl + πr^2  
• SPHERE: Volume = (4/3)πr^3, Surface area = 4πr^2  
• HEMISPHERE: Volume = (2/3)πr^3, Curved surface area = 2πr^2, Total surface area = 3πr^2
''',
      "Permutation and Combination": '''
• Number of permutations of n items taken r at a time:  
  nP r = n! / (n − r)!  
• Number of permutations of n things all at a time = n!  
• Permutations of n objects with duplicates: n! / (p1! p2! ... pr!)
• Number of combinations of n items taken r at a time:  
  nC r = n! / [r! (n − r)!]
• Note: nC r = nC (n − r).
''',
      "Ratio and Proportion": '''
• Ratio a:b is the fraction a / b
• Proportion: If a:b = c:d then a:b::c:d and b×c = a×d
• Fourth proportional to (a, b, c) is d where a:b = c:d
• Mean proportional between a and b is √(ab)
• Direct proportion: x ∝ y → x = k×y
• Inverse proportion: x ∝ 1/y → x×y = k.
''',
      "Probability": '''
• Probability of an event = Number of favourable outcomes / Total number of possible outcomes
• For two independent events A and B:  
  P(A and B) = P(A) × P(B)
  P(A or B) = P(A) + P(B) − P(A and B)
• For mutually exclusive events: P(A or B) = P(A) + P(B)
• Complementary events: P(A') = 1 − P(A).
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