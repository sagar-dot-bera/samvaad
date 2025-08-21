import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Format {
  //method to format number in number + country code format
  String formatNumber(String number) {
    //check if number length is 10 character if 10 then add country code and return string
    if (number.length == 10) {
      return "+91${number.trim()}";
    } else {
      return number; //if length is more then just return number back
    }
  }

  String dateFormat24Hourse(dateString) {
    try {
      final date = DateTime.parse(dateString);

      final formatedDate = DateFormat.Hm('en_US').format(date);
      //log("formated date ${formatedDate.toString()}");
      return formatedDate.toString();
    } on FormatException catch (ex) {
      //log("formate error $ex");
      return "";
    }
  }

  String removeCountryCode(String phoneNumber) {
    //remove country code from the beging of phone number
    String withOutCountryCode = phoneNumber.substring(3);

    return withOutCountryCode;
  }
}
