import 'package:flutter_webrtc/flutter_webrtc.dart';

class RtcRequestAndResult {
  String? fromUser;
  RTCSessionDescription? data;

  RtcRequestAndResult({required this.fromUser, required this.data});

  RtcRequestAndResult.fromJson(Map<String, dynamic> jsonData) {
    fromUser = jsonData['fromUser'];
    data = RTCSessionDescription(jsonData['sdp'], jsonData['type']);
  }

  Map<String, dynamic> toJson() =>
      {'fromUser': fromUser, 'type': data!.type, 'sdp': data!.sdp};
}
