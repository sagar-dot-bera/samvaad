import 'package:hive/hive.dart';
import 'package:samvaad/domain/entities/message.dart';

part 'failed_message.g.dart';

@HiveType(typeId: 44)
class FailedMessage {
  @HiveField(0)
  Message message;
  @HiveType(typeId: 1)
  String chatReference;

  FailedMessage({required this.message, required this.chatReference});
}
