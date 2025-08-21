import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/core/utils/compress.dart';
import 'package:samvaad/core/utils/current_user_singleton.dart';
import 'package:samvaad/domain/entities/group.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/presentation/viewmodels/user_detail_view_model.dart';
import 'package:samvaad/presentation/widgets/app_extended_elevated_button.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/select_group_member_cell.dart';
import 'package:samvaad/router.gr.dart';

@RoutePage()
class NewGroupScreen extends StatefulWidget {
  final bool toAddMember;
  const NewGroupScreen({super.key, required this.toAddMember});

  @override
  State<NewGroupScreen> createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends State<NewGroupScreen> {
  List<User> selectedUser =
      List.from([CurrentUser.instance.currentUser], growable: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeadlineMedium(text: "Add member"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Consumer<UserDetailsViewModel>(
              builder: (context, currentUserDetail, child) {
            if (currentUserDetail.userWhoKnowCurrentUser.isNotEmpty) {
              final member = currentUserDetail.groupInfoInView != null
                  ? currentUserDetail
                      .getMemberToAdd(currentUserDetail.groupInfoInView!.member)
                  : currentUserDetail.userWhoKnowCurrentUser;
              if (member.isEmpty) {
                return Center(
                  child: Text("No member to add"),
                );
              } else {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedUser.contains(member[index])) {
                            selectedUser.removeWhere((user) {
                              return user.phoneNo ==
                                  currentUserDetail
                                      .userWhoKnowCurrentUser![index].phoneNo;
                            });
                          } else {
                            selectedUser.add(currentUserDetail
                                .userWhoKnowCurrentUser
                                .firstWhere(
                                    (e) => e.phoneNo == member[index].phoneNo));
                          }
                        });
                      },
                      child: selectedUser.contains(member[index])
                          ? SelectGroupMemberCell(
                              userDetail: member[index], isSelected: true)
                          : SelectGroupMemberCell(
                              userDetail: member[index], isSelected: false),
                    );
                  },
                  itemCount: member.length,
                );
              }
            } else {
              return SizedBox(child: BodySmall(text: "No data found"));
            }
          }),
          Expanded(child: SizedBox()),
          selectedUser.isNotEmpty
              ? AppExtendedElevatedButton(
                  buttonLable: widget.toAddMember ? "Add" : "Next",
                  buttonClick: () async {
                    if (widget.toAddMember) {
                      final provider = Provider.of<UserDetailsViewModel>(
                          context,
                          listen: false);

                      await provider.addMember(
                          selectedUser
                              .map((e) => GroupMember(
                                  memberId: e.phoneNo, isAdmin: false))
                              .toList(),
                          provider.groupInfoInView!.chatId);
                    } else {
                      context.router.push(
                          CreateNewGroupeRoute(groupMemebers: selectedUser));
                    }
                  })
              : SizedBox()
        ],
      ),
    );
  }
}
