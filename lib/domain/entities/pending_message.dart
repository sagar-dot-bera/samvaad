import 'package:hive/hive.dart';
import 'package:samvaad/domain/entities/message.dart';
part 'pending_message.g.dart';

@HiveType(typeId: 11)
class PendingMessage {
  @HiveField(0)
  Message message;
  @HiveField(1)
  String chatid;

  PendingMessage({required this.message, required this.chatid});
}
