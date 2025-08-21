// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/size.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/main.dart';
import 'package:samvaad/presentation/viewmodels/chat_handler_view_model.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/audio_file_view.dart';
import 'package:samvaad/router.dart';

@RoutePage()
class SendAudioScreen extends StatefulWidget {
  List<File> audioFiles = List.empty(growable: true);
  ChatHandlerViewModel messageHandlerViewModel;

  SendAudioScreen(
      {super.key,
      required this.audioFiles,
      required this.messageHandlerViewModel});

  @override
  State<SendAudioScreen> createState() => _SendAudioScreenState();
}

class _SendAudioScreenState extends State<SendAudioScreen> {
  Future<void> sendAudioMessage(List<File> audioFile) async {
    for (var element in audioFile) {
      widget.messageHandlerViewModel
          .sendMessageWithFile(element, "audio", ExtraInfo());
    }
  }

  ValueNotifier<Set<int>> selectedIndex = ValueNotifier<Set<int>>({});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeadlineMedium(text: "Share audio"),
        actions: [
          ValueListenableBuilder(
            valueListenable: selectedIndex,
            builder: (context, value, child) {
              return value.isNotEmpty
                  ? IconButton(
                      onPressed: () async {
                        if (selectedIndex.value.length ==
                            widget.audioFiles.length) {
                          widget.audioFiles.clear();
                          await context.router.maybePop();
                        }
                        setState(() {
                          for (var element in value) {
                            widget.audioFiles.removeAt(element);
                          }
                          selectedIndex.value = {};
                        });
                      },
                      icon: Icon(Remix.delete_bin_2_line))
                  : SizedBox.shrink();
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeOf.intance.getWidth(context, 0.03)),
        child: Column(
          children: [
            ValueListenableBuilder(
                valueListenable: selectedIndex,
                builder: (context, value, child) {
                  log("rebuild ");
                  return Expanded(
                      child: ListView.builder(
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
                            AudioFileView(
                              audioFile: widget.audioFiles[index],
                              sliderWidth:
                                  SizeOf.intance.getWidth(context, 0.75),
                            ),
                            value.contains(index)
                                ? Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: AppColors.accentGreen
                                              .withValues(alpha: 0.2)),
                                    ),
                                  )
                                : SizedBox.shrink()
                          ],
                        ),
                      );
                    },
                    itemCount: widget.audioFiles.length,
                  ));
                }),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 20.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton.extended(
                    elevation: 0.0,
                    onPressed: () {
                      sendAudioMessage(widget.audioFiles);
                      context.maybePop();
                    },
                    label: Text(
                      "Send",
                      style: TextStyle(fontSize: 16.0),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
