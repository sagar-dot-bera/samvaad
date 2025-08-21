import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/core/utils/app_enums.dart';
import 'package:samvaad/core/utils/hive_handler.dart';
import 'package:samvaad/core/utils/size.dart';
import 'package:samvaad/domain/entities/call.dart';
import 'package:samvaad/domain/entities/call_log.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/presentation/viewmodels/call_manager_view_model.dart';
import 'package:samvaad/presentation/viewmodels/user_detail_view_model.dart';
import 'package:samvaad/presentation/widgets/app_make_call_cell.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/router.gr.dart';

@RoutePage()
class SelectContact extends StatefulWidget {
  SelectContact({super.key});

  @override
  State<SelectContact> createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  late final userWhoKnowCurrentUser;

  @override
  void initState() {
    super.initState();
  }

  final HiveHandler hiveHandler = HiveHandler();
  ValueNotifier<List<String>> selectedItem =
      ValueNotifier<List<String>>(List<String>.empty(growable: true));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeadlineMedium(text: "Select contact"),
      ),
      body: Column(
        children: [
          Consumer<UserDetailsViewModel>(
              builder: (context, userDetailProvider, child) {
            return ValueListenableBuilder(
                valueListenable: selectedItem,
                builder: (context, value, child) {
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeOf.intance.getWidth(
                          context,
                          0.02,
                        )),
                        child: GestureDetector(
                          onLongPress: () {
                            log("long press ${selectedItem.value.length} ${value.length}");
                            if (value.isEmpty) {
                              log("value added to list");
                              value.add(userDetailProvider
                                  .userWhoKnowCurrentUser[index].phoneNo!);
                              selectedItem.value = [...value];
                              log("list ${selectedItem.value.length}");
                            }
                          },
                          onTap: () {
                            if (selectedItem.value.isNotEmpty) {
                              if (!selectedItem.value.contains(
                                  userDetailProvider
                                      .userWhoKnowCurrentUser[index].phoneNo)) {
                                value.add(userDetailProvider
                                    .userWhoKnowCurrentUser[index].phoneNo!);
                                selectedItem.value = [...value];
                                log("list ${selectedItem.value.length}");
                              } else {
                                value.remove(userDetailProvider
                                    .userWhoKnowCurrentUser[index].phoneNo!);
                                selectedItem.value = [...value];
                              }
                            }
                          },
                          child: MakeCallCell(
                              isSelected: value.contains(userDetailProvider
                                  .userWhoKnowCurrentUser[index].phoneNo),
                              user: userDetailProvider
                                  .userWhoKnowCurrentUser[index],
                              onAudioCallTap: () async {
                                Call withUser = Call(
                                    withUser: userDetailProvider
                                        .userWhoKnowCurrentUser[index],
                                    callType: CallType.outgoing,
                                    timeStamp:
                                        DateTime.now().toIso8601String());
                                final cameraPermission =
                                    await Permission.camera.request();
                                final microphonePermission =
                                    await Permission.microphone.request();

                                if (await microphonePermission.isGranted &&
                                    await cameraPermission.isGranted) {
                                  context.router.push(AudioCallWrapperRoute(
                                      withUser: withUser));
                                } else {
                                  // ignore: prefer_const_declarations
                                  final snackBar = const SnackBar(
                                      content: const Text(
                                          "Please grant permission to make call"));
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              }),
                        ),
                      );
                    },
                    itemCount: userDetailProvider.userWhoKnowCurrentUser.length,
                  );
                });
          })
        ],
      ),
    );
  }
}

class AppMakeCallCellListView extends StatelessWidget {
  AppMakeCallCellListView({
    super.key,
    required this.userDetailes,
  });

  final List<User> userDetailes;
  final HiveHandler hiveHandler = HiveHandler();
  ValueNotifier<List<String>> selectedItem =
      ValueNotifier<List<String>>(<String>[]);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: selectedItem,
        builder: (context, value, child) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                onLongPress: () {
                  if (value.isEmpty) {
                    log("value added to list");
                    value.add(userDetailes[index].phoneNo!);
                    selectedItem.value = [...value];
                  }
                },
                onTap: () {
                  if (selectedItem.value.isNotEmpty) {
                    if (!selectedItem.value
                        .contains(userDetailes[index].phoneNo)) {
                      value.add(userDetailes[index].phoneNo!);
                      selectedItem.value = [...value];
                    } else {
                      value.remove(userDetailes[index].phoneNo!);
                      selectedItem.value = [...value];
                    }
                  }
                },
                child: MakeCallCell(
                    isSelected: value.contains(userDetailes[index].phoneNo),
                    user: userDetailes[index],
                    onAudioCallTap: () async {
                      Call withUser = Call(
                          withUser: userDetailes[index],
                          callType: CallType.outgoing,
                          timeStamp: DateTime.now().toIso8601String());
                      final cameraPermission =
                          await Permission.camera.request();
                      final microphonePermission =
                          await Permission.microphone.request();

                      if (await microphonePermission.isGranted &&
                          await cameraPermission.isGranted) {
                        await Provider.of<CallManagerViewModel>(context,
                                listen: false)
                            .setCallLog(CallLog(
                                callDetail: withUser.toJson(),
                                receivedOrAnswer: false));
                        context.router
                            .push(AudioCallWrapperRoute(withUser: withUser));
                      } else {
                        // ignore: prefer_const_declarations
                        final snackBar = const SnackBar(
                            content: const Text(
                                "Please grant permission to make call"));
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }),
              );
            },
            itemCount: userDetailes.length,
          );
        });
  }
}
