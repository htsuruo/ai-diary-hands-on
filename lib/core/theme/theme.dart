import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _themeData(.light);
  static ThemeData get dark => _themeData(.dark);

  static ThemeData _themeData(Brightness brightness) {
    final themeData = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        brightness: brightness,
        seedColor: Colors.blue,
      ),
    );
    final listTextStyle = themeData.textTheme.bodyMedium;

    return themeData.copyWith(
      splashFactory: InkSparkle.splashFactory,
      textTheme: themeData.textTheme.apply(
        fontFamily: GoogleFonts.inter().fontFamily,
        fontFamilyFallback: [GoogleFonts.notoSansJp().fontFamily!],
      ),
      appBarTheme: AppBarTheme(
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: .w700,
          color: themeData.colorScheme.onSurface,
        ),
        shape: Border(
          bottom: BorderSide(
            color: themeData.colorScheme.surfaceContainerHighest,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(space: 0),
      listTileTheme: ListTileThemeData(
        titleTextStyle: listTextStyle,
        leadingAndTrailingTextStyle: listTextStyle,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: .floating,
        shape: RoundedRectangleBorder(
          borderRadius: .circular(8),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        labelStyle: TextStyle(fontWeight: .bold),
        floatingLabelBehavior: .always,
        border: OutlineInputBorder(
          borderSide: .none,
          borderRadius: .all(.circular(8)),
        ),
        contentPadding: .all(12),
        alignLabelWithHint: true,
      ),
    );
  }
}
