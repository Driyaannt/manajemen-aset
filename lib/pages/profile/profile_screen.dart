
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/in_progress_page.dart';
import 'package:manajemen_aset/models/user.dart';
import 'package:manajemen_aset/pages/profile/edit_profile.dart';
import 'package:manajemen_aset/pages/profile/setting_domain_page.dart';
import 'package:manajemen_aset/pages/user/user_list_page.dart';
import 'package:manajemen_aset/service/database.dart';
import 'package:manajemen_aset/widget/menu_card.dart';
import 'package:manajemen_aset/widget/submit_button.dart';

import '../../widget/bottom_sheet/info_alarm.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // fungsi untuk sign out
  void logOut() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profil",
          style: TextStyle(color: Colors.black87),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Iconsax.arrow_left_24),
        ),
        // actions: <Widget>[
        //   Badge(
        //     // position: BadgePosition.topEnd(top: 2, end: 8),
        //     position: BadgePosition.topEnd(top: 11, end: 12),
        //     badgeStyle: const BadgeStyle(
        //         badgeColor: Color(0xFFDE2626), padding: EdgeInsets.all(6)),
        //     // badgeContent: const Text(
        //     //   '1',
        //     //   style: TextStyle(color: Colors.white),
        //     // ),
        //     child: IconButton(
        //       icon: const Icon(
        //         Iconsax.notification,
        //         color: Colors.black87,
        //       ),
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => const NotificationPage()),
        //         );
        //       },
        //     ),
        //   )
        // ],
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: DatabaseService().streamUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            Map<String, dynamic> user = snapshot.data!.data()!;
            UserModel userData = UserModel(
              user['nama'],
              user['email'],
              user['noHp'],
              user['role'],
              user['tingkatan'],
              user['wilayah'],
              user['wilayahId'],
              user['area'],
              user['areaId'],
              user['urlImg'],
              user['uid'],
            );
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    detailProfil(userData),

                    // menu edit profile
                    MenuCard(
                      leadingIcon: Iconsax.user,
                      titleText: "Ubah Profil",
                      nextPage: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfile(
                              user: userData,
                            ),
                          ),
                        );
                      },
                    ),

                    // menu panduan
                    MenuCard(
                      leadingIcon: Iconsax.message_question,
                      titleText: "Panduan",
                      nextPage: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InProgressPage(),
                          ),
                        );
                      },
                    ),

                    // menu tentang aplikasi
                    MenuCard(
                      leadingIcon: Iconsax.info_circle,
                      titleText: "Tentang Aplikasi",
                      nextPage: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InProgressPage(),
                          ),
                        );
                      },
                    ),

                    // menu setting API
                    MenuCard(
                      leadingIcon: Iconsax.setting_2,
                      titleText: "Pengaturan",
                      nextPage: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingDomainPage(),
                          ),
                        );
                      },
                    ),

                    // tambah user
                    if (userData.role == 'Admin')
                      MenuCard(
                        leadingIcon: Iconsax.user_add4,
                        titleText: 'Tambah Pengguna',
                        nextPage: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UserList(tingkatanAdmin: userData.tingkatan),
                            ),
                          );
                        },
                      ),

                    // menu kondisi aset
                    MenuCard(
                      leadingIcon: Iconsax.info_circle,
                      titleText: "Informasi Kondisi Aset",
                      nextPage: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InfoAlarm(),
                          ),
                        );
                      },
                    ),

                    // menu log out
                    MenuCard(
                      leadingIcon: Iconsax.logout,
                      titleText: "Keluar Akun",
                      nextPage: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(25.0),
                            ),
                          ),
                          context: context,
                          builder: (context) {
                            return logOutBottomSheet(context);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Text("Tidak dapat memuat data"),
            );
          }
        },
      ),
    );
  }

  // detail profil
  Column detailProfil(UserModel userData) {
    return Column(
      children: [
        // circle avatar
        SizedBox(
          height: 115,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: userData.urlImg == ''
                ? NetworkImage(
                    'https://ui-avatars.com/api/?name=${userData.email}')
                : NetworkImage(userData.urlImg!),
            backgroundColor: Colors.transparent,
          ),
        ),
        // nama
        Text(
          (userData.nama),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        // email
        Text(
          (userData.email),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4.0),
        //user role
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: const Color.fromARGB(255, 18, 149, 116),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
            child: Text(
              (userData.role == 'Admin' || userData.role == 'PLN'
                  ? '${userData.role} ${userData.tingkatan}'
                  : userData.role),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Padding logOutBottomSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(18)),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Apakah anda yakin ingin keluar dari aplikasi?",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Image.asset(
            'img/log-out.png',
            height: 130,
            fit: BoxFit.fill,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SubmitButton(
                title: "Batal",
                onPressed: () {
                  Navigator.pop(context);
                },
                bgColor: Colors.grey,
              ),
              const SizedBox(width: 8),
              SubmitButton(
                title: "Keluar",
                onPressed: () {
                  logOut();
                },
                bgColor: const Color.fromARGB(209, 253, 54, 84),
              ),
            ],
          )
        ],
      ),
    );
  }
}
