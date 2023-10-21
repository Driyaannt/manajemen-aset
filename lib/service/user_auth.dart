import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manajemen_aset/models/user.dart';
import 'package:manajemen_aset/pages/auth/welcome_page.dart';
import 'package:manajemen_aset/pages/home/home_operator.dart';
import 'package:manajemen_aset/pages/home/home_pln.dart';
import 'package:manajemen_aset/service/database.dart';

class UserAuth extends StatefulWidget {
  const UserAuth({Key? key, required this.isAnon}) : super(key: key);
  final bool isAnon;

  @override
  State<UserAuth> createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth> {
  // Widget homePageManager = const LoginScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: DatabaseService().userRole(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Container();
          }
          if (snap.hasData) {
            UserModel user = UserModel(
              snap.data?.data()?['nama'],
              snap.data?.data()?['email'],
              snap.data?.data()?['noHp'],
              snap.data?.data()?['role'],
              snap.data?.data()?['tingkatan'],
              snap.data?.data()?['wilayah'],
              snap.data?.data()?['wilayahId'],
              snap.data?.data()?['area'],
              snap.data?.data()?['areaId'],
              snap.data?.data()?['urlImg'],
              snap.data?.data()?['uid'],
            );

            if (user.role == 'Operator') {
              return HomeOperator(isAnon: widget.isAnon, user: user);
            } else if (user.role == 'PLN') {
              return HomePln(isAnon: widget.isAnon, user: user);
            } else if (user.role == 'Admin') {
              return HomePln(isAnon: widget.isAnon, user: user);
            } else if (user.role == 'Vendor') {
              return HomePln(isAnon: widget.isAnon, user: user);
            } else {
              return const WelcomePage();
            }
          }
          return const WelcomePage();
        },
      ),
    );
  }
}
