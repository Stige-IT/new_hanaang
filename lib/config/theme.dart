import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
/*
  ThemeData for the app
 */

class ConfigTheme {
  /// [themeData] is the main theme for the app
  static final ThemeData themeData = ThemeData(
    useMaterial3: false,
    fontFamily: "Poppins",
    primaryColor: _colorSchemeLight.primary,
    colorScheme: _colorSchemeLight,
    appBarTheme: _myAppBarTheme,
    textButtonTheme: _myTextButtonTheme,
    elevatedButtonTheme: _myElevatedButtonTheme,
    outlinedButtonTheme: _myOutlineButtonTheme,
    textTheme: _myTextTheme,
    primaryTextTheme: _myTextTheme,
    floatingActionButtonTheme: _myFloatingActionButtonTheme,
  );

  /// [TextTheme]
  static final TextTheme _myTextTheme = TextTheme(
    bodySmall: TextStyle(
      fontSize: 12.sp,
      color: _colorSchemeLight.onBackground,
    ),
    bodyMedium: TextStyle(
      fontSize: 16.sp,
      color: _colorSchemeLight.onBackground,
    ),
    bodyLarge: TextStyle(
      fontSize: 20.sp,
      color: _colorSchemeLight.onBackground,
    ),
    headlineSmall: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: _colorSchemeLight.onBackground,
    ),
    headlineLarge: TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w500,
      color: _colorSchemeLight.onBackground,
    ),
  );

  /// [AppBarTheme]
  static final AppBarTheme _myAppBarTheme = AppBarTheme(
    backgroundColor: _colorSchemeLight.primary,
    elevation: 0,
    centerTitle: true,
    foregroundColor: _colorSchemeLight.onPrimary,
    titleTextStyle: _myTextTheme.bodyMedium!.copyWith(
      fontWeight: FontWeight.w600,
      color: _colorSchemeLight.onPrimary,
    ),
  );

  /// [FloatingActionButtonThemeData]
  static final FloatingActionButtonThemeData _myFloatingActionButtonTheme =
      FloatingActionButtonThemeData(
    backgroundColor: _colorSchemeLight.primary,
    foregroundColor: _colorSchemeLight.onPrimary,
    elevation: 0,
  );

  /// [OutlinedButtonThemeData]
  static final OutlinedButtonThemeData _myOutlineButtonTheme =
      OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
          side: BorderSide(color: _colorSchemeLight.primary),
        ),
        padding: EdgeInsets.all(15.h),
        textStyle: _myTextTheme.bodySmall!),
  );

  /// [ElevatedButtonThemeData]
  static final ElevatedButtonThemeData _myElevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _colorSchemeLight.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      padding: EdgeInsets.all(15.h),
      textStyle: _myTextTheme.bodySmall!.copyWith(
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  /// [TextButtonThemeData]
  static final TextButtonThemeData _myTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      visualDensity: const VisualDensity(vertical: -4),
      padding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      alignment: Alignment.centerLeft,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  );

  /// [ColorScheme]
  static const ColorScheme _colorSchemeLight = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFFEB716),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF4D616C),
    onSecondary: Color(0xFFFFFFFF),
    error: Color(0xFFB00020),
    onError: Color(0xFFFFFFFF),
    background: Color(0xFFFBFCFE),
    onBackground: Color(0xFF191C1E),
    surface: Color(0xFFFBFCFE),
    onSurface: Color(0xFF191C1E),
  );
}
