import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:manajemen_aset/pages/report/pdf_preview_page.dart';

import '../../../widget/button/big_button.dart';
import '../../../widget/input_form/date_input_form.dart';

class ReportPage extends StatefulWidget {
  final String idPembangkit;
  final String namaPembangkit;
  final String docPembangkitId;
  final String idPerangkat;
  final String docPerangkatId;
  final String jenisPerangkat;
  final String kodePerangkat;

  const ReportPage({
    Key? key,
    required this.idPembangkit,
    required this.namaPembangkit,
    required this.docPembangkitId,
    required this.idPerangkat,
    required this.docPerangkatId,
    required this.jenisPerangkat,
    required this.kodePerangkat,
  }) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  DateTime? _date;
  TextEditingController tglAwalC = TextEditingController();
  TextEditingController tglAkhirC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _showDatePickerP(TextEditingController c) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (selectedDate != null) {
      setState(() {
        _date = selectedDate;
        DateTime newDate = DateTime(_date!.year, _date!.month, _date!.day);
        String dateFormated = DateFormat('yyyy-MM-dd').format(newDate);
        c.text = dateFormated;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 5),
                blurRadius: 6,
                color: const Color(0xff000000).withOpacity(0.06),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Report Aset',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text('Pilih Tanggal', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  // tgl mulai
                  DateInputForm(
                    controller: tglAwalC,
                    readOnly: false,
                    title: 'Tanggal Awal',
                    prefixIcon: const Icon(Iconsax.calendar_1),
                    showCalendar: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _showDatePickerP(tglAwalC);
                    },
                  ),
                  // tgl akhir
                  DateInputForm(
                    controller: tglAkhirC,
                    readOnly: false,
                    title: 'Tanggal Akhir',
                    prefixIcon: const Icon(Iconsax.calendar_1),
                    showCalendar: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _showDatePickerP(tglAkhirC);
                    },
                  ),

                  //submit button
                  BigButtonIcon(
                    isLoading: _isLoading,
                    title: "Cetak",
                    icon: Icons.picture_as_pdf_sharp,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return PdfPreviewPage(
                            tglAkhir: tglAkhirC.text,
                            tglAwal: tglAwalC.text,
                            idPembangkit: widget.idPembangkit,
                            namaPembangkit: widget.namaPembangkit,
                            docPerangkatId: widget.docPerangkatId,
                            jenisPerangkat: widget.jenisPerangkat,
                            kodePerangkat: widget.kodePerangkat,
                            docPembangkitId: widget.docPembangkitId,
                            idPerangkat: widget.idPerangkat,
                          );
                        })).then(
                          (_) => setState(() {
                            _isLoading = false;
                          }),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
