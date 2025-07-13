import 'package:flutter/material.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/processing_status_screen/processing_status_screen.dart';
import '../presentation/note_editor_screen/note_editor_screen.dart';
import '../presentation/summary_view_screen/summary_view_screen.dart';
import '../presentation/notes_library_screen/notes_library_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String loginScreen = '/login-screen';
  static const String homeDashboard = '/home-dashboard';
  static const String processingStatusScreen = '/processing-status-screen';
  static const String noteEditorScreen = '/note-editor-screen';
  static const String summaryViewScreen = '/summary-view-screen';
  static const String notesLibraryScreen = '/notes-library-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    loginScreen: (context) => const LoginScreen(),
    homeDashboard: (context) => const HomeDashboard(),
    processingStatusScreen: (context) => const ProcessingStatusScreen(),
    noteEditorScreen: (context) => const NoteEditorScreen(),
    summaryViewScreen: (context) => const SummaryViewScreen(),
    notesLibraryScreen: (context) => const NotesLibraryScreen(),
    // TODO: Add your other routes here
  };
}
