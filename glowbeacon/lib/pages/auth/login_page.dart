import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:glowbeacon/helper/helper_function.dart';
import 'package:glowbeacon/pages/auth/register_page.dart';
import 'package:glowbeacon/pages/home_page.dart';
import 'package:glowbeacon/service/auth_service.dart';
import 'package:glowbeacon/service/database_service.dart';
import 'package:glowbeacon/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor),) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/GlowBeacon.png"),
                const SizedBox(
                  height: 10,
                ),
                // Email Input
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      labelText: "Email",
                      prefixIcon: Icon(
                        Icons.email,
                        color: Theme.of(context).primaryColor,
                      )),
                  onChanged: (val) {
                    setState(() {
                      email = val;
                      print(email);
                    });
                  },
                  validator: (val) {
                    return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val!)
                        ? null
                        : "Please enter valid email";
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                // Password Input
                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                    labelText: "Password",
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      password = val;
                      print(password);
                    });
                  },
                  validator: (val) {
                    if (val!.length < 6) {
                      return "Password must be at least 6 characters";
                    } else {
                      return null;
                    }
                  },
                ),
                // Sign In button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () {
                      login();
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Link to the Register page
                Text.rich(TextSpan(
                    text: "Don't have an account? ",
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: "Register Here",
                          style: const TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              nextScreen(context, const RegisterPage());
                            }),
                    ])),
              ],
            ),
          ),
        ),
      ),
    );
  }

  login() async {
   if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await authService
          .loginWithUserNameAndPassword( email, password)
          .then((value) async {
        if (value == true) {
          // saving shared preference state
          QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);
          // Save user to shared preferences 
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]["fullName"]);
          await HelperFunctions.saveUserEmailSF(email);
          nextScreenReplace(context, HomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
