import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:samvaad/core/utils/size.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/presentation/screens/message_screens/messages_screen.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/chats/chat_mask_choose.dart';

@RoutePage()
class MarkedMessageScreen extends StatefulWidget {
  const MarkedMessageScreen({super.key, required this.markedMessage});
  final Map<String, dynamic> markedMessage;
  @override
  State<MarkedMessageScreen> createState() => _MarkedMessageScreenState();
}

class _MarkedMessageScreenState extends State<MarkedMessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: HeadlineMedium(text: "Marked message"),
      ),
      body: SizedBox(
          child: Padding(
        padding: EdgeInsets.all(SizeOf.intance.getWidth(context, 0.05)),
        child: ListView.builder(
          itemBuilder: (context, index) {
            if (widget.markedMessage.isNotEmpty) {
              Map<dynamic, dynamic> messageData =
                  widget.markedMessage.entries.elementAt(index).value;
              final message =
                  Message.fromJson(messageData.map((k, v) => MapEntry(k, v)));
              log("marked message from marked message screen ${message.toJson()}");
              return Padding(
                padding: EdgeInsets.only(
                    bottom: SizeOf.intance.getHight(context, 0.01)),
                child: ChatMaskChooser(
                  message: message,
                  isGroupChat: true,
                  isMarkedMessage: true,
                ),
              );
            } else {
              return Center(
                  child: LoadSvgImage(
                imageAsset: "lib/assets/image/No_data_bro.svg",
                text: "No data found",
              ));
            }
          },
          itemCount: widget.markedMessage.length,
        ),
      )),
    );
  }
}
