import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/pages/history_asset/add_history.dart';
import 'package:manajemen_aset/pages/history_asset/pelaporan/add_pelaporan.dart';
import 'package:manajemen_aset/service/database.dart';

class ButtonAddHistory extends StatefulWidget {
  final String docJpp;
  final String kodeJpp;
  final String spd1;
  final String docPembangkit;
  final String jenisAset;
  final String docAset;
  const ButtonAddHistory(
      {Key? key,
      required this.docJpp,
      required this.kodeJpp,
      required this.spd1,
      required this.docPembangkit,
      required this.jenisAset,
      required this.docAset})
      : super(key: key);

  @override
  State<ButtonAddHistory> createState() => _ButtonAddHistoryState();
}

class _ButtonAddHistoryState extends State<ButtonAddHistory> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: DatabaseService().userRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        if (snapshot.hasData) {
          String role = snapshot.data!.data()!['role'];
          String nama = snapshot.data!.data()!['nama'];
          // cek user untuk melakukan penjadwalan
          if (role == 'Vendor' || role == "Admin") {
            return FloatingActionButton(
              backgroundColor: const Color(0xFF129575),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                showModalBottomSheet<dynamic>(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25.0),
                        topLeft: Radius.circular(25.0)),
                  ),
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: Container(
                                width: 40,
                                height: 5,
                                decoration: BoxDecoration(
                                    color: const Color(0xFFD9D9D9),
                                    borderRadius: BorderRadius.circular(18)),
                              ),
                            ),
                            ListTile(
                              leading: const Icon(
                                Iconsax.additem,
                                color: Color(0xFF129575),
                              ),
                              title: const Text(
                                'Tambah Penugasan',
                                style: TextStyle(
                                  color: Color(0xFF129575),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              horizontalTitleGap: 4,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddHistoryPage(
                                      spd1: widget.spd1,
                                      docJpp: widget.docJpp,
                                      kodeJpp: widget.kodeJpp,
                                      docPembangkit: widget.docPembangkit,
                                      jenisAset: widget.jenisAset,
                                      docAset: widget.docAset,
                                    ),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: const Icon(
                                Iconsax.danger,
                                color: Color(0xFFDE2626),
                              ),
                              title: const Text(
                                'Tambah Pelaporan Darurat',
                                style: TextStyle(
                                  color: Color(0xFFDE2626),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              horizontalTitleGap: 4,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddPelaporan(
                                      spd1: widget.spd1,
                                      docJpp: widget.docJpp,
                                      kodeJpp: widget.kodeJpp,
                                      docPembangkit: widget.docPembangkit,
                                      jenisAset: widget.jenisAset,
                                      docAset: widget.docAset,
                                      currentUser: nama,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return FloatingActionButton(
              backgroundColor: const Color(0xFF129575),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPelaporan(
                      spd1: widget.spd1,
                      docJpp: widget.docJpp,
                      kodeJpp: widget.kodeJpp,
                      docPembangkit: widget.docPembangkit,
                      jenisAset: widget.jenisAset,
                      docAset: widget.docAset,
                      currentUser: nama,
                    ),
                  ),
                );
              },
            );
          }
        }
        return const SizedBox();
      },
    );
  }
}
