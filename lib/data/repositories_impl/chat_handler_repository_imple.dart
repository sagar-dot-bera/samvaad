import 'dart:async';

import 'package:flutter_contacts/properties/group.dart';
import 'package:rxdart/rxdart.dart';
import 'package:samvaad/core/utils/user_records.dart';
import 'package:samvaad/data/datasources/local/fetch_user_data_from_local.dart';
import 'package:samvaad/data/datasources/remote/fetch_user_data_from_firebase.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/domain/entities/participant.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/domain/entities/group.dart' as app_group;

import 'package:samvaad/domain/repositories/message_handler_repository.dart';

class MessageHandlerRepositoryImpl extends ChantHandlerRepository {
  FetchUserDataFromFirebase fetchUserDataFromFirebase;
  FetchUserDataFromLocal fetchUserDataFromLocal;

  MessageHandlerRepositoryImpl(
      {required this.fetchUserDataFromFirebase,
      required this.fetchUserDataFromLocal});

  @override
  Future<void> sendMessage(Message message, String chatId) async {
    await fetchUserDataFromFirebase.sendMessage(message, chatId);
  }

  @override
  Future<Participant?> getParticipant(String phoneNo) async {
    return await fetchUserDataFromFirebase.fetchSingleParticipent(phoneNo);
  }

  @override
  Future<void> setParticipant(Participant newParticipant) async {
    return await fetchUserDataFromFirebase.addParticipant(newParticipant);
  }

  @override
  Future<void> markAllMessageRead(
      List<Message> unreadedMessages, String chatId, String userId) {
    return fetchUserDataFromFirebase.batchReadUpdate(
        unreadedMessages, chatId, userId);
  }

  @override
  Future<void> getUserStatus(
      String ofUser, void Function(User userDetail) result) async {
    return await fetchUserDataFromFirebase.checkStatus(ofUser, result);
  }

  @override
  Future<void> addGroup(app_group.Group newGroup) async {
    await fetchUserDataFromFirebase.addGroup(newGroup);
  }

  @override
  Stream<Message> getMessage(String chatId) {
    return fetchUserDataFromFirebase.fetchMessage(chatId);
  }

  @override
  Stream<Message> pendingMessages(String chatId) {
    return fetchUserDataFromLocal.getPendingMessages(chatId);
  }

  @override
  Future<void> clearChat(String id) async {
    await UserRecord.instance.addToDeteledRecord([id]);
  }

  @override
  Future<void> removeMessage(
      List<String> messageIds, String chatId, bool isSoftDelete) async {
    await fetchUserDataFromFirebase.deleteMessage(
        isSoftDelete, messageIds, chatId);
  }

  @override
  Future<void> muteNotification(String user) async {
    await muteNotification(user);
  }

  @override
  Future<void> updateLastMessage(
      String messageData, bool isGroup, String id, String timeStamp) async {
    await fetchUserDataFromFirebase.updateLastMessage(
        messageData, isGroup, id, timeStamp);
  }
}
