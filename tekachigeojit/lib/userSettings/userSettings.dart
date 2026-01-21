import 'package:flutter/material.dart';
import 'package:tekachigeojit/prep/prepHome.dart';

class UserSettings extends StatelessWidget {
  const UserSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Screen-based scaling
    final double screenWidth = size.width;
    final double screenHeight = size.height;

    final double horizontalPadding = screenWidth * 0.05;
    final double cardRadius = screenWidth * 0.08;
    final double profileHeight = screenHeight * 0.09;
    final double baseFontSize = screenWidth * 0.045;

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      bottomNavigationBar: NavBar(),
      body: SafeArea(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: screenHeight * 0.03,
                ),
                child: Column(
                  children: [
                    Text(
                      'Settings',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF8DD300),
                        fontFamily: "DelaGothicOne",
                        fontSize: 0.15 * screenWidth,
                      ),
                    ),

                    Container(
                      height: profileHeight,
                      margin: EdgeInsets.only(top: screenHeight * 0.05, bottom: screenHeight * 0.02),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(cardRadius),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: profileHeight * 0.32,
                            backgroundColor: Colors.black,
                            child: Icon(
                              Icons.person,
                              size: profileHeight * 0.35,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.04),
                          Text(
                            "Username",
                            style: TextStyle(
                              fontSize: baseFontSize,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Settings Card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(cardRadius),
                      ),
                      child: Column(
                        children: [
                          _settingsItem(
                            "Change password",
                            fontSize: baseFontSize,
                          ),
                          _settingsItem(
                            "Clear conversations",
                            fontSize: baseFontSize,
                          ),
                          _settingsItem("Log Out", fontSize: baseFontSize),
                          _settingsItem(
                            "Delete account",
                            fontSize: baseFontSize,
                            isDestructive: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }

  Widget _settingsItem(
    String title, {
    required double fontSize,
    bool isDestructive = false,
  }) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: fontSize * 1.2,
          vertical: fontSize * 0.9,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isDestructive ? FontWeight.w600 : FontWeight.w400,
              color: isDestructive ? Colors.red : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
