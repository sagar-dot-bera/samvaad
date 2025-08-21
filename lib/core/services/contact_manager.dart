import 'dart:developer';

import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactManager {
  Future<List<Contact>> getUserContact() async {
    try {
      if (await FlutterContacts.requestPermission()) {
        log("fetching contacts");
        return await FlutterContacts.getContacts(
            withProperties: true, withAccounts: true);
      } else {
        log("unable to fetch");
        return [];
      }
    } catch (e) {
      log("Error!!! ${e.toString()}");
      return [];
    }
  }
}
