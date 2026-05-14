import 'package:flutter/material.dart';
import 'package:tekachigeojit/startscreens/home.dart';
import 'package:tekachigeojit/prep/prepHome.dart';
import 'package:tekachigeojit/services/AuthService.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final FocusNode _emailFocus = FocusNode();

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  Future<void> _handleLogin() async {
    final theme = Theme.of(context);
    if (_emailCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFEAEAEA),
          content: Text(
            'Please enter an email',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Color(0xFF0047AB),
            ),
          ),
        ),
      );
      return;
    }

    if (!_isValidEmail(_emailCtrl.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFEAEAEA),
          content: Text(
            'Please enter a valid email address',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Color(0xFF0047AB),
            ),
          ),
        ),
      );
      return;
    }

    if (_passwordCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFEAEAEA),
          content: Text(
            'Please enter a password',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Color(0xFF0047AB),
            ),
          ),
        ),
      );
      return;
    }

    try {
      final response = await AuthService()
          .loginUser(email: _emailCtrl.text, password: _passwordCtrl.text)
          .timeout(const Duration(seconds: 3));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFEAEAEA),
          content: Text(
            'Logging in...',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Color(0xFF0047AB),
            ),
          ),
        ),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        AuthService().setCredentials(
          _emailCtrl.text.trim(),
          _passwordCtrl.text.trim(),
        );
        debugPrint('Login successful');

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const PrepHome()),
          (route) => false,
        );
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFFEAEAEA),
            content: Text(
              'Wrong email or password',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Color(0xFF0047AB),
              ),
            ),
          ),
        );
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFFEAEAEA),
            content: Text(
              'Cannot connect to server. Please try again later.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Color(0xFF0047AB),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFEAEAEA),
          content: Text(
            "An error occurred. $e",
            style: theme.textTheme.bodySmall?.copyWith(
              color: Color(0xFF0047AB),
            ),
          ),
        ),
      );
      debugPrintStack(label: 'Login error: $e');
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(
                    vertical: screenWidth * 0.25,
                    horizontal: screenHeight * 0.05,
                  ),
                  child: const Column(children: [AppTitle(), AppSubtitle()]),
                ),

                SizedBox(
                  width: screenWidth * 0.6,
                  height: screenHeight * 0.06,
                  child: TextField(
                    focusNode: _emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    controller: _emailCtrl,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: theme.colorScheme.surfaceDim,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      hintText: "E-mail",
                      hintStyle: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontFamily: "Trebuchet",
                        letterSpacing: 0.1,
                        color: theme.colorScheme.primary.withOpacity(0.6),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none,
                      ),
                    ),

                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    width: screenWidth * 0.6,
                    height: screenHeight * 0.06,
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceDim,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: TextField(
                        controller: _passwordCtrl,
                        obscureText: true,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontFamily: "Trebuchet",
                            letterSpacing: 0.1,
                            color: theme.colorScheme.primary.withOpacity(0.6),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 10),
                  child: SizedBox(
                    width: screenWidth * 0.4,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        textStyle: theme.textTheme.headlineLarge,
                        padding: const EdgeInsets.all(16),
                        backgroundColor: theme.colorScheme.secondary,
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: theme.colorScheme.tertiary,
                          fontSize: 0.05 * screenWidth,
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: SizedBox(
                    width: 100,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        backgroundColor: theme.colorScheme.surfaceDim,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Back",
                        style: TextStyle(
                          fontFamily: 'Trebuchet',
                          fontSize: screenWidth * 0.035,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
