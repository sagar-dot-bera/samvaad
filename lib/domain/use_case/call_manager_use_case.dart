import 'package:samvaad/domain/entities/call.dart';
import 'package:samvaad/domain/entities/call_log.dart';
import 'package:samvaad/domain/repositories/call_manager_repository.dart';

class CallManagerUseCase {
  CallManagerRepository callManagerRepository;

  CallManagerUseCase({required this.callManagerRepository});

  Future<List<CallLog>> getCallLogsUseCase() async {
    return await callManagerRepository.getCallLogFromStorage();
  }

  Future<void> addCallLogUseCase(CallLog callLog) async {
    return await callManagerRepository.storeCallLog(callLog);
  }

  Future<void> removeCallLogUseCase(String id) async {
    return await callManagerRepository.deleteCallLog(id);
  }
}
