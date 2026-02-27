import 'package:flutter/material.dart';
import 'package:tekachigeojit/login.dart';
import 'package:tekachigeojit/signup.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    dynamic secondary = theme.colorScheme.secondary;
    dynamic black = theme.colorScheme.onPrimary;
    dynamic lightGrey = theme.colorScheme.surface;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
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

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SizedBox(
                  width: screenWidth * 0.55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (_) => Login()));
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: theme.textTheme.labelLarge?.copyWith(
                        fontSize: 0.065 * screenWidth,
                      ),
                      padding: const EdgeInsets.all(16),
                      backgroundColor: secondary,
                    ),
                    child: Text(
                      "Log In",
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: black,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SizedBox(
                  width: screenWidth * 0.55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (_) => Signup()));
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: theme.textTheme.labelLarge?.copyWith(
                        fontSize: 0.065 * screenWidth,
                      ),
                      padding: const EdgeInsets.all(16),
                      backgroundColor: lightGrey,
                    ),
                    child: Text(
                      "Sign Up",
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    dynamic secondary = theme.colorScheme.secondary;
    return Text(
      "Tekachi",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
        fontSize: 0.2 * screenWidth,
        color: secondary,
        fontFamily: "RussoOne",
      ),
    );
  }
}

class AppSubtitle extends StatelessWidget {
  const AppSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      "Your cheatcode to acing placements",
      textAlign: TextAlign.center,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontSize: 0.04 * MediaQuery.of(context).size.width,
        color: Color.fromARGB(255, 134, 134, 134),
      ),
    );
  }
}
