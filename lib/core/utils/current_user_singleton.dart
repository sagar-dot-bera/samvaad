import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:samvaad/domain/entities/user.dart';

class CurrentUser {
  User? currentUser;
  List<Contact>? currentUserContacts;

  static final instance = CurrentUser._privateConstructor();

  CurrentUser._privateConstructor();

  factory CurrentUser() {
    return instance;
  }

  set setUser(User user) {
    currentUser = user;
  }

  set setContact(List<Contact> contact) {
    currentUserContacts = contact;
  }

  get getCurrentUser => currentUser;
  get getCurrentContact => currentUserContacts;
}
