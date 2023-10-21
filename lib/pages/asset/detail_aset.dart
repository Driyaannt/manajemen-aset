import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/pages/asset/aset_controller.dart';
import 'package:manajemen_aset/pages/asset/widget/spek_dasar.dart';
import 'package:manajemen_aset/pages/asset/widget/spek_umum_widget.dart';
import 'package:manajemen_aset/pages/history_asset/history_page.dart';
import 'package:manajemen_aset/service/database.dart';
import 'package:manajemen_aset/widget/bottom_sheet/bottom_sheet_aset.dart';
import 'package:manajemen_aset/widget/carousel_image_card.dart';

import '../../models/aset.dart';
import 'edit_aset.dart';

class DetailAset extends StatefulWidget {
  final Aset dataAset;
  final String jenisAset;
  final String jenisPerangkat;

  const DetailAset({
    Key? key,
    required this.dataAset,
    required this.jenisAset,
    required this.jenisPerangkat,
  }) : super(key: key);

  @override
  State<DetailAset> createState() => _DetailAsetState();
}

class _DetailAsetState extends State<DetailAset> {
  String? image1;
  String? image2;
  List<String?> cardList = [];
  String titleSpd1 = '';
  String titleSpd2 = '';
  String titleSpd3 = '';
  String titleSpd4 = '';
  String titleSpd5 = '';
  Color colorStatus = Colors.grey;

  @override
  void initState() {
    super.initState();
    image1 = widget.dataAset.img1;
    String image2 = widget.dataAset.img2;
    cardList = [image1, image2];
    if (widget.dataAset.status == "Aktif") {
      colorStatus = const Color(0xFF129575);
    } else if (widget.dataAset.status == "Tidak Aktif") {
      colorStatus = const Color(0xFFA9A9A9);
    } else if (widget.dataAset.status == "Belum Terpasang") {
      colorStatus = const Color(0xFF000000);
    } else if (widget.dataAset.status == "Pemasangan") {
      colorStatus = const Color(0xFF3A7AD0);
    } else if (widget.dataAset.status == "Belum Diverifikasi") {
      colorStatus = const Color(0xFFFFA71A);
    }
    if (widget.jenisAset == 'mekanik') {
      setState(() {
        titleSpd1 = 'SPD 1.1';
        titleSpd2 = 'SPD 1.2';
        titleSpd3 = 'SPD 1.3';
        titleSpd4 = 'SPD 1.4';
        titleSpd5 = 'SPD 1.5';
      });
    } else if (widget.jenisAset == 'elektrik') {
      setState(() {
        titleSpd1 = 'SPD 2.1';
        titleSpd2 = 'SPD 2.2';
        titleSpd3 = 'SPD 2.3';
        titleSpd4 = 'SPD 2.4';
        titleSpd5 = 'SPD 2.5';
      });
    } else if (widget.jenisAset == 'kd') {
      setState(() {
        titleSpd1 = 'SPD 3.1';
        titleSpd2 = 'SPD 3.2';
        titleSpd3 = 'SPD 3.3';
        titleSpd4 = 'SPD 3.4';
        titleSpd5 = 'SPD 3.5';
      });
    } else if (widget.jenisAset == 'sensor') {
      setState(() {
        titleSpd1 = 'SPD 4.1';
        titleSpd2 = 'SPD 4.2';
        titleSpd3 = 'SPD 4.3';
        titleSpd4 = 'SPD 4.4';
        titleSpd5 = 'SPD 4.5';
      });
    } else if (widget.jenisAset == 'it') {
      setState(() {
        titleSpd1 = 'SPD 5.1';
        titleSpd2 = 'SPD 5.2';
        titleSpd3 = 'SPD 5.3';
        titleSpd4 = 'SPD 5.4';
        titleSpd5 = 'SPD 5.5';
      });
    } else {
      setState(() {
        titleSpd1 = 'SPD 6.1';
        titleSpd2 = 'SPD 6.2';
        titleSpd3 = 'SPD 6.3';
        titleSpd4 = 'SPD 6.4';
        titleSpd5 = 'SPD 6.5';
      });
    }
  }

  int _currentIndex = 0;
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titleAppBar(),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Iconsax.arrow_left_24),
        ),
        actions: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: DatabaseService().userRole(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return Container();
              }
              String role = snap.data!.data()!['role'];
              if (role == 'Admin' && widget.jenisPerangkat != 'Warehouse') {
                return IconButton(
                  icon: const Icon(Icons.more_vert_rounded),
                  onPressed: () {
                    showModalBottomSheet<dynamic>(
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0),
                        ),
                      ),
                      context: context,
                      builder: (BuildContext context) {
                        return BottomSheetAset(
                          edit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditAset(
                                  aset: widget.dataAset,
                                  jenisAset: widget.jenisAset,
                                ),
                              ),
                            );
                          },
                          delete: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Hapus Aset'),
                                content: const Text(
                                    'Apakah anda yakin ingin menghapus aset?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Batal"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await AsetController().deleteAset(
                                        aset: widget.dataAset,
                                        jenisAset: widget.jenisAset,
                                      );

                                      if (context.mounted) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text("Hapus"),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              children: [
                // Status
                statusAset(),
                const SizedBox(height: 10),
                // image carousel
                imageCarousel(),
                // History
                if (widget.jenisPerangkat != 'Warehouse') history(context),

                SpekDasarWidget(
                  title1: titleSpd1,
                  spd1: widget.dataAset.spd1,
                  title2: titleSpd2,
                  spd2: widget.dataAset.spd2,
                  title3: titleSpd3,
                  spd3: widget.dataAset.spd3,
                  title4: titleSpd4,
                  spd4: widget.dataAset.spd4,
                  title5: titleSpd5,
                  spd5: widget.dataAset.spd5,
                ),

                // Spek Umum
                SpekUmumWidget(
                  tglPasang: widget.dataAset.tglPasang,
                  spu1: widget.dataAset.spu1,
                  spu2: widget.dataAset.spu2,
                  spu3: widget.dataAset.spu3,
                  sopFileName: widget.dataAset.sopFileName,
                  spu4: widget.dataAset.spu4,
                  garansiFileName: widget.dataAset.garansiFileName,
                  umurAset: widget.dataAset.umurAset,
                  vendorPemasangan: widget.dataAset.vendorPemasangan,
                  vendorPengadaan: widget.dataAset.vendorPengadaan,
                  commisioning: widget.dataAset.commisioning,
                  lokasi: widget.dataAset.lokasi,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Text titleAppBar() {
    return Text(
      widget.jenisAset == 'mekanik'
          ? "Detail Mekanik"
          : widget.jenisAset == 'elektrik'
              ? "Detail Elektrik"
              : widget.jenisAset == 'kd'
                  ? "Detail Komunikasi Data"
                  : widget.jenisAset == 'sensor'
                      ? "Detail Sensor"
                      : widget.jenisAset == 'it'
                          ? "Detail IT"
                          : "Detail Sipil",
      overflow: TextOverflow.fade,
      style: const TextStyle(
        color: Colors.black87,
      ),
    );
  }

  // history
  Widget history(BuildContext context) {
    return GestureDetector(
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Riwayat Maintenance',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF797979)),
          ),
          SizedBox(width: 8),
          Icon(Iconsax.arrow_circle_right5,
              size: 18, color: Color.fromARGB(255, 228, 177, 36))
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HistoryPage(
              docJpp: widget.dataAset.docJpp,
              kodeJpp: widget.dataAset.kodeJpp,
              spd1: widget.dataAset.spd1,
              docPembangkit: widget.dataAset.docPembangkit,
              jenisAset: widget.jenisAset,
              docAset: widget.dataAset.docAsetId,
            ),
          ),
        );
      },
    );
  }

  // image carousel
  Widget imageCarousel() {
    return Column(
      children: [
        CarouselSlider(
          items: cardList.map((item) {
            return CarouselImageCard(image: item.toString());
          }).toList(),
          //Slider Container properties
          options: CarouselOptions(
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 12 / 11,
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlayInterval: const Duration(minutes: 1),
              viewportFraction: 0.8,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: map<Widget>(cardList, (index, url) {
            return Container(
              width: _currentIndex == index ? 30 : 10.0,
              height: 10.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: _currentIndex == index
                    ? const Color(0xFF129575)
                    : const Color(0xFF129575).withOpacity(0.3),
              ),
            );
          }),
        ),
      ],
    );
  }

  // status aset
  Row statusAset() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.dataAset.status,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: colorStatus,
          ),
        ),
        // const SizedBox(width: 8),
        // SizedBox(
        //   height: 24,
        //   child: Image(
        //     image: AssetImage(widget.dataAset.status),
        //   ),
        // ),
      ],
    );
  }
}
