class Participant {
  String? withUser;
  String? chatId;
  String? lastMessage;
  String? lastMessageTimeStamp;
  int? newMessageCount;
  bool? isLastMessageRead;
  String? lastMessageType;

  Participant(
      {required this.withUser,
      required this.chatId,
      required this.lastMessage,
      required this.isLastMessageRead,
      required this.lastMessageType,
      required this.lastMessageTimeStamp,
      required this.newMessageCount});

  Participant.fromJson(Map<String, dynamic> data) {
    withUser = data['withUser'];
    chatId = data['chatId'];
    lastMessage = data['lastMessage'];
    isLastMessageRead = data['isLastMessageRead'];
    lastMessageTimeStamp = data['lastMessageTimeStamp'];
    newMessageCount = data['newMessageCount'];
    lastMessageType = data['lastMessageType'];
  }

  Map<String, dynamic> toJson() => {
        'withUser': withUser,
        'chatId': chatId,
        'lastMessage': lastMessage,
        'lastMessageTimeStamp': lastMessageTimeStamp,
        'newMessageCount': newMessageCount,
        'isLastMessageRead': isLastMessageRead,
        'lastMessageType': lastMessageType
      };
}
