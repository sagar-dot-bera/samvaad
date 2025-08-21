import 'dart:developer';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:samvaad/domain/entities/call_log.dart';
import 'package:samvaad/domain/entities/local_file.dart';

class HiveHandler {
  static final intance = HiveHandler._private();
  HiveHandler._private();

  factory HiveHandler() {
    return intance;
  }
  Future<File?> getLocalFile(String dataId) async {
    try {
      final localBox = await Hive.openBox<LocalFile>('local_data_v2');

      final data = localBox.get(dataId);

      if (data != null) {
        File dataFile = File(data.filePath);
        log("file $dataId found path ${data.filePath}");
        return dataFile;
      }

      return null;
    } on Exception catch (e) {
      log("Error $e");
      return null;
    }
  }

  Future<void> setLocalFile(String fileId, String filePath, String sender,
      String fileType, String metaData) async {
    try {
      LocalFile newLocalFile = LocalFile(
          fileId: fileId,
          filePath: filePath,
          fileType: fileType,
          sender: sender,
          metaData: metaData);
      log("local file saved ${newLocalFile.fileId} ${newLocalFile.metaData} ${newLocalFile.sender}");
      final localBox = Hive.box<LocalFile>('local_data_v2');

      localBox.put(fileId, newLocalFile);
    } on Exception catch (e) {
      log("Error $e");
    }
  }

  Future<List<LocalFile>> getAllLocalFiles() async {
    try {
      List<LocalFile> localFiles = List.empty(growable: true);
      final localBox = Hive.box<LocalFile>("local_data_v2");

      localFiles.addAll(localBox.values);
      return localFiles;
    } catch (e) {
      log("Error in fetching local files $e");
      return List.empty();
    }
  }

  Future<void> deleteLocalFile(List<String> ids) async {
    try {
      final localBox = Hive.box<LocalFile>("local_data_v2");

      await localBox.deleteAll(ids);
    } catch (e) {
      log("Error when deleting local file");
    }
  }

  Future<void> setCallLog(CallLog callLog) async {
    try {
      log("added call log to local storage");
      final callLogBox = Hive.box<CallLog>("call_log");
      await callLogBox.put(callLog.callDetail["timeStamp"], callLog);
    } on Exception catch (e) {
      log("Error on adding call detaile in local call log");
    }
  }

  Future<List<CallLog>> getCallLogs() async {
    try {
      log("getting call logs");
      List<CallLog> logs = List.empty(growable: true);

      final callLogBox = Hive.box<CallLog>("call_log");
      logs.addAll(callLogBox.values);
      return logs;
    } on Exception catch (e) {
      log("Error in fetching call logs $e");
      return [];
    }
  }

  Future<void> clearAllCallLog() async {
    try {
      final callLogBox = Hive.box<CallLog>("call_log");

      await callLogBox.clear();
    } on Exception catch (e) {
      log("Error in removing call logs");
    }
  }

  Future<void> deleteCallLog(List<String> ids) async {
    try {
      final callLogBox = Hive.box<CallLog>("call_log");
      await callLogBox.deleteAll(ids);
    } on Exception catch (e) {
      log("Error in delete call log");
    }
  }

  Future<void> removeLocalFile(String fileId) async {
    try {
      log("remove file from local storage with id $fileId");
      final localBox = await Hive.openBox<LocalFile>('local_data_v2');
      await localBox.delete(fileId);
    } on Exception catch (e) {
      log("Error in detelting file with id $fileId");
    }
  }

  Future<bool> checkIfFileIsDownloaded(String mediaId) async {
    try {
      File? file = await getLocalFile(mediaId);
      if (file != null) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      log("Erro in getting local image using checkIfdownload exits method $e");
      return false;
    }
  }

  Future<void> updateRecord(
      Map<dynamic, dynamic> updatedRecord, String recordName) async {
    try {
      final recordBox = await Hive.openBox<Map<dynamic, dynamic>>("record");
      for (var element in recordBox.keys) {
        log("keys $element");
      }

      for (var element in recordBox.values) {
        log("values $element");
      }

      await recordBox.put(recordName, updatedRecord);
      log("record name $recordName");

      recordBox.close();
    } on Exception catch (e) {
      log("error in updating delete record $e");
    }
  }

  Future<Map<String, String>> fetchRecord(String nameOfRecord) async {
    try {
      final recordBox = await Hive.openBox<Map<dynamic, dynamic>>("record");

      final Map<String, String>? data = recordBox
          .get(nameOfRecord)
          ?.map((k, v) => MapEntry(k.toString(), v.toString()));
      await recordBox.close();
      if (data!.isNotEmpty) {
        log("data fetched for record $nameOfRecord ${data.keys}");
        return data;
      } else {
        return {};
      }
    } catch (e) {
      log("error in fetching data $e");
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchMarkedMessage(String nameOfRecord) async {
    try {
      final recordBox = await Hive.openBox<Map<dynamic, dynamic>>("record");

      final Map<String, dynamic>? data =
          recordBox.get(nameOfRecord)?.map((k, v) => MapEntry(k.toString(), v));
      await recordBox.close();
      if (data!.isNotEmpty) {
        log("data fetched for record $nameOfRecord ${data.keys}");
        return data;
      } else {
        return {};
      }
    } catch (e) {
      log("error in fetching record $nameOfRecord data $e");
      return {};
    }
  }
}
