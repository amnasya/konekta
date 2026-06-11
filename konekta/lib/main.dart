import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme.dart';
import 'core/api_client.dart';
import 'core/session.dart';
import 'core/app_scope.dart';
import 'Opening/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final session = Session(prefs);
  final api = ApiClient(session);
  runApp(KonektaApp(session: session, api: api));
}

class KonektaApp extends StatelessWidget {
  final Session session;
  final ApiClient api;
  const KonektaApp({super.key, required this.session, required this.api});

  @override
  Widget build(BuildContext context) {
    return AppScope(session: session, api: api, child: MaterialApp(
      title: 'Konekta',
      debugShowCheckedModeBanner: false,
      theme: KonektaTheme.light,
      home: const KonektaSplashScreen(),
    ));
  }
}
