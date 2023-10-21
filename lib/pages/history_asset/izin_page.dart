import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manajemen_aset/pages/history_asset/utils/terjadwal.dart';
import 'package:manajemen_aset/widget/input_form/image_form.dart';
import 'package:manajemen_aset/widget/input_form/text_input_form.dart';

import '../../service/send_message.dart';

class IzinPage extends StatefulWidget {
  final String currentStatusKonfirmasi;
  final String docJpp;
  final String kodeJpp;
  final String spd1;
  final String docPembangkit;
  final String jenisAset;
  final String docAset;
  final String docHistory;
  final String uidPetugas;
  final String namaPetugas;
  final String jadwalMulai;
  final String jenisPekerjaan;

  const IzinPage({
    Key? key,
    required this.currentStatusKonfirmasi,
    required this.docJpp,
    required this.kodeJpp,
    required this.spd1,
    required this.docPembangkit,
    required this.jenisAset,
    required this.docAset,
    required this.docHistory,
    required this.uidPetugas,
    required this.namaPetugas,
    required this.jadwalMulai,
    required this.jenisPekerjaan,
  }) : super(key: key);

  @override
  State<IzinPage> createState() => _IzinPageState();
}

class _IzinPageState extends State<IzinPage> {
  final SendMessageController controller = Get.put(SendMessageController());
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  // text field controller
  TextEditingController alasanC = TextEditingController();
  File? _pickedImage;

  Future openCamera() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image == null) return;
    File? img = File(image.path);
    setState(() {
      _pickedImage = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Formulir Izin",
          overflow: TextOverflow.fade,
          style: TextStyle(
            color: Colors.black87,
          ),
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // alasan
                TextInputForm(
                  maxLine: 5,
                  controller: alasanC,
                  title: 'Alasan',
                  hintTxt: 'Tuliskan alasan',
                  readOnly: false,
                ),

                // foto surat izin
                ImageForm(
                  pickedImage: _pickedImage,
                  title: 'Foto',
                  desc: 'Upload bukti izin',
                  openCamera: () {
                    openCamera();
                  },
                  deleteImage: () {
                    setState(() {
                      _pickedImage = null;
                    });
                  },
                ),

                //submit button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        await Terjadwal()
                            .izinHistory(
                              docJpp: widget.docJpp,
                              kodeJpp: widget.kodeJpp,
                              spd1: widget.spd1,
                              docPembangkit: widget.docPembangkit,
                              jenisAset: widget.jenisAset,
                              docAset: widget.docAset,
                              uidPetugas: widget.uidPetugas,
                              docHistory: widget.docHistory,
                              statusKonfirmasi: 'Ditolak',
                              alasan: alasanC.text,
                              imgSuratIzin: _pickedImage,
                            )
                            .then((_) => setState(() {
                                  _isLoading = false;
                                }));
                        String message =
                            'INFO\n\nPada tanggal ${widget.jadwalMulai}, Petugas ${widget.namaPetugas} tidak dapat melakukan ${widget.jenisPekerjaan} dikarenakan ${alasanC.text}.\nSegera cari petugas lain untuk melakukan ${widget.jenisPekerjaan} pada aset dengan detail sebagai berikut:\n-Kode Pembangkit: ${widget.kodeJpp}\n-Jenis Aset: ${widget.jenisAset}\n-Nama Aset: ${widget.spd1}';
                        controller.sendWhatsApp('+6285175092056', message);

                        if (context.mounted) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _isLoading ? 'Menyimpan...' : 'Simpan',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
