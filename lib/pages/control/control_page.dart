import 'package:flutter/cupertino.dart';
import 'package:manajemen_aset/pages/control/solar_panel/control_solar_panel.dart';
import 'package:manajemen_aset/pages/control/wind_turbine/control_wt_page.dart';

class ControlPage extends StatefulWidget {
  final String idPembangkit;
  final String docPerangkatId;
  final String docPembangkitId;
  final String jenisPerangkat;
  final String idPerangkat;

  const ControlPage(
      {Key? key,
      required this.idPembangkit,
      required this.docPerangkatId,
      required this.docPembangkitId,
      required this.jenisPerangkat,
      required this.idPerangkat})
      : super(key: key);

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            if (widget.jenisPerangkat == 'PLTB')
              const ControlWtPage()
            else if (widget.jenisPerangkat == 'PLTS')
              const ControlSpPage()
            else if (widget.jenisPerangkat == 'Diesel')
              const ControlSpPage()
            else if (widget.jenisPerangkat == 'Baterai')
              const ControlSpPage()
            else if (widget.jenisPerangkat == 'Weather Station')
              const ControlSpPage()
            else if (widget.jenisPerangkat == 'Rumah Energi')
              const ControlSpPage()
          ],
        ),
      ),
    );
  }
}
