import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/core/services/fetch_files.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/compress.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/main.dart';
import 'package:samvaad/presentation/viewmodels/user_detail_view_model.dart';
import 'package:samvaad/presentation/widgets/app_contact_cell_status.dart';
import 'package:samvaad/presentation/widgets/app_divider.dart';
import 'package:samvaad/presentation/widgets/app_photo_pick_icon_button.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/app_text_field.dart';
import 'package:samvaad/presentation/widgets/spacing.dart';
import 'package:samvaad/router.dart';
import 'package:samvaad/router.gr.dart';

@RoutePage()
class CreateNewGroupeScreen extends StatefulWidget {
  List<User> groupMemebers;
  CreateNewGroupeScreen({super.key, required this.groupMemebers});

  @override
  State<CreateNewGroupeScreen> createState() => _CreateNewGroupeScreenState();
}

class _CreateNewGroupeScreenState extends State<CreateNewGroupeScreen> {
  final ImagePicker _picker = ImagePicker();
  final Compress compressor = Compress();
  String fileDownloadUrl = '';
  bool isLoading = false;
  File? tempImageFile;
  TextEditingController groupNameTextController = TextEditingController();
  XFile? image;

  Future<void> pickImage(ImageSource source) async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        tempImageFile = File(image!.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: HeadlineMedium(text: "New Group"),
        actions: [
          IconButton(
              onPressed: () async {
                if (groupNameTextController.text != '' &&
                    tempImageFile != null &&
                    fileDownloadUrl != '') {
                  setState(() {
                    isLoading = true;
                  });
                  await Provider.of<UserDetailsViewModel>(context,
                          listen: false)
                      .setNewGroupDetails(
                          groupNameTextController.text.toString().trim(),
                          fileDownloadUrl,
                          widget.groupMemebers);
                  setState(() {
                    isLoading = false;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Please upload profile pic and add name")));
                }
              },
              icon: Icon(FeatherIcons.check))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: isLoading,
              child: LinearProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
            ),
            AppSpacingSmall(),
            AppSpacingSmall(),
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
                    // final compressedFile =
                    //     await compressor.compressImageFile(tempImageFile!);
                    String tempUrl = await Provider.of<UserDetailsViewModel>(
                            context,
                            listen: false)
                        .uploadImage(tempImageFile!);
                    setState(() {
                      fileDownloadUrl = tempUrl;
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
            AppSpacingSmall(),
            AppTextField(
                hint: "Group name",
                leadingIcon: Icon(FeatherIcons.users),
                validate: (value) {},
                control: groupNameTextController,
                keybordType: TextInputType.text),
            AppSpacingMedium(),
            AppDivider(),
            AppSpacingSmall(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: TitleLarge(
                      text: "${widget.groupMemebers.length} Member")),
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ContactWithStatusCell(user: widget.groupMemebers[index]);
              },
              itemCount: widget.groupMemebers.length,
            )
          ],
        ),
      ),
    );
  }
}
