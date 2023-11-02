import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glowbeacon/helper/helper_function.dart';
import 'package:glowbeacon/pages/auth/login_page.dart';
import 'package:glowbeacon/service/auth_service.dart';
import 'package:glowbeacon/shared/constants.dart';
import 'package:glowbeacon/shared/user_data.dart';
import 'package:glowbeacon/widgets/widgets.dart';
import 'package:glowbeacon/service/database_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  String? _userName = "";
  String? _fullName = "";
  String? _followerCount = "";
  String? _followingCount = "";

  @override
  void initState() {
    super.initState();
    getUsername();
    getFullname();
    getFollowerCount();
    getFollowingCount();
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

  getFullname() async {
    await HelperFunctions.getFullname().then((value) {
      if (value != null) {
        setState(() {
          _fullName = value;
        });
      }
    });
  }

  getFollowerCount() {
    setState(() {
      _followerCount = UserData().followers!.length.toString();
    });
  }

  getFollowingCount() {
    setState(() {
      _followingCount = UserData().following!.length.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //margin: EdgeInsets.all(16),
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
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 40,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Followers",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(_followerCount!),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Following",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(_followingCount!),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          _userName!,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          _fullName!,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream:
                    DatabaseService(uid: UserData().uid).getUserPostsByUid(),
                builder: (context, snapshot) {
                  List<Row> userPosts = [];
                  if (snapshot.hasData) {
                    final clients = snapshot.data?.docs.reversed.toList();
                    for (var client in clients!) {
                      final clientWidget = Row(
                        children: [Text(client['description'])],
                      );
                      userPosts.add(clientWidget);
                    }
                  }
                  return Expanded(
                    child: ListView(
                      children: userPosts,
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
