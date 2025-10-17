import 'package:flutter/material.dart';
import '../presentation/settings/settings.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/session_notes/session_notes.dart';
import '../presentation/timer_dashboard/timer_dashboard.dart';
import '../presentation/login/login_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String login = '/login';
  static const String settings = '/settings';
  static const String splash = '/splash-screen';
  static const String sessionNotes = '/session-notes';
  static const String timerDashboard = '/timer-dashboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    settings: (context) => const Settings(),
    splash: (context) => const SplashScreen(),
    sessionNotes: (context) => const SessionNotes(),
    timerDashboard: (context) => const TimerDashboard(),
    // TODO: Add your other routes here
  };
}
