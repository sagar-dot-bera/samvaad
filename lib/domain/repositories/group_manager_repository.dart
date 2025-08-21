import 'package:flutter_contacts/flutter_contacts.dart';

abstract class GroupManagerRepository {
  Future<void> createGroup(Group newGroup);
}
