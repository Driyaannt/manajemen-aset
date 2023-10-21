import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/pages/auth/background.dart';
import 'package:manajemen_aset/pages/auth/input_form.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isHidePass = true;
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (context.mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Login Gagal';
      if (e.code == 'user-not-found') {
        errorMessage = 'User tidak ditemukan';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Password salah';
      }
      Get.snackbar('Login Gagal !', errorMessage,
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
          child: Center(
            child: SafeArea(
              child: ListView(
                children: [
                  loginHeaderWidget(),
                  loginForm(),
                  loginButton(),
                  registerButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column registerButton() {
    return Column(
      children: [
        const Text(
          "Tidak Memiliki AKun ?",
        ),
        GestureDetector(
          onTap: widget.showRegisterPage,
          child: const Text(
            "Buat Akun",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  // widget header
  Widget loginHeaderWidget() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 150),
        Text(
          'Halo,',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Selamat Datang Kembali',
          style: TextStyle(fontSize: 16),
        )
      ],
    );
  }

  // widget untuk menampilkan form inputan
  Widget loginForm() {
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
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Password';
                } else if (value.length < 6) {
                  return 'Password must be atleast 8 characters!';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  // Button untuk login dengan email dan password
  Widget loginButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            setState(() {
              _isLoading = true;
            });
            signIn().then((_) {
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
                  'Login',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
      ),
    );
  }
}
