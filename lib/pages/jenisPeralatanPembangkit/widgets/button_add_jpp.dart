import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manajemen_aset/models/user.dart';
import 'package:manajemen_aset/pages/jenisPeralatanPembangkit/add_jpp.dart';
import 'package:manajemen_aset/pages/jenisPeralatanPembangkit/widgets/bottom_shett.dart';
import 'package:manajemen_aset/service/database.dart';

class ButtonAddJpp extends StatelessWidget {
  const ButtonAddJpp({
    Key? key,
    required this.distance,
    required String docPembangkitId,
  })  : _docPembangkitId = docPembangkitId,
        super(key: key);

  final double distance;
  final String _docPembangkitId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: DatabaseService().userRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        if (snapshot.hasData) {
          Map<String, dynamic> user = snapshot.data!.data()!;
          UserModel userData = UserModel(
            user['nama'],
            user['email'],
            user['noHp'],
            user['role'],
            user['tingkatan'],
            user['wilayah'],
            user['wilayahId'],
            user['area'],
            user['areaId'],
            user['urlImg'],
            user['uid'],
          );
          // cek user untuk menampilkan tombol tambah data aset
          if (userData.role == "Admin" || userData.role == "Vendor") {
            return FloatingActionButton(
              backgroundColor: const Color(0xFF129575),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                // jika distance <= 1000 maka uset dapat menambahkan data aset
                if (distance <= 100000000) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddJpp(docId: _docPembangkitId, user: userData),
                    ),
                  );
                } else {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    context: context,
                    builder: (context) {
                      return const FailedAddAset();
                    },
                  );
                }
              },
            );
          } else {
            null;
          }
        }
        return const SizedBox();
      },
    );
  }
}
