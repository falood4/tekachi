import 'package:flutter/material.dart';
import 'package:tekachigeojit/apptheme.dart';
import 'package:tekachigeojit/components/NavBar.dart';
import 'package:tekachigeojit/home.dart';
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
    final double baseFontSize = screenWidth * 0.05;

    final Color primary = Theme.of(context).colorScheme.secondary;
    final Color black = Theme.of(context).colorScheme.onPrimary;
    final Color lightGrey = Theme.of(context).colorScheme.surface;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: NavBar(selectedPage: 3),
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
                            color: primary,
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
                          icon: Icons.lock_outline,
                          onPressed: _setChangePassword,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 35,
                                vertical: 16,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.brightness_medium_rounded,
                                      color: Colors.black,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      "Change theme",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(width: screenWidth * 0.05),

                            ValueListenableBuilder<ThemeMode>(
                              valueListenable: themeNotifier,
                              builder: (context, themeMode, child) {
                                return Switch(
                                  value: themeMode == ThemeMode.light,
                                  onChanged: (val) {
                                    _changeTheme();
                                  },
                                  activeThumbColor: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                  activeTrackColor: Theme.of(
                                    context,
                                  ).colorScheme.background,
                                  inactiveThumbColor: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                  inactiveTrackColor: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                );
                              },
                            ),
                          ],
                        ),

                        _settingsItem(
                          "Log Out",
                          icon: Icons.logout,
                          onPressed: _confirmLogout,
                        ),
                        _settingsItem(
                          "Delete account",
                          icon: Icons.delete_forever_outlined,
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
    required IconData icon,
    bool isDestructive = false,
    required VoidCallback onPressed,
  }) {
    dynamic black = Theme.of(context).colorScheme.onPrimary;
    dynamic red = Theme.of(context).colorScheme.error;
    final color = isDestructive ? red : black;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 12),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }

  void _setChangePassword() {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final Color primary = Theme.of(context).colorScheme.primary;
        final Color secondary = Theme.of(context).colorScheme.secondary;
        final Color tertiary = Theme.of(context).colorScheme.tertiary;
        final Color blackbg = Theme.of(context).colorScheme.background;
        final Color black = Theme.of(context).colorScheme.onPrimary;

        return AlertDialog(
          title: Text(
            'Change Password',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: primary),
          ),
          backgroundColor: blackbg,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentController,
                obscureText: true,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
                decoration: InputDecoration(
                  hintText: 'Current Password',
                  hintStyle: TextStyle(
                    color: tertiary,
                    fontFamily: "Trebuchet",
                  ),
                ),
              ),

              SizedBox(height: 10),
              TextField(
                controller: newController,
                obscureText: true,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
                decoration: InputDecoration(
                  hintText: 'New Password',
                  hintStyle: TextStyle(
                    color: tertiary,
                    fontFamily: "Trebuchet",
                  ),
                ),
              ),

              SizedBox(height: 10),
              TextField(
                controller: confirmController,
                obscureText: true,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
                decoration: InputDecoration(
                  hintText: 'Confirm New Password',
                  hintStyle: TextStyle(
                    color: tertiary,
                    fontFamily: "Trebuchet",
                  ),
                ),
              ),
              SizedBox.fromSize(size: const Size.fromHeight(20)),

              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(backgroundColor: secondary),
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: black, fontFamily: "DelaGothicOne"),
                ),
              ),

              SizedBox.fromSize(size: const Size.fromHeight(10)),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: secondary),
                  borderRadius: BorderRadius.circular(25),
                ),
                width: 120,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    if (newController.text.isEmpty ||
                        confirmController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF8DD300),
                          content: Text(
                            'Please fill in all password fields.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.black),
                          ),
                        ),
                      );
                      return;
                    }
                    if (newController.text != confirmController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF8DD300),
                          content: Text(
                            'New passwords do not match.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.black),
                          ),
                        ),
                      );
                      return;
                    }
                    Navigator.of(context).pop();
                    _handleChangePassword(newController.text);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: black),
                  child: Text(
                    'OK',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
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

    if (!mounted) return;
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('Password changed successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF8DD300),
          content: Text(
            'Password changed successfully.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.black),
          ),
        ),
      );
    } else {
      debugPrint('Failed to change password');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF8DD300),
          content: Text(
            'Failed to change password. Please try again.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.black),
          ),
        ),
      );
    }
  }

  void _changeTheme() {
    themeNotifier.toggleTheme();
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final Color primary = Theme.of(context).colorScheme.primary;
        final Color secondary = Theme.of(context).colorScheme.secondary;
        final Color blackbg = Theme.of(context).colorScheme.background;
        final Color black = Theme.of(context).colorScheme.onPrimary;
        final Color red = Theme.of(context).colorScheme.error;

        return AlertDialog(
          title: Text(
            'Delete Account',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: primary),
          ),
          backgroundColor: blackbg,
          content: Text(
            'Are you sure you want to delete your account?',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: primary),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: secondary),
              child: Text(
                'CANCEL',
                style: TextStyle(color: black, fontFamily: "DelaGothicOne"),
              ),
            ),

            SizedBox.fromSize(size: const Size.fromHeight(10)),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleDeleteAccount();
              },
              style: ElevatedButton.styleFrom(backgroundColor: red),
              child: Text(
                'DELETE',
                style: TextStyle(color: primary, fontFamily: "DelaGothicOne"),
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

      if (!mounted) return;
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
        final Color primary = Theme.of(context).colorScheme.primary;
        final Color secondary = Theme.of(context).colorScheme.secondary;
        final Color black = Theme.of(context).colorScheme.onPrimary;
        final Color blackbg = Theme.of(context).colorScheme.background;
        final Color red = Theme.of(context).colorScheme.error;

        return AlertDialog(
          title: Text(
            'Log Out',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: primary),
          ),
          backgroundColor: blackbg,
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(color: primary, fontFamily: "Trebuchet"),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: secondary),
              child: Text(
                'CANCEL',
                style: TextStyle(color: black, fontFamily: "DelaGothicOne"),
              ),
            ),
            SizedBox.fromSize(size: const Size.fromHeight(10)),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleLogOut();
              },
              style: ElevatedButton.styleFrom(backgroundColor: red),
              child: Text(
                'ACCEPT',
                style: TextStyle(color: primary, fontFamily: "DelaGothicOne"),
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

      if (!mounted) return;
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
