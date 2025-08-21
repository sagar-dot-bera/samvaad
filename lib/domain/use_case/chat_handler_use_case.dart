import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:samvaad/data/datasources/local/fetch_user_data_from_local.dart';
import 'package:samvaad/data/datasources/remote/fetch_user_data_from_firebase.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/domain/entities/participant.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/domain/repositories/message_handler_repository.dart';

class MessageHandlerUseCase {
  ChantHandlerRepository messageHandlerRepository;
  FetchUserDataFromLocal fetchUserDataFromLocal = FetchUserDataFromLocal();
  FetchUserDataFromFirebase fetchUserDataFromFirebase =
      FetchUserDataFromFirebase(firebaseFirestore: FirebaseFirestore.instance);

  MessageHandlerUseCase({required this.messageHandlerRepository});

  //call to getMessage method to messageHandler repository
  Stream<Message> executeFetchMessage(String chatId) {
    return messageHandlerRepository.getMessage(chatId);
  }

  Stream<Message> executeFetchFailedMessage(String chatId) {
    return fetchUserDataFromLocal.getFailedMessages(chatId);
  }

  //call to sendMessage of messageHandler repository
  Future<void> callSendMessage(Message message, String chatId) async {
    await messageHandlerRepository.sendMessage(message, chatId);
  }

  //call to addParticipant of messageHandler repository
  Future<void> callToaddParticipant(Participant participant) async {
    await messageHandlerRepository.setParticipant(participant);
  }

  //call to getParticipant of messageHandler repository
  Future<Participant?> callToGetParticipant(String phoneNo) async {
    return await messageHandlerRepository.getParticipant(phoneNo);
  }

  //call to batchReadMessage in messageHandler repository
  Future<void> execReadMessage(
      List<Message> unReadedMessage, String chatId, String userId) async {
    await messageHandlerRepository.markAllMessageRead(
        unReadedMessage, chatId, userId);
  }

  Future<void> exceCheckUserStatus(
      String ofUser, void Function(User userDetails) result) async {
    await messageHandlerRepository.getUserStatus(ofUser, result);
  }

  Stream<Message> excePendingMsg(String chatId) {
    return messageHandlerRepository.pendingMessages(chatId);
  }

  Future<void> clearChatUseCase(String id) async {
    await messageHandlerRepository.clearChat(id);
  }

  Future<void> deleteMessageUseCase(
      List<String> messageId, String chatId, bool isSoftDelete) async {
    await messageHandlerRepository.removeMessage(
        messageId, chatId, isSoftDelete);
  }

  Future<void> updateLastMessage(
      String messageData, bool isGroup, String id, String timeStamp) async {
    await messageHandlerRepository.updateLastMessage(
        messageData, isGroup, id, timeStamp);
  }

  Future<Participant?> checkIfParticipantExit(String withUser) async {
    return await fetchUserDataFromFirebase.checkIfParticipantExit(withUser);
  }
}
