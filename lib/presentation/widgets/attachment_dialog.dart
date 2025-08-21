// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart'
    as native_contact_picker;
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:samvaad/core/services/location_service.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/size.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/main.dart';
import 'package:samvaad/presentation/viewmodels/chat_handler_view_model.dart';
import 'package:samvaad/presentation/widgets/app_rounded_button.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/spacing.dart';
import 'package:samvaad/router.dart';
import 'package:samvaad/router.gr.dart';

class AttachmentDialog extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  //BuildContext contextOfChatScreen;
  AttachmentDialog({super.key});

  Future<List<XFile>> pickAssets(String typeOfAssets) async {
    List<XFile> asstesList = List.empty(growable: true);
    if (typeOfAssets == "image") {
      asstesList = await _picker.pickMultiImage();
    }
    return asstesList;
  }

  Future<List<File>> getMediaFiles(List<String> allowedTypes) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowedExtensions: allowedTypes,
        type: FileType.custom);
    List<File> files = List.empty(growable: true);

    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
    }

    return files;
  }

  Future<Map<String, File>> getDocumentFilesWithName(
      List<String> allowedTypes) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowedExtensions: allowedTypes,
        type: FileType.custom);
    Map<String, File> files = {};

    int count = 0;
    if (result != null) {
      for (var element in result.names) {
        files[element!] = File(result.paths[count]!);
        count++;
      }
    }
    return files;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 24.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.neutralGrayLight),
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        const AppSpacingSmall(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AppRoundedButtonWithLable(
                buttonLable: "camera",
                buttonIcon: const Icon(FeatherIcons.camera),
                onClick: () async {
                  List<File> filesToSend = List.empty(growable: true);
                  String fileType = "";

                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                AppRoundedButtonWithLable(
                                    buttonLable: "Video",
                                    buttonIcon: Icon(FeatherIcons.video),
                                    onClick: () async {
                                      if (await Permission.videos
                                              .request()
                                              .isGranted ==
                                          true) {
                                        log("permission granted");
                                        final selectedFiles =
                                            await ImagePicker().pickVideo(
                                                source: ImageSource.camera,
                                                maxDuration:
                                                    Duration(seconds: 10));

                                        if (selectedFiles != null) {
                                          filesToSend = [
                                            File(selectedFiles.path)
                                          ];
                                          fileType = "video";
                                          context.router.maybePop();
                                          log("file to send ${filesToSend.length}");
                                        }
                                      }
                                    },
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary),
                                AppRoundedButtonWithLable(
                                    buttonLable: "Image",
                                    buttonIcon: Icon(FeatherIcons.image),
                                    onClick: () async {
                                      bool capturing = true;
                                      if (await Permission.photos
                                              .request()
                                              .isGranted ==
                                          true) {
                                        log("permission granted");
                                        while (capturing) {
                                          final pickedImage = await ImagePicker
                                              .platform
                                              .getImageFromSource(
                                                  source: ImageSource.camera);

                                          if (pickedImage != null) {
                                            filesToSend
                                                .add(File(pickedImage.path));
                                            capturing = await showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    title: Text(
                                                        'Add another image?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(ctx)
                                                                .pop(false),
                                                        child: Text('No'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(ctx)
                                                                .pop(true),
                                                        child: Text('Yes'),
                                                      ),
                                                    ],
                                                  ),
                                                ) ??
                                                false;
                                          }
                                        }
                                      }
                                    },
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary),
                              ],
                            ),
                          ],
                        ));
                      });

                  if (filesToSend.isNotEmpty) {
                    if (fileType == "video") {
                      final provider = Provider.of<ChatHandlerViewModel>(
                          context,
                          listen: false);

                      context.router.push(SendVideoRoute(
                          files: filesToSend, messageChangeNotifier: provider));
                    } else if (fileType == "image") {
                      final provider = Provider.of<ChatHandlerViewModel>(
                          context,
                          listen: false);

                      context.router.push(ImagePreviewRoute(
                          images: filesToSend,
                          messageHandlerViewModel: provider));
                    }
                  } else {}
                },
                backgroundColor: Theme.of(context).colorScheme.primary),
            AppRoundedButtonWithLable(
                buttonLable: "Gallery",
                buttonIcon: const Icon(FeatherIcons.image),
                onClick: () async {
                  List<File> filesToSend = List.empty(growable: true);
                  String fileType = "";
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                AppRoundedButtonWithLable(
                                    buttonLable: "Video",
                                    buttonIcon: Icon(FeatherIcons.video),
                                    onClick: () async {
                                      if (await Permission.videos
                                              .request()
                                              .isGranted ==
                                          true) {
                                        log("permission granted");
                                        final selectedFiles =
                                            await getMediaFiles(['mp4']);

                                        if (selectedFiles.isNotEmpty) {
                                          filesToSend = selectedFiles;
                                          fileType = "video";
                                          context.router.maybePop();
                                          log("file to send ${filesToSend.length}");
                                        }
                                      }
                                    },
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary),
                                AppRoundedButtonWithLable(
                                    buttonLable: "Image",
                                    buttonIcon: Icon(FeatherIcons.image),
                                    onClick: () async {
                                      if (await Permission.photos
                                              .request()
                                              .isGranted ==
                                          true) {
                                        log("permission granted");
                                        final selectedFiles =
                                            await getMediaFiles(
                                                ['png', 'jpeg', 'jpg']);

                                        if (selectedFiles.isNotEmpty) {
                                          filesToSend = selectedFiles;
                                          fileType = "image";
                                          context.router.maybePop();
                                        }
                                      }
                                    },
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary),
                              ],
                            ),
                          ],
                        ));
                      });
                  if (filesToSend.isNotEmpty) {
                    if (fileType == "video") {
                      final provider = Provider.of<ChatHandlerViewModel>(
                          context,
                          listen: false);

                      context.router.push(SendVideoRoute(
                          files: filesToSend, messageChangeNotifier: provider));
                    } else if (fileType == "image") {
                      final provider = Provider.of<ChatHandlerViewModel>(
                          context,
                          listen: false);

                      context.router.push(ImagePreviewRoute(
                          images: filesToSend,
                          messageHandlerViewModel: provider));
                    }
                  } else {}
                },
                backgroundColor: Theme.of(context).colorScheme.primary),
            AppRoundedButtonWithLable(
                buttonLable: "Document",
                buttonIcon: const Icon(FeatherIcons.file),
                onClick: () async {
                  // if (await Permission.manageExternalStorage.isGranted ==
                  //     true) {
                  log("opeing file picker");
                  Map<String, File> pickedFile =
                      await getDocumentFilesWithName(["pdf"]);
                  // if (pickedFile != null) {
                  log("number of file picked ${pickedFile.length}");
                  final provider =
                      Provider.of<ChatHandlerViewModel>(context, listen: false);
                  List<File> fileList = List.from(pickedFile.values);
                  context.router.push(SendFileRoute(
                      fileListWithName: pickedFile,
                      files: fileList,
                      messageHandlerViewModel: provider));
                  // }
                  //}
                },
                backgroundColor: Theme.of(context).colorScheme.primary),
          ],
        ),
        const AppSpacingSmall(),
        const AppSpacingSmall(),
        const AppSpacingSmall(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AppRoundedButtonWithLable(
                buttonLable: "Audio",
                buttonIcon: const Icon(FeatherIcons.headphones),
                onClick: () async {
                  List<File> audioFiles = await getMediaFiles(["mp3"]);

                  if (audioFiles.isNotEmpty) {
                    final provider = Provider.of<ChatHandlerViewModel>(context,
                        listen: false);

                    context.router.push(SendAudioRoute(
                        audioFiles: audioFiles,
                        messageHandlerViewModel: provider));
                  }
                },
                backgroundColor: Theme.of(context).colorScheme.primary),
            AppRoundedButtonWithLable(
                buttonLable: "Location",
                buttonIcon: const Icon(FeatherIcons.mapPin),
                onClick: () async {
                  LocationHandler locationHandler = LocationHandler();

                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Accessing you location"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Fetching user location"),
                              SvgPicture.asset(
                                "lib/assets/image/Online_world_bro.svg",
                                width: SizeOf.intance.getWidth(context, 0.20),
                                height: SizeOf.intance.getHight(context, 0.20),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              CircularProgressIndicator(),
                            ],
                          ),
                        );
                      });

                  final location = await locationHandler
                      .getCurrentLocation()
                      .catchError((error) {
                    getIt<AppRouter>().maybePop();
                    log("on catch fired");
                    if (error.toString().contains("service not")) {
                      log("location service is off");
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Enable location"),
                              content: Text(
                                  "Enable location service to share location from you phone"),
                            );
                          });
                    } else if (error.toString().contains("permission denied")) {
                      log("permission denied");
                    } else if (error
                        .toString()
                        .contains(" we cannot request permissions")) {
                      log(" we cannot request permissions");
                    }
                    return null;
                  });
                  String? address;
                  if (location != null) {
                    address = await locationHandler.getAddressFromLatLng(
                        location.latitude, location.longitude);
                  }
                  getIt<AppRouter>().maybePop();
                  final provider =
                      Provider.of<ChatHandlerViewModel>(context, listen: false);
                  String latLong =
                      '{"lat":"${location!.latitude}","lng":"${location.longitude}"}';
                  Message message = await provider.messageCreator(latLong,
                      "location", "sent", ExtraInfo(fileName: address));
                  await provider.sendMessage(message);
                },
                backgroundColor: Theme.of(context).colorScheme.primary),
            AppRoundedButtonWithLable(
                buttonLable: "Contact",
                buttonIcon: const Icon(FeatherIcons.user),
                onClick: () async {
                  List<Contact> selectedContacts = List.empty(growable: true);
                  bool oneMore = true;
                  while (oneMore) {
                    final native_contact_picker.FlutterNativeContactPicker
                        contactPicker =
                        native_contact_picker.FlutterNativeContactPicker();

                    Contact? contact = await contactPicker.selectContact();

                    if (contact != null) {
                      selectedContacts.add(contact);
                    }

                    oneMore = await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Add another?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: Text('No'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: Text('Yes'),
                              ),
                            ],
                          ),
                        ) ??
                        false;
                  }
                  if (selectedContacts.isNotEmpty) {
                    final provider = Provider.of<ChatHandlerViewModel>(context,
                        listen: false);
                    context.router.push(SendContactRoute(
                        selectedContactList: selectedContacts,
                        messageHandlerViewModel: provider));
                  }
                },
                backgroundColor: Theme.of(context).colorScheme.primary),
          ],
        )
      ]),
    );
  }
}

class AppRoundedButtonWithLable extends StatelessWidget {
  Widget buttonIcon;
  void Function() onClick;
  Color backgroundColor;
  String buttonLable;
  AppRoundedButtonWithLable(
      {super.key,
      required this.buttonLable,
      required this.buttonIcon,
      required this.backgroundColor,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppRoundedButton(
            buttonIcon: buttonIcon,
            onClikc: onClick,
            backgroundColor: backgroundColor),
        TitleSmall(text: buttonLable)
      ],
    );
  }
}

class ImageOrVideoOptionMenu extends StatelessWidget {
  const ImageOrVideoOptionMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSpacingSmall(),
        Row(
          children: [
            AppRoundedButtonWithLable(
                buttonLable: "Image",
                buttonIcon: Icon(FeatherIcons.image),
                backgroundColor: Theme.of(context).colorScheme.primary,
                onClick: () {}),
            AppRoundedButtonWithLable(
                buttonLable: "Video",
                buttonIcon: Icon(FeatherIcons.video),
                backgroundColor: Theme.of(context).colorScheme.primary,
                onClick: () {})
          ],
        ),
        AppSpacingSmall()
      ],
    );
  }
}
