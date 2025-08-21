import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/core/themes/chat_bubble_colors.dart';
import 'package:samvaad/core/utils/local_storage_handler.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/presentation/screens/profile_screens/setting_screens/chat_setting_screen.dart';
import 'package:samvaad/presentation/viewmodels/user_detail_view_model.dart';
import 'package:samvaad/presentation/widgets/animations.dart';
import 'package:samvaad/presentation/widgets/app_divider.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/chats/contact_message_view.dart';

@RoutePage()
class StorageSetting extends StatefulWidget {
  const StorageSetting({super.key});

  @override
  State<StorageSetting> createState() => _StorageSettingState();
}

class _StorageSettingState extends State<StorageSetting> {
  (double?, String?)? totalStorage,
      imageStorageSize,
      audioStorageSize,
      videoStorageSize,
      documentStorageSize;
  LocalStorageHandler localStorageHandler = LocalStorageHandler();

  @override
  void initState() {
    super.initState();

    localStorageHandler.totalStorageCalculator((imageFileSize, audioFileSize,
        videoFileSize, documentFileSize, totalFileSize) {
      log("Image size $imageFileSize audio size $audioFileSize video size $videoFileSize docu size $documentFileSize total $totalFileSize");
      setState(() {
        imageStorageSize = localStorageHandler.byteToUnitSize(imageFileSize);
        audioStorageSize = localStorageHandler.byteToUnitSize(audioFileSize);
        videoStorageSize = localStorageHandler.byteToUnitSize(videoFileSize);
        documentStorageSize =
            localStorageHandler.byteToUnitSize(documentFileSize);
        totalStorage = localStorageHandler.byteToUnitSize(totalFileSize);

        log("Image size $imageFileSize audio size $audioFileSize video size $videoFileSize docu size $documentFileSize total $totalFileSize");
      });
    });
  }

  double getScreenSize(BuildContext context) {
    log("Screen Width: ${MediaQuery.sizeOf(context).width}");

    return MediaQuery.sizeOf(context).width * 94 / 100;
  }

  double getScreenHeight(BuildContext context, double precentOfScreen) {
    return MediaQuery.sizeOf(context).width * precentOfScreen;
  }

  double avaiableSpace(BuildContext context) {
    log("$totalStorage");
    log("${toBytes(totalStorage!)}");
    log("screen ${getScreenSize(context)}");

    return (getScreenSize(context) - 10) / toBytes(totalStorage!);
  }

  double toBytes((double?, String?) data) {
    if (data.$2! == "GB") {
      return data.$1! * 1024 * 1024 * 1024;
    } else if (data.$2! == "MB") {
      return data.$1! * 1024 * 1024;
    } else if (data.$2! == "KB") {
      return data.$1! * 1024;
    } else {
      return 0;
    }
  }

  String sizeStringTemplet((double?, String?)? size) {
    return "${size!.$1!.toStringAsFixed(2)} ${size.$2}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeadlineMedium(text: "Storage"),
      ),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * 0.04),
              child: Row(
                children: [
                  TitleLarge(text: "Storage used"),
                  Expanded(child: SizedBox()),
                  TitleLarge(
                      text: totalStorage != null
                          ? sizeStringTemplet(totalStorage)
                          : "Calculating")
                ],
              )),
          Container(
            width: getScreenSize(context),
            height: getScreenHeight(context, 0.10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black38, width: 1.0)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: totalStorage != null && totalStorage!.$1! > 0
                  ? Row(
                      children: [
                        Container(
                          width: avaiableSpace(context) *
                              toBytes(imageStorageSize!),
                          height: getScreenHeight(context, 0.97),
                          decoration: BoxDecoration(
                            color: ChatBubbleColors.lavenderPurple,
                          ),
                        ),
                        Container(
                          width: avaiableSpace(context) *
                              toBytes(audioStorageSize!),
                          height: getScreenHeight(context, 0.97),
                          decoration: BoxDecoration(
                            color: ChatBubbleColors.goldenSand,
                          ),
                        ),
                        Container(
                          width: avaiableSpace(context) *
                              toBytes(videoStorageSize!),
                          height: getScreenHeight(context, 0.97),
                          decoration: BoxDecoration(
                            color: ChatBubbleColors.forestGreen,
                          ),
                        ),
                        Container(
                          width: avaiableSpace(context) *
                              toBytes(documentStorageSize!),
                          height: getScreenHeight(context, 0.97),
                          decoration: BoxDecoration(
                            color: ChatBubbleColors.skyBlue,
                          ),
                        )
                      ],
                    )
                  : SizedBox(),
            ),
          ),
          Container(
              padding: EdgeInsets.only(
                left: MediaQuery.sizeOf(context).width * 0.05,
                right: MediaQuery.sizeOf(context).width * 0.05,
              ),
              child: Column(
                children: [
                  ListTileWithIconAndTitle(
                      tileIcon: ColorChip(
                        chipColor: ChatBubbleColors.lavenderPurple,
                      ),
                      title: "Image Files",
                      trailingText: imageStorageSize != null
                          ? sizeStringTemplet(imageStorageSize)
                          : "calculating",
                      onTileTapped: () {}),
                  ListTileWithIconAndTitle(
                      tileIcon:
                          ColorChip(chipColor: ChatBubbleColors.goldenSand),
                      title: "Audio Files",
                      trailingText: audioStorageSize != null
                          ? sizeStringTemplet(audioStorageSize)
                          : "calculating",
                      onTileTapped: () {}),
                  ListTileWithIconAndTitle(
                      tileIcon:
                          ColorChip(chipColor: ChatBubbleColors.forestGreen),
                      title: "Video Files",
                      trailingText: videoStorageSize != null
                          ? sizeStringTemplet(videoStorageSize)
                          : "calculating",
                      onTileTapped: () {}),
                  ListTileWithIconAndTitle(
                      tileIcon: ColorChip(chipColor: ChatBubbleColors.skyBlue),
                      title: "Document Files",
                      trailingText: documentStorageSize != null
                          ? sizeStringTemplet(documentStorageSize)
                          : "calculating",
                      onTileTapped: () {}),
                ],
              )),
          AppDivider(),
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(
          //         horizontal: MediaQuery.sizeOf(context).width * 0.05),
          //     child: BodyMedium(
          //       text: "User wise storage",
          //       align: TextAlign.start,
          //     ),
          //   ),
          // ),
          Expanded(
              child: FutureBuilder(
            future: localStorageHandler.userWiseStorageUses(
                Provider.of<UserDetailsViewModel>(context)
                    .detailsOfParticipants),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ProfileCellShimmerList();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error"),
                );
              } else {
                List<User> users = List.from(snapshot.data!.keys);
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: InitialLetterAvatar(
                        name: users[index].userName!,
                      ),
                      title: BodyMedium(
                        text: users[index].userName!,
                        align: TextAlign.start,
                      ),
                      trailing: BodyMedium(
                          text: "${snapshot.data![users[index]]} MB"),
                    );
                  },
                  itemCount: users.length,
                );
              }
            },
          ))
        ],
      ),
    );
  }
}

class ColorChip extends StatelessWidget {
  final Color chipColor;

  const ColorChip({super.key, required this.chipColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 18,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: chipColor),
    );
  }
}
