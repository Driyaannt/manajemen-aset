import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/in_progress_page.dart';
import 'package:manajemen_aset/models/api.dart';
import 'package:manajemen_aset/pages/profile/setting_domain_page.dart';
import 'package:manajemen_aset/widget/menu_card.dart';
import 'package:manajemen_aset/widget/submit_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreenGuest extends StatefulWidget {
  const ProfileScreenGuest({Key? key}) : super(key: key);

  @override
  State<ProfileScreenGuest> createState() => _ProfileScreenGuestState();
}

class _ProfileScreenGuestState extends State<ProfileScreenGuest> {
  late ApiModel apiModel;

  @override
  void initState() {
    super.initState();
    // String anon = 'widget.user.isAnonymous';

    _loadConfig();
  }

  // fungsi untuk sign out
  void logOut() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  // fungsi untuk mendapatkan domain
  void _loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final domain = prefs.getString('api_url') ?? 'http://ebt-polinema.site';
    setState(() {
      apiModel = ApiModel(domain: domain);
    });
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
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              // circle avatar
              const SizedBox(
                height: 115,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('img/polinema.png'),
                  backgroundColor: Colors.transparent,
                ),
              ),

              // nama
              const Text(
                ("Tamu"),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4.0),

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
              const SizedBox(height: 8),

              // menu panduan
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
              const SizedBox(height: 8),

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
              const SizedBox(height: 8),

              // menu log out
              MenuCard(
                leadingIcon: Iconsax.logout,
                titleText: "Keluar Akun",
                nextPage: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text(
                              "Apakah anda yakin ingin keluar dari aplikasi?",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
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
                                  bgColor:
                                      const Color.fromARGB(209, 253, 54, 84),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}
