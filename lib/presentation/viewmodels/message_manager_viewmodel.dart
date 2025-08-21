import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samvaad/core/utils/menu.dart';
import 'package:samvaad/core/utils/user_records.dart';
import 'package:samvaad/domain/entities/participant.dart';
import 'package:samvaad/domain/use_case/message_manager_user_case.dart';
import 'package:samvaad/domain/entities/group.dart' as my_app;

class MessageManagerViewModel extends ChangeNotifier {
  MessageManagerUserCase messageManagerUserCase;

  MessageManagerViewModel({required this.messageManagerUserCase});

  Map<String, String> _selectedItem = {};
  Map<String, String> get selectedItem => _selectedItem;
  Map<String, String> popupMenuMap = {};

  bool isSelectedOnlyTypeOf(String typeOf) {
    //check if selected item is only type of participant
    if (typeOf == "participant") {
      return !selectedItem.values.contains("group") &&
          _selectedItem.values.isNotEmpty;
    } else if (typeOf == "group") {
      return !selectedItem.values.contains("participant") &&
          _selectedItem.values.isNotEmpty;
    } else {
      return false;
    }
  }

  Future<void> deleteChat() async {
    log("delete chat invoked");
    await UserRecord.instance.addToDeteledRecord(_selectedItem.keys.toList());
    _selectedItem.forEach((k, v) {
      messageManagerUserCase.deleteChatUseCase(k, v);
    });
    selectedItem.clear();
    notifyListeners();
  }

  Future<void> addToPriyaSuchi() async {
    await UserRecord.instance.addToPriyasuchi(_selectedItem);
    selectedItem.clear();
    notifyListeners();
  }

  Future<void> addBlockedUser() async {
    await UserRecord.instance.addToBlockList(_selectedItem);
    _selectedItem.forEach((k, v) {
      messageManagerUserCase.blockUserUseCase(k);
    });
    selectedItem.clear();
    notifyListeners();
  }

  Future<void> ublockUser(List<String> ids) async {
    await UserRecord.instance.removeFromBlockList(ids);
    selectedItem.clear();
    notifyListeners();
  }

  void addToSelectedItem(Object item) {
    log("add to selected invoked");
    if (item is Participant) {
      if (!_selectedItem.containsKey(item.chatId)) {
        _selectedItem = {..._selectedItem, item.chatId!: "participant"};
        notifyListeners();
      }
    } else if (item is my_app.Group) {
      if (!_selectedItem.containsKey(item.chatId)) {
        _selectedItem = {..._selectedItem, item.chatId: "group"};
        notifyListeners();
      }
    } else {
      log("unknown type");
    }
  }

  Future<void> exitGroup() async {
    _selectedItem.forEach((k, v) async {
      await messageManagerUserCase.exitGroupUseCase(k);
    });
  }

  void navigateToGroupDetail() {
    if (selectedItem.length == 1) {}
  }

  void removeFromSelected(Object item) {
    if (item is Participant) {
      _selectedItem = Map.from(_selectedItem)..remove(item.chatId);
    } else if (item is my_app.Group) {
      _selectedItem = Map.from(_selectedItem)..remove(item.chatId);
    } else {
      log("unknown type");
    }
    notifyListeners();
  }

  bool checkIfSingleChat(Object item) {
    return item is Participant;
  }

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

  List<String> popUpListContent() {
    log("get popup list content invoked");
    if (isSelectedOnlyTypeOf("participant")) {
      log("is only participant ${_selectedItem.entries}");
      if (_selectedItem.length == 1) {
        popupMenuMap = Menu.intance.singleChatSelectedMenu;
        return Menu.intance.singleChatSelectedMenu.keys.toList();
      } else {
        popupMenuMap = Menu.intance.multipleSingleChatSelectedMenu;
        return Menu.intance.multipleSingleChatSelectedMenu.keys.toList();
      }
    } else if (isSelectedOnlyTypeOf("group")) {
      log("only group");
      if (_selectedItem.length == 1) {
        popupMenuMap = Menu.intance.groupChatSelectedMenu;
        return Menu.intance.groupChatSelectedMenu.keys.toList();
      } else {
        popupMenuMap = Menu.intance.multipleGroupChatSelectedMenu;
        return Menu.intance.multipleGroupChatSelectedMenu.keys.toList();
      }
    } else if (_selectedItem.isEmpty) {
      popupMenuMap = Menu.intance.messageScreenMenu;
      return Menu.intance.messageScreenMenu.keys.toList();
    } else {
      popupMenuMap = Menu.intance.bothChatAndGroupSelectedMenu;
      return Menu.intance.bothChatAndGroupSelectedMenu.keys.toList();
    }
  }
}
