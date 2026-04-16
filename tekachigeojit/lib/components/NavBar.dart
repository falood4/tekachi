import 'package:flutter/material.dart';
import 'package:tekachigeojit/prep/prepHome.dart';
import 'package:tekachigeojit/test/testHome.dart';
import 'package:tekachigeojit/userSettings/userSettings.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key, this.selectedPage = 0});

  /// Which tab is currently active: 1 = Prep, 2 = Test, 3 = Profile.
  final int selectedPage;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.085,
      alignment: Alignment.bottomCenter,
      color: const Color(0xFF8DD300),

      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selectedPage == 1)
              SizedBox(
                width: 75,
                height: 75,
                child: IconButton(
                  constraints: BoxConstraints.tight(const Size(75, 75)),
                  icon: ImageIcon(
                    const AssetImage('assets/nav_icons/prepNav.png'),
                    color: const Color(0xFF8DD300),
                    size: screenHeight * 0.07,
                  ),
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Colors.black,
                    ),
                    shape: WidgetStateProperty.all<CircleBorder>(
                      const CircleBorder(),
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                width: 75,
                height: 75,
                child: IconButton(
                  icon: ImageIcon(
                    const AssetImage('assets/nav_icons/prepNav.png'),
                    color: Colors.black,
                    size: screenHeight * 0.07,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const PrepHome()),
                      (route) => false,
                    );
                  },
                ),
              ),

            SizedBox(width: screenHeight * 0.075),

            if (selectedPage == 2)
              SizedBox(
                width: 75,
                height: 75,
                child: IconButton(
                  constraints: BoxConstraints.tight(const Size(75, 75)),
                  icon: ImageIcon(
                    const AssetImage('assets/nav_icons/testNav.png'),
                    color: const Color(0xFF8DD300),
                    size: screenHeight * 0.07,
                  ),
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Colors.black,
                    ),
                    shape: WidgetStateProperty.all<CircleBorder>(
                      const CircleBorder(),
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                width: 75,
                height: 75,
                child: IconButton(
                  icon: ImageIcon(
                    const AssetImage('assets/nav_icons/testNav.png'),
                    color: Colors.black,
                    size: screenHeight * 0.07,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const TestHome()),
                      (route) => false,
                    );
                  },
                ),
              ),

            SizedBox(width: screenHeight * 0.075),

            if (selectedPage == 3)
              SizedBox(
                width: 75,
                height: 75,
                child: IconButton(
                  constraints: BoxConstraints.tight(const Size(75, 75)),
                  icon: ImageIcon(
                    const AssetImage('assets/nav_icons/profile.png'),
                    color: const Color(0xFF8DD300),
                    size: screenHeight * 0.07,
                  ),
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Colors.black,
                    ),
                    shape: WidgetStateProperty.all<CircleBorder>(
                      const CircleBorder(),
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                width: 75,
                height: 75,
                child: IconButton(
                  icon: ImageIcon(
                    const AssetImage('assets/nav_icons/profile.png'),
                    color: Colors.black,
                    size: screenHeight * 0.07,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const UserSettings(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
