import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/models/user.dart';
import 'package:manajemen_aset/service/database.dart';
import 'package:manajemen_aset/widget/input_form/text_input_form.dart';

import '../../widget/back_verif.dart';
import '../../widget/button/big_button.dart';

class AddJpp extends StatefulWidget {
  final String docId;
  final UserModel user;
  const AddJpp({Key? key, required this.docId, required this.user})
      : super(key: key);

  @override
  State<AddJpp> createState() => _AddJppState();
}

class _AddJppState extends State<AddJpp> {
  final _addJppKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool isDataSaved = false;

  // text field controller
  final TextEditingController idC = TextEditingController();
  final TextEditingController kodeC = TextEditingController();

  final jenisList = [
    'PLTB',
    'PLTS',
    'Diesel',
    'Baterai',
    'Weather Station',
    'Rumah Energi',
    'Warehouse'
  ];

  final statusList = [
    'Aktif',
    'Tidak Aktif',
  ];
  String? selectedJenis = '';
  String? selectedStatus = '';

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
                title: 'Batalkan tambah peralatan pembangkit?',
                content: 'Data yang telah anda masukkan tidak akan disimpan',
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
            "Tambah Peralatan Pembangkit",
            style: TextStyle(
              color: Colors.black87,
            ),
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
                      title: 'Batalkan tambah peralatan pembangkit?',
                      content:
                          'Data yang telah anda masukkan tidak akan disimpan',
                    );
                  },
                );
              }
            },
            icon: const Icon(Iconsax.arrow_left_24),
          ),
        ),
        body: Form(
          key: _addJppKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // jenis
                  Row(
                    children: [
                      const Text(
                        'Jenis Peralatan Pembangkit',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ' *',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField(
                    items: jenisList
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedJenis = val as String;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Iconsax.note),
                      hintText: 'Pilih Jenis Peralatan Pembangkit',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Pilih Jenis Peralatan Pembangkit';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  // Kode
                  TextInputForm(
                    title: "Kode Peralatan Pembangkit",
                    controller: kodeC,
                    prefixIcon: const Icon(Iconsax.document_text),
                    readOnly: false,
                    hintTxt: 'Kode peralatan pembangkit',
                  ),

                  //submit button
                  BigButtonIcon(
                    isLoading: _isLoading,
                    title: "Simpan",
                    icon: Icons.save,
                    onPressed: () async {
                      if (_addJppKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        await DatabaseService()
                            .addJPP(
                                documentId: widget.docId,
                                // idPerangkat: idC.text,
                                idJPP: '0',
                                kodeJPP: kodeC.text,
                                jenisJPP: selectedJenis,
                                statusJPP: 'Belum Diverifikasi',
                                alarmJPP: 'Aman')
                            .then((_) => setState(() {
                                  _isLoading = false;
                                  isDataSaved = true;
                                },
                              ),
                            );

                        if (context.mounted) {
                          Navigator.pop(context);
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
