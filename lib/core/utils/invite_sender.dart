import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';

class InviteSender {
  static String messageStr(String name) {
    return "Hey $name! Join me on Samvaad the best place to connect and chat! Download now:[App Link] (This is a test message,do not respond)";
  }

  static Future<void> sendSms(String name, String number) async {
    // final Uri sms = Uri(
    //     scheme: 'sms',
    //     path: number,
    //     queryParameters: <String, String>{'body': });

    String msg = messageStr(name);

    final Uri sms = Uri.parse("sms:$number?body=${Uri.encodeComponent(msg)}");

    if (await canLaunchUrl(sms)) {
      log("sms launche successful");
      launchUrl(sms);
    } else {
      log("can not launche sms");
    }
  }
}
