import 'package:flutter/material.dart';
import 'package:samvaad/core/utils/hive_handler.dart';
import 'package:samvaad/domain/entities/call.dart';
import 'package:samvaad/domain/entities/call_log.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/domain/use_case/call_manager_use_case.dart';

class CallManagerViewModel extends ChangeNotifier {
  CallManagerUseCase callManagerUseCase;
  List<CallLog> _callLogs = [];
  List<CallLog> get callLogs => _callLogs;
  CallManagerViewModel({required this.callManagerUseCase});
  List<String> _selectedLogs = [];
  List<String> get selectedLogs => _selectedLogs;
  bool _isSelectionModeOn = false;
  bool get isSelectionModeOn => _isSelectionModeOn;
  List<CallLog> _filteredList = List.empty(growable: true);
  List<CallLog> get filteredList => _filteredList;

  void clearFilterList() {
    _filteredList.clear();
    notifyListeners();
  }

  set setSelectionMode(bool value) {
    _isSelectionModeOn = value;
    notifyListeners();
  }

  Future<void> setCallLog(CallLog log) async {
    await callManagerUseCase.addCallLogUseCase(log);
    _callLogs.add(log);
    notifyListeners();
  }

  Future<void> getCallLogs() async {
    callLogs.addAll(await callManagerUseCase.getCallLogsUseCase());
    notifyListeners();
  }

  void modifySelected(String id) {
    if (_selectedLogs.contains(id)) {
      _selectedLogs.removeWhere((e) => e == id);
      if (_selectedLogs.isEmpty) {
        _isSelectionModeOn = false;
      }
    } else {
      _selectedLogs.add(id);
      if (!_isSelectionModeOn) {
        _isSelectionModeOn = true;
      }
    }
    notifyListeners();
  }

  Future<void> clearAll() async {
    await HiveHandler.intance.clearAllCallLog();
    _callLogs.clear();
    notifyListeners();
  }

  Future<void> deleteCallLog(List<String> callLogs) async {
    await HiveHandler.intance.deleteCallLog(callLogs);
    _callLogs
        .removeWhere((e) => selectedLogs.contains(e.callDetail["timeStamp"]));
    selectedLogs.clear();
    notifyListeners();
  }

  void searchCallLog(String query) {
    for (var element in callLogs) {
      final call = Call.fromJson(element.callDetail);
      if (call.withUser!.userName!.contains(query)) {
        addToList(element);
      } else if (call.withUser!.phoneNo!.contains(query)) {
        addToList(element);
      }
    }
  }

  void addToList(CallLog callLog) {
    if (_filteredList.indexWhere((e) => e.callDetail == callLog.callDetail) ==
        -1) {
      _filteredList.add(callLog);
    } else {
      _filteredList.remove(callLog);
    }
    notifyListeners();
  }
}
