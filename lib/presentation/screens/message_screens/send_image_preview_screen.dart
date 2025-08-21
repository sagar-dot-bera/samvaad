// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:remixicon/remixicon.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/compress.dart';
import 'package:samvaad/core/utils/hive_handler.dart';
import 'package:samvaad/data/datasources/remote/upload_profile_data_to_firebase.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/main.dart';
import 'package:samvaad/presentation/viewmodels/chat_handler_view_model.dart';
import 'package:samvaad/presentation/widgets/spacing.dart';
import 'package:samvaad/router.dart';

@RoutePage()
// ignore: must_be_immutable
class ImagePreviewScreen extends StatefulWidget {
  List<File> images;
  ChatHandlerViewModel messageHandlerViewModel;
  HiveHandler hiveHandler = HiveHandler();

  ImagePreviewScreen(
      {super.key, required this.images, required this.messageHandlerViewModel});

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  final _key = GlobalKey<FormState>();
  Compress compress = Compress();

  TextEditingController capitionTextControler = TextEditingController();
  FocusNode capitionTextFocusNode = FocusNode();
  HandelProfileDataToFirebase uploadProfileDataToFirebase =
      HandelProfileDataToFirebase(
          firestore: FirebaseFirestore.instance,
          firebaseStorage: FirebaseStorage.instance);
  int selectedIndex = 0;
  Offset? startPosition;
  void sendImageFile(File file) async {
    String captionString = capitionTextControler.text.trim().isNotEmpty
        ? capitionTextControler.text.trim()
        : "NaN";

    widget.messageHandlerViewModel
        .sendMessageWithFile(file, 'image', ExtraInfo(caption: captionString));
  }

  @override
  Widget build(BuildContext context) {
    //log("file path of image for sending ${widget.imageFile.path}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Share image"),
        actions: [
          IconButton(
              onPressed: () {
                if (widget.images.isNotEmpty) {
                  widget.images.removeAt(selectedIndex);
                  if (widget.images.isNotEmpty) {
                    setState(() {});
                  } else {
                    getIt<AppRouter>().maybePop();
                  }
                }
              },
              icon: Icon(Remix.delete_bin_3_line))
        ],
      ),
      body: Stack(
        children: [
          const AppSpacingSmall(),
          Positioned.fill(
            child: GestureDetector(
                onPanStart: (details) {
                  log("swipe recorded");
                  startPosition = details.globalPosition;
                },
                onPanEnd: (details) {
                  log("swipe ended");

                  double dx = details.globalPosition.dx - startPosition!.dx;

                  setState(() {
                    log("start value ${startPosition!.dx} end value ${details.globalPosition.dx}");
                    log("dx value $dx selected ");
                    if (dx > 50) {
                      if (selectedIndex > 0) {
                        selectedIndex--;
                      }
                    }

                    if (dx < -50) {
                      if (selectedIndex < widget.images.length - 1) {
                        selectedIndex++;
                      }
                    }
                  });
                },
                child: Image.file(widget.images[selectedIndex])),
          ),
          const AppSpacingSmall(),
          const AppSpacingSmall(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 50,
                  width: MediaQuery.sizeOf(context).width - 40,
                  child: Center(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                              margin: EdgeInsets.all(2.0),
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  border: index == selectedIndex
                                      ? Border.all(
                                          color: AppColors.brandColorDark,
                                          width: 2.50)
                                      : Border(),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                child: Image.file(
                                  widget.images[index],
                                  fit: BoxFit.cover,
                                ),
                              )),
                        );
                      },
                      itemCount: widget.images.length,
                    ),
                  ),
                ),
                CapitionBox(
                    capitionTextFocusNode: capitionTextFocusNode,
                    capitionTextControler: capitionTextControler,
                    key: _key),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton.extended(
                          icon: const Icon(FeatherIcons.send),
                          onPressed: () async {
                            sendImageFile(widget.images.first);
                            if (widget.images.isNotEmpty) {
                              widget.images.removeAt(0);
                              if (widget.images.isNotEmpty) {
                                setState(() {});
                              }
                            }
                            if (widget.images.isEmpty) {
                              context.router.maybePop();
                            }
                          },
                          label: const Text(
                            "Send",
                            style: TextStyle(fontSize: 16.0),
                          ))),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CapitionBox extends StatelessWidget {
  const CapitionBox({
    super.key,
    required this.capitionTextFocusNode,
    required this.capitionTextControler,
  });

  final FocusNode capitionTextFocusNode;
  final TextEditingController capitionTextControler;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.sizeOf(context).width * 95,
        constraints: const BoxConstraints(minHeight: 60.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.neutralGrayLight),
        child: Row(
          children: [
            Expanded(
                child: TextFormField(
              focusNode: capitionTextFocusNode,
              controller: capitionTextControler,
              onChanged: (value) {},
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  hintText: "Type a caption",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none),
            )),
          ],
        ),
      ),
    );
  }
}
