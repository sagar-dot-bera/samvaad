import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nanoid/async.dart';
import 'package:rxdart/rxdart.dart';
import 'package:samvaad/core/utils/current_user_singleton.dart';
import 'package:samvaad/domain/entities/group.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/presentation/viewmodels/chat_handler_view_model.dart';

class GroupChatMessageHandler extends ChatHandlerViewModel {
  Group chatWithGroup;

  GroupChatMessageHandler({required this.chatWithGroup});

  @override
  Future<Message> messageCreator(String content, String contentType,
      String msgStatus, ExtraInfo extraInfo) async {
    String messageId = await nanoid();
    return Message(
        sender: currentUserDetails.phoneNumber,
        receiver: chatWithGroup.member.map((e) => e.memberId!).toList(),
        messageId: messageId,
        timeStamp: DateTime.now().toIso8601String(),
        contentType: contentType,
        content: content,
        messageStatus: msgStatus,
        senderName: CurrentUser.instance.currentUser!.userName,
        extraInfo: extraInfo,
        readBy: readByMap(chatWithGroup.member),
        messageNotVisible: []);
  }

  Map<String, dynamic> readByMap(List<GroupMember> members) {
    Map<String, dynamic> memberReadByMap = {};

    for (var element in members) {
      memberReadByMap[element.memberId!] = true;
    }

    log(memberReadByMap.toString());
    return memberReadByMap;
  }

  String receiverJsonString(List<String> members) {
    StringBuffer memberJson = StringBuffer();
    memberJson.write('{');

    for (var element in members) {
      memberJson.write('"$element",');
    }
    memberJson.write('}');
    log(memberJson.toString());

    return memberJson.toString();
  }

  @override
  String getChatId() {
    return chatWithGroup.chatId;
  }

  @override
  Stream<Message> getMessageStream() {
    return messageHandlerUseCase.executeFetchMessage(chatWithGroup.chatId);
  }

  @override
  bool isGroup() {
    return true;
  }
}
