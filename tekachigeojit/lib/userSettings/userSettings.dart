import 'package:flutter/material.dart';
import 'package:tekachigeojit/apptheme.dart';
import 'package:tekachigeojit/components/Widgets/NavBar.dart';
import 'package:tekachigeojit/startscreens/home.dart';
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

    final Color accent = Theme.of(context).colorScheme.secondary;
    final Color textPrimary = Theme.of(context).colorScheme.primary;
    final Color cardBackground = Theme.of(context).colorScheme.surfaceDim;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                      color: cardBackground,
                      borderRadius: BorderRadius.circular(cardRadius),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: profileHeight * 0.32,
                          backgroundColor: textPrimary,
                          child: Icon(
                            Icons.person,
                            size: profileHeight * 0.35,
                            color: accent,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.04),
                        Text(
                          AuthService().shareEmail() ?? '',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: baseFontSize,
                                color: textPrimary,
                              ),
                        ),
                      ],
                    ),
                  ),

                  /// Settings Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cardBackground,
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
                                      color: Color(0xFF8DD300),
                                      size: 22,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      "Change theme",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(color: Color(0xFF8DD300)),
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
                                  ).colorScheme.tertiary,
                                  inactiveThumbColor: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                  inactiveTrackColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
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
    dynamic textColor = Theme.of(context).colorScheme.primary;
    dynamic red = Theme.of(context).colorScheme.error;
    final color = isDestructive ? red : textColor;

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
        final Color dialogBg = Theme.of(context).colorScheme.surface;
        final Color dialogText = Theme.of(context).colorScheme.onSurface;

        return AlertDialog(
          title: Text(
            'Change Password',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: primary),
          ),
          backgroundColor: dialogBg,
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
                  style: TextStyle(
                    color: dialogText,
                    fontFamily: "DelaGothicOne",
                  ),
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
                    _handleChangePassword(
                      currentController.text,
                      newController.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: dialogText),
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

  Future<void> _handleChangePassword(
    String oldPassword,
    String newPassword,
  ) async {
    final response = await AuthService().changePassword(
      oldPassword: oldPassword,
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
        final Color dialogBg = Theme.of(context).colorScheme.surface;
        final Color dialogText = Theme.of(context).colorScheme.onSurface;
        final Color red = Theme.of(context).colorScheme.error;

        return AlertDialog(
          title: Text(
            'Delete Account',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: primary),
          ),
          backgroundColor: dialogBg,
          content: Text(
            'Are you sure you want to delete your account?',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: primary),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: secondary),
              child: Text(
                'NO',
                style: TextStyle(
                  color: dialogText,
                  fontFamily: "DelaGothicOne",
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleDeleteAccount();
              },
              style: ElevatedButton.styleFrom(backgroundColor: red),
              child: Text(
                'YES',
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
        final Color dialogText = Theme.of(context).colorScheme.onSurface;
        final Color dialogBg = Theme.of(context).colorScheme.surface;
        final Color red = Theme.of(context).colorScheme.error;

        return AlertDialog(
          title: Text(
            'Log Out',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: primary),
          ),
          backgroundColor: dialogBg,
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(color: primary, fontFamily: "Trebuchet"),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: secondary),
              child: Text(
                'NO',
                style: TextStyle(
                  color: dialogText,
                  fontFamily: "DelaGothicOne",
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleLogOut();
              },
              style: ElevatedButton.styleFrom(backgroundColor: red),
              child: Text(
                'YES',
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
