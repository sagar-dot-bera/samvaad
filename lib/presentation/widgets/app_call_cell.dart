import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:samvaad/core/services/fetch_files.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/app_enums.dart';
import 'package:samvaad/core/utils/format.dart';
import 'package:samvaad/core/utils/hive_handler.dart';
import 'package:samvaad/domain/entities/call.dart';
import 'package:samvaad/domain/entities/call_log.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/participant_cell.dart';
import 'package:samvaad/presentation/widgets/profile_avatar_widget.dart';
import 'package:samvaad/presentation/widgets/spacing.dart';
import 'package:samvaad/router.gr.dart';

// ignore: must_be_immutable
class CallLogCell extends StatefulWidget {
  CallLog callLog;
  Function() onRefresh;
  bool isSelected;
  CallLogCell(
      {super.key,
      required this.callLog,
      required this.onRefresh,
      required this.isSelected});

  @override
  State<CallLogCell> createState() => _CallLogCellState();
}

class _CallLogCellState extends State<CallLogCell> {
  Call? callDetail;

  Uint8List? userProfileImageBytes;
  HiveHandler hiveHandler = HiveHandler();
  FetchFiles fetchFiles = FetchFiles(dio: Dio());
  Format format = Format();

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> details = widget.callLog.callDetail;
    callDetail = Call.fromJson(details);
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: LeadingProfilePictureWidget(
          profileUrl: callDetail!.withUser!.profilePhotoUrl!,
          profileId: callDetail!.withUser!.phoneNo!,
          isSelected: widget.isSelected,
          userName: callDetail!.withUser!.userName!),
      title: BodyLarge(text: callDetail!.withUser!.userName!),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          callDetail!.callType == CallType.incoming
              ? widget.callLog.receivedOrAnswer
                  ? Icon(
                      FeatherIcons.phoneIncoming,
                      color: AppColors.accentGreen,
                      size: 14.0,
                    )
                  : Icon(
                      FeatherIcons.phoneMissed,
                      color: AppColors.accentRed,
                      size: 14.0,
                    )
              : Icon(
                  FeatherIcons.phoneOutgoing,
                  color: AppColors.accentRed,
                  size: 14.0,
                ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.02,
          ),
          Text(
            format.dateFormat24Hourse(callDetail!.timeStamp),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      trailing: IconButton(
          onPressed: () async {
            Call withUser = Call(
                withUser: callDetail!.withUser,
                callType: CallType.outgoing,
                timeStamp: DateTime.now().toIso8601String());
            final cameraPermission = await Permission.camera.request();
            final microphonePermission = await Permission.microphone.request();

            if (microphonePermission.isGranted && cameraPermission.isGranted) {
              await hiveHandler.setCallLog(CallLog(
                  callDetail: withUser.toJson(), receivedOrAnswer: false));
              context.router
                  .push(AudioCallWrapperRoute(withUser: withUser))
                  .then((value) {
                widget.onRefresh();
              });
            } else {
              // ignore: prefer_const_declarations
              final snackBar = const SnackBar(
                  content: const Text("Please grant permission to make call"));
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          icon: Icon(FeatherIcons.phone)),
    );
  }
}
