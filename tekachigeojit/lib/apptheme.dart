import 'package:flutter/material.dart';

@immutable
class AppCustomColors extends ThemeExtension<AppCustomColors> {
  final Color cardLight;
  final Color popupSurface;
  final Color quizOption;
  final Color success;
  final Color danger;

  const AppCustomColors({
    required this.cardLight,
    required this.popupSurface,
    required this.quizOption,
    required this.success,
    required this.danger,
  });

  @override
  AppCustomColors copyWith({
    Color? cardLight,
    Color? popupSurface,
    Color? quizOption,
    Color? success,
    Color? danger,
  }) {
    return AppCustomColors(
      cardLight: cardLight ?? this.cardLight,
      popupSurface: popupSurface ?? this.popupSurface,
      quizOption: quizOption ?? this.quizOption,
      success: success ?? this.success,
      danger: danger ?? this.danger,
    );
  }

  @override
  AppCustomColors lerp(ThemeExtension<AppCustomColors>? other, double t) {
    if (other is! AppCustomColors) return this;
    return AppCustomColors(
      cardLight: Color.lerp(cardLight, other.cardLight, t)!,
      popupSurface: Color.lerp(popupSurface, other.popupSurface, t)!,
      quizOption: Color.lerp(quizOption, other.quizOption, t)!,
      success: Color.lerp(success, other.success, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
    );
  }
}

class AppTheme {
  AppTheme._();

  static const Color _accent = Color(0xFF0047AB);
  static const Color _cardLight = Color(0xFFEAEAEA);
  static const Color _white = Colors.white;
  static const Color _black = Colors.black;
  static const Color _grey = Color(0xFF27282A);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: _white,

    colorScheme: const ColorScheme.light(
      primary: _black,
      secondary: _accent,
      tertiary: _cardLight,
      surface: _white,
      error: Color(0xFFE53935),
      onSurface: _grey,
      surfaceDim: Color.fromARGB(255, 221, 221, 221),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'ElmsSansBold',
        fontSize: 32,
        color: _accent,
      ),
      titleLarge: TextStyle(
        fontFamily: 'ElmsSansBold',
        fontSize: 26,
        fontWeight: FontWeight.w500,
        color: _black,
      ),
      titleMedium: TextStyle(
        fontFamily: 'ElmsSansItalic',
        fontSize: 24,
        fontWeight: FontWeight.w100,
        color: _black,
      ),
      bodyLarge: TextStyle(
        fontSize: 22,
        fontFamily: "Trebuchet",
        color: Colors.black87,
      ),
      bodyMedium: TextStyle(
        fontSize: 20,
        fontFamily: "Trebuchet",
        color: Colors.black87,
      ),
      bodySmall: TextStyle(
        fontSize: 16,
        fontFamily: "Trebuchet",
        color: Colors.black87,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _accent,
        disabledBackgroundColor: _cardLight,
        foregroundColor: _white,
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
    ),

    snackBarTheme: const SnackBarThemeData(
      backgroundColor: _cardLight,
      contentTextStyle: TextStyle(
        color: _accent,
        fontFamily: 'Trebuchet',
        fontSize: 16,
      ),
    ),

    extensions: const [
      AppCustomColors(
        cardLight: _cardLight,
        popupSurface: Color(0xFF1F1F1F),
        quizOption: Color(0xFFEFEFEF),
        success: Color(0xFF4CAF50),
        danger: Color(0xFFE53935),
      ),
    ],
  );
}

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.dark);

  bool get isDarkMode => value == ThemeMode.dark;

  void toggleTheme() {
    value = isDarkMode ? ThemeMode.light : ThemeMode.dark;
  }
}

final themeNotifier = ThemeNotifier();
