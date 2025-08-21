import 'package:samvaad/domain/entities/call.dart';
import 'package:samvaad/domain/entities/call_log.dart';

abstract class CallManagerRepository {
  Future<void> storeCallLog(CallLog callLog);
  Future<void> deleteCallLog(String id);
  Future<List<CallLog>> getCallLogFromStorage();
}
