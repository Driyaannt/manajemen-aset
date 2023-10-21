import 'package:get/get.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class SendMessageController extends GetxController {
  TwilioFlutter? twilioFlutter;
  @override
  void onInit() {
    super.onInit();
    twilioFlutter = TwilioFlutter(
        accountSid: 'ACf4a6d825fb0ced3549a696350ce7be62',
        authToken: 'b30f04f1f25657475438e91343b51eb5',
        twilioNumber: '+14155238886');
  }

  @override
  void onClose() {
    // Hapus controller ketika keluar dari halaman
    Get.delete<SendMessageController>();
    super.onClose();
  }

  void sendWhatsApp(String number, String message) async {
    twilioFlutter!.sendWhatsApp(toNumber: number, messageBody: message);
  }
}
