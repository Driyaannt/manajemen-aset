import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manajemen_aset/service/database.dart';
import 'package:manajemen_aset/widget/submit_button.dart';

class ButtonAddKomponen extends StatelessWidget {
  final double latCluster;
  final double lngCluster;
  final double distance;
  final void Function()? nextPage;
  const ButtonAddKomponen({
    Key? key,
    required this.latCluster,
    required this.lngCluster,
    required this.distance,
    required this.nextPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Color(0xFF129575)),
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: DatabaseService().userRole(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  if (snapshot.hasData) {
                    String role = snapshot.data!.data()!['role'];
                    // cek user untuk menampilkan tombol tambah data aset
                    if (role == 'Operator' || role == 'Admin') {
                      // debugPrint(distance);
                      return IconButton(
                        onPressed: () {
                          // jika distance <= 1000 maka uset dapat menambahkan data aset
                          if (distance <= 10000000) {
                            nextPage!();
                          } else {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        width: 45,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFD9D9D9),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100.0)),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "Jarak Terlalu Jauh",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Image.asset(
                                        'img/denied.png',
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.5,
                                      ),
                                      const Text(
                                        'Anda berada terlalu jauh dari lokasi cluster, jarak maksimum untuk menambahkan data aset adalah 1 km dari lokasi aset.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SubmitButton(
                                            title: "OK",
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            bgColor: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                      );
                    } else {
                      null;
                    }
                  }
                  return const SizedBox();
                }),
          ),
        ],
      ),
    );
  }
}
