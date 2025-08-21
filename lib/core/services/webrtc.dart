import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:samvaad/core/services/signaling.dart';
import 'package:samvaad/core/utils/hive_handler.dart';
import 'package:samvaad/domain/entities/call.dart';
import 'package:samvaad/domain/entities/call_log.dart';
import 'package:samvaad/domain/entities/ice_candidate.dart';
import 'package:samvaad/domain/entities/rtc_request.dart';
import 'package:samvaad/domain/entities/user.dart' as my_app;

class WebrtcService extends ChangeNotifier {
  Signaling signaling = Signaling();
  SingnalingState singnalingState = SingnalingState.idel;
  IceConnectionState iceConnectionState = IceConnectionState.idel;
  MyPeerConnectionState connectionState = MyPeerConnectionState.idel;
  RTCPeerConnection? peerConnection;
  MediaStream? localMediaStream;
  static const audioManager = MethodChannel("com.samvaad.audio_manager");
  bool isOnSpeaker = false;
  bool isOnMute = false;

  bool isOtherUserBusy = false;

  //method to get user media streams
  Future<MediaStream> getUserMedia() async {
    //specification for getting devie media stream
    Map<String, dynamic> constraints = {
      'audio': {
        'echoCancellation': true,
        'noiseSuppression': true,
        'channelCount': 2,
        'autoGainControl': true
      }
    };

    return await navigator.mediaDevices.getUserMedia(constraints);
  }

  Future<void> setAudioToEarpiece() async {
    try {
      log("setting audio to earpiece ");
      await audioManager.invokeMethod<void>("enableEarpiece");
      if (isOnSpeaker) {
        isOnSpeaker = false;
        notifyListeners();
      }
    } catch (e) {
      log("enable to set audio to earpice failed");
      log("error $e");
    }
  }

  Future<void> setAudioToSpeaker() async {
    try {
      log("setting audio to speaker ");
      await audioManager.invokeMethod<void>("enableSpeaker");
      isOnSpeaker = true;
      notifyListeners();
    } catch (e) {
      log("set to speaker failed failed");
      log("error $e");
    }
  }

  Future<void> setMuteOn() async {
    try {
      log("setting audio to mute");
      await audioManager.invokeMethod<void>("setMuteOn");
      isOnMute = true;
      notifyListeners();
    } catch (e) {
      log("mute on  failed");
      log("error $e");
    }
  }

  Future<void> setMuteOff() async {
    try {
      log("setting audio to mute off ");
      await audioManager.invokeMethod<void>("setMuteOff");
      isOnMute = false;
      notifyListeners();
    } catch (e) {
      log("mute off failed");
      log("error $e");
    }
  }

  Future<void> makeAudioCall(my_app.User toUser) async {
    try {
      //bool result = await signaling.checkIfOtherIsOnCall(toUser.phoneNo!);
      // if (result) {
      //   log("on going call");
      //   isOtherUserBusy = true;
      //   notifyListeners();
      //   return;
      // }
      signaling.updateOnGoingCall(true);
      //creating a rtc session description offer object
      Map<String, dynamic> configration = {
        'iceServers': [
          {'urls': 'stun:stun.l.google.com:19302'},
          {'urls': 'stun:stun1.l.google.com:19302'},
          {'urls': 'stun:stun2.l.google.com:19302'},
        ]
      };

      signaling.onGoingCallListener(toUser.phoneNo!, () async {
        connectionState = MyPeerConnectionState.disconnected;
        iceConnectionState = IceConnectionState.disconnected;
        singnalingState = SingnalingState.closed;
        isOtherUserBusy = true;
        notifyListeners();
      });

      peerConnection = await createPeerConnection(configration);
      localMediaStream = await getUserMedia();
      log("getting local device tracks");
      for (var track in localMediaStream!.getTracks()) {
        peerConnection!.addTrack(track, localMediaStream!);
      }
      await setAudioToEarpiece();
      final offer = await peerConnection!.createOffer();
      log("offer create");
      peerConnection!.setLocalDescription(offer);
      log("local decription set");

      await signaling.sendOffer(offer, toUser.phoneNo!);
      log("offer sent");

      peerConnection!.onIceCandidate = (candidate) async {
        await signaling.sendIceCandidates(candidate, toUser.phoneNo!);
        log("candidate sent to user ${toUser.phoneNo}");
        log("$candidate");
      };
      signaling.reciveAnswer((RtcRequestAndResult result) async {
        log("receive answer listner set");
        if (result.data != null) {
          log("answer received");

          final remoteDesc =
              RTCSessionDescription(result.data!.sdp, result.data!.type);
          await peerConnection!.setRemoteDescription(remoteDesc);
        }
      });

      signaling.receiveIceCadidates((Candidate result) async {
        log("candidate received from user ${result.fromUser}");
        // if (isRemoteSdpReceived) {
        log("setting candidate received from user ${result.fromUser}");
        await peerConnection!.addCandidate(result.candidate!);
      });

      peerConnection!.onSignalingState = (state) async {
        log("onSingnalingState invoked (0_0)");
        if (state == RTCSignalingState.RTCSignalingStateHaveLocalOffer) {
          log("signalingSate local offer created (^_^)");
          singnalingState = SingnalingState.offerSent;
        } else if (state ==
            RTCSignalingState.RTCSignalingStateHaveRemotePrAnswer) {
          singnalingState = SingnalingState.answerReceived;
        } else if (state == RTCSignalingState.RTCSignalingStateClosed) {
          singnalingState = SingnalingState.closed;
        } else if (state == RTCSignalingState.RTCSignalingStateStable) {
          log("signalingSate stable");
        }
      };

      peerConnection!.onConnectionState = (state) {
        log("peerConnection makeCall onConnectionState invoked !!(0_0)!! ");
        if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnecting) {
          connectionState = MyPeerConnectionState.connecting;
          notifyListeners();
          log("peer connection stage !!connceting!! (0_0)");
        } else if (state ==
            RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
          connectionState = MyPeerConnectionState.connected;
          notifyListeners();
          log("peer connection stage !!connected!! (^_^)");
        } else if (state ==
            RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
          connectionState = MyPeerConnectionState.disconnected;
          notifyListeners();
          log("peer connection stage !!disconnected!! (-_-)");
        } else if (state ==
            RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
          connectionState = MyPeerConnectionState.failed;
          notifyListeners();
          log("peer connection stage !!failed!! (*_*)");
        }
      };

      peerConnection!.onIceGatheringState = (state) {
        if (state == RTCIceGatheringState.RTCIceGatheringStateGathering) {
          log("Gathering ice ");
        } else if (state == RTCIceGatheringState.RTCIceGatheringStateNew) {
          log("Ice gathering state new");
        } else if (state == RTCIceGatheringState.RTCIceGatheringStateComplete) {
          log("Ice gathring complete");
        }
      };

      peerConnection!.onIceConnectionState = (state) {
        log("iceConnectionState invoked in makeCall (0_0)");

        if (state == RTCIceConnectionState.RTCIceConnectionStateChecking) {
          iceConnectionState = IceConnectionState.connecting;
          log("ice connection stage !!connceting!! (0_0)");
        } else if (state ==
            RTCIceConnectionState.RTCIceConnectionStateConnected) {
          iceConnectionState = IceConnectionState.connected;
          notifyListeners();
          log("ice connection stage !!connceted!! (^_^)");
        } else if (state ==
            RTCIceConnectionState.RTCIceConnectionStateCompleted) {
          iceConnectionState = IceConnectionState.completed;
          notifyListeners();
        } else if (state ==
            RTCIceConnectionState.RTCIceConnectionStateDisconnected) {
          iceConnectionState == IceConnectionState.disconnected;
          log("ice connection stage !!disconnceting!! (-_-)");
        } else if (state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
          iceConnectionState = IceConnectionState.failed;
          notifyListeners();
          log("ice connection stage !!failed!! (*_*)");
        } else if (state ==
            RTCIceConnectionState.RTCIceConnectionStateChecking) {
          log("checking");
        }
      };
    } on Exception catch (e) {
      log("error");
      log("$e");
    }
  }

  Future<void> receiveCall(String? fromUser, RtcRequestAndResult offer) async {
    log("receive call called");
    signaling.updateOnGoingCall(true);
    peerConnection = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
        {'urls': 'stun:stun1.l.google.com:19302'},
        {'urls': 'stun:stun2.l.google.com:19302'},
      ]
    });

    signaling.onGoingCallListener(fromUser!, () async {
      connectionState = MyPeerConnectionState.disconnected;
      iceConnectionState = IceConnectionState.disconnected;
      singnalingState = SingnalingState.closed;

      notifyListeners();
    });

    peerConnection!.onIceCandidate = (candidate) async {
      await signaling.sendIceCandidates(candidate, fromUser!);
      log("candidate sent to $fromUser");
      log("$candidate");
    };

    signaling.receiveIceCadidates((Candidate result) async {
      log("candidate received from user ${result.fromUser}");

      log("setting candidate received from user ${result.fromUser}");
      await peerConnection!.addCandidate(result.candidate!);

      log("candidate received from user ${result.fromUser} queued");
    });

    localMediaStream = await getUserMedia();
    log("local track set");
    for (var track in localMediaStream!.getTracks()) {
      peerConnection!.addTrack(track, localMediaStream!);
    }
    RTCSessionDescription offerSdp =
        RTCSessionDescription(offer.data!.sdp, offer.data!.type);

    peerConnection!.setRemoteDescription(offerSdp);
    final answer = await peerConnection!.createAnswer();
    log("local description set");
    peerConnection!.setLocalDescription(answer);
    log("answer sent");
    await signaling.giveAnswer(answer, fromUser!);

    peerConnection!.onSignalingState = (state) async {
      log("onSingnalingState invoked (0_0)");
      if (state == RTCSignalingState.RTCSignalingStateHaveLocalPrAnswer) {
        log("local answer created (^_^)");
        singnalingState = SingnalingState.offerSent;
      } else if (state == RTCSignalingState.RTCSignalingStateHaveRemoteOffer) {
        log("offer received (^_^)");

        singnalingState = SingnalingState.answerReceived;
      } else if (state == RTCSignalingState.RTCSignalingStateClosed) {
        log("connection closed (-_-)");
        singnalingState = SingnalingState.closed;
      }
    };

    peerConnection!.onConnectionState = (state) {
      log("peerConnection receive onConnectionState invoked !!(0_0)!! ");
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnecting) {
        connectionState = MyPeerConnectionState.connecting;
        notifyListeners();
        log("peer connection stage !!connceting!! (0_0)");
      } else if (state ==
          RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
        connectionState = MyPeerConnectionState.connected;
        notifyListeners();
        log("peer connection stage !!connected!! (^_^)");
      } else if (state ==
          RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
        connectionState = MyPeerConnectionState.disconnected;
        notifyListeners();
        log("peer connection stage !!disconnected!! (-_-)");
      } else if (state == RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
        connectionState = MyPeerConnectionState.failed;
        notifyListeners();
        log("peer connection stage !!failed!! (*_*)");
      }
    };

    peerConnection!.onIceConnectionState = (state) {
      log("iceConnectionState invoked in receiveing (0_0)");

      if (state == RTCIceConnectionState.RTCIceConnectionStateChecking) {
        iceConnectionState = IceConnectionState.connecting;
        log("ice connection stage !!connceting!! (0_0)");
        notifyListeners();
      } else if (state ==
          RTCIceConnectionState.RTCIceConnectionStateConnected) {
        iceConnectionState = IceConnectionState.connected;
        log("ice connection stage !!connceted!! (^_^)");
        notifyListeners();
      } else if (state ==
          RTCIceConnectionState.RTCIceConnectionStateCompleted) {
        iceConnectionState = IceConnectionState.completed;
      } else if (state ==
          RTCIceConnectionState.RTCIceConnectionStateDisconnected) {
        iceConnectionState == IceConnectionState.disconnected;
        notifyListeners();
        log("ice connection stage !!disconnceting!! (-_-)");
      } else if (state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
        iceConnectionState = IceConnectionState.failed;
        notifyListeners();
        log("ice connection stage !!failed!! (*_*)");
      }

      peerConnection!.onIceGatheringState = (state) {
        if (state == RTCIceGatheringState.RTCIceGatheringStateGathering) {
          log("Gathering ice ");
        } else if (state == RTCIceGatheringState.RTCIceGatheringStateNew) {
          log("Ice gathering state new");
        } else if (state == RTCIceGatheringState.RTCIceGatheringStateComplete) {
          log("Ice gathring complete");
        }
      };
    };
  }

  Future<void> endConnetion() async {
    if (peerConnection != null) {
      peerConnection!.onIceCandidate = null;
      peerConnection!.onSignalingState = null;
      peerConnection!.onConnectionState = null;
      peerConnection!.onIceConnectionState = null;
      peerConnection!.onIceGatheringState = null;
      signaling.removeListners();
      await peerConnection!.close();
      peerConnection = null;
      signaling.updateOnGoingCall(false);
      if (localMediaStream != null) {
        await localMediaStream!.dispose();
      }
      notifyListeners();
      log("peer conncetion closed");
    }
  }

  Future<void> addCalltoLog(Call newCall, bool answered) async {
    HiveHandler hiveHandler = HiveHandler();

    CallLog callLog =
        CallLog(callDetail: newCall.toJson(), receivedOrAnswer: answered);
    await hiveHandler.setCallLog(callLog);
  }
}

enum SingnalingState {
  idel,
  offerSent,
  answerReceived,
  stable,
  haveOffer,
  haveAnswer,
  closed
}

enum MyPeerConnectionState {
  idel,
  newConnection,
  connected,
  disconnected,
  connecting,
  failed,
  busy,
  closed,
}

enum IceConnectionState {
  idel,
  connecting,
  newIceConnection,
  connected,
  completed,
  disconnected,
  failed,
  busy,
  closed
}
