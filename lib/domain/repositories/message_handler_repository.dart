import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/domain/entities/participant.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/domain/entities/group.dart' as app_group;

//repository to manage task related to message
abstract class ChantHandlerRepository {
  //method to fetch message from firebase
  Stream<Message> getMessage(String chatId);
  //method to send message
  Future<void> sendMessage(Message message, String chatId);

  //method to fetch single participant
  Future<Participant?> getParticipant(String phoneNo);
  //method to add participant
  Future<void> setParticipant(Participant newParticipant);

  //method to to mark unreaded message to read
  Future<void> markAllMessageRead(
      List<Message> unreadedMessages, String chatId, String userId);

  Future<void> getUserStatus(
      String ofUser, void Function(User userDetails) result);

  Future<void> addGroup(app_group.Group newGroup);

  Stream<Message> pendingMessages(String chatId);

  Future<void> clearChat(String id);
  Future<void> removeMessage(
      List<String> messageIds, String chatId, bool isSoftDelete);
  Future<void> muteNotification(String user);

  Future<void> updateLastMessage(
      String messageData, bool isGroup, String id, String timeStamp);
}
