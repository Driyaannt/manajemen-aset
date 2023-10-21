import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:manajemen_aset/pages/history_asset/utils/terjadwal.dart';
import 'package:manajemen_aset/widget/input_form/date_input_form.dart';

import '../../service/send_message.dart';
import '../../widget/button/big_button.dart';
import '../../widget/input_form/text_input_form.dart';

class KonfirmasiForm extends StatefulWidget {
  final String docJpp;
  final String kodeJpp;
  final String docPembangkit;
  final String jenisAset;
  final String spd1;
  final String jenisPekerjaan;
  final String agenda;
  final String uidPetugas;
  final String namaPetugas;
  final String docAset;
  final String docHistory;
  final String jadwalMulai;
  final String jadwalSelesai;
  final String statusKonfirmasi;

  const KonfirmasiForm({
    Key? key,
    required this.jadwalMulai,
    required this.jadwalSelesai,
    required this.docJpp,
    required this.kodeJpp,
    required this.docPembangkit,
    required this.jenisAset,
    required this.spd1,
    required this.jenisPekerjaan,
    required this.agenda,
    required this.uidPetugas,
    required this.namaPetugas,
    required this.docAset,
    required this.docHistory,
    required this.statusKonfirmasi,
  }) : super(key: key);

  @override
  State<KonfirmasiForm> createState() => _KonfirmasiFormState();
}

class _KonfirmasiFormState extends State<KonfirmasiForm> {
  final SendMessageController controller = Get.put(SendMessageController());
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // text field controller
  TextEditingController petugasC = TextEditingController();
  TextEditingController jenisPekerjaanC = TextEditingController();
  TextEditingController agendaC = TextEditingController();
  TextEditingController jadwalMulaiC = TextEditingController();
  TextEditingController jadwalSelesaiC = TextEditingController();

  DateTime? _date;
  TimeOfDay? _time;

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

  @override
  void initState() {
    petugasC = TextEditingController(text: widget.namaPetugas);
    jenisPekerjaanC = TextEditingController(text: widget.jenisPekerjaan);
    agendaC = TextEditingController(text: widget.agenda);
    jadwalMulaiC = TextEditingController(text: widget.jadwalMulai);
    jadwalSelesaiC = TextEditingController(text: widget.jadwalSelesai);
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
                  title: 'Petugas',
                  maxLine: 1,
                  controller: petugasC,
                  prefixIcon: const Icon(Iconsax.user),
                  readOnly: true,
                ),
                // jenis pekerjaan
                OpsionalTextInputForm(
                  title: 'Jenis Pekerjaan',
                  maxLine: 1,
                  controller: jenisPekerjaanC,
                  prefixIcon: const Icon(Iconsax.document_text_1),
                  readOnly: true,
                ),
                // agenda
                OpsionalTextInputForm(
                  title: 'Agenda',
                  maxLine: 1,
                  controller: agendaC,
                  prefixIcon: const Icon(Iconsax.document_text_1),
                  readOnly: true,
                ),
                // jadwal mulai
                DateInputForm(
                  controller: jadwalMulaiC,
                  readOnly: false,
                  title: 'Jadwal Mulai',
                  prefixIcon: const Icon(Iconsax.calendar_1),
                  showCalendar: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _showDatePickerP(jadwalMulaiC);
                  },
                ),

                // jadwal mulai
                DateInputForm(
                  controller: jadwalSelesaiC,
                  readOnly: false,
                  title: 'Jadwal Selesai',
                  prefixIcon: const Icon(Iconsax.calendar_1),
                  showCalendar: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _showDatePickerP(jadwalSelesaiC);
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
                      await Terjadwal()
                          .konfirmasiHistory(
                            docJpp: widget.docJpp,
                            kodeJpp: widget.kodeJpp,
                            docPembangkit: widget.docPembangkit,
                            jenisAset: widget.jenisAset,
                            docAset: widget.docAset,
                            spd1: widget.spd1,
                            uidPetugas: widget.uidPetugas,
                            docHistory: widget.docHistory,
                            statusKonfirmasi: 'Diterima',
                            jadwalMulai: jadwalMulaiC.text,
                            jadwalSelesai: jadwalSelesaiC.text,
                          )
                          .then((_) => setState(() {
                                _isLoading = false;
                              }));
                      String message =
                          'INFO\n\nPada tanggal ${jadwalMulaiC.text}, Petugas ${widget.namaPetugas} dapat melakukan ${widget.jenisPekerjaan} untuk aset dengan detail sebagai berikut:\n-Kode Pembangkit: ${widget.kodeJpp}\n-Jenis Aset: ${widget.jenisAset}\n-Nama Aset: ${widget.spd1}';
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
