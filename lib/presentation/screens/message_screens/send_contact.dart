import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:remixicon/remixicon.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/presentation/viewmodels/chat_handler_view_model.dart';
import 'package:samvaad/presentation/widgets/app_share_contact_cell.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';

@RoutePage()
class SendContactScreen extends StatefulWidget {
  List<Contact> selectedContactList;
  ChatHandlerViewModel messageHandlerViewModel;

  SendContactScreen(
      {super.key,
      required this.selectedContactList,
      required this.messageHandlerViewModel});

  @override
  State<SendContactScreen> createState() => _SendContactScreenState();
}

class _SendContactScreenState extends State<SendContactScreen> {
  String contactToJson(Contact contact) {
    String contactJson =
        '{"name":"${contact.fullName}","phoneNumber":"${contact.phoneNumbers!.first}"}';
    return contactJson;
  }

  ValueNotifier<Set<int>> selectedIndex = ValueNotifier<Set<int>>({});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeadlineMedium(text: "Share contact"),
        actions: [
          ValueListenableBuilder(
              valueListenable: selectedIndex,
              builder: (context, value, child) {
                return value.isNotEmpty
                    ? IconButton(
                        onPressed: () async {
                          if (selectedIndex.value.length ==
                              widget.selectedContactList.length) {
                            widget.selectedContactList.clear();
                            await context.router.maybePop();
                          }
                          setState(() {
                            if (widget.selectedContactList.isNotEmpty &&
                                widget.selectedContactList.length <
                                    selectedIndex.value.length) {
                              for (var element in value) {
                                widget.selectedContactList.removeAt(element);
                              }
                              selectedIndex.value = {};
                            }
                          });
                        },
                        icon: Icon(Remix.delete_bin_2_line))
                    : SizedBox.shrink();
              })
        ],
      ),
      body: Column(
        children: [
          ValueListenableBuilder(
              valueListenable: selectedIndex,
              builder: (context, value, child) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onLongPress: () {
                        if (value.isEmpty) {
                          log("item added");
                          value.add(index);
                          final updated = {...value, index};
                          selectedIndex.value = updated;
                        }
                      },
                      onTap: () {
                        if (value.isNotEmpty) {
                          if (value.contains(index)) {
                            value.remove(index);
                            final updated = {...value};
                            selectedIndex.value = updated;
                          } else {
                            value.add(index);
                            final updated = {...value, index};
                            selectedIndex.value = updated;
                          }
                        }
                      },
                      child: Stack(
                        children: [
                          ShareContactCell(
                            contact: widget.selectedContactList[index],
                          ),
                          selectedIndex.value.contains(index)
                              ? Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.accentGreen
                                            .withValues(alpha: 0.2)),
                                  ),
                                )
                              : SizedBox.shrink()
                        ],
                      ),
                    );
                  },
                  itemCount: widget.selectedContactList.length,
                );
              }),
          Expanded(child: SizedBox()),
          Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FloatingActionButton.extended(
                    elevation: 0.0,
                    onPressed: () async {
                      List<String> encodedContacts = List.empty(growable: true);

                      for (var element in widget.selectedContactList) {
                        String encodedData = contactToJson(element);

                        encodedContacts.add(encodedData);
                      }

                      for (String contact in encodedContacts) {
                        final message = await widget.messageHandlerViewModel
                            .messageCreator(
                                contact, "contact", 'sent', ExtraInfo());
                        await widget.messageHandlerViewModel
                            .sendMessage(message);
                        log("Message sent");
                      }
                      context.router.maybePop();
                    },
                    icon: Icon(FeatherIcons.send),
                    label: Text(
                      "Send",
                      style: TextStyle(fontSize: 16.0),
                    )),
              ))
        ],
      ),
    );
  }
}
