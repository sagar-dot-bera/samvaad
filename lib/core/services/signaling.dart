import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:samvaad/core/utils/current_user_singleton.dart';
import 'package:samvaad/domain/entities/ice_candidate.dart';
import 'package:samvaad/domain/entities/rtc_request.dart';
import 'package:video_compress/video_compress.dart';

class Signaling {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  StreamSubscription? _offerSubscription;
  StreamSubscription? _answerSubscription;
  StreamSubscription? _iceCandidateSubscription;
  StreamSubscription? _onGoingStreamSubscription;

  static final instance = Signaling._private();

  Signaling._private();

  factory Signaling() {
    return instance;
  }

  Future<void> sendOffer(final offer, String toUser) async {
    try {
      final toUserRef = firebaseFirestore
          .collection('call_central')
          .doc(toUser)
          .collection("offers");
      log("offer sent to user");
      RtcRequestAndResult rtcOffer =
          RtcRequestAndResult(fromUser: currentUser.phoneNumber, data: offer);

      await toUserRef.doc().set(rtcOffer.toJson());
    } on Exception catch (e) {
      log("erorr encountered ");
      log("$e");
    }
  }

  Future<void> reciveAnswer(
      Future<void> Function(RtcRequestAndResult result) onReceived) async {
    final answerRef = firebaseFirestore
        .collection('call_central')
        .doc(currentUser.phoneNumber)
        .collection("answers");
    bool isInitial = true;
    _answerSubscription = answerRef.snapshots().listen((event) {
      if (event.docChanges.isNotEmpty) {
        // if (!isInitial) {
        for (var element in event.docChanges) {
          if (element.type == DocumentChangeType.added) {
            //invoking callback function after fetching answer
            final result = RtcRequestAndResult.fromJson(element.doc.data()!);
            log("answer  received");

            onReceived(result);
          }
        }
        // } else {
        //   log("initial data skiped");
        //   isInitial = false;
        // }
      }
    });
  }

  Future<void> giveAnswer(final answer, String toUser) async {
    final toUserRef = firebaseFirestore
        .collection('call_central')
        .doc(toUser)
        .collection("answers");

    RtcRequestAndResult rtcAnswer = RtcRequestAndResult(
        fromUser: CurrentUser.instance.currentUser!.phoneNo!, data: answer);
    await toUserRef.doc().set(rtcAnswer.toJson());
  }

  Future<void> receiveOffer(
      Future<void> Function(RtcRequestAndResult result) onReceived) async {
    log("receive offer tured on");
    final answerRef = firebaseFirestore
        .collection('call_central')
        .doc(currentUser.phoneNumber)
        .collection("offers");
    bool initial = true;
    _offerSubscription = answerRef.snapshots().listen((event) {
      if (event.docChanges.isNotEmpty) {
        // if (!initial) {
        log("doc change size ${event.docChanges.length}");
        for (var element in event.docChanges) {
          if (element.type == DocumentChangeType.added) {
            log("element doc id ${element.doc.id}");
            //invoking callback function after fetching answer

            final result = RtcRequestAndResult.fromJson(element.doc.data()!);
            log("receive offer invoked sending request ${result.fromUser} with has code ${result.data}");
            onReceived(result);
          }
          // }
          //   } else {
          //     initial = false;
        }
      }
    });
  }

  Future<void> sendIceCandidates(
      RTCIceCandidate candidate, String toUser) async {
    try {
      log("sending ice candidates..(0_0)");
      final toUserRef = firebaseFirestore
          .collection("call_central")
          .doc(toUser)
          .collection('candidates');

      Candidate remoteCandidate =
          Candidate(candidate: candidate, fromUser: currentUser.phoneNumber);
      await toUserRef.doc().set(remoteCandidate.toJson());
      log("candidate sent ..(^_^)");
    } on Exception catch (e) {
      log("error");
      log(e.toString());
    }
  }

  Future<void> receiveIceCadidates(
      Future<void> Function(Candidate result) onCandidateReceived) async {
    log("receive ice candidate invoked..(0_0)");
    final answerRef = firebaseFirestore
        .collection('call_central')
        .doc(currentUser.phoneNumber)
        .collection("candidates");
    bool initial = true;
    _iceCandidateSubscription = answerRef.snapshots().listen((event) {
      if (event.docChanges.isNotEmpty) {
        if (!initial) {
          log("doc change size ${event.docChanges.length}");
          for (var element in event.docChanges) {
            if (element.type == DocumentChangeType.added) {
              //invoking callback function after fetching answer
              log("candidate received from other user invoking call back(0_0)");
              final result = Candidate.fromJson(element.doc.data()!);
              onCandidateReceived(result);
            }
          }
        } else {
          initial = false;
        }
      }
    });
  }

  void removeListners() {
    if (_offerSubscription != null) {
      _offerSubscription?.cancel();
      _offerSubscription = null;
    }

    if (_answerSubscription != null) {
      _answerSubscription?.cancel();
      _answerSubscription = null;
    }

    if (_iceCandidateSubscription != null) {
      _iceCandidateSubscription?.cancel();
      _iceCandidateSubscription = null;
    }

    if (_onGoingStreamSubscription != null) {
      _onGoingStreamSubscription?.cancel();
      _onGoingStreamSubscription = null;
    }
    clearOldCallData(FirebaseAuth.instance!.currentUser!.phoneNumber!);
    log("All Firestore listeners removed.");
  }

  Future<void> clearOldCallData(String userId) async {
    final callRef = firebaseFirestore.collection('call_central').doc(userId);

    await callRef.collection("offers").get().then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });

    await callRef.collection("answers").get().then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });

    await callRef.collection("candidates").get().then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });

    log("Old call data cleared.");
  }

  Future<void> deleteOldOffers() async {
    final callRef = firebaseFirestore
        .collection('call_central')
        .doc(CurrentUser.instance.currentUser!.phoneNo);

    await callRef.collection("offers").get().then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  Future<void> setOngoingCall(bool value) async {
    final callManagerRef = firebaseFirestore.collection("isUserBusy");

    await callManagerRef
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .set({"isConnected": false});
  }

  Future<void> updateOnGoingCall(bool value) async {
    final callManagerRef = firebaseFirestore.collection("isUserBusy");

    try {
      await callManagerRef
          .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
          .update({"isConnected": value});
    } on Exception catch (e) {
      await setOngoingCall(true);
    }
  }

  Future<bool> checkIfOtherIsOnCall(String otherUser) async {
    try {
      bool isConnected = false;
      final callManagerRef =
          firebaseFirestore.collection("isUserBusy").doc(otherUser);

      final data = await callManagerRef.get();

      if (data.exists) {
        data.data()!.forEach((e, s) {
          if (s) {
            isConnected = true;
          }
        });
      }

      return isConnected;
    } catch (e) {
      return false;
    }
  }

  Future<void> onGoingCallListener(String onUser, Function() callEnded) async {
    final callManagerRef =
        firebaseFirestore.collection("isUserBusy").doc(onUser);
    bool isFirstLoad = true;
    _onGoingStreamSubscription = callManagerRef.snapshots().listen((event) {
      log("on going call listener invoked");

      if (event.exists) {
        if (isFirstLoad != true) {
          if (event.data() != null && event.data()!.isNotEmpty) {
            event.data()!.forEach((e, s) {
              log("is available  listener invoked");

              if (s == false) {
                log("value from is on going call $e $s");
                log("on going call listener invoked");
                callEnded();
              }
            });
          }
        } else {
          isFirstLoad = false;
        }
      }
    });
  }
}
