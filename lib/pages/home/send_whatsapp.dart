// import 'package:flutter/material.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
// class SendWhatsapp extends StatefulWidget {
//   SendWhatsapp({Key key, this.title}) : super(key: key);
//   final String title;
//   @override
//   _SendWhatsappState createState() => _SendWhatsappState();
// }
// class _SendWhatsappState extends State<SendWhatsapp> {
//   TwilioFlutter twilioFlutter;
//   @override
//   void initState() {
//     twilioFlutter = TwilioFlutter(
//         accountSid: '*************************',
//         authToken: '**************************',
//         twilioNumber: '+1***********');
//     super.initState();
//   }
//   void sendSms() async {
//     twilioFlutter.sendSMS(
//         toNumber: ' ************', messageBody: 'Hii everyone this is a demo of\nflutter twilio sms.');
//   }
//   void getSms() async {
//     var data = await twilioFlutter.getSmsList();
//     debugPrint(data);
//     await twilioFlutter.getSMS('***************************');
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text(widget.title),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Text(
//           'Press the button to send SMS.',
//           style: TextStyle(
//               color: Colors.black,
//               fontSize: 16
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: sendSms,
//         tooltip: 'Send Sms',
//         child: Icon(Icons.send),
//       ),
//     );
//   }
// }