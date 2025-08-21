// ignore_for_file: must_be_immutable

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/domain/entities/participant.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/presentation/screens/message_screens/single_chat_screen.dart';
import 'package:samvaad/presentation/viewmodels/chat_handler_view_model.dart';
import 'package:samvaad/presentation/viewmodels/single_chat_message_handler.dart';

@RoutePage()
class SingelChatScreenWrapperScreen extends StatelessWidget
    implements AutoRouteWrapper {
  User userWithDetails;
  Participant? participantDetail;
  SingelChatScreenWrapperScreen(
      {super.key, required this.userWithDetails, this.participantDetail});

  @override
  Widget build(BuildContext context) {
    return ChatScreen();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return ChangeNotifierProvider<ChatHandlerViewModel>(
      create: (context) => SingleChatMessageHandler(
        chatWithUserDetails: userWithDetails,
        participant: participantDetail,
      ),
      child: this,
    );
  }
}
