import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/pages/auth/auth_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool isLoading = false;

  Future signInAnon() async {
    FirebaseAuth.instance.signInAnonymously();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                headerWidget(),
                loginButton(context),
                guestButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  // widget header
  Widget headerWidget() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          'Manajemen Aset\tPembangkit EBT',
          style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 2),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Image.asset(
          "img/1.jpg",
          // width: 150,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // Button pindah halaman
  Widget loginButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AuthPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'Masuk Ke Akun',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  // Button pindah halaman
  Widget guestButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isLoading = true;
          });
          signInAnon().then((_) => setState(() {
                isLoading = false;
              }));
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          primary: const Color(0xFFFF9C00),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Masuk Sebagai Tamu",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            // Spacer(flex:2),
            SizedBox(width: 20),
            Icon(Iconsax.arrow_circle_right5),
          ],
        ),
      ),
    );
  }
}
