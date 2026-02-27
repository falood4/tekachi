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
    final double baseFontSize = screenWidth * 0.05;

    dynamic white = Theme.of(context).colorScheme.secondary;
    dynamic black = Theme.of(context).colorScheme.onPrimary;
    dynamic lightGrey = Theme.of(context).colorScheme.surface;

    return Scaffold(
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
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: screenWidth * 0.15,
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
                      color: lightGrey,
                      borderRadius: BorderRadius.circular(cardRadius),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: profileHeight * 0.32,
                          backgroundColor: black,
                          child: Icon(
                            Icons.person,
                            size: profileHeight * 0.35,
                            color: white,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.04),
                        Text(
                          AuthService().shareEmail() ?? '',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontSize: baseFontSize),
                        ),
                      ],
                    ),
                  ),

                  /// Settings Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: lightGrey,
                      borderRadius: BorderRadius.circular(cardRadius),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.01),
                        _settingsItem(
                          "Change password",
                          onPressed: _setChangePassword,
                        ),
                        _settingsItem(
                          "Clear conversations",
                          onPressed: _confirmClearConversations,
                        ),
                        _settingsItem("Log Out", onPressed: _confirmLogout),
                        _settingsItem(
                          "Delete account",
                          isDestructive: true,
                          onPressed: _confirmDeleteAccount,
                        ),
                        SizedBox(height: screenHeight * 0.01),
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
    bool isDestructive = false,
    required VoidCallback onPressed,
  }) {
    dynamic black = Theme.of(context).colorScheme.onPrimary;
    dynamic red = Theme.of(context).colorScheme.error;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: isDestructive ? red : black),
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
        dynamic white = Theme.of(context).colorScheme.primary;
        dynamic lime = Theme.of(context).colorScheme.secondary;
        dynamic grey = Theme.of(context).colorScheme.tertiary;
        dynamic blackbg = Theme.of(context).colorScheme.background;
        dynamic black = Theme.of(context).colorScheme.onPrimary;

        return AlertDialog(
          title: Text(
            'Change Password',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: white),
          ),
          backgroundColor: blackbg,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentController,
                obscureText: true,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Current Password',
                  hintStyle: TextStyle(color: grey, fontFamily: "Trebuchet"),
                ),
              ),

              SizedBox(height: 10),
              TextField(
                controller: newController,
                obscureText: true,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'New Password',
                  hintStyle: TextStyle(color: grey, fontFamily: "Trebuchet"),
                ),
              ),

              SizedBox(height: 10),
              TextField(
                controller: confirmController,
                obscureText: true,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Confirm New Password',
                  hintStyle: TextStyle(color: grey, fontFamily: "Trebuchet"),
                ),
              ),
              SizedBox.fromSize(size: const Size.fromHeight(20)),

              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(backgroundColor: lime),
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: black, fontFamily: "DelaGothicOne"),
                ),
              ),

              SizedBox.fromSize(size: const Size.fromHeight(10)),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: lime),
                  borderRadius: BorderRadius.circular(25),
                ),
                width: 120,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    _handleChangePassword(newController.text);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: black),
                  child: Text(
                    'OK',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: white, fontFamily: "DelaGothicOne"),
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
        dynamic white = Theme.of(context).colorScheme.primary;
        dynamic lime = Theme.of(context).colorScheme.secondary;
        dynamic blackbg = Theme.of(context).colorScheme.background;
        dynamic black = Theme.of(context).colorScheme.onPrimary;
        dynamic red = Theme.of(context).colorScheme.error;

        return AlertDialog(
          title: Text(
            'Clear Conversations',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: white),
          ),
          backgroundColor: blackbg,
          content: Text(
            'Are you sure you want to clear conversations?',
            style: TextStyle(color: white, fontFamily: "Trebuchet"),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: lime),
              child: Text(
                'CANCEL',
                style: TextStyle(color: black, fontFamily: "DelaGothicOne"),
              ),
            ),
            SizedBox.fromSize(size: const Size.fromHeight(10)),
            ElevatedButton(
              onPressed: () {
                _handleClearConversations();
              },
              style: ElevatedButton.styleFrom(backgroundColor: red),
              child: Text(
                'CLEAR',
                style: TextStyle(color: white, fontFamily: "DelaGothicOne"),
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
        dynamic white = Theme.of(context).colorScheme.primary;
        dynamic lime = Theme.of(context).colorScheme.secondary;
        dynamic blackbg = Theme.of(context).colorScheme.background;
        dynamic black = Theme.of(context).colorScheme.onPrimary;
        dynamic red = Theme.of(context).colorScheme.error;

        return AlertDialog(
          title: Text(
            'Delete Account',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: white),
          ),
          backgroundColor: blackbg,
          content: Text(
            'Are you sure you want to delete your account?',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: white),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: lime),
              child: Text(
                'CANCEL',
                style: TextStyle(color: black, fontFamily: "DelaGothicOne"),
              ),
            ),

            SizedBox.fromSize(size: const Size.fromHeight(10)),
            ElevatedButton(
              onPressed: () {
                _handleDeleteAccount();
              },
              style: ElevatedButton.styleFrom(backgroundColor: red),
              child: Text(
                'DELETE',
                style: TextStyle(color: white, fontFamily: "DelaGothicOne"),
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
        dynamic white = Theme.of(context).colorScheme.primary;
        dynamic lime = Theme.of(context).colorScheme.secondary;
        dynamic black = Theme.of(context).colorScheme.onPrimary;
        dynamic blackbg = Theme.of(context).colorScheme.background;
        dynamic red = Theme.of(context).colorScheme.error;

        return AlertDialog(
          title: Text(
            'Log Out',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: white),
          ),
          backgroundColor: blackbg,
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(color: white, fontFamily: "Trebuchet"),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: lime),
              child: Text(
                'CANCEL',
                style: TextStyle(color: black, fontFamily: "DelaGothicOne"),
              ),
            ),
            SizedBox.fromSize(size: const Size.fromHeight(10)),
            ElevatedButton(
              onPressed: () {
                _handleLogOut();
              },
              style: ElevatedButton.styleFrom(backgroundColor: red),
              child: Text(
                'ACCEPT',
                style: TextStyle(color: white, fontFamily: "DelaGothicOne"),
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
