// ignore_for_file: must_be_immuta, camel_case_types, must_be_immutable

import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player_platform_interface.dart';
import 'package:just_audio/just_audio.dart';

import 'package:provider/provider.dart';
import 'package:samvaad/core/services/webrtc.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/app_enums.dart';
import 'package:samvaad/core/utils/audio_loader.dart';
import 'package:samvaad/domain/entities/call.dart';
import 'package:samvaad/domain/entities/call_log.dart';
import 'package:samvaad/domain/entities/rtc_request.dart';
import 'package:samvaad/presentation/viewmodels/call_manager_view_model.dart';
import 'package:samvaad/presentation/widgets/app_audio_call_rounded_button.dart';
import 'package:samvaad/presentation/widgets/app_rounded_button.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/chats/contact_message_view.dart';
import 'package:samvaad/presentation/widgets/spacing.dart';
import 'package:samvaad/router.dart';

@RoutePage()
class AudioCall extends StatefulWidget {
  Call withUser; //details about caller or callee
  RtcRequestAndResult? offerFromCaller; //used to store call offer of a caller
  AudioCall({
    super.key,
    required this.withUser,
    this.offerFromCaller,
  });

  @override
  State<AudioCall> createState() => _AudioCallState();
}

class _AudioCallState extends State<AudioCall> {
  bool isCallRecevied = false;

  @override
  void initState() {
    super.initState();
    if (widget.withUser.callType == CallType.outgoing) {
      Provider.of<WebrtcService>(context, listen: false)
          .makeAudioCall(widget.withUser.withUser!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final webrtcServiceProvider = Provider.of<WebrtcService>(context);
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Column(
          children: [
            const AppSpacingLarge(),
            const AppSpacingMedium(),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                  width: 140,
                  height: 140,
                  child: InitialLetterAvatar(
                    name: widget.withUser.withUser!.userName!,
                    radius: 30,
                  )),
            ),
            const Expanded(child: SizedBox()),
            HeadlineLargeWithOnPrimary(
                text: widget.withUser.withUser!.userName!),
            Consumer<WebrtcService>(
              builder:
                  (BuildContext context, WebrtcService value, Widget? child) {
                if (value.iceConnectionState == IceConnectionState.connected &&
                    value.connectionState == MyPeerConnectionState.connected) {
                  return BodySmallWithOnPrimary(
                    text: "Connected",
                  );
                } else if (value.iceConnectionState ==
                        IceConnectionState.failed &&
                    value.connectionState == MyPeerConnectionState.failed) {
                  return BodySmallWithOnPrimary(text: "Failed");
                } else if (value.iceConnectionState ==
                        IceConnectionState.disconnected &&
                    value.connectionState ==
                        MyPeerConnectionState.disconnected) {
                  value.endConnetion();
                  Provider.of<CallManagerViewModel>(context, listen: false)
                      .setCallLog(CallLog(
                          callDetail: widget.withUser.toJson(),
                          receivedOrAnswer: false));
                  context.router.maybePop();
                  return BodySmallWithOnPrimary(text: "End Call");
                } else if (value.isOtherUserBusy) {
                  AudioLoader.intance.audioPlayer.seek(Duration.zero, index: 0);
                  AudioLoader.intance.audioPlayer.play();

                  return BodySmallWithOnPrimary(
                    text: "Not available",
                  );
                } else {
                  return BodySmallWithOnPrimary(
                    text: "Connecting",
                  );
                }
              },
            ),
            const AppSpacingMedium(),
            widget.withUser.callType == CallType.outgoing || isCallRecevied
                ? Consumer<WebrtcService>(
                    builder: (BuildContext context, WebrtcService value,
                        Widget? child) {
                      return InCallScreenOptions(
                          onMute: value.isOnMute,
                          onSpeaker: value.isOnSpeaker,
                          onSpeakerClick: () async {
                            if (!webrtcServiceProvider.isOnSpeaker) {
                              await value.setAudioToSpeaker();
                            } else {
                              await value.setAudioToEarpiece();
                            }
                          },
                          onMuteClick: () async {
                            if (!webrtcServiceProvider.isOnMute) {
                              log("isMuteOn ${webrtcServiceProvider.isOnMute}");
                              await value.setMuteOn();
                            } else {
                              log("isMuteOn ${webrtcServiceProvider.isOnMute}");
                              await value.setMuteOff();
                            }
                          },
                          onEndCall: () async {
                            AudioLoader.intance.audioPlayer.stop();
                            await value.endConnetion();
                            await Provider.of<CallManagerViewModel>(context,
                                    listen: false)
                                .setCallLog(CallLog(
                                    callDetail: widget.withUser.toJson(),
                                    receivedOrAnswer: false));
                            context.router.maybePop();
                          });
                    },
                  )
                : OnCallReceivingScreenOptions(onCallReceive: () async {
                    final provider =
                        Provider.of<WebrtcService>(context, listen: false);
                    await provider.addCalltoLog(widget.withUser, true);
                    await FlutterRingtonePlayer().stop();
                    provider.receiveCall(widget.offerFromCaller!.fromUser,
                        widget.offerFromCaller!);
                    setState(() {
                      isCallRecevied = true;
                    });
                  }, onCutCall: () async {
                    final provider =
                        Provider.of<WebrtcService>(context, listen: false);
                    await FlutterRingtonePlayer().stop();
                    log("cut call clicked");
                    await Provider.of<CallManagerViewModel>(context,
                            listen: false)
                        .setCallLog(CallLog(
                            callDetail: widget.withUser.toJson(),
                            receivedOrAnswer: false));
                    AudioLoader.intance.audioPlayer.stop();
                    if (mounted) {
                      await Provider.of<WebrtcService>(context, listen: false)
                          .endConnetion();
                    }
                    if (mounted) {
                      context.router.maybePop();
                    }
                  }),
            const AppSpacingLarge()
          ],
        ));
  }
}

class InCallScreenOptions extends StatelessWidget {
  void Function() onMuteClick;
  void Function() onSpeakerClick;
  void Function() onEndCall;
  bool onSpeaker;
  bool onMute;

  InCallScreenOptions(
      {super.key,
      required this.onSpeaker,
      required this.onMute,
      required this.onSpeakerClick,
      required this.onMuteClick,
      required this.onEndCall});

  @override
  Widget build(BuildContext context) {
    log("InCallScreenOptions build method invoked");
    log("is Speaker  on $onSpeaker");
    log("is mute on $onMute");
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        RoundedLableButton(
            isEnabled: onSpeaker,
            buttonIcon: const Icon(FeatherIcons.volume2),
            onClick: onSpeakerClick,
            label: "Speaker",
            backgroundColor: AppColors.neutralGray,
            enabledBackgroundColor: AppColors.accentGreen),
        RoundedLableButton(
            buttonIcon: const Icon(FeatherIcons.micOff),
            onClick: onMuteClick,
            label: "Mute",
            isEnabled: onMute,
            backgroundColor: AppColors.neutralGray,
            enabledBackgroundColor: AppColors.accentGreen),
        RoundedLableButton(
            label: "End Call",
            buttonIcon: const Icon(FeatherIcons.phoneOff),
            isEnabled: false,
            onClick: onEndCall,
            backgroundColor: AppColors.accentRed),
      ],
    );
  }
}

class OnCallReceivingScreenOptions extends StatelessWidget {
  void Function() onCutCall;
  void Function() onCallReceive;
  OnCallReceivingScreenOptions(
      {super.key, required this.onCallReceive, required this.onCutCall});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        AppRoundedButton(
            buttonIcon: const Icon(FeatherIcons.phone),
            onClikc: onCallReceive,
            backgroundColor: AppColors.accentGreen),
        AppRoundedButton(
            buttonIcon: const Icon(FeatherIcons.phoneOff),
            onClikc: onCutCall,
            backgroundColor: AppColors.accentRed),
      ],
    );
  }
}

class OnCallEndScreenOption extends StatelessWidget {
  Function() callback;
  Function() sendMessage;
  OnCallEndScreenOption(
      {super.key, required this.callback, required this.sendMessage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        AppRoundedButton(
            buttonIcon: const Icon(FeatherIcons.phone),
            onClikc: callback,
            backgroundColor: AppColors.neutralGray),
        AppRoundedButton(
            buttonIcon: const Icon(FeatherIcons.messageCircle),
            onClikc: sendMessage,
            backgroundColor: AppColors.neutralGray),
      ],
    );
  }
}
