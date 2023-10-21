import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manajemen_aset/pages/auth/welcome_page.dart';
import 'package:manajemen_aset/pages/home/home_guest.dart';
import 'package:manajemen_aset/service/user_auth.dart';

class AuthService extends StatelessWidget {
  const AuthService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isAnonymous) {
              bool isAnon = snapshot.data!.isAnonymous;
              return HomeGuest(isAnon: isAnon);
            } else {
              bool isAnon = snapshot.data!.isAnonymous;
              return UserAuth(isAnon: isAnon);
            }
          } else {
            return const WelcomePage();
          }
        },
      ),
    );
  }
}
