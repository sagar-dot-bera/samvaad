import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/presentation/screens/profile_screens/setting_screens/notification_screen.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/avatar_view.dart';
import 'package:samvaad/presentation/widgets/profile_avatar_widget.dart';

@RoutePage()
class OtherUserProfileScreen extends StatelessWidget {
  final User userDetail;
  const OtherUserProfileScreen({super.key, required this.userDetail});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: ProfileCell(userDetail: userDetail),
          expandedHeight: 200,
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [ListTile()],
          ),
        )
      ],
    );
  }
}

class ProfileCell extends StatelessWidget {
  final User userDetail;
  const ProfileCell({super.key, required this.userDetail});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.all(0.0),
        minVerticalPadding: 0.0,
        leading: ProfileAvatarWidget(
            profileUrl: userDetail.profilePhotoUrl ?? "",
            profilePictureId: userDetail.phoneNo!,
            name: userDetail.userName ?? "User"),
        title: HeadlineMedium(
          text: userDetail.userName!,
          alig: TextAlign.start,
        ));
  }
}
