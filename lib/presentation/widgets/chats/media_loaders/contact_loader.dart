import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:samvaad/core/utils/app_enums.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/presentation/widgets/chats/contact_message_view.dart';
import 'package:samvaad/presentation/widgets/chats/file_loader/image_view.dart';

import 'package:samvaad/presentation/widgets/chats/media_loaders/media_loader_widget.dart';

class ContactLoader extends StatelessWidget {
  Message message;
  ContactLoader({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return ContactMessageViewer(message: message);
  }
}
