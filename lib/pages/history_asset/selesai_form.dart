import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:manajemen_aset/pages/history_asset/utils/dalam_proses.dart';
import 'package:manajemen_aset/widget/input_form/date_input_form.dart';

import '../../service/send_message.dart';
import '../../widget/button/big_button.dart';
import '../../widget/input_form/image_form.dart';
import '../../widget/input_form/text_input_form.dart';

class SelesaiForm extends StatefulWidget {
  final String docJpp;
  final String kodeJpp;
  final String docPembangkit;
  final String jenisAset;
  final String spd1;
  final String uidPetugas;
  final String namaPetugas;
  final String docAset;
  final String docHistory;
  final String jenisPekerjaan;
  final String agenda;
  final String jadwalMulai;
  final String jadwalSelesai;
  final String statusKonfirmasi;
  final String mulaiPengerjaan;

  const SelesaiForm({
    Key? key,
    required this.jadwalMulai,
    required this.jadwalSelesai,
    required this.docJpp,
    required this.kodeJpp,
    required this.docPembangkit,
    required this.jenisAset,
    required this.spd1,
    required this.uidPetugas,
    required this.namaPetugas,
    required this.docAset,
    required this.docHistory,
    required this.statusKonfirmasi,
    required this.mulaiPengerjaan,
    required this.jenisPekerjaan,
    required this.agenda,
  }) : super(key: key);

  @override
  State<SelesaiForm> createState() => _SelesaiFormState();
}

class _SelesaiFormState extends State<SelesaiForm> {
  final SendMessageController controller = Get.put(SendMessageController());
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // text field controller
  TextEditingController namaPetugasC = TextEditingController();
  TextEditingController jenisPekerjaanC = TextEditingController();
  TextEditingController agendaC = TextEditingController();
  TextEditingController jadwalMulaiC = TextEditingController();
  TextEditingController jadwalSelesaiC = TextEditingController();
  TextEditingController mulaiPengerjaanC = TextEditingController();
  TextEditingController descPengerjaanC = TextEditingController();
  File? _pickedImage;
  File? _pickedImage2;

  Future openCamera() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);

    if (image == null) return;
    File? img = File(image.path);
    setState(() {
      _pickedImage = img;
    });
  }

  Future openCamera2() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);

    if (image == null) return;
    File? img = File(image.path);
    setState(() {
      _pickedImage2 = img;
    });
  }

  @override
  void initState() {
    namaPetugasC = TextEditingController(text: widget.namaPetugas);
    jenisPekerjaanC = TextEditingController(text: widget.jenisPekerjaan);
    agendaC = TextEditingController(text: widget.agenda);
    jadwalMulaiC = TextEditingController(text: widget.jadwalMulai);
    jadwalSelesaiC = TextEditingController(text: widget.jadwalSelesai);
    mulaiPengerjaanC = TextEditingController(text: widget.mulaiPengerjaan);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Konfirmasi Pengerjaan",
            overflow: TextOverflow.fade,
            style: TextStyle(
              color: Colors.black87,
            )),
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // petugas
                OpsionalTextInputForm(
                  maxLine: 1,
                  controller: namaPetugasC,
                  title: 'Petugas',
                  readOnly: true,
                ),

                // jenis pekerjaan
                OpsionalTextInputForm(
                  maxLine: 1,
                  controller: jenisPekerjaanC,
                  title: 'Jenis Pekerjaan',
                  readOnly: true,
                ),

                // Agenda
                OpsionalTextInputForm(
                  maxLine: 1,
                  controller: agendaC,
                  title: 'Agenda',
                  readOnly: true,
                ),

                // jadwal mulai
                DateInputForm(
                  controller: jadwalMulaiC,
                  readOnly: true,
                  title: 'Jadwal Mulai',
                  prefixIcon: const Icon(Iconsax.calendar_1),
                ),

                // jadwal mulai
                DateInputForm(
                  controller: jadwalSelesaiC,
                  readOnly: true,
                  title: 'Jadwal Selesai',
                  prefixIcon: const Icon(Iconsax.calendar_1),
                ),

                // mulai pengerjaan
                DateInputForm(
                  controller: jadwalSelesaiC,
                  readOnly: true,
                  title: 'Mulai Pengerjaan',
                  prefixIcon: const Icon(Iconsax.calendar_1),
                ),

                // deskripsi
                TextInputForm(
                  maxLine: 5,
                  controller: descPengerjaanC,
                  title: 'Deskripsi Pengerjaan',
                  hintTxt: 'Tuliskan apa yang anda lakukan',
                  readOnly: false,
                ),

                // foto
                ImageForm(
                  pickedImage: _pickedImage,
                  title: 'Foto',
                  desc: 'Upload bukti pengerjaan',
                  openCamera: () {
                    openCamera();
                  },
                  deleteImage: () {
                    setState(() {
                      _pickedImage = null;
                    });
                  },
                ),

                // foto
                ImageForm(
                  pickedImage: _pickedImage2,
                  title: 'Foto',
                  desc: 'Upload bukti pengerjaan',
                  openCamera: () {
                    openCamera2();
                  },
                  deleteImage: () {
                    setState(() {
                      _pickedImage2 = null;
                    });
                  },
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
                      String tglSelesai =
                          DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
                      await DalamProses()
                          .selesaiPengerjaan(
                            docJpp: widget.docJpp,
                            kodeJpp: widget.kodeJpp,
                            docPembangkit: widget.docPembangkit,
                            jenisAset: widget.jenisAset,
                            docAset: widget.docAset,
                            spd1: widget.spd1,
                            uidPetugas: widget.uidPetugas,
                            docHistory: widget.docHistory,
                            status: 'Selesai',
                            verifPengerjaan: 'Belum Verifikasi',
                            descPengerjaan: descPengerjaanC.text,
                            selesaiPengerjaan: tglSelesai,
                            imgFoto1: _pickedImage,
                            imgFoto2: _pickedImage2,
                          )
                          .then((_) => setState(() {
                                _isLoading = false;
                              }));
                      String message =
                          'INFO\n\nPada tanggal $tglSelesai, Petugas ${widget.namaPetugas} telah selesai melakukan ${widget.jenisPekerjaan} untuk aset dengan detail sebagai berikut:\n-Kode Pembangkit: ${widget.kodeJpp}\n-Jenis Aset: ${widget.jenisAset}\n-Nama Aset: ${widget.spd1}';
                      controller.sendWhatsApp('+6285175092056', message);

                      if (context.mounted) {
                        Navigator.pop(context);
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
    );
  }
}
