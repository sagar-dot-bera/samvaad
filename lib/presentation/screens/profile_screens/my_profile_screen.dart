// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/compress.dart';
import 'package:samvaad/core/utils/current_user_singleton.dart';
import 'package:samvaad/domain/use_case/user_profile_handler_use_case.dart';
import 'package:samvaad/main.dart';
import 'package:samvaad/presentation/viewmodels/profile_handler_view_model.dart';
import 'package:samvaad/presentation/viewmodels/user_detail_view_model.dart';
import 'package:samvaad/presentation/widgets/app_photo_pick_icon_button.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/app_tile.dart';
import 'package:samvaad/presentation/widgets/spacing.dart';
import 'package:samvaad/router.dart';
import 'package:samvaad/router.gr.dart';

@RoutePage()
class MyProfileScreen extends StatefulWidget {
  MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  final Compress compressor = Compress();
  File? profileImage;
  bool isLoading = false;
  XFile? image;
  bool isNewImageSeleted = false;
  TextEditingController bioTextController = TextEditingController();
  TextEditingController nameTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    profileImage = null;
  }

  @override
  void initState() {
    super.initState();
    bioTextController.text = CurrentUser.instance.currentUser!.bio!;
    nameTextController.text = CurrentUser.instance.currentUser!.userName!;
    final userProfileHandler =
        Provider.of<ProfileHandlerViewModel>(context, listen: false);
    userProfileHandler.setUpUserDetaile();
  }

  Future<void> pickImage(ImageSource sourceOfImage) async {
    final image = await _picker.pickImage(source: sourceOfImage);

    if (image != null) {
      log("setting new image");
      Provider.of<ProfileHandlerViewModel>(context, listen: false)
          .setUserProfileImage(File(image!.path));
      setState(() {
        log("set state called");
        isNewImageSeleted = true;
      });
    }

    Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: HeadlineMedium(text: "My Profile"),
      ),
      body: Column(
        children: [
          Visibility(
              visible: isLoading,
              child: LinearProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
              )),
          const AppSpacingMedium(),
          DottedBorder(
              borderType: BorderType.Circle,
              dashPattern: const [6, 4],
              strokeCap: StrokeCap.round,
              strokeWidth: 1.45,
              color: AppColors.neutralGray,
              child: Container(
                  height: 140,
                  width: 140,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: GestureDetector(onTap: () async {
                    try {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 150,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  AppPhotoPickIconButton(
                                    buttonIcon:
                                        const Icon(Icons.photo_album_outlined),
                                    buttonText: "Gallery",
                                    buttonPressed: () async {
                                      await pickImage(ImageSource.gallery);
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                                  ),
                                  AppPhotoPickIconButton(
                                      buttonIcon:
                                          const Icon(FeatherIcons.camera),
                                      buttonText: "Camera",
                                      buttonPressed: () async {
                                        await pickImage(ImageSource.camera);
                                        setState(() {
                                          isLoading = false;
                                        });
                                      })
                                ],
                              ),
                            );
                          });
                    } catch (e) {
                      log(e.toString());
                    }
                  }, child: Consumer<ProfileHandlerViewModel>(
                      builder: (context, profileHandler, child) {
                    if (profileHandler.userProfileImage != null) {
                      return ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.file(
                            profileHandler.userProfileImage!,
                            fit: BoxFit.cover,
                          ));
                    } else {
                      return ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Icon(FeatherIcons.camera));
                    }
                  })))),
          const AppSpacingSmall(),
          TextButton(
              onPressed: () async {
                if (isNewImageSeleted) {
                  setState(() {
                    isLoading = true;
                  });
                  final compressedFile = await compressor.compressImageFile(
                      Provider.of<ProfileHandlerViewModel>(context,
                              listen: false)
                          .userProfileImage!);
                  await Provider.of<ProfileHandlerViewModel>(context,
                          listen: false)
                      .updateUserProfileImage(compressedFile);
                  setState(() {
                    isLoading = false;
                    profileImage = null;
                    //tempImageFile = null;
                  });
                } else {
                  const warningSnackbar =
                      SnackBar(content: Text("please select a new photo"));

                  ScaffoldMessenger.of(context).showSnackBar(warningSnackbar);
                }
              },
              child: Text(
                "Set Profile Image",
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).primaryColor),
              )),
          ProfileUpdateField(
            profileFieldData:
                Provider.of<ProfileHandlerViewModel>(context).userName,
            profileFieldName: "Your name",
            isEditEnabled: true,
            fieldIcon: const Icon(
              FeatherIcons.user,
              size: 26,
            ),
            onEditPressed: () {
              showUpdateDialog("Your Name", nameTextController,
                  CurrentUser.instance.currentUser!.userName!, () async {
                log("user name ${CurrentUser.instance.currentUser!.userName!}");
                if (nameTextController.text !=
                        CurrentUser.instance.currentUser!.userName! &&
                    nameTextController.text.isNotEmpty) {
                  log("New user name ${nameTextController.text}");
                  await Provider.of<ProfileHandlerViewModel>(context,
                          listen: false)
                      .updateUserName(nameTextController.text.trim());
                }
              });
            },
          ),
          ProfileUpdateField(
            profileFieldData: CurrentUser.instance.currentUser!.bio!,
            profileFieldName: "Your bio",
            isEditEnabled: true,
            fieldIcon: const Icon(
              FeatherIcons.info,
              size: 26,
            ),
            onEditPressed: () {
              showUpdateDialog("Your bio", bioTextController,
                  CurrentUser.instance.currentUser!.bio!, () async {
                if (bioTextController.text !=
                    CurrentUser.instance.currentUser!.bio!) {
                  log("New bio ${bioTextController.text}");
                  await Provider.of<ProfileHandlerViewModel>(context,
                          listen: false)
                      .updateBio(bioTextController.text.trim());
                }
              });
            },
          ),
          GestureDetector(
            onTap: () {
              getIt<AppRouter>().push(ChangeNumberRoute());
            },
            child: ProfileUpdateField(
                profileFieldData: CurrentUser.instance.currentUser!.phoneNo!,
                profileFieldName: "Your phone number",
                isEditEnabled: false,
                fieldIcon: Icon(FeatherIcons.phone)),
          ),
          Expanded(child: SizedBox()),
          AppTile(
              onTileTap: () async {
                await FirebaseAuth.instance.signOut();
                context.router.replaceAll([StartOnbordingRoute()]);
              },
              tileTitle: "Log out",
              tileIcon: Icon(FeatherIcons.logOut))
        ],
      ),
    );
  }
}

class ProfileUpdateField extends StatelessWidget {
  String profileFieldData;
  String profileFieldName;
  bool isEditEnabled;
  Widget fieldIcon;
  void Function()? onEditPressed;

  ProfileUpdateField(
      {super.key,
      required this.profileFieldData,
      required this.profileFieldName,
      required this.isEditEnabled,
      required this.fieldIcon,
      this.onEditPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width - 30,
        child: Row(
          children: [
            fieldIcon,
            const SizedBox(
              width: 5,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 30.0, 0.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width - 110,
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0),
                    child: TitleLarge(text: profileFieldData),
                  ),
                  BodyMedium(
                    text: profileFieldName,
                    align: TextAlign.start,
                  )
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            isEditEnabled
                ? GestureDetector(
                    onTap: () {
                      log("on edit pressed");
                      if (onEditPressed != null) {
                        onEditPressed!();
                      }
                    },
                    child: const Icon(FeatherIcons.edit3, size: 26))
                : const SizedBox(),
            const SizedBox(
              width: 12,
            )
          ],
        ),
      ),
    );
  }
}

// class UpdateDialog extends StatelessWidget {
//   String updatingFieldName;
//   String oldValueOfField;
//   String newValueOfField;
//   TextEditingController textController;
//   UpdateDialog(
//       {super.key,
//       required this.updatingFieldName,
//       required this.oldValueOfField,
//       required this.newValueOfField,
//       required this.textController});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           TitleMedium(text: updatingFieldName),
//           TextFormField(
//             controller: textController,
//             decoration: InputDecoration(hintText: oldValueOfField),
//           )
//         ],
//       ),
//     );
//   }
// }

class UpdateDialog extends StatelessWidget {
  String updatingFieldName;
  String oldValueOfField;
  String newValueOfField;
  TextEditingController textController;
  void Function() onSaveClick;

  UpdateDialog(
      {super.key,
      required this.onSaveClick,
      required this.updatingFieldName,
      required this.oldValueOfField,
      required this.newValueOfField,
      required this.textController});
  @override
  Widget build(BuildContext context) {
    log("on showing update dialog called");
    return AlertDialog(
      title: TitleMedium(text: updatingFieldName),
      content: TextFormField(
        controller: textController,
        decoration: const InputDecoration(hintText: "write here"),
      ),
      actions: [
        TextButton(
            onPressed: () {
              context.router.maybePopTop();
            },
            child: const Text("Cancel")),
        TextButton(onPressed: onSaveClick, child: const Text("Save")),
      ],
    );
  }
}
