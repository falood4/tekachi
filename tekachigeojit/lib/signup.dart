import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tekachigeojit/home.dart';
import 'package:tekachigeojit/prep/prepHome.dart';
import 'package:tekachigeojit/services/AuthService.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> with TickerProviderStateMixin {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final FocusNode _emailFocus = FocusNode();

  bool _signedUp = false;

  late final AnimationController _circleController;
  late final Animation<double> _circleSize;
  late final AnimationController _checkController;
  late final Animation<double> _checkScale;

  @override
  void initState() {
    super.initState();

    _circleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _circleSize = Tween<double>(begin: 0, end: 200).animate(
      CurvedAnimation(parent: _circleController, curve: Curves.easeOutBack),
    );

    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _checkScale = Tween<double>(begin: 0, end: 1.75).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _emailFocus.dispose();
    _circleController.dispose();
    _checkController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  void handleSignup() async {
    if (_emailCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter an email')));
      return;
    }

    if (!_isValidEmail(_emailCtrl.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    if (_passwordCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a password')));
      return;
    }

    if (_passwordCtrl.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    try {
      final response = await AuthService.signup(
        email: _emailCtrl.text,
        password: _passwordCtrl.text,
      ).timeout(const Duration(seconds: 10));

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        AuthService().setCredentials(
          _emailCtrl.text.trim(),
          _passwordCtrl.text.trim(),
        );

        setState(() => _signedUp = true);

        _circleController.value = 0;
        _checkController.value = 0;

        await _circleController.forward();
        if (!mounted) return;
        await Future.delayed(const Duration(milliseconds: 200));
        await _checkController.forward();
        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const PrepHome()),
          (route) => false,
        );
      } else if (response.statusCode == 409) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Email already exists')));
        return;
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${response.body}')));
      }
    } on http.ClientException catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Network error. Please check your connection and try again.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
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

                if (!_signedUp) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: SizedBox(
                      width: screenWidth * 0.6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1D1D1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: TextField(
                          focusNode: _emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          controller: _emailCtrl,
                          decoration: InputDecoration(
                            hintText: "E-mail",
                            hintStyle: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontFamily: "Trebuchet",
                              letterSpacing: 0.1,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: SizedBox(
                      width: screenWidth * 0.6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1D1D1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: TextField(
                          controller: _passwordCtrl,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontFamily: "Trebuchet",
                              letterSpacing: 0.1,
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
                      width: 150,
                      child: ElevatedButton(
                        onPressed: handleSignup,
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontFamily: "DelaGothicOne",
                            color: Colors.black,
                          ),
                          padding: const EdgeInsets.all(16),
                          backgroundColor: const Color(0xFF8DD300),
                        ),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.04,
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
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Back",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "DelaGothicOne",
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  AnimatedBuilder(
                    animation: _circleSize,
                    builder: (context, child) {
                      final size = _circleSize.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: SizedBox(
                          width: size,
                          height: size,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF8DD300),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Center(
                              child: ScaleTransition(
                                scale: _checkScale,
                                child: const Icon(
                                  Icons.check,
                                  size: 72,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      "Account Created Successfully!",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
