import 'package:material_ui/material_ui.dart';

import 'screens/home_shell.dart';
import 'screens/login_screen.dart';
import 'state/app_state.dart';
import 'theme.dart';

void main() {
  runApp(const CodeTrackApp());
}

class CodeTrackApp extends StatefulWidget {
  const CodeTrackApp({super.key});

  @override
  State<CodeTrackApp> createState() => _CodeTrackAppState();
}

class _CodeTrackAppState extends State<CodeTrackApp> {
  final AppState _state = AppState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: MaterialApp(
        title: 'CodeTrack',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: ListenableBuilder(
          listenable: _state,
          builder: (context, _) {
            return _state.isAuthenticated
                ? const HomeShell()
                : const LoginScreen();
          },
        ),
      ),
    );
  }
}
