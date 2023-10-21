import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:manajemen_aset/pages/history_asset/utils/pelaporan.dart';

import '../../../service/send_message.dart';
import '../../../widget/back_verif.dart';
import '../../../widget/button/big_button.dart';
import '../../../widget/input_form/date_input_form.dart';
import '../../../widget/input_form/image_form.dart';
import '../../../widget/input_form/text_input_form.dart';

class AddPelaporan extends StatefulWidget {
  final String docJpp;
  final String kodeJpp;
  final String spd1;
  final String docPembangkit;
  final String jenisAset;
  final String docAset;
  final String currentUser;

  const AddPelaporan(
      {Key? key,
      required this.docJpp,
      required this.kodeJpp,
      required this.spd1,
      required this.docPembangkit,
      required this.jenisAset,
      required this.docAset,
      required this.currentUser})
      : super(key: key);

  @override
  State<AddPelaporan> createState() => _AddPelaporanState();
}

class _AddPelaporanState extends State<AddPelaporan> {
  final SendMessageController controller = Get.put(SendMessageController());
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool isDataSaved = false;

  // text field controller
  TextEditingController waktuPelaporanC = TextEditingController();
  TextEditingController descC = TextEditingController();
  TextEditingController currentUserC = TextEditingController();
  DateTime? _date;
  TimeOfDay? _time;
  File? _pickedImage;
  File? _pickedImage2;
  File? _pickedImage3;

  void _showDatePickerP(TextEditingController c) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (selectedDate != null && context.mounted) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        setState(() {
          _date = selectedDate;
          _time = selectedTime;
          DateTime newDateTime = DateTime(_date!.year, _date!.month, _date!.day,
              _time!.hour, _time!.minute);
          String dateTimeFormated =
              DateFormat('yyyy-MM-dd HH:mm').format(newDateTime);
          c.text = dateTimeFormated;
        });
      }
    }
  }

  Future openCamera(bool? isPhoto1, bool isPhoto2) async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image == null) return;
    File? img = File(image.path);
    setState(() {
      if (isPhoto1 == true) {
        _pickedImage = img;
      } else if (isPhoto2 == true) {
        _pickedImage2 = img;
      } else {
        _pickedImage3 = img;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    currentUserC = TextEditingController(text: widget.currentUser);
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
                title: 'Batalkan tambah pelaporan?',
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
            'Tambah Pelaporan',
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
                      title: 'Batalkan tambah pelaporan?',
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
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // petugas
                  TextInputForm(
                    title: 'Petugas',
                    controller: currentUserC,
                    prefixIcon: const Icon(Iconsax.user),
                    readOnly: true,
                  ),
                  // waktu pelaporan
                  DateInputForm(
                    controller: waktuPelaporanC,
                    readOnly: false,
                    title: 'Waktu Pelaporan',
                    prefixIcon: const Icon(Iconsax.calendar_1),
                    showCalendar: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _showDatePickerP(waktuPelaporanC);
                    },
                  ),

                  // agenda
                  TextInputForm(
                    title: 'Deskripsi Pelaporan',
                    controller: descC,
                    prefixIcon: const Icon(Iconsax.document_text_1),
                    hintTxt: 'Tuliskan pelaporan',
                    readOnly: false,
                    maxLine: 5,
                  ),

                  // foto 1
                  ImageForm(
                    pickedImage: _pickedImage,
                    title: 'Foto',
                    desc: 'Upload foto pelaporan',
                    openCamera: () {
                      openCamera(true, false);
                    },
                    deleteImage: () {
                      setState(() {
                        _pickedImage = null;
                      });
                    },
                  ),

                  // foto 2
                  OptionalImageForm(
                    pickedImage: _pickedImage2,
                    title: 'Foto',
                    desc: 'Upload foto pelaporan',
                    openCamera: () {
                      openCamera(false, true);
                    },
                    deleteImage: () {
                      setState(() {
                        _pickedImage2 = null;
                      });
                    },
                  ),

                  // foto 3
                  OptionalImageForm(
                    pickedImage: _pickedImage3,
                    title: 'Foto',
                    desc: 'Upload foto pelaporan',
                    openCamera: () {
                      openCamera(false, false);
                    },
                    deleteImage: () {
                      setState(() {
                        _pickedImage3 = null;
                      });
                    },
                  ),

                  //submit button
                  BigButtonIcon(
                    isLoading: _isLoading,
                    title: "Simpan",
                    icon: Icons.save,
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          _pickedImage != null) {
                        setState(() {
                          _isLoading = true;
                        });
                        await Pelaporan()
                            .addPelaporan(
                              docJpp: widget.docJpp,
                              kodeJpp: widget.kodeJpp,
                              docPembangkit: widget.docPembangkit,
                              jenisAset: widget.jenisAset,
                              docAset: widget.docAset,
                              spd1: widget.spd1,
                              namaPetugas: currentUserC.text,
                              waktuPelaporan: waktuPelaporanC.text,
                              descPelaporan: descC.text,
                              imgFoto1: _pickedImage,
                              imgFoto2: _pickedImage2,
                              imgFoto3: _pickedImage3,
                            )
                            .then((_) => setState(() {
                                  _isLoading = false;
                                  isDataSaved = true;
                                }));
                        String message =
                            'DARURAT\n\nDetail Aset\n-Kode Pembangkit: ${widget.kodeJpp}\n-Jenis Aset: ${widget.jenisAset}\n-Nama Aset: ${widget.spd1}\n\nDetail Pelaporan\n-Tanggal Pelaporan: ${waktuPelaporanC.text}\n-Deskripsi Pelaporan: ${descC.text}';
                        controller.sendWhatsApp('+6285175092056', message);

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      } else if (_pickedImage == null) {
                        Get.snackbar(
                          'Peringatan',
                          'Foto wajib diisi',
                          backgroundColor: Colors.red[400],
                          colorText: Colors.white,
                        );
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
