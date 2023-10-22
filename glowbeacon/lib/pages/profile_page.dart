import 'package:flutter/material.dart';
import 'package:glowbeacon/helper/helper_function.dart';
import 'package:glowbeacon/pages/auth/login_page.dart';
import 'package:glowbeacon/service/auth_service.dart';
import 'package:glowbeacon/shared/constants.dart';
import 'package:glowbeacon/widgets/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  String? _userName = "";

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  getUsername() async {
    await HelperFunctions.getUsername().then((value) {
      if (value != null) {
        setState(() {
          _userName = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black26),
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
            )
          ],
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200,
              color: Constants().primaryColor,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                  ),
                  Text(
                    _userName!,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
