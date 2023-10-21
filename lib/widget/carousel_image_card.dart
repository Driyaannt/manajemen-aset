import 'package:flutter/material.dart';

class CarouselImageCard extends StatelessWidget {
  final String image;

  const CarouselImageCard({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width * 0.8,
      // height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GestureDetector(
            child: Image(
              image: NetworkImage(
                image,
              ),
              fit: BoxFit.fill,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullScreenImage(image: image)));
            },
          ),
        ),
      ),
    );
  }
}

class FullScreenImage extends StatefulWidget {
  final String image;

  const FullScreenImage({Key? key, required this.image}) : super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // check for bug
        child: Image.network(
          widget.image,
          fit: BoxFit.contain,
          //enableLoadState: false,
          // mode: ExtendedImageMode.gesture,
          // initGestureConfigHandler: (state) {
          //   return GestureConfig(
          //     minScale: 0.9,
          //     animationMinScale: 0.7,
          //     maxScale: 3.0,
          //     animationMaxScale: 3.5,
          //     speed: 1.0,
          //     inertialSpeed: 100.0,
          //     initialScale: 1.0,
          //     inPageView: false,
          //     initialAlignment: InitialAlignment.center,
          //   );
          // },
        ),
      ),
      // children: [
      // GestureDetector(
      //     child: const Icon(
      //       Iconsax.close_circle,
      //       size: 20,
      //       color: Colors.white,
      //     ),
      //     onTap: () {
      //       Navigator.of(context).pop();
      //     }),

      // ],
    );
  }
}
