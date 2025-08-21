import 'package:flutter_webrtc/flutter_webrtc.dart';

class Candidate {
  String? fromUser;
  RTCIceCandidate? candidate;

  Candidate({required this.candidate, required this.fromUser});

  Map<String, dynamic> toJson() => {
        'candidate': candidate!.candidate,
        'sdpMid': candidate!.sdpMid,
        'sdpMLineIndex': candidate!.sdpMLineIndex,
        'fromUser': fromUser
      };

  Candidate.fromJson(Map<String, dynamic> data) {
    candidate = RTCIceCandidate(
        data['candidate'], data['sdpMid'], data['sdpMLineIndex']);
    fromUser = data['fromUser'];
  }
}
