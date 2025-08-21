import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Menu {
  static final intance = Menu._private();

  Menu._private();

  factory Menu() {
    return intance;
  }

  Map<String, String> messageScreenMenu = {
    "New contact": "newContact",
    "New group": "newGroup",
    "Marked message": "markedMessage"
  };

  Map<String, String> singleChatSelectedMenu = {
    "Delete": "delete",
    "Block user": "block",
    "User info": "info",
    "Add to priyasuchi": "addToPriyasuchi"
  };

  Map<String, String> groupChatSelectedMenu = {
    "Groupe info": "groupInfo",
    "Exit group": "exitGroup",
    "Delete": "delete",
    "Add to priyasuchi": "addToPriyasuchi"
  };

  List<String> callLogMenu = ["Clear call log"];

  Map<String, String> bothChatAndGroupSelectedMenu = {
    "Delete": "delete",
    "Add to priyasuchi": "addToPriyasuchi"
  };
  Map<String, String> multipleSingleChatSelectedMenu = {
    "Delete": "delete",
    "Block user": "block",
    "Add to priyasuchi": "addToPriyasuchi"
  };
  Map<String, String> multipleGroupChatSelectedMenu = {
    "Delete": "delete",
    "Block group": "block",
    "Add to priyasuchi": "addToPriyasuchi"
  };
  Map<String, String> singlechatScreenMenu = {
    "add to contact": "newContact",
    "Clear chat": "clearChat"
  };
  Map<String, String> groupChatScreenMenu = {
    "Clear chat": "clearChat",
    "Group info": "groupInfo"
  };

  List<PopupMenuEntry<String>> getPopUpList(List<String> values) {
    List<PopupMenuEntry<String>> items = List.empty(growable: true);

    for (var element in values) {
      items.add(PopupMenuItem(
          value: element,
          child: Text(
            element,
            style: GoogleFonts.ebGaramond(),
          )));
    }

    return items;
  }
}
