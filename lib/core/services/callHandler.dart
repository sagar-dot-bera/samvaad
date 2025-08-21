import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:samvaad/core/services/rington_plyer.dart';
import 'package:samvaad/core/services/signaling.dart';
import 'package:samvaad/core/utils/app_enums.dart';
import 'package:samvaad/core/utils/user_details_helper.dart';
import 'package:samvaad/domain/entities/call.dart';
import 'package:samvaad/domain/entities/rtc_request.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/router.dart';
import 'package:samvaad/router.gr.dart';

class CallHandler {
  Signaling signaling = Signaling();

  static final instance = CallHandler._private();
  bool isListnerSet = false;
  CallHandler._private();

  factory CallHandler() {
    return instance;
  }

  void initializeCall() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //reference to signaling class to  hadle incoming calles
      //receiver to handle incoming call
      if (isListnerSet) return;
      isListnerSet = true;
      signaling.receiveOffer((RtcRequestAndResult result) async {
        log("receiving offer");
        UserDetailsHelper getUserDetailsHelper =
            UserDetailsHelper(); //get caller details

        User callerUserDetails =
            await getUserDetailsHelper.getSingleUser(result.fromUser!);
        bool isOngoingCall = false;
        Call caller = Call(
            withUser: callerUserDetails,
            callType: CallType.incoming,
            timeStamp: DateTime.now().toString());
        log("launching receive call screen");
        if (!isOngoingCall) {
          isOngoingCall = true;
          log("is on going call");
          RingtonPlayer.intance.startPlaying();
          navigatorKey.currentContext!
              .pushRoute(AudioCallWrapperRoute(
                  withUser: caller, offerFromCaller: result))
              .then((date) {
            log("setting isOngoing to false");
            isOngoingCall = false;
          });
        }
      });
    });
  }
}
