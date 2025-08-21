import 'package:samvaad/domain/entities/message.dart';

class MessageWithChatid {
  Message? message;
  String? chatId;

  MessageWithChatid({required this.message, required this.chatId});

  MessageWithChatid.fromJson(Map<String, dynamic> data) {
    message = Message.fromJson(data['message']);
    chatId = data['chatId'];
  }

  Map<String, dynamic> toJson() =>
      {'message': message!.toJson(), 'chatId': chatId};
}
