import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the time tracking application.
/// Implements Contemporary Professional Minimalism with Focused Blue Productivity theme.
class AppTheme {
  AppTheme._();

  // Core brand colors - Focused Blue Productivity palette
  static const Color primaryBlue = Color(0xFF3B59F5);
  static const Color primaryBlueDark = Color(0xFF2A47E8);
  static const Color successGreen = Color(0xFF34C759);
  static const Color alertRed = Color(0xFFFF3B30);
  
  // Background and surface colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  // Text colors with proper contrast ratios
  static const Color textPrimary = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFF8E8E93);
  
  // Utility colors
  static const Color borderSubtle = Color(0xFFE5E5EA);
  static const Color progressTrack = Color(0xFFF2F2F7);
  static const Color cardDark = Color(0xFF2D2D2D);
  static const Color dialogDark = Color(0xFF2D2D2D);
  
  // Shadow colors for subtle elevation
  static const Color shadowLight = Color(0x0F000000);
  static const Color shadowDark = Color(0x1FFFFFFF);

  /// Light theme optimized for mobile productivity
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryBlue,
      onPrimary: surfaceWhite,
      primaryContainer: primaryBlueDark,
      onPrimaryContainer: surfaceWhite,
      secondary: successGreen,
      onSecondary: surfaceWhite,
      secondaryContainer: successGreen.withValues(alpha: 0.1),
      onSecondaryContainer: textPrimary,
      tertiary: alertRed,
      onTertiary: surfaceWhite,
      tertiaryContainer: alertRed.withValues(alpha: 0.1),
      onTertiaryContainer: textPrimary,
      error: alertRed,
      onError: surfaceWhite,
      surface: surfaceWhite,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: borderSubtle,
      outlineVariant: progressTrack,
      shadow: shadowLight,
      scrim: shadowLight,
      inverseSurface: textPrimary,
      onInverseSurface: surfaceWhite,
      inversePrimary: primaryBlue,
    ),
    scaffoldBackgroundColor: backgroundLight,
    cardColor: surfaceWhite,
    dividerColor: borderSubtle,
    
    // AppBar theme with gradient-ready styling
    appBarTheme: AppBarTheme(
      backgroundColor: primaryBlue,
      foregroundColor: surfaceWhite,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: surfaceWhite,
        letterSpacing: 0.15,
      ),
      iconTheme: const IconThemeData(
        color: surfaceWhite,
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: surfaceWhite,
        size: 24,
      ),
    ),
    
    // Card theme for content containers
    cardTheme: CardThemeData(
      color: surfaceWhite,
      elevation: 2.0,
      shadowColor: shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    
    // Bottom navigation optimized for thumb interaction
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceWhite,
      selectedItemColor: primaryBlue,
      unselectedItemColor: textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    
    // Floating action button for primary actions
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryBlue,
      foregroundColor: surfaceWhite,
      elevation: 6.0,
      focusElevation: 8.0,
      hoverElevation: 8.0,
      highlightElevation: 12.0,
    ),
    
    // Button themes with proper touch targets
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: surfaceWhite,
        backgroundColor: primaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(88, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 2.0,
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(88, 48),
        side: const BorderSide(color: primaryBlue, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: const Size(64, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),
    
    // Typography system using Inter font family
    textTheme: _buildTextTheme(isLight: true),
    
    // Input decoration for forms
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceWhite,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: borderSubtle, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: borderSubtle, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primaryBlue, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: alertRed, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: alertRed, width: 2.0),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    
    // Switch theme for settings
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue;
        }
        return progressTrack;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue.withValues(alpha: 0.3);
        }
        return borderSubtle;
      }),
    ),
    
    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue;
        }
        return surfaceWhite;
      }),
      checkColor: WidgetStateProperty.all(surfaceWhite),
      side: const BorderSide(color: borderSubtle, width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),
    
    // Radio theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue;
        }
        return borderSubtle;
      }),
    ),
    
    // Progress indicators for timer states
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryBlue,
      linearTrackColor: progressTrack,
      circularTrackColor: progressTrack,
    ),
    
    // Slider theme for time adjustments
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryBlue,
      thumbColor: primaryBlue,
      overlayColor: primaryBlue.withValues(alpha: 0.2),
      inactiveTrackColor: progressTrack,
      trackHeight: 4.0,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
    ),
    
    // Tab bar theme
    tabBarTheme: TabBarThemeData(
      labelColor: primaryBlue,
      unselectedLabelColor: textSecondary,
      indicatorColor: primaryBlue,
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
        color: textPrimary.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.inter(
        color: surfaceWhite,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    
    // SnackBar theme for feedback
    snackBarTheme: SnackBarThemeData(
      backgroundColor: textPrimary,
      contentTextStyle: GoogleFonts.inter(
        color: surfaceWhite,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: primaryBlue,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 6.0,
    ), dialogTheme: DialogThemeData(backgroundColor: surfaceWhite),
  );

  /// Dark theme optimized for low-light productivity sessions
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryBlue,
      onPrimary: surfaceWhite,
      primaryContainer: primaryBlueDark,
      onPrimaryContainer: surfaceWhite,
      secondary: successGreen,
      onSecondary: textPrimary,
      secondaryContainer: successGreen.withValues(alpha: 0.2),
      onSecondaryContainer: surfaceWhite,
      tertiary: alertRed,
      onTertiary: surfaceWhite,
      tertiaryContainer: alertRed.withValues(alpha: 0.2),
      onTertiaryContainer: surfaceWhite,
      error: alertRed,
      onError: surfaceWhite,
      surface: surfaceDark,
      onSurface: textPrimaryDark,
      onSurfaceVariant: textSecondaryDark,
      outline: borderSubtle.withValues(alpha: 0.3),
      outlineVariant: progressTrack.withValues(alpha: 0.1),
      shadow: shadowDark,
      scrim: shadowDark,
      inverseSurface: surfaceWhite,
      onInverseSurface: textPrimary,
      inversePrimary: primaryBlue,
    ),
    scaffoldBackgroundColor: backgroundDark,
    cardColor: cardDark,
    dividerColor: borderSubtle.withValues(alpha: 0.2),
    
    // AppBar theme for dark mode
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceDark,
      foregroundColor: textPrimaryDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
        letterSpacing: 0.15,
      ),
      iconTheme: const IconThemeData(
        color: textPrimaryDark,
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: textPrimaryDark,
        size: 24,
      ),
    ),
    
    // Card theme for dark mode
    cardTheme: CardThemeData(
      color: cardDark,
      elevation: 4.0,
      shadowColor: shadowDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    
    // Bottom navigation for dark mode
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
      selectedItemColor: primaryBlue,
      unselectedItemColor: textSecondaryDark,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    
    // Floating action button for dark mode
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryBlue,
      foregroundColor: surfaceWhite,
      elevation: 6.0,
      focusElevation: 8.0,
      hoverElevation: 8.0,
      highlightElevation: 12.0,
    ),
    
    // Button themes for dark mode
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: surfaceWhite,
        backgroundColor: primaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(88, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 2.0,
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(88, 48),
        side: const BorderSide(color: primaryBlue, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: const Size(64, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),
    
    // Typography for dark mode
    textTheme: _buildTextTheme(isLight: false),
    
    // Input decoration for dark mode
    inputDecorationTheme: InputDecorationTheme(
      fillColor: cardDark,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: borderSubtle.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: borderSubtle.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primaryBlue, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: alertRed, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: alertRed, width: 2.0),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondaryDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textSecondaryDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    
    // Switch theme for dark mode
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue;
        }
        return progressTrack;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue.withValues(alpha: 0.3);
        }
        return borderSubtle.withValues(alpha: 0.3);
      }),
    ),
    
    // Checkbox theme for dark mode
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue;
        }
        return cardDark;
      }),
      checkColor: WidgetStateProperty.all(surfaceWhite),
      side: BorderSide(
        color: borderSubtle.withValues(alpha: 0.3),
        width: 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),
    
    // Radio theme for dark mode
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue;
        }
        return borderSubtle.withValues(alpha: 0.3);
      }),
    ),
    
    // Progress indicators for dark mode
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryBlue,
      linearTrackColor: progressTrack.withValues(alpha: 0.2),
      circularTrackColor: progressTrack.withValues(alpha: 0.2),
    ),
    
    // Slider theme for dark mode
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryBlue,
      thumbColor: primaryBlue,
      overlayColor: primaryBlue.withValues(alpha: 0.2),
      inactiveTrackColor: progressTrack.withValues(alpha: 0.2),
      trackHeight: 4.0,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
    ),
    
    // Tab bar theme for dark mode
    tabBarTheme: TabBarThemeData(
      labelColor: primaryBlue,
      unselectedLabelColor: textSecondaryDark,
      indicatorColor: primaryBlue,
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
    
    // Tooltip theme for dark mode
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: surfaceWhite.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    
    // SnackBar theme for dark mode
    snackBarTheme: SnackBarThemeData(
      backgroundColor: surfaceWhite,
      contentTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: primaryBlue,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 6.0,
    ), dialogTheme: DialogThemeData(backgroundColor: dialogDark),
  );

  /// Helper method to build text theme with Inter font family
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textHighEmphasis = isLight ? textPrimary : textPrimaryDark;
    final Color textMediumEmphasis = isLight ? textSecondary : textSecondaryDark;

    return TextTheme(
      // Display styles for large headings
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
      ),
      
      // Headline styles for section headers
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
      ),
      
      // Title styles for cards and dialogs
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0.15,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.1,
      ),
      
      // Body styles for main content
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMediumEmphasis,
        letterSpacing: 0.4,
      ),
      
      // Label styles for buttons and form elements
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textMediumEmphasis,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textMediumEmphasis,
        letterSpacing: 0.5,
      ),
    );
  }
}