import 'package:hive/hive.dart';
import 'package:samvaad/domain/entities/call.dart';

part 'call_log.g.dart';

@HiveType(typeId: 15)
class CallLog {
  @HiveField(0)
  Map<String, dynamic> callDetail;
  @HiveField(1)
  bool receivedOrAnswer;

  CallLog({required this.callDetail, required this.receivedOrAnswer});
}
