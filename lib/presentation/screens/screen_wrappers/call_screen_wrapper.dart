// ignore_for_file: camel_case_types

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/core/services/webrtc.dart';
import 'package:samvaad/data/repositories_impl/call_manager_repository_impl.dart';
import 'package:samvaad/domain/entities/call.dart';
import 'package:samvaad/domain/entities/rtc_request.dart';
import 'package:samvaad/domain/use_case/call_manager_use_case.dart';
import 'package:samvaad/presentation/screens/call_screens/audio_call_screen.dart';
import 'package:samvaad/presentation/viewmodels/call_manager_view_model.dart';

// ignore: must_be_immutable

// ignore: must_be_immutable
@RoutePage()
class AudioCallWrapperScreen extends StatelessWidget
    implements AutoRouteWrapper {
  Call withUser;
  RtcRequestAndResult? offerFromCaller;
  AudioCallWrapperScreen(
      {super.key, required this.withUser, this.offerFromCaller});

  @override
  Widget build(BuildContext context) {
    if (offerFromCaller != null) {
      return AudioCall(withUser: withUser, offerFromCaller: offerFromCaller);
    } else {
      return AudioCall(withUser: withUser);
    }
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WebrtcService()),
        ChangeNotifierProvider(
            create: (context) => CallManagerViewModel(
                callManagerUseCase: CallManagerUseCase(
                    callManagerRepository: CallManagerRepositoryImpl())))
      ],
      child: this,
    );
  }
}
