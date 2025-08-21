import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 3)
class Message implements Comparable<Message> {
  @HiveField(0)
  String? sender;
  @HiveField(1)
  List<String>? receiver;
  @HiveField(2)
  String? timeStamp;
  @HiveField(3)
  String? contentType;
  @HiveField(4)
  String? content;
  @HiveField(5)
  String? messageStatus;
  @HiveField(6)
  String? messageId;
  @HiveField(7)
  Map<dynamic, dynamic>? readBy;
  @HiveField(8)
  List<String>? messageNotVisible;
  @HiveField(9)
  ExtraInfo? extraInfo;
  @HiveField(10)
  String? quotedMessageId;
  @HiveField(11)
  String? senderName;

  Message(
      {required this.sender,
      required this.receiver,
      required this.messageId,
      required this.timeStamp,
      required this.contentType,
      required this.content,
      required this.readBy,
      required this.messageStatus,
      required this.messageNotVisible,
      required this.extraInfo,
      this.quotedMessageId,
      this.senderName = ""});

  Message.fromJson(Map<String, dynamic> data) {
    sender = data['sender'];
    receiver =
        (data['receiver'] as List<dynamic>).map((e) => e.toString()).toList() ??
            [];
    timeStamp = data['timeStamp'];
    contentType = data['contentType'];
    content = data['content'];
    messageStatus = data['messageStatus'];
    messageId = data['messageId'];
    messageNotVisible = (data['messageVisibility'] as List<dynamic>)
            .map((e) => e.toString())
            .toList() ??
        [];
    readBy = data['readBy'];
    extraInfo = ExtraInfo.fromJson(data["extraInfo"]);
    quotedMessageId = data["quotedMessageId"] ?? "";
    senderName = data["senderName"] ?? "";
  }

  set setStatus(String status) {
    messageStatus = status;
  }

  set setContent(String data) {
    content = data;
  }

  set setMessagid(String id) {
    messageId = id;
  }

  @override
  int get hashCode => messageId.hashCode;

  set setQuotedMessage(String id) {
    quotedMessageId = id;
  }

  Map<String, dynamic> toJson() => {
        'sender': sender,
        'messageId': messageId,
        'receiver': receiver,
        'timeStamp': timeStamp,
        'contentType': contentType,
        'content': content,
        'readBy': readBy,
        'messageStatus': messageStatus,
        'messageVisibility': messageNotVisible,
        'extraInfo': extraInfo!.toJson(),
        'quotedMessageId': quotedMessageId,
        'senderName': senderName
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Message) return false;
    return messageId == other.messageId;
  }

  String enumToString(MessageStatus messageStatus) {
    return messageStatus.toString().split('.').last;
  }

  MessageStatus stringToEnum(String enumValue) {
    return MessageStatus.values.firstWhere((element) {
      return element.name == enumValue;
    });
  }

  @override
  int compareTo(Message other) {
    final currentDate = DateTime.parse(timeStamp!);
    final otherDate = DateTime.parse(other.timeStamp!);

    return currentDate.compareTo(otherDate);
  }

  bool checkIfMessageAreSame(Message otherMessage) {
    if (messageStatus == otherMessage.messageStatus &&
        readByCompare(otherMessage.readBy!, readBy!)) {
      return true;
    } else {
      return false;
    }
  }

  bool readByCompare(
      Map<dynamic, dynamic> firstReadBy, Map<dynamic, dynamic> secondReadBy) {
    bool isSame = true;

    for (var element in firstReadBy.keys) {
      if (secondReadBy.containsKey(element)) {
        isSame = secondReadBy[element] == firstReadBy[element];

        if (!isSame) {
          return isSame;
        }
      }
    }

    return isSame;
  }
}

//message visibility class
@HiveType(typeId: 4)
class MessageVisibility {
  @HiveField(0)
  bool? senderVisibility;
  @HiveField(1)
  bool? receiverVisibility;

  MessageVisibility(
      {this.senderVisibility = true, this.receiverVisibility = true});

  MessageVisibility.fromJson(Map<dynamic, dynamic> data) {
    senderVisibility = data['senderVisibility'];
    receiverVisibility = data['receiverVisibility'];
  }

  Map<String, dynamic> toJson() => {
        'senderVisibility': senderVisibility,
        'receiverVisibility': receiverVisibility
      };
}

@HiveType(typeId: 77)
class ExtraInfo {
  @HiveField(0)
  String? caption;
  @HiveField(1)
  int? width;
  @HiveField(2)
  int? height;
  @HiveField(3)
  String? fileName;
  @HiveField(4)
  String? thumbnail;

  ExtraInfo(
      {this.caption = "NaN",
      this.width = 0,
      this.height = 0,
      this.fileName = "NaN",
      this.thumbnail = "NaN"});

  Map<String, dynamic> toJson() => {
        "caption": caption,
        "width": width.toString(),
        "height": height.toString(),
        "fileName": fileName.toString(),
        "thumbnail": thumbnail
      };

  ExtraInfo.fromJson(Map<dynamic, dynamic> data) {
    caption = data["caption"];
    width = int.tryParse(data["width"]);
    height = int.tryParse(data['height']);
    fileName = data["fileName"];
    thumbnail = data["thumbnail"];
  }
}

enum MessageStatus { sent, pending }
