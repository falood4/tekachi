import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/NavBar.dart';
import 'package:tekachigeojit/home.dart';
import 'package:tekachigeojit/services/AuthService.dart';
import 'package:tekachigeojit/services/HistoryService.dart';

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
                          onPressed: _setChangePassword,
                        ),
                        _settingsItem(
                          "Clear conversations",
                          fontSize: baseFontSize,
                          onPressed: _confirmClearConversations,
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
                          onPressed: _confirmDeleteAccount,
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

  void _setChangePassword() {
    debugPrint('Change password initiated');

    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  labelStyle: TextStyle(
                    color: const Color.fromARGB(255, 132, 132, 132),
                    fontFamily: "Trebuchet",
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF8DD300)),
                  ),
                ),
              ),
              TextField(
                controller: newController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'New Password',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 132, 132, 132),
                    fontFamily: "Trebuchet",
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF8DD300)),
                  ),
                ),
              ),
              TextField(
                controller: confirmController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 132, 132, 132),
                    fontFamily: "Trebuchet",
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF8DD300)),
                  ),
                ),
              ),
              SizedBox.fromSize(size: const Size.fromHeight(10)),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8DD300),
                ),
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontFamily: "DelaGothicOne",
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF8DD300)),
                  borderRadius: BorderRadius.circular(25),
                ),
                width: 120,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    _handleChangePassword(newController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  child: Text(
                    'OK',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontFamily: "DelaGothicOne",
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleChangePassword(String newPassword) async {
    final response = await AuthService().changePassword(
      newPassword: newPassword,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.pop(context);
      debugPrint('Password changed successfully');
    } else {
      debugPrint('Failed to change password');
    }
  }

  void _confirmClearConversations() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'ClearConversations',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
          content: Text(
            'Are you sure you want to clear conversations?',
            style: TextStyle(color: Colors.white, fontFamily: "Trebuchet"),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8DD300),
              ),
              child: Text(
                'CANCEL',
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontFamily: "DelaGothicOne",
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _handleClearConversations();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 252, 88, 88),
              ),
              child: Text(
                'CLEAR',
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontFamily: "DelaGothicOne",
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleClearConversations() async {
    final response = await HistoryService().deleteAttempt();

    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.pop(context);
      debugPrint('Conversations cleared successfully');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to clear conversations'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Account', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
          content: Text(
            'Are you sure you want to delete your account?',
            style: TextStyle(color: Colors.white, fontFamily: "Trebuchet"),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8DD300),
              ),
              child: Text(
                'CANCEL',
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontFamily: "DelaGothicOne",
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _handleDeleteAccount();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 252, 88, 88),
              ),
              child: Text(
                'DELETE',
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontFamily: "DelaGothicOne",
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleDeleteAccount() async {
    try {
      final response = await AuthService().deleteUser();

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );

        debugPrint('Account Deleted');
      } else if (response.statusCode == 403) {
        debugPrint('Token not received');
      }
    } catch (e) {
      debugPrint('Error during Deletion: $e');
    }
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
            style: TextStyle(color: Colors.white, fontFamily: "Trebuchet"),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8DD300),
              ),
              child: Text(
                'CANCEL',
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontFamily: "DelaGothicOne",
                ),
              ),
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
                  fontFamily: "DelaGothicOne",
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
        // Source - https://stackoverflow.com/a/57030299
        // Posted by Paul Iluhin, modified by community. See post 'Timeline' for change history
        // Retrieved 2026-02-02, License - CC BY-SA 4.0

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );

        debugPrint('Log out initiated');
      } else if (response.statusCode == 403) {
        debugPrint('Token not received');
      }
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }
}
