import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';

import '../../models/user.dart';
import '../../service/database.dart';
import '../../widget/back_verif.dart';
import '../../widget/button/big_button.dart';
import '../../widget/input_form/text_input_form.dart';
import 'add_user.dart';

class EditUser extends StatefulWidget {
  final UserModel user;
  final String tingkatanAdmin;

  const EditUser({Key? key, required this.user, required this.tingkatanAdmin})
      : super(key: key);

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool isDataSaved = false;

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

  late String selectedRole = widget.user.role;
  late String selectedTingkatan = widget.user.tingkatan;

  List _getWil = [];
  late String selectedWil = widget.user.wilayah;
  late String selectedWilId = widget.user.idWilayah;

  List _getArea = [];
  late String selectedArea = widget.user.area;
  late String selectedAreaId = widget.user.idArea;
  late RoleUser selectedRoleUser;

  @override
  void initState() {
    namaC = TextEditingController(text: widget.user.nama);
    noHpC = TextEditingController(text: widget.user.noHp);
    emailC = TextEditingController(text: widget.user.role);
    selectedRoleUser = RoleUser(widget.user.tingkatan,
        '${widget.user.role} ${widget.user.tingkatan}', widget.user.role);

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
                title: 'Batalkan edit pengguna?',
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
            "Edit Pengguna",
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

                  // role
                  const Text(
                    'Role',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField(
                    items: widget.tingkatanAdmin == 'Pusat'
                        ? roleListPusat
                            .map((e) => DropdownMenuItem(
                                value: e, child: Text(e.namaRole)))
                            .toList()
                        : widget.tingkatanAdmin == 'Wilayah'
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
                        selectedArea = '';
                        selectedAreaId = '';
                        selectedWil = '';
                        selectedWilId = '';
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Iconsax.category),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: selectedRole,
                    ),
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
                          //   hintText: selectedWil == ''
                          //       ? 'Pilih Wilayah'
                          //       : selectedWil,
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
                            if (selectedWil == '' || value == '') {
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
                          //   hintText: selectedWil == ''
                          //       ? 'Pilih Wilayah'
                          //       : selectedWil,
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
                              hintText: selectedWil == ''
                                  ? 'Pilih Wilayah'
                                  : selectedWil,
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
                            if (selectedWil == '' || value == '') {
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
                          //   hintText: selectedArea == ''
                          //       ? 'Pilih Area'
                          //       : selectedArea,
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
                              hintText: selectedArea == ''
                                  ? 'Pilih Area'
                                  : selectedArea,
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
                            if (selectedArea == '' || value == '') {
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
                            .editUser(
                              user: UserModel(
                                namaC.text,
                                emailC.text,
                                noHpC.text,
                                selectedRole,
                                selectedTingkatan,
                                selectedWil,
                                selectedWilId,
                                selectedArea,
                                selectedAreaId,
                                widget.user.urlImg,
                                widget.user.uid,
                              ),
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
}
