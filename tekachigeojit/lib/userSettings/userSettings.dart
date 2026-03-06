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

    dynamic primary = Theme.of(context).colorScheme.secondary;
    dynamic black = Theme.of(context).colorScheme.onPrimary;
    dynamic lightGrey = Theme.of(context).colorScheme.surface;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
                          onPressed: _setChangePassword,
                          icon: Icon(Icons.password),
                        ),

                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.08,
                                vertical: 16,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.brightness_6,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                      size: 26,
                                    ),
                                    SizedBox(width: 12),
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

                            SizedBox(width: screenWidth * 0.1),

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
                          onPressed: _confirmLogout,
                          icon: Icon(Icons.logout_outlined),
                        ),

                        _settingsItem(
                          "Delete account",
                          isDestructive: true,
                          onPressed: _confirmDeleteAccount,
                          icon: Icon(Icons.delete_forever_outlined),
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
    required Icon icon,
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
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Icon(
                icon.icon,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 26,
              ),

              SizedBox(width: 12),

              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDestructive ? red : black,
                ),
              ),
            ],
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
      builder: (BuildContext dialogContext) {
        dynamic primary = Theme.of(dialogContext).colorScheme.primary;
        dynamic secondary = Theme.of(dialogContext).colorScheme.secondary;
        dynamic tertiary = Theme.of(dialogContext).colorScheme.tertiary;
        dynamic blackbg = Theme.of(dialogContext).colorScheme.background;
        dynamic black = Theme.of(dialogContext).colorScheme.onPrimary;

        return AlertDialog(
          title: Text(
            'Change Password',
            style: Theme.of(
              dialogContext,
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
                style: Theme.of(dialogContext).textTheme.bodyMedium,
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
                style: Theme.of(dialogContext).textTheme.bodyMedium,
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
                style: Theme.of(dialogContext).textTheme.bodyMedium,
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
                  Navigator.of(dialogContext).pop();
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
                    final newPass = newController.text.trim();
                    final confirmPass = confirmController.text.trim();
                    if (newPass.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Password must be at least 6 characters',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      );
                      return;
                    }
                    if (newPass != confirmPass) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Passwords do not match',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      );
                      return;
                    }
                    _handleChangePassword(newPass);
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
    ).then((_) {
      currentController.dispose();
      newController.dispose();
      confirmController.dispose();
    });
  }

  Future<void> _handleChangePassword(String newPassword) async {
    final response = await AuthService().changePassword(
      newPassword: newPassword,
    );

    if (!mounted) return;
    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.pop(context);
      debugPrint('Password changed successfully');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to change password. Please try again.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      );
      debugPrint('Failed to change password');
    }
  }

  void _changeTheme() {
    themeNotifier.toggleTheme();
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        dynamic primary = Theme.of(context).colorScheme.primary;
        dynamic secondary = Theme.of(context).colorScheme.secondary;
        dynamic blackbg = Theme.of(context).colorScheme.background;
        dynamic black = Theme.of(context).colorScheme.onPrimary;
        dynamic red = Theme.of(context).colorScheme.error;

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
        dynamic primary = Theme.of(context).colorScheme.primary;
        dynamic secondary = Theme.of(context).colorScheme.secondary;
        dynamic black = Theme.of(context).colorScheme.onPrimary;
        dynamic blackbg = Theme.of(context).colorScheme.background;
        dynamic red = Theme.of(context).colorScheme.error;

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
