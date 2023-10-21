import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/pages/asset/detail_aset.dart';

import '../../models/aset.dart';
import 'aset_controller.dart';

class ListAset extends StatefulWidget {
  const ListAset({
    Key? key,
    required this.idCluster,
    required this.idPerangkat,
    required this.kodePerangkat,
    required this.jenisAset,
    required this.jenisPerangkat,
  }) : super(key: key);

  final String idCluster;
  final String idPerangkat;
  final String kodePerangkat;
  final String jenisAset;
  final String jenisPerangkat;

  @override
  State<ListAset> createState() => _ListAsetState();
}

class _ListAsetState extends State<ListAset> {
  String spd1 = '';
  String spd2 = '';
  String spd3 = '';
  String spd4 = '';
  String spd5 = '';

  @override
  void initState() {
    super.initState();
    if (widget.jenisAset == 'mekanik') {
      setState(() {
        spd1 = 'spd11';
        spd2 = 'spd12';
        spd3 = 'spd13';
        spd4 = 'spd14';
        spd5 = 'spd15';
      });
    } else if (widget.jenisAset == 'elektrik') {
      setState(() {
        spd1 = 'spd21';
        spd2 = 'spd22';
        spd3 = 'spd23';
        spd4 = 'spd24';
        spd5 = 'spd25';
      });
    } else if (widget.jenisAset == 'kd') {
      setState(() {
        spd1 = 'spd31';
        spd2 = 'spd32';
        spd3 = 'spd33';
        spd4 = 'spd34';
        spd5 = 'spd35';
      });
    } else if (widget.jenisAset == 'sensor') {
      setState(() {
        spd1 = 'spd41';
        spd2 = 'spd42';
        spd3 = 'spd43';
        spd4 = 'spd44';
        spd5 = 'spd45';
      });
    } else if (widget.jenisAset == 'it') {
      setState(() {
        spd1 = 'spd51';
        spd2 = 'spd52';
        spd3 = 'spd53';
        spd4 = 'spd54';
        spd5 = 'spd55';
      });
    } else {
      setState(() {
        spd1 = 'spd61';
        spd2 = 'spd62';
        spd3 = 'spd63';
        spd4 = 'spd64';
        spd5 = 'spd65';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AsetController()
          .listAset(widget.idCluster, widget.idPerangkat, widget.jenisAset),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        } else if (snapshot.hasData || snapshot.data != null) {
          if (snapshot.data!.docs.isEmpty) {
            return const Column(
              children: [
                SizedBox(height: 8),
                Image(image: AssetImage('img/folder.png'), width: 50),
                SizedBox(height: 8),
                Text(
                  'Tidak Ada Data Aset',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                )
              ],
            );
          } else {
            List<DocumentSnapshot> sortedDocs = snapshot.data!.docs;
            sortedDocs.sort((a, b) {
              String spd1A = a[spd1];
              String spd1B = b[spd1];
              return spd1A.compareTo(spd1B);
            });
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final documentSnapshot = sortedDocs[index];
                  final String docAsetId = sortedDocs[index].id;
                  String id = documentSnapshot['id'] ?? "-";
                  String spd1Data = documentSnapshot[spd1] ?? "-";
                  String spd2Data = documentSnapshot[spd2] ?? "-";
                  String spd3Data = documentSnapshot[spd3] ?? "-";
                  String spd4Data = documentSnapshot[spd4] ?? "-";
                  String spd5Data = documentSnapshot[spd5] ?? "-";
                  String lokasi = documentSnapshot['lokasi'] ?? "-";
                  String tglPasang = documentSnapshot['tglPasang'] ?? "-";
                  String img1 = documentSnapshot['img1'] ?? "-";
                  String img2 = documentSnapshot['img2'] ?? "-";
                  String alarm = documentSnapshot['alarm'];
                  String status = documentSnapshot['status'];
                  String spu1 = documentSnapshot['spu1'] ?? "-";
                  String spu2 = documentSnapshot['spu2'] ?? "-";
                  String spu3 = documentSnapshot['spu3'] ?? "-";
                  String sopFileName = documentSnapshot['sopFileName'] ?? "-";
                  String spu4 = documentSnapshot['spu4'] ?? "-";
                  String garansiFileName =
                      documentSnapshot['garansiFileName'] ?? "-";
                  String umurAset = documentSnapshot['umurAset'] ?? "-";
                  String vendorPemasangan =
                      documentSnapshot['vendorPemasangan'] ?? "-";
                  String vendorPengadaan =
                      documentSnapshot['vendorPengadaan'] ?? "-";
                  String commisioning = documentSnapshot['commisioning'] ?? "-";
                  String garansi = documentSnapshot['garansi'] ?? "-";

                  // alarm
                  // String imgStatus= 'img/alarm/aman.png';
                  // if (alarm == "Aman") {
                  //   imgAlarm = 'img/alarm/aman.png';
                  // } else if (alarm == "Peringatan 1") {
                  //   imgAlarm = 'img/alarm/peringatan1.png';
                  // } else if (alarm == "Peringatan 2") {
                  //   imgAlarm = 'img/alarm/peringatan2.png';
                  // } else if (alarm == "Sedang Service") {
                  //   imgAlarm = 'img/alarm/service.png';
                  // } else if (alarm == "Bahaya") {
                  //   imgAlarm = 'img/alarm/bahaya.png';
                  // } else if (alarm == "Belum Terpasang") {
                  //   imgAlarm = 'img/alarm/kosong.png';
                  // }
                  return Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.12,
                            width: MediaQuery.of(context).size.width * 0.22,
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image(
                                      image: NetworkImage(
                                        img1,
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (widget.jenisAset == 'mekanik')
                            asetMekanik(spd1Data, spd2Data),
                          if (widget.jenisAset == 'elektrik')
                            asetElektrik(spd1Data, spd2Data),
                          if (widget.jenisAset == 'kd')
                            asetKd(spd1Data, spd2Data),
                          if (widget.jenisAset == 'sensor')
                            asetSensor(spd1Data, spd2Data),
                          if (widget.jenisAset == 'it')
                            asetIt(spd1Data, spd2Data),
                          if (widget.jenisAset == 'sipil')
                            asetSipil(spd1Data, spd2Data),
                          // SizedBox(
                          //   height: 24,
                          //   child: Image(
                          //     image: AssetImage(imgAlarm),
                          //   ),
                          // ),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailAset(
                                      jenisAset: widget.jenisAset,
                                      jenisPerangkat: widget.jenisPerangkat,
                                      dataAset: Aset(
                                        id: id,
                                        docAsetId: docAsetId,
                                        docJpp: widget.idPerangkat,
                                        kodeJpp: widget.kodePerangkat,
                                        docPembangkit: widget.idCluster,
                                        spd1: spd1Data,
                                        spd2: spd2Data,
                                        spd3: spd3Data,
                                        spd4: spd4Data,
                                        spd5: spd5Data,
                                        lokasi: lokasi,
                                        tglPasang: tglPasang,
                                        img1: img1,
                                        img2: img2,
                                        alarm: alarm,
                                        status: status,
                                        imgAlarm: '',
                                        spu1: spu1,
                                        spu2: spu2,
                                        spu3: spu3,
                                        sopFileName: sopFileName,
                                        spu4: spu4,
                                        garansiFileName: garansiFileName,
                                        umurAset: umurAset,
                                        vendorPemasangan: vendorPemasangan,
                                        vendorPengadaan: vendorPengadaan,
                                        commisioning: commisioning,
                                        garansi: garansi,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Iconsax.arrow_circle_right5,
                                color: Color(0XFFAFD3CA),
                              ))
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Divider(thickness: 1),
                    ],
                  );
                },
              ),
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
    );
  }

  Widget asetMekanik(String spd1Data, String spd2Data) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextAset(title: 'SPD 1.1: $spd1Data'),
          TextAset(title: 'SPD 1.2: $spd2Data'),
        ],
      ),
    );
  }

  Widget asetElektrik(String spd1Data, String spd2Data) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextAset(title: 'SPD 2.1: $spd1Data'),
          TextAset(title: 'SPD 2.2: $spd2Data'),
        ],
      ),
    );
  }

  Widget asetKd(String spd1Data, String spd2Data) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextAset(title: 'SPD 3.1: $spd1Data'),
          TextAset(title: 'SPD 3.2: $spd2Data'),
        ],
      ),
    );
  }

  Widget asetSensor(String spd1Data, String spd2Data) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextAset(title: 'SPD 4.1: $spd1Data'),
          TextAset(title: 'SPD 4.2: $spd2Data'),
        ],
      ),
    );
  }

  Widget asetIt(String spd1Data, String spd2Data) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextAset(title: 'SPD 5.1: $spd1Data'),
          TextAset(title: 'SPD 5.2: $spd2Data'),
        ],
      ),
    );
  }

  Widget asetSipil(String spd1Data, String spd2Data) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextAset(title: 'SPD 6.1: $spd1Data'),
          TextAset(title: 'SPD 6.2: $spd2Data'),
        ],
      ),
    );
  }
}

class TextAset extends StatelessWidget {
  const TextAset({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      maxLines: 3,
    );
  }
}
