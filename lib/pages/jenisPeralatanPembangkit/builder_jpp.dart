import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manajemen_aset/pages/jenisPeralatanPembangkit/widgets/jpp_card.dart';

class BuilderJpp extends StatefulWidget {
  final String docPembangkitId;
  final double latPembangkit;
  final double lngPembangkit;
  final String idPembangkit;
  final String namaPembangkit;
  final dynamic stream;
  final bool isAnon;
  const BuilderJpp({
    Key? key,
    required this.stream,
    required this.docPembangkitId,
    required this.latPembangkit,
    required this.lngPembangkit,
    required this.idPembangkit,
    required this.isAnon,
    required this.namaPembangkit,
  }) : super(key: key);

  @override
  State<BuilderJpp> createState() => _BuilderJppState();
}

class _BuilderJppState extends State<BuilderJpp> {
  // Future<WtDailyProd> getDataWt(String id) async {
  //   String? domain = widget.apiModel.domain;
  //   // [WT.08]
  //   Uri url = Uri.parse("$domain/api/wind-turbine/daily-production");
  //   var response = await http.post(
  //     url,
  //     body: {
  //       "id": id,
  //       "date_day": DateFormat('dd/MM/yyyy').format(DateTime.now())
  //     },
  //   );

  //   final jsonData = json.decode(response.body);
  //   final idP = jsonData['id'];
  //   final day =
  //       DateFormat('yyyy-mm-dd').format(DateTime.parse(jsonData['day']));
  //   final powerKwh = jsonData['power_kwh'] ?? '-';
  //   final powerWatt = jsonData['power_watt'] ?? '-';

  //   List<WtDailyProd> dailyProd = [];

  //   dailyProd.add(WtDailyProd(idP, day, powerKwh, powerWatt));
  //   return WtDailyProd(idP, day, powerKwh, powerWatt);
  // }

  // Future<SpDailyProd> getDataSp(String id) async {
  //   String? domain = widget.apiModel.domain;
  //   // [SP.03]
  //   Uri url = Uri.parse("$domain/api/solar-panel/daily-production");
  //   var response = await http.post(
  //     url,
  //     body: {
  //       "id": id,
  //       "date_day": DateFormat('dd/MM/yyyy').format(DateTime.now())
  //     },
  //   );

  //   final jsonData = json.decode(response.body);
  //   final idP = jsonData['id'];
  //   final day =
  //       DateFormat('yyyy-mm-dd').format(DateTime.parse(jsonData['day']));
  //   final powerKwh = jsonData['power_kwh'] ?? '-';
  //   final powerWatt = jsonData['power_watt'] ?? '-';

  //   List<SpDailyProd> dailyProd = [];

  //   dailyProd.add(SpDailyProd(idP, day, powerWatt, powerKwh));
  //   return SpDailyProd(idP, day, powerWatt, powerKwh);
  // }

  Future getData() async {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: StreamBuilder(
        stream: widget.stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          } else if (snapshot.hasData || snapshot.data != null) {
            if (snapshot.data!.docs.isEmpty) {
              return const Column(
                children: [
                  Image(image: AssetImage('img/no_data.png')),
                  Text(
                    'Peralatan Pembangkit Belum Terpasang',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  )
                ],
              );
            } else {
              List<DocumentSnapshot> sortedDocs = snapshot.data!.docs;
              sortedDocs.sort((a, b) {
                String kodeA = a['kode'];
                String kodeB = b['kode'];
                return kodeA.compareTo(kodeB);
              });
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final documentSnapshot = sortedDocs[index];
                  final String docId = sortedDocs[index].id;
                  String id = documentSnapshot['id'];
                  String kode = documentSnapshot['kode'];
                  String jenis = documentSnapshot['jenis'];
                  String status = documentSnapshot['status'];
                  String alarm = documentSnapshot['alarm'];
                  // gambar pembangkit
                  String img = '';
                  // fetch data prod energi
                  // masih fetch data WT saja
                  Future fetchData = getData();
                  if (jenis == 'PLTB') {
                    img = 'img/pltb.png';
                    // fetchData = getDataSp(id);
                  } else if (jenis == 'PLTS') {
                    img = 'img/plts.png';
                    // fetchData = getDataSp(id);
                  } else if (jenis == 'Diesel') {
                    img = 'img/pltd.png';
                  } else if (jenis == 'Baterai') {
                    img = 'img/battery.png';
                  } else if (jenis == 'Weather Station') {
                    img = 'img/ws.png';
                  } else if (jenis == 'Rumah Energi') {
                    img = 'img/rumah-energi.png';
                  } else if (jenis == 'Warehouse') {
                    img = 'img/warehouse.png';
                  }
                  // warna dari status
                  Color colorStatus = Colors.grey;
                  if (status == "Aktif") {
                    colorStatus = const Color(0xFF129575);
                  } else if (status == "Tidak Aktif") {
                    colorStatus = const Color(0xFFA9A9A9);
                  } else if (status == "Belum Terpasang") {
                    colorStatus = const Color(0xFF000000);
                  } else if (status == "Pemasangan") {
                    colorStatus = const Color(0xFF3A7AD0);
                  } else if (status == "Belum Diverifikasi") {
                    colorStatus = const Color(0xFFFFA71A);
                  }
                  // warna alarm
                  String imgAlarm = 'img/alarm/aman.png';
                  if (alarm == "Aman") {
                    imgAlarm = 'img/alarm/aman.png';
                  } else if (alarm == "Peringatan 1") {
                    imgAlarm = 'img/alarm/peringatan1.png';
                  } else if (alarm == "Peringatan 2") {
                    imgAlarm = 'img/alarm/peringatan2.png';
                  } else if (alarm == "Sedang Service") {
                    imgAlarm = 'img/alarm/service.png';
                  } else if (alarm == "Bahaya") {
                    imgAlarm = 'img/alarm/bahaya.png';
                  } else if (alarm == "Belum Terpasang") {
                    imgAlarm = 'img/alarm/kosong.png';
                  }

                  // warna alarm
                  Color colorAlarm = Colors.grey;
                  if (alarm == "Aman") {
                    colorAlarm = const Color(0xFF129575);
                  } else if (alarm == "Peringatan") {
                    colorAlarm = const Color(0xFFFFA71A);
                  } else if (alarm == "Bahaya") {
                    colorAlarm = const Color(0xFFDE2626);
                  }
                  return JppCard(
                    docPembangkitId: widget.docPembangkitId,
                    docJppId: docId,
                    id: id,
                    kode: kode,
                    status: status,
                    colorStatus: colorStatus,
                    img: img,
                    jenis: jenis,
                    alarm: alarm,
                    colorAlarm: colorAlarm,
                    fetchData: fetchData,
                    latPembangkit: widget.latPembangkit,
                    lngPembangkit: widget.lngPembangkit,
                    imgAlarm: imgAlarm,
                    idPembangkit: widget.idPembangkit,
                    isAnon: widget.isAnon,
                    namaPembangkit: widget.namaPembangkit,
                  );
                },
              );
            }
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
    );
  }
}
