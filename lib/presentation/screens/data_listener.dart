import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/presentation/viewmodels/user_detail_view_model.dart';

class DataListener extends StatefulWidget {
  const DataListener({super.key});

  @override
  State<DataListener> createState() => _DataListenerState();
}

class _DataListenerState extends State<DataListener> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final updatedParticipantAndGroupList = Provider.of<List<Object>>(context);
    log("fetched data ${updatedParticipantAndGroupList.length}");
    final detailsOfUser = Provider.of<List<User>>(context);
    log("user detail ${detailsOfUser.length}");
    final userDetailProvider =
        Provider.of<UserDetailsViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userDetailProvider.participantAndGroups !=
          updatedParticipantAndGroupList) {
        userDetailProvider.participantAndGroupSetter =
            updatedParticipantAndGroupList;
      }
      if (userDetailProvider.userWhoKnowCurrentUser != detailsOfUser) {
        log("setting user detail");
        userDetailProvider.userWhoKnowCurrentUserSetter = detailsOfUser;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
