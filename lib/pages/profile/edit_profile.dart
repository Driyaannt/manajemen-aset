import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manajemen_aset/models/user.dart';
import 'package:manajemen_aset/widget/input_form/text_input_form.dart';

import '../../service/database.dart';
import '../../widget/back_verif.dart';
import '../../widget/button/big_button.dart';
import '../asset/editAset/photo_option_scree.dart';

class EditProfile extends StatefulWidget {
  final UserModel user;
  const EditProfile({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool isDataSaved = false;

  // text field controller
  TextEditingController emailC = TextEditingController();
  TextEditingController namaC = TextEditingController();
  TextEditingController noHpC = TextEditingController();
  TextEditingController roleC = TextEditingController();
  File? _pickedImage1;

  @override
  void initState() {
    emailC = TextEditingController(text: widget.user.email);
    namaC = TextEditingController(text: widget.user.nama);
    noHpC = TextEditingController(text: widget.user.noHp);
    roleC = TextEditingController(text: widget.user.role);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!isDataSaved) {
          // Tampilkan bottom sheet untuk mengonfirmasi keluar dari halaman edit data
          await showModalBottomSheet(
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            context: context,
            builder: (BuildContext context) {
              return const BackVerification(
                title: 'Batalkan edit profil?',
                content: 'Data yang telah anda rubah \nakan hilang',
              );
            },
          );
          // Kembalikan false agar halaman tidak ditutup secara otomatis
          return false;
        }
        // Kembalikan true jika data telah disimpan dan halaman dapat ditutup
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Ubah Profil",
            style: TextStyle(color: Colors.black87),
          ),
          leading: IconButton(
            onPressed: () async {
              if (!isDataSaved) {
                // Tampilkan bottom sheet untuk mengonfirmasi keluar dari halaman edit data
                await showModalBottomSheet(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0),
                    ),
                  ),
                  context: context,
                  builder: (BuildContext context) {
                    return const BackVerification(
                      title: 'Batalkan edit profil?',
                      content: 'Data yang telah anda rubah \nakan hilang',
                    );
                  },
                );
              }
            },
            icon: const Icon(Iconsax.arrow_left_24),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: _pickedImage1 == null &&
                                widget.user.urlImg! != ''
                            ? ClipOval(
                                child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Image(
                                    image: NetworkImage(widget.user.urlImg!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : _pickedImage1 != null
                                ? SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: ClipOval(
                                      child: Image(
                                        image: FileImage(_pickedImage1!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : ClipOval(
                                    child: Image(
                                      image: NetworkImage(
                                          'https://ui-avatars.com/api/?name=${widget.user.email}'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: IconButton(
                            icon: const Icon(Iconsax.edit_25),
                            color: const Color(0xFF129575),
                            onPressed: () {
                              _showSelectPhotoOptions(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  // nama
                  TextInputForm(
                    title: "Nama",
                    controller: namaC,
                    readOnly: false,
                    prefixIcon: const Icon(Iconsax.user),
                  ),

                  //email
                  TextInputForm(
                    title: "Email",
                    controller: emailC,
                    readOnly: true,
                    hintTxt: 'Email Pengguna',
                    prefixIcon: const Icon(Iconsax.sms),
                    inputType: TextInputType.emailAddress,
                  ),

                  //noHp
                  TextInputForm(
                    title: "Nomor Whatsapp",
                    controller: noHpC,
                    readOnly: false,
                    hintTxt: 'Nomor Whatsapp Pengguna',
                    prefixIcon: const Icon(Iconsax.call),
                    inputType: TextInputType.phone,
                  ),

                  //submit button

                  BigButtonIcon(
                    isLoading: _isLoading,
                    title: "Simpan",
                    icon: Icons.save,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        _formKey.currentState!.save();
                        await DatabaseService()
                            .editUser(
                              user: UserModel(
                                namaC.text,
                                emailC.text,
                                noHpC.text,
                                widget.user.role,
                                widget.user.tingkatan,
                                widget.user.wilayah,
                                widget.user.idWilayah,
                                widget.user.area,
                                widget.user.idArea,
                                widget.user.urlImg,
                                widget.user.uid,
                              ),
                              img: _pickedImage1,
                            )
                            .then((_) => setState(() {
                                  _isLoading = false;
                                  isDataSaved = true;
                                }));
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _pickImage1(ImageSource source) async {
    try {
      final image =
          await ImagePicker().pickImage(source: source, imageQuality: 30);
      if (image == null) return;
      File? img = File(image.path);
      setState(() {
        _pickedImage1 = img;
        Navigator.of(context).pop();
      });
    } on PlatformException {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      builder: (context) => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(16.0),
        child: SelectedPhotoOptionsScreen(
          onTap: _pickImage1,
        ),
      ),
    );
  }
}
