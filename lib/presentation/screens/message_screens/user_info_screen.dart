import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/local_storage_handler.dart';
import 'package:samvaad/core/utils/size.dart';
import 'package:samvaad/domain/entities/local_file.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/presentation/screens/message_screens/messages_screen.dart';
import 'package:samvaad/presentation/screens/profile_screens/setting_screens/notification_screen.dart';
import 'package:samvaad/presentation/viewmodels/user_detail_view_model.dart';
import 'package:samvaad/presentation/widgets/app_divider.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/spacing.dart';
import 'package:samvaad/presentation/widgets/user_app_bar_cell.dart';

@RoutePage()
class UserInfoScreen extends StatefulWidget {
  User userDetail;

  UserInfoScreen({required this.userDetail});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  LocalStorageHandler localStorageHandler = LocalStorageHandler();
  ValueNotifier<int> selectedItemCount = ValueNotifier<int>(0);
  List<String> selectedItem = List.empty(growable: true);
  ValueNotifier<bool> muteNotification = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    Provider.of<UserDetailsViewModel>(context, listen: false)
        .checkIfUserIsMute(widget.userDetail.phoneNo!)
        .then((v0) {
      muteNotification.value = v0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ValueListenableBuilder(
              valueListenable: selectedItemCount,
              builder: (context, selectedItemCount, child) {
                if (selectedItemCount > 0) {
                  return Row(
                    children: [
                      IconButton(
                          onPressed: () {}, icon: Icon(Remix.delete_bin_line)),
                      Text("$selectedItemCount")
                    ],
                  );
                } else {
                  return SizedBox();
                }
              })
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeOf.intance.getHight(context, 0.02)),
            child: Consumer<UserDetailsViewModel>(
                builder: (context, userDetailsViewModel, child) {
              log("rebuild called on user info screen");
              User userDetail = userDetailsViewModel
                  .getUserDetails(widget.userDetail.phoneNo!);
              return Column(
                children: [
                  UserAppBarCell(
                    userDetails: userDetail,
                    showStatus: true,
                    showBio: false,
                  ),
                  ValueListenableBuilder(
                      valueListenable: muteNotification,
                      builder: (context, value, child) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  SizeOf.intance.getHight(context, 0.01)),
                          child: ListTileWithSwitch(
                              tileTitle: "Mute notification",
                              isActive: value,
                              onPress: (v) async {
                                muteNotification.value = v;
                                await Provider.of<UserDetailsViewModel>(context,
                                        listen: false)
                                    .muteNotificationToggle(
                                        userDetail.phoneNo!, v);
                              },
                              tileIcon: Icon(
                                Remix.volume_mute_line,
                                size: 26,
                              )),
                        );
                      }),
                ],
              );
            }),
          ),
          AppSpacingSmall(),
          AppDivider(),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeOf.intance.getHight(context, 0.02)),
            child: Consumer<UserDetailsViewModel>(
                builder: (context, userDetailViewModel, child) {
              User userDetail = userDetailViewModel
                  .getUserDetails(widget.userDetail.phoneNo!);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacingSmall(),
                  TitleLarge(text: "Bio"),
                  AppSpacingSmall(),
                  BodyLarge(
                    text: userDetail.bio!,
                  ),
                  AppSpacingSmall(),
                  TitleLarge(text: "Phone number"),
                  AppSpacingSmall(),
                  TitleLarge(text: userDetail.phoneNo!),
                ],
              );
            }),
          ),
          AppSpacingSmall(),
          AppDivider(),
          AppSpacingSmall(),
          FutureBuilder(
              future: localStorageHandler.specificUserFiles("+919909988088"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError || snapshot.data == null) {
                  return LoadSvgImage(
                      imageAsset: "lib/assets/image/No_data_bro.svg",
                      text: "Error in loading file");
                } else {
                  return Expanded(
                    child: FileListView(
                      files: snapshot.data!,
                      selectedChange: (selected) {
                        selectedItem = selected;
                        selectedItemCount.value = selected.length;
                      },
                    ),
                  );
                }
              })
        ],
      ),
    );
  }
}

class FileListView extends StatefulWidget {
  Map<String, List<LocalFile>> files;
  Function(List<String> selected) selectedChange;
  FileListView({super.key, required this.files, required this.selectedChange});

  @override
  State<FileListView> createState() => _FileListViewState();
}

class _FileListViewState extends State<FileListView> {
  List<String> selectedFiles = List.empty(growable: true);

  void modifySelectedItem(String id) {
    if (selectedFiles.contains(id)) {
      selectedFiles.remove(id);
      widget.selectedChange(selectedFiles);
    } else {
      selectedFiles.add(id);
      widget.selectedChange(selectedFiles);
    }
  }

  bool checkIfResultIsEmpty(Map<String, List<LocalFile>> files) {
    for (var element in files.keys) {
      if (files[element]!.isEmpty) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return !checkIfResultIsEmpty(widget.files)
        ? ListView.builder(
            itemBuilder: (context, index) {
              final filesToShow = widget.files.values.elementAt(index);
              final int itemsPerRow = 5;
              final double itemHeight = 20; // your item height
              final double spacing = 3;
              final double screenWidth = MediaQuery.of(context).size.width;
              final double itemWidth =
                  (screenWidth - 20 - (spacing * (itemsPerRow - 1))) /
                      itemsPerRow;

              final int rowCount = (filesToShow.length / itemsPerRow).ceil();
              final double totalHeight =
                  rowCount * itemHeight + (rowCount - 1) * spacing;
              if (filesToShow.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeOf.intance.getWidth(context, 0.01)),
                      child:
                          TitleLarge(text: widget.files.keys.elementAt(index)),
                    ),
                    MasonryGridView.count(
                      crossAxisCount: 10,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, innerIndex) {
                        log("file name ${filesToShow[innerIndex].filePath}");
                        return GestureDetector(
                          onLongPress: () {
                            modifySelectedItem(filesToShow[innerIndex].fileId);
                          },
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: MediaViewer(
                                    mediaType: filesToShow[innerIndex].fileType,
                                    mediaData:
                                        filesToShow[innerIndex].fileType ==
                                                "image"
                                            ? filesToShow[innerIndex].filePath
                                            : filesToShow[innerIndex].metaData,
                                    mediaFile:
                                        filesToShow[innerIndex].filePath),
                              ),
                              Positioned(
                                  child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent
                                        .withValues(alpha: 0.4)),
                              ))
                            ],
                          ),
                        );
                      },
                      itemCount: filesToShow.length,
                    )
                  ],
                );
              } else {
                return SizedBox();
              }
            },
            itemCount: widget.files.length)
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              LoadSvgImage(
                  imageAsset: "lib/assets/image/No_data_bro.svg",
                  text: "No Files"),
            ],
          );
  }
}

class MediaViewer extends StatelessWidget {
  final String mediaType;
  final String mediaData;
  final String mediaFile;
  const MediaViewer(
      {super.key,
      required this.mediaType,
      required this.mediaData,
      required this.mediaFile});

  @override
  Widget build(BuildContext context) {
    // log("media view called");
    if (mediaType == "image") {
      // log("media type is image");
      // log("meta data $mediaData");
      return Image.file(
        File(mediaData),
        fit: BoxFit.cover,
      );
    } else if (mediaType == "document" ||
        mediaType == "pdf" ||
        mediaType == "video") {
      return SizedBox(
        height: 20,
        width: 20,
      );
    } else if (mediaType == "audio") {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: AppColors.brandColorLightGray),
        child: Icon(FeatherIcons.headphones),
      );
    } else {
      return SizedBox();
    }
  }
}


// SizedBox(
//                       height: totalHeight,
//                       child: GridView.builder(
//                         physics: NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         padding: EdgeInsets.all(10),
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: itemsPerRow,
//                             crossAxisSpacing: spacing,
//                             mainAxisSpacing: spacing,
//                             childAspectRatio: itemWidth / itemHeight),
//                         itemCount: filesToShow.length,
//                         itemBuilder: (context, innerIndex) {
//                           log(" ");
//                           // final item = widget.files.values
//                           //     .elementAt(index)
//                           //     .elementAt(innerIndex);
//                           // return GestureDetector(
//                           //   onLongPress: () {
//                           //     modifySelectedItem(item.fileId);
//                           //   },
//                           //   child: Stack(
//                           //     children: [
//                           //       Positioned.fill(
//                           //         child: MediaViewer(
//                           //             mediaType: item.fileType,
//                           //             mediaData: item.fileType == "image"
//                           //                 ? item.filePath
//                           //                 : item.metaData,
//                           //             mediaFile: item.filePath),
//                           //       ),
//                           //       Positioned(
//                           //           child: Container(
//                           //         decoration: BoxDecoration(
//                           //             color: Colors.blueAccent
//                           //                 .withValues(alpha: 0.4)),
//                           //       ))
//                           //     ],
//                           //   ),
//                           // );
//                         },
//                       ),
//                     ),