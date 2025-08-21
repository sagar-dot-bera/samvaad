import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/core/utils/message_with_chatid.dart';
import 'package:samvaad/domain/entities/group.dart';
import 'package:samvaad/presentation/screens/message_screens/group_chat_screen.dart';
import 'package:samvaad/presentation/viewmodels/group_chat_message_handler.dart';
import 'package:samvaad/presentation/viewmodels/chat_handler_view_model.dart';

@RoutePage()
// ignore: must_be_immutable
class GroupChatChangeNotifierWrapperScreen extends StatelessWidget
    implements AutoRouteWrapper {
  Group chatWithGroup;
  GroupChatChangeNotifierWrapperScreen(
      {super.key, required this.chatWithGroup});

  @override
  Widget build(BuildContext context) {
    return GroupChatScreen();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return ChangeNotifierProvider<ChatHandlerViewModel>(
      create: (context) =>
          GroupChatMessageHandler(chatWithGroup: chatWithGroup),
      child: this,
    );
  }
}
