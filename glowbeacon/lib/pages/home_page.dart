import 'package:flutter/material.dart';
import 'package:glowbeacon/pages/auth/login_page.dart';
import 'package:glowbeacon/service/auth_service.dart';
import 'package:glowbeacon/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
        child: Text("Logout"),
        onPressed: () {
          authService.signOut();
          nextScreenReplace(context, const LoginPage());
        },
      ),
    ));
  }
}
