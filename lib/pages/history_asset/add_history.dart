import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:manajemen_aset/pages/history_asset/utils/terjadwal.dart';
import 'package:manajemen_aset/service/database.dart';
import 'package:manajemen_aset/widget/input_form/text_input_form.dart';

import '../../service/send_message.dart';
import '../../widget/button/big_button.dart';
import '../../widget/input_form/date_input_form.dart';

class AddHistoryPage extends StatefulWidget {
  final String docJpp;
  final String kodeJpp;
  final String spd1;
  final String docPembangkit;
  final String jenisAset;
  final String docAset;

  const AddHistoryPage(
      {Key? key,
      required this.docJpp,
      required this.kodeJpp,
      required this.spd1,
      required this.docPembangkit,
      required this.jenisAset,
      required this.docAset})
      : super(key: key);

  @override
  State<AddHistoryPage> createState() => _AddHistoryPageState();
}

class _AddHistoryPageState extends State<AddHistoryPage> {
  final SendMessageController controller = Get.put(SendMessageController());
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // text field controller
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

  final jenisList = [
    'Perbaikan',
    'Perawatan',
    'Pemeriksaan',
  ];
  String? selectedJenis = '';
  final List<UserData> _getUser = [];
  String? selectedNamaPetugas = '';
  String? selectedUidPetugas = '';
  String? selectedNoHpPetugas = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Penugasan',
          style: TextStyle(color: Colors.black87),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // petugas
                const Text(
                  'Petugas',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                StreamBuilder<QuerySnapshot>(
                  stream: DatabaseService().listUserOperator(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      const Text("Loading.....");
                    } else {
                      _getUser.clear();
                      for (int i = 0; i < snapshot.data!.docs.length; i++) {
                        DocumentSnapshot snap = snapshot.data!.docs[i];
                        String nama = snap['nama'];
                        String uid = snap['uid'];
                        String nomerHp = snap['noHp'];

                        UserData dataUser =
                            UserData(nama: nama, uid: uid, nomerHp: nomerHp);
                        _getUser.add(dataUser);
                      }
                      // Render SearchableDropdown dengan items yang sudah didapatkan
                      return DropdownSearch<UserData>(
                        // dropdownSearchDecoration: InputDecoration(
                        //   hintText: "Pilih Petugas Operator",
                        //   prefixIcon: const Icon(Iconsax.user),
                        //   border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(10.0),
                        //   ),
                        // ),
                        // mode: Mode.DIALOG,
                        // showSearchBox: true,
                        // enabled: true,
                        // onFind: (text) async {
                        //   return _getUser;
                        // },
                        popupProps: const PopupProps.dialog(
                          showSearchBox: true,
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            hintText: "Pilih Petugas Operator",
                            prefixIcon: const Icon(Iconsax.user),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        // TODO: check for bug
                        onChanged: (UserData? val) {
                          setState(() {
                            selectedUidPetugas = val!.uid;
                            selectedNamaPetugas = val.nama;
                            selectedNoHpPetugas = val.nomerHp;
                          });
                        },
                        validator: (value) {
                          if (value!.nama == '') {
                            return 'Pilih Petugas Operator';
                          }
                          return null;
                        },
                        itemAsString: (item) => item.nama,
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.black,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 16,
                ),

                // jenis
                const Text(
                  'Jenis Pekerjaan',
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                    hintText: 'Pilih Jenis Pekerjaan',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Pilih Jenis Pekerjaan';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),

                // agenda
                TextInputForm(
                  title: 'Agenda',
                  controller: agendaC,
                  prefixIcon: const Icon(Iconsax.document_text_1),
                  hintTxt: 'Tuliskan agenda penugasan',
                  readOnly: false,
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
                          .addPenjadwalan(
                            docJpp: widget.docJpp,
                            kodeJpp: widget.kodeJpp,
                            docPembangkit: widget.docPembangkit,
                            jenisAset: widget.jenisAset,
                            docAset: widget.docAset,
                            spd1: widget.spd1,
                            namaPetugas: selectedNamaPetugas,
                            uidPetugas: selectedUidPetugas,
                            agenda: agendaC.text,
                            jenisPekerjaan: selectedJenis,
                            jadwalMulai: jadwalMulaiC.text,
                            jadwalSelesai: jadwalSelesaiC.text,
                            status: 'Terjadwal',
                            statusKonfirmasi: 'Belum Terkonfirmasi',
                          )
                          .then((_) => setState(() {
                                _isLoading = false;
                              }));
                      String message =
                          'PENUGASAN\n\n-Nama Petugas: $selectedNamaPetugas\n\n-Kode Pembangkit: ${widget.kodeJpp}\n-Jenis Aset: ${widget.jenisAset}\n-Nama Aset: ${widget.spd1}\n\n-Jenis Pekerjaan: $selectedJenis\n-Agenda: ${agendaC.text}\n\n-Jadwal Mulai: ${jadwalMulaiC.text},\n-Jadwal Selesai: ${jadwalSelesaiC.text}\n\n Lakukan konfirmasi penugasan pada aplikasi';
                      controller.sendWhatsApp(selectedNoHpPetugas!, message);

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

class UserData {
  final String nama;
  final String uid;
  final String nomerHp;

  UserData({required this.nama, required this.uid, required this.nomerHp});
}
