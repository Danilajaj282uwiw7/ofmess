import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/chats_screen.dart';
import 'api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  runApp(OFRMessApp(initialToken: token));
}

class OFRMessApp extends StatelessWidget {
  final String? initialToken;
  const OFRMessApp({super.key, this.initialToken});

  @override
  Widget build(BuildContext context) {
    ApiService.token = initialToken;
    return MaterialApp(
      title: 'OFMess',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1E1E1E)),
      ),
      home: initialToken == null ? const LoginScreen() : const ChatsScreen(),
    );
  }
}
