import 'package:flutter/material.dart';
import 'package:glowbeacon/helper/helper_function.dart';
import 'package:glowbeacon/pages/feed_page.dart';
import 'package:glowbeacon/pages/profile_page.dart';
import 'package:glowbeacon/pages/search_page.dart';
import 'package:glowbeacon/shared/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glowbeacon/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glowbeacon/helper/helper_function.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Default index of the first screen

  // List of pages to display
  final List<Widget> _pages = [
    FeedPage(),
    SearchPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!UserData().initialized) {
      loadUser();
    }
  }

  loadUser() async {
    await HelperFunctions.getUserEmailSF().then((value) async {
      QuerySnapshot snapshot =
          await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .gettingUserData(value!);
      List<String> followersList = [];
      if (snapshot.docs[0]["followers"] != null) {
        followersList = (snapshot.docs[0]["followers"] as List)
            .map((follower) => follower.toString())
            .toList();
      }
      List<String> followingList = [];
      if (snapshot.docs[0]["followers"] != null) {
        followingList = (snapshot.docs[0]["following"] as List)
            .map((following) => following.toString())
            .toList();
      }
      UserData().setUserData(
        email: value,
        fullName: snapshot.docs[0]["fullName"],
        username: snapshot.docs[0]["username"],
        uid: snapshot.docs[0]["uid"],
        followers: followersList,
        following: followingList,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update the selected index
          });
        },
      ),
    );
  }
}
