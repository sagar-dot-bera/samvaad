import 'package:samvaad/data/datasources/local/fetch_user_data_from_local.dart';
import 'package:samvaad/domain/entities/call_log.dart';
import 'package:samvaad/domain/repositories/call_manager_repository.dart';

class CallManagerRepositoryImpl extends CallManagerRepository {
  FetchUserDataFromLocal fetchUserDataFromLocal = FetchUserDataFromLocal();
  @override
  Future<void> deleteCallLog(String id) async {
    await fetchUserDataFromLocal.removeCallLog(id);
  }

  @override
  Future<List<CallLog>> getCallLogFromStorage() async {
    return await fetchUserDataFromLocal.fetchCallLogs();
  }

  @override
  Future<void> storeCallLog(CallLog callLog) async {
    return await fetchUserDataFromLocal.addCallLog(callLog);
  }
}
