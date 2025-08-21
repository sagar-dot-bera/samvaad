import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/presentation/viewmodels/user_detail_view_model.dart';

class UserDataListener extends StatefulWidget {
  const UserDataListener({super.key});

  @override
  State<UserDataListener> createState() => _UserDataListenerState();
}

class _UserDataListenerState extends State<UserDataListener> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userDetailProvider = Provider.of<UserDetailsViewModel>(context);
    final detailsOfUser = Provider.of<List<User>>(context);
    log("details of user ${detailsOfUser.length}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (detailsOfUser != userDetailProvider.userWhoKnowCurrentUser) {
        userDetailProvider.userWhoKnowCurrentUser = detailsOfUser;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
