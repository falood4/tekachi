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

  static const Color _background = Color(0xFF141414);
  static const Color _accent = Color(0xFF8DD300);
  static const Color _cardLight = Color(0xFFD9D9D9);
  static const Color _white = Colors.white;
  static const Color _black = Colors.black;
  static const Color _tertiary = const Color.fromARGB(255, 132, 132, 132);

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: _background,

    colorScheme: const ColorScheme.dark(
      primary: _white,
      secondary: _accent,
      tertiary: _tertiary,
      background: _background,
      surface: _cardLight,
      error: Color(0xFFE53935),
      onPrimary: _black,
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'DelaGothicOne',
        fontSize: 32,
        color: _accent,
      ),
      titleLarge: TextStyle(
        fontFamily: 'RussoOne',
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: _black,
      ),
      titleMedium: TextStyle(
        fontFamily: 'RussoOne',
        fontSize: 24,
        fontWeight: FontWeight.w300,
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
        color: _white,
      ),
    ),

    cardTheme: const CardThemeData(
      color: _cardLight,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        disabledBackgroundColor: _cardLight,
        foregroundColor: _accent,
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
    ),

    dialogTheme: const DialogThemeData(
      backgroundColor: _cardLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
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

  static final ButtonStyle topicCards = ElevatedButton.styleFrom(
    backgroundColor: Color(0xFFD9D9D9),
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
  );
}
