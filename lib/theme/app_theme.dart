import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the application.
/// Implements Notion-inspired Dark Mode design with clean typography and organized layouts
class AppTheme {
  AppTheme._();

  // Notion-inspired Dark Mode Color Palette
  static const Color notionDarkBg = Color(0xFF191919); // Main background
  static const Color notionDarkSurface =
      Color(0xFF2F3437); // Card/surface background
  static const Color notionDarkSurfaceLight =
      Color(0xFF373C40); // Lighter surface
  static const Color notionDarkBorder = Color(0xFF434447); // Subtle borders
  static const Color notionDarkText = Color(0xFFFFFFFF); // Primary text
  static const Color notionDarkTextSecondary =
      Color(0xFF9B9B9B); // Secondary text
  static const Color notionDarkTextTertiary =
      Color(0xFF6B6B6B); // Tertiary text
  static const Color notionBlue = Color(0xFF2383E2); // Primary blue
  static const Color notionBlueLight = Color(0xFF4BA3F7); // Lighter blue
  static const Color notionGreen = Color(0xFF0F7B0F); // Success green
  static const Color notionRed = Color(0xFFE03E3E); // Error red
  static const Color notionOrange = Color(0xFFD9730D); // Warning orange
  static const Color notionPurple = Color(0xFF6940A5); // Accent purple
  static const Color notionGray = Color(0xFF787774); // Neutral gray

  // Light theme colors (minimal changes for contrast)
  static const Color primaryLight = Color(0xFF2563EB);
  static const Color secondaryLight = Color(0xFF64748B);
  static const Color accentLight = Color(0xFFF59E0B);
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF1E293B);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color successLight = Color(0xFF10B981);
  static const Color warningLight = Color(0xFFF59E0B);
  static const Color errorLight = Color(0xFFEF4444);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color dividerLight = Color(0xFFE2E8F0);
  static const Color shadowLight = Color(0x1A000000);

  // Dark theme colors - Notion inspired
  static const Color primaryDark = notionBlue;
  static const Color secondaryDark = notionDarkTextSecondary;
  static const Color accentDark = notionOrange;
  static const Color backgroundDark = notionDarkBg;
  static const Color surfaceDark = notionDarkSurface;
  static const Color textPrimaryDark = notionDarkText;
  static const Color textSecondaryDark = notionDarkTextSecondary;
  static const Color successDark = notionGreen;
  static const Color warningDark = notionOrange;
  static const Color errorDark = notionRed;
  static const Color borderDark = notionDarkBorder;
  static const Color dividerDark = notionDarkBorder;
  static const Color shadowDark = Color(0x1A000000);

  /// Light theme - Contemporary Minimalist Productivity
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryLight,
      onPrimary: Colors.white,
      primaryContainer: primaryLight.withAlpha(26),
      onPrimaryContainer: primaryLight,
      secondary: secondaryLight,
      onSecondary: Colors.white,
      secondaryContainer: secondaryLight.withAlpha(26),
      onSecondaryContainer: secondaryLight,
      tertiary: accentLight,
      onTertiary: Colors.white,
      tertiaryContainer: accentLight.withAlpha(26),
      onTertiaryContainer: accentLight,
      error: errorLight,
      onError: Colors.white,
      surface: surfaceLight,
      onSurface: textPrimaryLight,
      onSurfaceVariant: textSecondaryLight,
      outline: borderLight,
      outlineVariant: dividerLight,
      shadow: shadowLight,
      scrim: Colors.black54,
      inverseSurface: surfaceDark,
      onInverseSurface: textPrimaryDark,
      inversePrimary: primaryDark,
    ),
    scaffoldBackgroundColor: backgroundLight,
    cardColor: surfaceLight,
    dividerColor: dividerLight,
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceLight,
      foregroundColor: textPrimaryLight,
      elevation: 0,
      scrolledUnderElevation: 1,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
      ),
      iconTheme: IconThemeData(color: textPrimaryLight),
    ),
    cardTheme: CardTheme(
      color: surfaceLight,
      elevation: 0,
      shadowColor: shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: borderLight, width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceLight,
      selectedItemColor: primaryLight,
      unselectedItemColor: textSecondaryLight,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle:
          GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500),
      unselectedLabelStyle:
          GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w400),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryLight,
      foregroundColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryLight,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        side: BorderSide(color: borderLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
    textTheme: _buildTextTheme(isLight: true),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceLight,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: BorderSide(color: borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: BorderSide(color: borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: BorderSide(color: primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: BorderSide(color: errorLight),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: BorderSide(color: errorLight, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
          color: textSecondaryLight, fontSize: 14, fontWeight: FontWeight.w400),
      hintStyle: GoogleFonts.inter(
          color: textSecondaryLight.withAlpha(153),
          fontSize: 14,
          fontWeight: FontWeight.w400),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primaryLight;
        return Colors.grey[300];
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected))
          return primaryLight.withAlpha(77);
        return Colors.grey[200];
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primaryLight;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: BorderSide(color: borderLight),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primaryLight;
        return textSecondaryLight;
      }),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryLight,
      linearTrackColor: primaryLight.withAlpha(51),
      circularTrackColor: primaryLight.withAlpha(51),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryLight,
      thumbColor: primaryLight,
      overlayColor: primaryLight.withAlpha(51),
      inactiveTrackColor: primaryLight.withAlpha(77),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: primaryLight,
      unselectedLabelColor: textSecondaryLight,
      indicatorColor: primaryLight,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle:
          GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: textPrimaryLight.withAlpha(230),
        borderRadius: BorderRadius.circular(6),
      ),
      textStyle: GoogleFonts.inter(
          color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: textPrimaryLight,
      contentTextStyle: GoogleFonts.inter(
          color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
      actionTextColor: accentLight,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
    ),
    dialogTheme: DialogThemeData(backgroundColor: surfaceLight),
  );

  /// Dark theme - Notion-inspired Dark Mode
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryDark,
      onPrimary: Colors.white,
      primaryContainer: primaryDark.withAlpha(26),
      onPrimaryContainer: primaryDark,
      secondary: secondaryDark,
      onSecondary: notionDarkBg,
      secondaryContainer: secondaryDark.withAlpha(26),
      onSecondaryContainer: secondaryDark,
      tertiary: accentDark,
      onTertiary: Colors.white,
      tertiaryContainer: accentDark.withAlpha(26),
      onTertiaryContainer: accentDark,
      error: errorDark,
      onError: Colors.white,
      surface: surfaceDark,
      onSurface: textPrimaryDark,
      onSurfaceVariant: textSecondaryDark,
      outline: borderDark,
      outlineVariant: dividerDark,
      shadow: shadowDark,
      scrim: Colors.black87,
      inverseSurface: surfaceLight,
      onInverseSurface: textPrimaryLight,
      inversePrimary: primaryLight,
    ),
    scaffoldBackgroundColor: backgroundDark,
    cardColor: surfaceDark,
    dividerColor: dividerDark,

    // Notion-style AppBar - clean and minimal
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundDark,
      foregroundColor: textPrimaryDark,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      iconTheme: IconThemeData(color: textPrimaryDark, size: 20),
    ),

    // Notion-style Cards - subtle borders and clean backgrounds
    cardTheme: CardTheme(
      color: surfaceDark,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: borderDark, width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    ),

    // Bottom navigation with Notion aesthetics
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: backgroundDark,
      selectedItemColor: primaryDark,
      unselectedItemColor: textSecondaryDark,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Floating Action Button with Notion blue
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryDark,
      foregroundColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),

    // Button themes with Notion styling
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryDark,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textPrimaryDark,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        side: BorderSide(color: borderDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryDark,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // Typography - Inter font for Notion-like readability
    textTheme: _buildTextTheme(isLight: false),

    // Input decoration with Notion aesthetics
    inputDecorationTheme: InputDecorationTheme(
      fillColor: notionDarkSurfaceLight,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: BorderSide(color: borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: BorderSide(color: borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: BorderSide(color: primaryDark, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: BorderSide(color: errorDark),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: BorderSide(color: errorDark, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondaryDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: notionDarkTextTertiary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),

    // Switch theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        return notionGray;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark.withAlpha(77);
        }
        return notionDarkBorder;
      }),
    ),

    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: BorderSide(color: borderDark),
    ),

    // Radio theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        return textSecondaryDark;
      }),
    ),

    // Progress indicator theme
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryDark,
      linearTrackColor: borderDark,
      circularTrackColor: borderDark,
    ),

    // Slider theme
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryDark,
      thumbColor: primaryDark,
      overlayColor: primaryDark.withAlpha(51),
      inactiveTrackColor: borderDark,
    ),

    // Tab bar theme
    tabBarTheme: TabBarTheme(
      labelColor: primaryDark,
      unselectedLabelColor: textSecondaryDark,
      indicatorColor: primaryDark,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Tooltip theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: notionDarkSurfaceLight,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderDark),
      ),
      textStyle: GoogleFonts.inter(
        color: textPrimaryDark,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // SnackBar theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: notionDarkSurfaceLight,
      contentTextStyle: GoogleFonts.inter(
        color: textPrimaryDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: primaryDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: borderDark),
      ),
    ),
  );

  /// Helper method to build text theme based on brightness
  /// Uses Inter font family for Notion-like geometric clarity and readability
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textPrimary = isLight ? textPrimaryLight : textPrimaryDark;
    final Color textSecondary =
        isLight ? textSecondaryLight : textSecondaryDark;
    final Color textTertiary =
        isLight ? textSecondaryLight : notionDarkTextTertiary;

    return TextTheme(
      // Display styles - Notion-inspired headers
      displayLarge: GoogleFonts.inter(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: -0.5,
        height: 1.1,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: -0.25,
        height: 1.15,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.2,
      ),

      // Headline styles - Notion section headers
      headlineLarge: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.3,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.3,
      ),

      // Title styles - Notion card and component headers
      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.4,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.1,
        height: 1.4,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.1,
        height: 1.4,
      ),

      // Body styles - Notion content text
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.45,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        letterSpacing: 0,
        height: 1.4,
      ),

      // Label styles - Notion UI elements and metadata
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.4,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        letterSpacing: 0,
        height: 1.35,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textTertiary,
        letterSpacing: 0,
        height: 1.3,
      ),
    );
  }
}
