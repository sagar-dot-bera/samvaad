import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:samvaad/core/utils/hive_handler.dart';

class UserRecord {
  static final instance = UserRecord._private();
  UserRecord._private();

  factory UserRecord() {
    return instance;
  }

  Map<String, String> deletedRecords = {};
  Map<String, String> priyasuchi = {};
  Map<String, String> blockedUser = {};
  Map<String, dynamic> markedMessage = {};
  Map<String, dynamic> oldNumber = {};

  Future<void> addToDeteledRecord(List<String> ids) async {
    for (var element in ids) {
      deletedRecords[element] = DateTime.now().toIso8601String();
    }
    await HiveHandler.intance.updateRecord(deletedRecords, "deletedRecord");
  }

  Future<void> addToPriyasuchi(Map<String, String> data) async {
    priyasuchi[data.keys.first] = data.keys.last;
    await HiveHandler.intance.updateRecord(priyasuchi, "priyasuchi");
  }

  Future<void> removeFromPriyasuchi(List<String> ids) async {
    for (var element in ids) {
      priyasuchi.remove(element);
    }
    await HiveHandler.intance.updateRecord(priyasuchi, "priyasuchi");
  }

  Future<void> addToBlockList(Map<String, String> data) async {
    blockedUser = {...blockedUser, ...data};
    log("blocking ${data.entries}");
    await HiveHandler.intance.updateRecord(blockedUser, "blockedRecord");
  }

  Future<void> removeFromBlockList(List<String> ids) async {
    for (var element in ids) {
      blockedUser.remove(element);
    }
    await HiveHandler.intance.updateRecord(priyasuchi, "blockedRecord");
  }

  Future<void> addToMarkedMessage(Map<String, dynamic> data) async {
    markedMessage = {...markedMessage, ...data};
    log("marking message ${markedMessage.entries}");
    await HiveHandler.intance.updateRecord(markedMessage, "markedMessage");
  }

  Future<void> addNumberToOldNumberList(String number) async {
    oldNumber[number] = "oldNumber";
    log("old number added to list");
    await HiveHandler.intance.updateRecord(oldNumber, "oldNumber");
  }
}
