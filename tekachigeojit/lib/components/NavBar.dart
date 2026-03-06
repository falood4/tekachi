import 'package:flutter/material.dart';
import 'package:tekachigeojit/prep/prepHome.dart';
import 'package:tekachigeojit/test/testHome.dart';
import 'package:tekachigeojit/userSettings/userSettings.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

int _selectedPage = 1;
void _navChosen(int index) {
  _selectedPage = index;
}

class _NavBarState extends State<NavBar> {
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
            if (_selectedPage == 1)
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
                    setState(() {
                      _navChosen(1);
                    });
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const PrepHome()),
                    );
                  },
                ),
              ),

            SizedBox(width: screenHeight * 0.075),

            if (_selectedPage == 2)
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
                    setState(() {
                      _navChosen(2);
                    });
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const TestHome()),
                    );
                  },
                ),
              ),

            SizedBox(width: screenHeight * 0.075),

            if (_selectedPage == 3)
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
                    setState(() {
                      _navChosen(3);
                    });
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const UserSettings(),
                      ),
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
