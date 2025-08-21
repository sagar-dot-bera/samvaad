import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart'
    as flutter_contact_group;
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/compress.dart';
import 'package:samvaad/core/utils/current_user_singleton.dart';
import 'package:samvaad/core/utils/user_details_helper.dart';
import 'package:samvaad/domain/entities/group.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/main.dart';
import 'package:samvaad/presentation/screens/profile_screens/my_profile_screen.dart';
import 'package:samvaad/presentation/viewmodels/user_detail_view_model.dart';
import 'package:samvaad/presentation/widgets/app_divider.dart';
import 'package:samvaad/presentation/widgets/app_photo_pick_icon_button.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/avatar_image_loader.dart';
import 'package:samvaad/presentation/widgets/spacing.dart';
import 'package:samvaad/presentation/widgets/user_app_bar_cell.dart';
import 'package:samvaad/presentation/widgets/user_cell.dart';
import 'package:samvaad/router.dart';
import 'package:samvaad/router.gr.dart';

@RoutePage()
class GroupScreen extends StatefulWidget {
  final Group groupDetail;
  const GroupScreen({super.key, required this.groupDetail});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final ImagePicker _picker = ImagePicker();
  final Compress compressor = Compress();
  String fileDownloadUrl = '';
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  File? tempImageFile;
  ValueNotifier<String> imageFilePath = ValueNotifier<String>("");
  TextEditingController groupNameTextController = TextEditingController();
  XFile? image;

  Future<void> pickImage(ImageSource source) async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageFilePath.value = image!.path;
    }
  }

  Future<List<User>> getGroupMember(
      List<GroupMember> userNumbers, BuildContext context) async {
    final userDetailProvider =
        Provider.of<UserDetailsViewModel>(context, listen: false);
    List<User> groupMembers = List.empty(growable: true);
    TextEditingController groupNameTextController = TextEditingController();

    for (var elemet in userNumbers) {
      if (userDetailProvider.detailsOfParticipants
              .indexWhere((e) => e.phoneNo == elemet.memberId) !=
          -1) {
        groupMembers.add(userDetailProvider.detailsOfParticipants[
            userDetailProvider.detailsOfParticipants
                .indexWhere((e) => e.phoneNo == elemet.memberId)]);
      } else {
        User userDetail =
            await UserDetailsHelper.intance.getSingleUser(elemet.memberId!);
        groupMembers.add(userDetail);
      }
    }
    return groupMembers;
  }

  bool checkIfCurrentUserIsAdmin(Group group, String number) {
    int result =
        group.member.indexWhere((e) => e.memberId == number && e.isAdmin!);
    if (result != -1) {
      return true;
    } else {
      return false;
    }
  }

  void showUpdateDialog(
      String updatingFieldName,
      TextEditingController controller,
      String oldValue,
      void Function() onSaveClick) {
    log("showUpdateDialog called");
    showDialog(
        context: context,
        builder: (context) {
          return UpdateDialog(
              onSaveClick: onSaveClick,
              updatingFieldName: updatingFieldName,
              oldValueOfField: oldValue,
              newValueOfField: "",
              textController: controller);
        }).then((value) {
      setState(() {});
    });
  }

  bool checkIfSelectedIsNotAdmin(
      List<String> selectedMember, List<GroupMember> groupMembers) {
    for (var element in groupMembers) {
      if (selectedMember.contains(element.memberId) && element.isAdmin!) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer<UserDetailsViewModel>(builder: (context, provider, child) {
            if (checkIfCurrentUserIsAdmin(provider.groupInfoInView!,
                CurrentUser.instance.currentUser!.phoneNo!)) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ValueListenableBuilder(
                      valueListenable: imageFilePath,
                      builder: (context, value, child) {
                        return value.isNotEmpty
                            ? IconButton(
                                onPressed: () async {
                                  isLoading.value = true;
                                  await provider.updateGroupProfilePicture(
                                      File(value),
                                      provider.groupInfoInView!.chatId);
                                  isLoading.value = false;
                                },
                                icon: Icon(Remix.upload_2_line))
                            : SizedBox();
                      }),
                  IconButton(
                      onPressed: () {
                        getIt<AppRouter>()
                            .push(NewGroupRoute(toAddMember: true));
                      },
                      icon: Icon(
                        Remix.user_add_line,
                        size: 28,
                      )),
                  provider.selectedGroupMember.isNotEmpty
                      ? PopupMenuButton(onSelected: (value) async {
                          log("value $value");
                          switch (value) {
                            case "makeAdmin":
                              provider.makeNewAdmin(
                                  provider.selectedGroupMember
                                      .map((e) => provider
                                          .groupInfoInView!.member
                                          .firstWhere((m) => m.memberId == e))
                                      .toList(),
                                  provider.groupInfoInView!.chatId);
                              break;
                            case "remove":
                              provider.removeMember(
                                  provider.selectedGroupMember
                                      .map((e) => provider
                                          .groupInfoInView!.member
                                          .firstWhere((m) => m.memberId == e))
                                      .toList(),
                                  provider.groupInfoInView!.chatId);
                            default:
                          }
                        }, itemBuilder: (context) {
                          if (checkIfSelectedIsNotAdmin(
                              provider.selectedGroupMember,
                              provider.groupInfoInView!.member)) {
                            return <PopupMenuEntry<String>>[
                              PopupMenuItem(
                                value: "makeAdmin",
                                child: Text("Make Admin"),
                              ),
                              PopupMenuItem(
                                  value: "remove", child: Text("Remove"))
                            ];
                          } else {
                            return <PopupMenuEntry<String>>[
                              PopupMenuItem(
                                  value: "remove", child: Text("Remove"))
                            ];
                          }
                        })
                      : SizedBox()
                ],
              );
            } else {
              return SizedBox();
            }
          })
        ],
      ),
      body: Column(
        children: [
          ValueListenableBuilder(
              valueListenable: isLoading,
              builder: (context, value, child) {
                return value
                    ? LinearProgressIndicator(
                        backgroundColor: AppColors.background,
                      )
                    : SizedBox();
              }),
          DottedBorder(
            borderType: BorderType.Circle,
            dashPattern: [6, 4],
            strokeCap: StrokeCap.round,
            strokeWidth: 1.45,
            color: AppColors.neutralGray,
            child: Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: GestureDetector(
                  onTap: () async {
                    try {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 150,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  AppPhotoPickIconButton(
                                    buttonIcon:
                                        Icon(Icons.photo_album_outlined),
                                    buttonText: "Gallery",
                                    buttonPressed: () async {
                                      pickImage(ImageSource.gallery);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  AppPhotoPickIconButton(
                                      buttonIcon: Icon(FeatherIcons.camera),
                                      buttonText: "Camera",
                                      buttonPressed: () async {
                                        pickImage(ImageSource.camera);
                                        Navigator.pop(context);
                                      })
                                ],
                              ),
                            );
                          });
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: ValueListenableBuilder(
                      valueListenable: imageFilePath,
                      builder: (context, value, child) {
                        return value.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.file(
                                  File(value),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : AvatarImageLoader(
                                userId: widget.groupDetail.chatId,
                                userName: widget.groupDetail.name,
                                profilePhotoUrl:
                                    widget.groupDetail.profilePhotoUrl,
                                avatarSize: 100);
                      })),
            ),
          ),
          Consumer<UserDetailsViewModel>(builder: (context, provider, child) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  HeadlineMedium(text: provider.groupInfoInView!.name),
                  checkIfCurrentUserIsAdmin(widget.groupDetail,
                          CurrentUser.instance.currentUser!.phoneNo!)
                      ? IconButton(
                          onPressed: () {
                            showUpdateDialog(
                                "Group Name",
                                groupNameTextController,
                                Provider.of<UserDetailsViewModel>(context,
                                        listen: false)
                                    .groupInfoInView!
                                    .name, () async {
                              if (provider.groupInfoInView!.name !=
                                      groupNameTextController.text &&
                                  groupNameTextController.text != "") {
                                await provider.updateGroupName(
                                    groupNameTextController.text,
                                    provider.groupInfoInView!.chatId);
                              }
                            });
                          },
                          icon: Icon(FeatherIcons.edit2))
                      : SizedBox()
                ]);
          }),
          BodyMedium(text: "${widget.groupDetail.member.length} Members"),
          AppSpacingMedium(),
          AppDivider(),
          Expanded(child: Consumer<UserDetailsViewModel>(
              builder: (context, userDetailProvider, child) {
            if (userDetailProvider.userWhoKnowCurrentUser.isEmpty) {
              return Center(child: Text("Error getting data"));
            } else {
              return ListView.builder(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.sizeOf(context).width * 0.05),
                itemBuilder: (context, index) {
                  if (widget.groupDetail.member.indexWhere((e) =>
                          e.memberId ==
                          userDetailProvider.userWhoKnowCurrentUser
                              .elementAt(index)
                              .phoneNo) !=
                      -1) {
                    return GestureDetector(
                      onLongPress: () {
                        userDetailProvider.modifySelectedGroup(
                            userDetailProvider.userWhoKnowCurrentUser
                                .elementAt(index)
                                .phoneNo!);
                      },
                      onTap: () {
                        if (userDetailProvider.selectedGroupMember.isNotEmpty) {
                          userDetailProvider.modifySelectedGroup(
                              userDetailProvider.userWhoKnowCurrentUser
                                  .elementAt(index)
                                  .phoneNo!);
                        }
                      },
                      child: UserCell(
                        userDetails: userDetailProvider.userWhoKnowCurrentUser
                            .elementAt(index),
                        showBio: true,
                        showStatus: false,
                        isAdmin: checkIfCurrentUserIsAdmin(
                            userDetailProvider.groupInfoInView!,
                            userDetailProvider.userWhoKnowCurrentUser
                                .elementAt(index)
                                .phoneNo!),
                        isSelected: userDetailProvider.selectedGroupMember
                            .contains(userDetailProvider.userWhoKnowCurrentUser
                                .elementAt(index)
                                .phoneNo),
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
                itemCount: userDetailProvider.userWhoKnowCurrentUser.length,
              );
            }
          })),
        ],
      ),
    );
  }
}
