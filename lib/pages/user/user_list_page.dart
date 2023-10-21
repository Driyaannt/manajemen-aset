import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manajemen_aset/models/user.dart';
import 'package:manajemen_aset/pages/user/add_user.dart';
import 'package:manajemen_aset/pages/user/edit_user.dart';
import 'package:manajemen_aset/service/database.dart';

class UserList extends StatefulWidget {
  final String tingkatanAdmin;
  const UserList({
    Key? key,
    required this.tingkatanAdmin,
  }) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kelola Pengguna',
          style: TextStyle(color: Colors.black87),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Iconsax.arrow_left_24),
        ),
      ),
      body: StreamBuilder(
        stream: widget.tingkatanAdmin == 'Pusat'
            ? DatabaseService().listUser()
            : widget.tingkatanAdmin == 'Wilayah'
                ? DatabaseService().listUserWilayah()
                : DatabaseService().listUserArea(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          } else if (snapshot.hasData || snapshot.data != null) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final documentSnapshot = snapshot.data!.docs[index];
                      // final String docId = snapshot.data!.docs[index].id;
                      UserModel userData = UserModel(
                          documentSnapshot['nama'],
                          documentSnapshot['email'],
                          documentSnapshot['noHp'],
                          documentSnapshot['role'],
                          documentSnapshot['tingkatan'],
                          documentSnapshot['wilayah'],
                          documentSnapshot['wilayahId'],
                          documentSnapshot['area'],
                          documentSnapshot['areaId'],
                          documentSnapshot['urlImg'],
                          documentSnapshot['uid']);

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            Card(
                              // elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                isThreeLine: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                title: Text(
                                  userData.nama,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(userData.email),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: const Color.fromARGB(
                                              255, 18, 149, 116),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 3),
                                          child: Text(
                                            (userData.role == 'Admin' ||
                                                    userData.role == 'PLN'
                                                ? '${userData.role} ${userData.tingkatan}'
                                                : userData.role),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditUser(
                                            user: userData,
                                            tingkatanAdmin:
                                                widget.tingkatanAdmin),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Iconsax.edit),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF129575),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddUser(tingkatan: widget.tingkatanAdmin)));
        },
      ),
    );
  }
}
