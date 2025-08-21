// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/compress.dart';
import 'package:samvaad/core/utils/current_user_singleton.dart';
import 'package:samvaad/core/utils/user_details_helper.dart';
import 'package:samvaad/presentation/viewmodels/profile_handler_view_model.dart';
import 'package:samvaad/presentation/widgets/app_extended_elevated_button.dart';
import 'package:samvaad/presentation/widgets/app_photo_pick_icon_button.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/spacing.dart';
import 'package:samvaad/router.gr.dart';

@RoutePage()
class AddYourPhoto extends StatefulWidget {
  const AddYourPhoto({super.key});

  @override
  State<AddYourPhoto> createState() => _AddYourPhotoState();
}

class _AddYourPhotoState extends State<AddYourPhoto> {
  final ImagePicker _picker = ImagePicker();
  final Compress compressor = Compress();
  File? tempImageFile = null;
  bool isLoading = false;
  XFile? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        AppSpacingLarge(),
        HeadlineMedium(text: "Add your photo"),
        AppSpacingSmall(),
        BodyMedium(text: "Get more people to know you better"),
        AppSpacingMedium(),
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
                        return Container(
                          height: 150,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AppPhotoPickIconButton(
                                buttonIcon: Icon(Icons.photo_album_outlined),
                                buttonText: "Gallery",
                                buttonPressed: () async {
                                  image = await _picker.pickImage(
                                      source: ImageSource.gallery);
                                  if (image != null) {
                                    setState(() {
                                      tempImageFile = File(image!.path);
                                    });
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                              AppPhotoPickIconButton(
                                  buttonIcon: Icon(FeatherIcons.camera),
                                  buttonText: "Camera",
                                  buttonPressed: () async {
                                    image = await _picker.pickImage(
                                        source: ImageSource.camera);

                                    if (image != null) {
                                      setState(() {
                                        tempImageFile = File(image!.path);
                                      });
                                    }
                                    Navigator.pop(context);
                                  })
                            ],
                          ),
                        );
                      });
                } catch (e) {
                  log("$e");
                }
              },
              child: tempImageFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.file(
                        tempImageFile!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      FeatherIcons.camera,
                      color: Theme.of(context).colorScheme.primary,
                    ),
            ),
          ),
        ),
        AppSpacingSmall(),
        TextButton(
            onPressed: () async {
              if (tempImageFile != null) {
                setState(() {
                  isLoading = true;
                });
                final compressedFile =
                    await compressor.compressImageFile(tempImageFile!);
                final profileProvider = Provider.of<ProfileHandlerViewModel>(
                    context,
                    listen: false);
                await profileProvider.updateUserProfileImage(compressedFile);
                setState(() {
                  isLoading = false;
                });
              } else {
                final warningSnackbar =
                    SnackBar(content: Text("please select image first"));

                ScaffoldMessenger.of(context).showSnackBar(warningSnackbar);
              }
            },
            child: Text(
              "upload",
              style: TextStyle(
                  fontSize: 18, color: Theme.of(context).primaryColor),
            )),
        Container(child: isLoading ? CircularProgressIndicator() : Container()),
        Expanded(child: Container()),
        AppExtendedElevatedButton(
            buttonLable: "Next",
            buttonClick: () async {
              await Provider.of<ProfileHandlerViewModel>(context, listen: false)
                  .uploadUserDetails();

              final user = await UserDetailsHelper.intance.getSingleUser(
                  FirebaseAuth.instance.currentUser!.phoneNumber!);

              CurrentUser.instance.setUser = user;
              CurrentUser.instance.setContact =
                  await UserDetailsHelper.intance.getContact();

              context.router.replaceAll([MainRoute()]);
            })
      ],
    ));
  }
}
