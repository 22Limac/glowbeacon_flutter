import 'package:flutter/material.dart';
import 'package:glowbeacon/pages/auth/login_page.dart';
import 'package:glowbeacon/service/auth_service.dart';
import 'package:glowbeacon/widgets/widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
              child: Text("Logout"),
              onPressed: () {
                authService.signOut();
                nextScreenReplace(context, const LoginPage());
              },
            )
    );
  }
}
