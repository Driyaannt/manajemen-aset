import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/service/database.dart';

import '../../models/user.dart';
import '../../widget/button/big_button.dart';
import '../../widget/input_form/text_input_form.dart';

class AddUser extends StatefulWidget {
  final String tingkatan;
  const AddUser({Key? key, required this.tingkatan}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // text field controller
  TextEditingController emailC = TextEditingController();
  TextEditingController namaC = TextEditingController();
  TextEditingController noHpC = TextEditingController();

  final List<RoleUser> roleListPusat = [
    RoleUser('Pusat', 'PLN Pusat', 'PLN'),
    RoleUser('Wilayah', 'PLN Wilayah', 'PLN'),
    RoleUser('Area', 'PLN Area', 'PLN'),
    RoleUser('Pusat', 'Admin Pusat', 'Admin'),
    RoleUser('Wilayah', 'Admin Wilayah', 'Admin'),
    RoleUser('Area', 'Admin Area', 'Admin'),
    RoleUser('Wilayah', 'Vendor', 'Vendor'),
    RoleUser('Area', 'Operator', 'Operator'),
  ];

  final List<RoleUser> roleListWil = [
    RoleUser('Wilayah', 'PLN Wilayah', 'PLN'),
    RoleUser('Area', 'PLN Area', 'PLN'),
    RoleUser('Wilayah', 'Admin Wilayah', 'Admin'),
    RoleUser('Area', 'Admin Area', 'Admin'),
    RoleUser('Wilayah', 'Vendor', 'Vendor'),
    RoleUser('Area', 'Operator', 'Operator'),
  ];

  final List<RoleUser> roleListArea = [
    RoleUser('Area', 'PLN Area', 'PLN'),
    RoleUser('Area', 'Admin Area', 'Admin'),
    RoleUser('Area', 'Operator', 'Operator'),
  ];

  String? selectedRole = '';
  String? selectedTingkatan = '';

  List _getWil = [];
  String? selectedWil = '';
  String? selectedWilId = '';

  List _getArea = [];
  String? selectedArea = '';
  String? selectedAreaId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tambah Pengguna",
          style: TextStyle(color: Colors.black87),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Iconsax.arrow_left_24),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // nama
                TextInputForm(
                  title: "Nama",
                  controller: namaC,
                  readOnly: false,
                  hintTxt: 'Nama Pengguna',
                  prefixIcon: const Icon(Iconsax.user),
                ),

                //email
                TextInputForm(
                  title: "Email",
                  controller: emailC,
                  readOnly: false,
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

                // role
                const Text(
                  'Role',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField(
                  items: widget.tingkatan == 'Pusat'
                      ? roleListPusat
                          .map((e) => DropdownMenuItem(
                              value: e, child: Text(e.namaRole)))
                          .toList()
                      : widget.tingkatan == 'Wilayah'
                          ? roleListWil
                              .map((e) => DropdownMenuItem(
                                  value: e, child: Text(e.namaRole)))
                              .toList()
                          : roleListArea
                              .map((e) => DropdownMenuItem(
                                  value: e, child: Text(e.namaRole)))
                              .toList(),
                  onChanged: (RoleUser? val) {
                    setState(() {
                      selectedRole = val!.role;
                      selectedTingkatan = val.tingkatan;
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Iconsax.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: 'Pilih role pengguna',
                  ),
                  validator: (RoleUser? value) {
                    if (value == null || value.namaRole == '') {
                      return 'Pilih role pengguna';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // dropdown wilayah (provinsi)
                if (selectedTingkatan == 'Wilayah')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Wilayah',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      DropdownSearch<dynamic>(
                        //you can design textfield here as you want
                        // dropdownSearchDecoration: InputDecoration(
                        //   hintText: "Pilih Wilayah",
                        //   prefixIcon: const Icon(Iconsax.category),
                        //   border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(10.0),
                        //   ),
                        // ),

                        // //have two mode: menu mode and dialog mode
                        // mode: Mode.DIALOG,
                        // //if you want show search box
                        // showSearchBox: true,
                        popupProps: const PopupProps.dialog(
                          showSearchBox: true,
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            hintText: "Pilih Wilayah",
                            prefixIcon: const Icon(Iconsax.category),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        // TODO: check for bug

                        //get data from the internet
                        asyncItems: (text) async {
                          var response = await http.post(Uri.parse(
                              "http://ebt-polinema.site/api/wilayah/provinsi"));
                          if (response.statusCode == 200) {
                            final data = jsonDecode(response.body);
                            setState(() {
                              _getWil = data['data'];
                            });
                          }
                          return _getWil;
                        },

                        //what do you want anfter item clicked
                        onChanged: (value) {
                          setState(() {
                            selectedWil = value['wilayah'];
                            selectedWilId = value['wilayah_id'];
                          });
                        },

                        validator: (value) {
                          if (value == null || value == '') {
                            return 'Pilih wilayah';
                          }
                          return null;
                        },

                        //this data appear in dropdown after clicked
                        itemAsString: (item) => item['wilayah'],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                if (selectedTingkatan == 'Area')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Wilayah',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      DropdownSearch<dynamic>(
                        //you can design textfield here as you want
                        // dropdownSearchDecoration: InputDecoration(
                        //   hintText: "Pilih Wilayah",
                        //   prefixIcon: const Icon(Iconsax.category),
                        //   border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(10.0),
                        //   ),
                        // ),

                        // //have two mode: menu mode and dialog mode
                        // mode: Mode.DIALOG,
                        // //if you want show search box
                        // showSearchBox: true,
                        popupProps: const PopupProps.dialog(
                          showSearchBox: true,
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            hintText: "Pilih Wilayah",
                            prefixIcon: const Icon(Iconsax.category),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        // TODO: check for bug
                        //get data from the internet
                        asyncItems: (text) async {
                          var response = await http.post(Uri.parse(
                              "http://ebt-polinema.site/api/wilayah/provinsi"));
                          if (response.statusCode == 200) {
                            final data = jsonDecode(response.body);
                            setState(() {
                              _getWil = data['data'];
                            });
                          }
                          return _getWil;
                        },

                        //what do you want anfter item clicked
                        onChanged: (value) {
                          setState(() {
                            selectedWil = value['wilayah'];
                            selectedWilId = value['wilayah_id'];
                          });
                        },

                        validator: (value) {
                          if (value == null || value == '') {
                            return 'Pilih wilayah';
                          }
                          return null;
                        },

                        //this data appear in dropdown after clicked
                        itemAsString: (item) => item['wilayah'],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Area',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      DropdownSearch<dynamic>(
                        //you can design textfield here as you want
                        // dropdownSearchDecoration: InputDecoration(
                        //   hintText: "Pilih Area",
                        //   prefixIcon: const Icon(Iconsax.category),
                        //   border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(10.0),
                        //   ),
                        // ),

                        // //have two mode: menu mode and dialog mode
                        // mode: Mode.DIALOG,
                        // //if you want show search box
                        // showSearchBox: true,
                        popupProps: const PopupProps.dialog(
                          showSearchBox: true,
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            hintText: "Pilih Area",
                            prefixIcon: const Icon(Iconsax.category),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        // TODO: check for bug

                        //get data from the internet
                        asyncItems: (text) async {
                          var response = await http.post(
                            Uri.parse(
                                "http://ebt-polinema.site/api/wilayah/area"),
                            body: {'id': selectedWilId},
                          );
                          if (response.statusCode == 200) {
                            final data = jsonDecode(response.body);
                            setState(() {
                              _getArea = data['data'];
                            });
                          }
                          return _getArea;
                        },

                        //what do you want anfter item clicked
                        onChanged: (value) {
                          setState(() {
                            selectedArea = value['wilayah'];
                            selectedAreaId = value['wilayah_id'];
                          });
                        },

                        validator: (value) {
                          if (value == null || value == '') {
                            return 'Pilih Area';
                          }
                          return null;
                        },

                        //this data appear in dropdown after clicked
                        itemAsString: (item) => item['wilayah'],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
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
                          .addUser(
                              user: UserModel(
                            namaC.text,
                            emailC.text,
                            noHpC.text,
                            selectedRole!,
                            selectedTingkatan!,
                            selectedWil!,
                            selectedWilId!,
                            selectedArea!,
                            selectedAreaId!,
                            '',
                            null,
                          ))
                          .then((_) => setState(() {
                                _isLoading = false;
                              }));
                      if (context.mounted) {
                        Navigator.of(context).pop();
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
    );
  }
}

class RoleUser {
  final String tingkatan;
  final String namaRole;
  final String role;

  RoleUser(this.tingkatan, this.namaRole, this.role);
}
