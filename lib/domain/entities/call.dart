import 'package:hive/hive.dart';
import 'package:samvaad/core/utils/app_enums.dart';
import 'package:samvaad/domain/entities/user.dart';

part 'call.g.dart';

@HiveType(typeId: 98)
class Call {
  @HiveField(0)
  User? withUser;
  @HiveField(1)
  CallType? callType;
  @HiveField(3)
  String? timeStamp;

  Call(
      {required this.withUser,
      required this.callType,
      required this.timeStamp});

  Map<String, dynamic> toJson() => {
        "withUser": withUser!.toJson(),
        "callType": callTypeToString(callType!),
        "timeStamp": timeStamp
      };

  Call.fromJson(Map<String, dynamic> data) {
    withUser = User.fromJson(Map<String, dynamic>.from(data["withUser"]));
    callType = fromStringToCallType(data["callType"]);
    timeStamp = data['timeStamp'] ?? "";
  }

  String callTypeToString(CallType type) {
    if (type == CallType.incoming) {
      return "incoming";
    } else if (type == CallType.outgoing) {
      return "outgoing";
    } else if (type == CallType.missedCall) {
      return "missedCall";
    } else {
      return "don't know";
    }
  }

  CallType fromStringToCallType(String callType) {
    if (callType == "incoming") {
      return CallType.incoming;
    } else if (callType == "outgoing") {
      return CallType.outgoing;
    } else if (callType == "missedCall") {
      return CallType.missedCall;
    } else {
      return CallType.unknown;
    }
  }
}
