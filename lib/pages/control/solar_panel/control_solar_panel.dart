import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manajemen_aset/pages/control/wind_turbine/controls_box.dart';

class ControlSpPage extends StatefulWidget {
  const ControlSpPage({Key? key}) : super(key: key);

  @override
  State<ControlSpPage> createState() => _ControlSpPageState();
}

class _ControlSpPageState extends State<ControlSpPage> {
  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  // list of controls
  List controls = [
    // [ smartDeviceName, iconPath , powerStatus ]
    ["Electrical System", "img/energy.png", false],
  ];

  // power button switched
  void powerSwitchChanged(bool value, int index) {
    Get.defaultDialog(
      middleText: 'Apakah anda ingin melakukan kontrol?',
      onConfirm: () => setState(
        () {
          controls[index][2] = value;
          Get.back();
        },
      ),
      textConfirm: 'Ya',
      confirmTextColor: Colors.white,
      buttonColor: Colors.green[400],
      textCancel: 'Tidak',
      cancelTextColor: Colors.black38,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // control system grid
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Text(
              "Kontrol",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // grid
          GridView.builder(
            shrinkWrap: true,
            itemCount: 1,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 25),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.3,
            ),
            itemBuilder: (context, index) {
              return ControlsBox(
                controls: controls[index][0],
                iconPath: controls[index][1],
                powerOn: controls[index][2],
                onChanged: (value) => powerSwitchChanged(value, index),
              );
            },
          )
        ],
      ),
    );
  }
}
