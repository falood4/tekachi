
import 'package:flutter/material.dart';
import 'package:tekachigeojit/prep/prepHome.dart';
import 'package:tekachigeojit/test/testHome.dart';
import 'package:tekachigeojit/userSettings/userSettings.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.08,
      alignment: Alignment.bottomCenter,
      color: const Color(0xFF8DD300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: ImageIcon(
              AssetImage('assets/nav_icons/prepNav.png'),
              color: Colors.black,
              size: screenHeight * 0.1,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const PrepHome()),
              );
            },
          ),
          IconButton(
            icon: ImageIcon(
              AssetImage('assets/nav_icons/testNav.png'),
              color: Colors.black,
              size: screenHeight * 0.1,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const TestHome()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.black, size: screenHeight * 0.045,),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const UserSettings()),
              );
            },
          ),
        ],
      ),
    );
  }
}