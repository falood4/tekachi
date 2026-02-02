import 'package:flutter/material.dart';
import 'package:tekachigeojit/home.dart';
import 'package:tekachigeojit/components/NavBar.dart';
import 'package:tekachigeojit/services/AuthService.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});
  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                      color: const Color(0xFF8DD300),
                      fontFamily: "DelaGothicOne",
                      fontSize: 0.15 * screenWidth,
                    ),
                  ),

                  Container(
                    height: profileHeight,
                    margin: EdgeInsets.only(
                      top: screenHeight * 0.05,
                      bottom: screenHeight * 0.02,
                    ),
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
                          AuthService().shareEmail() ?? '',
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
                          onPressed: _handleChangePassword,
                        ),
                        _settingsItem(
                          "Clear conversations",
                          fontSize: baseFontSize,
                          onPressed: _handleClearConversations,
                        ),
                        _settingsItem(
                          "Log Out",
                          fontSize: baseFontSize,
                          onPressed: _confirmLogout,
                        ),
                        _settingsItem(
                          "Delete account",
                          fontSize: baseFontSize,
                          isDestructive: true,
                          onPressed: _handleDeleteAccount,
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
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
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

  void _handleChangePassword() {
    debugPrint('Change password initiated');
  }

  void _handleClearConversations() {
    debugPrint('Clear conversations initiated');
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8DD300),
              ),
              child: Text('CANCEL', style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
            ),
            ElevatedButton(
              onPressed: () {
                _handleLogOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 252, 88, 88),
              ),
              child: Text(
                'ACCEPT',
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleLogOut() async {
    try {
      final response = await AuthService().logout();

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));

        debugPrint('Log out initiated');
      } else if (response.statusCode == 403) {
        debugPrint('Token not received');
      }
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }

  void _handleDeleteAccount() {
    debugPrint('Delete account initiated');
  }
}
