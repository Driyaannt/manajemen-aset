import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../widget/carousel_image_card.dart';
import 'history_page.dart';

class DetailPelaporan extends StatelessWidget {
  const DetailPelaporan(
      {Key? key,
      this.petugas,
      this.waktuPelaporan,
      this.descPelaporan,
      this.urlFoto1,
      this.urlFoto2,
      this.urlFoto3})
      : super(key: key);

  final String? petugas;
  final String? waktuPelaporan;
  final String? descPelaporan;
  final String? urlFoto1;
  final String? urlFoto2;
  final String? urlFoto3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Pelaporan",
          overflow: TextOverflow.fade,
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Iconsax.arrow_left_24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
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
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // petugas
                        ShowText(
                          title: 'Petugas',
                          prefixIcon: Iconsax.user,
                          content: petugas,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: const Color(0xFFDE2626),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          child: const Text(
                            'Pelaporan',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // waktu pelaporan
                    ShowText(
                      title: 'Waktu Pelaporan',
                      prefixIcon: Iconsax.calendar_1,
                      content: waktuPelaporan,
                    ),
                    // Deskripsi Pelaporani
                    const Text(
                      'Deskripsi Pelaporan',
                      style: TextStyle(
                        color: Color(0xFF797979),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Iconsax.document_text,
                          size: 18,
                          color: Color(0xFF129575),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            descPelaporan!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF129575),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),

                    // foto
                    const Text(
                      'Foto',
                      style: TextStyle(
                        color: Color(0xFF797979),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    foto(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row foto(BuildContext context) {
    if (urlFoto2 != '-' && urlFoto3 == '-') {
      return Row(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.22,
            width: MediaQuery.of(context).size.width * 0.32,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GestureDetector(
                  child: Image(
                    image: NetworkImage(urlFoto1!),
                    fit: BoxFit.fill,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FullScreenImage(image: urlFoto1!)));
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.22,
            width: MediaQuery.of(context).size.width * 0.32,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GestureDetector(
                  child: Image(
                    image: NetworkImage(urlFoto2!),
                    fit: BoxFit.fill,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FullScreenImage(image: urlFoto2!)));
                  },
                ),
              ),
            ),
          ),
        ],
      );
    } else if (urlFoto2 != '-' && urlFoto3 != '-') {
      return Row(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.12,
            width: MediaQuery.of(context).size.width * 0.22,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GestureDetector(
                  child: Image(
                    image: NetworkImage(urlFoto1!),
                    fit: BoxFit.fill,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FullScreenImage(image: urlFoto1!)));
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.12,
            width: MediaQuery.of(context).size.width * 0.22,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GestureDetector(
                  child: Image(
                    image: NetworkImage(urlFoto2!),
                    fit: BoxFit.fill,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FullScreenImage(image: urlFoto2!)));
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.12,
            width: MediaQuery.of(context).size.width * 0.22,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GestureDetector(
                  child: Image(
                    image: NetworkImage(urlFoto3!),
                    fit: BoxFit.fill,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FullScreenImage(image: urlFoto3!)));
                  },
                ),
              ),
            ),
          ),
        ],
      );
    }
    return Row(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.22,
          width: MediaQuery.of(context).size.width * 0.32,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GestureDetector(
                child: Image(
                  image: NetworkImage(urlFoto1!),
                  fit: BoxFit.fill,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FullScreenImage(image: urlFoto1!)));
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
