import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/pages/auth/background.dart';
import 'package:manajemen_aset/pages/auth/input_form.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final noWaController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isHidePass = true;
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    noWaController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future signUp(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;
        await FirebaseFirestore.instance.collection("user").doc(uid).set({
          "nama": usernameController.text,
          "email": emailController.text,
          "uid": uid,
          "noHp": noWaController.text,
          "role": 'PLN Area',
          "tingkatan": "Area",
          "wilayah": "JAWA TIMUR",
          "wilayahId": "35",
          "area": "KAB.MALANG",
          "areaId": "35.07",
          "createdAt": DateTime.now().toIso8601String(),
          "urlImg": "",
        });
      }

      if (context.mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Login Gagal !', e.code,
          colorText: Colors.white, backgroundColor: Colors.red[400]);
    } catch (e) {
      Get.snackbar('Login Gagal !', e.toString(),
          colorText: Colors.white, backgroundColor: Colors.red[400]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Background(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SafeArea(
            child: ListView(
              children: [
                headerWidget(),
                registerForm(),
                registerButton(),
                loginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column loginButton() {
    return Column(
      children: [
        const Text(
          "Sudah Memiliki Akun ?",
        ),
        GestureDetector(
          onTap: widget.showLoginPage,
          child: const Text(
            "Masuk",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  // widget header
  Widget headerWidget() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 50),
        Text(
          'Buat Akun',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  // widget untuk menampilkan form inputan
  Widget registerForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthInputForm(
            controller: emailController,
            title: 'Email',
            inputType: TextInputType.emailAddress,
            prefixIcon: const Icon(Iconsax.sms),
            hintTxt: 'Masukkan Email',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Masukkan Alamat Email';
              } else if (!value.contains('@')) {
                return 'Alamat Email Tidak Valid';
              }
              return null;
            },
          ),
          AuthInputForm(
            controller: usernameController,
            title: 'Username',
            prefixIcon: const Icon(Iconsax.user),
            hintTxt: 'Masukkan Username',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Masukkan Username';
              }
              return null;
            },
          ),
          AuthInputForm(
            controller: noWaController,
            title: 'No Whatsapp',
            inputType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone_android_rounded),
            hintTxt: 'Masukkan No Whatsapp',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Masukkan No Whatsapp';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'Password',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: TextFormField(
              obscureText: _isHidePass,
              controller: passwordController,
              decoration: InputDecoration(
              prefixIcon: const Icon(Icons.key),
                hintText: "Password",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: Color(0xFF129575), width: 2.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.red, width: 2.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.red, width: 2.0),
                ),
                suffixIcon: IconButton(
                  icon: _isHidePass
                      ? const Icon(
                          Iconsax.eye_slash,
                        )
                      : const Icon(Iconsax.eye, color: Color(0xFF129575)),
                  onPressed: () {
                    if (_isHidePass) {
                      setState(() {
                        _isHidePass = false;
                      });
                    } else {
                      setState(() {
                        _isHidePass = true;
                      });
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Button untuk login dengan email dan password
  Widget registerButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            setState(() {
              _isLoading = true;
            });
            signUp(emailController.text, passwordController.text).then((_) {
              setState(() {
                _isLoading = false;
              });
            });
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: _isLoading
            ? const Padding(
                padding: EdgeInsets.all(12.0),
                child: CircularProgressIndicator(color: Colors.white),
              )
            : const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Register',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
      ),
    );
  }
}
