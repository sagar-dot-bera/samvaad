import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/data/datasources/remote/fetch_user_data_from_firebase.dart';
import 'package:samvaad/data/repositories_impl/manage_user_repository_impl.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/presentation/screens/user_data_listener.dart';
import 'package:samvaad/presentation/viewmodels/user_detail_view_model.dart';
import 'package:samvaad/presentation/viewmodels/message_manager_viewmodel.dart';
import 'package:samvaad/domain/use_case/message_manager_user_case.dart';
import 'package:samvaad/presentation/screens/message_screens/message_host_screen.dart';

@RoutePage()
class MessageWrapperScreen extends StatelessWidget implements AutoRouteWrapper {
  const MessageWrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MessagesHostScreen();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MessageManagerViewModel(
              messageManagerUserCase: MessageManagerUserCase(
                  manageNewUserRepository: ManageUserRepositoryImpl(
                      fetchUserDataFromFirebase: FetchUserDataFromFirebase(
                          firebaseFirestore: FirebaseFirestore.instance)))),
        ),
        StreamProvider<List<User>>(
            create: (context) => UserDetailsViewModel.instance
                .setUserWhoKnowCurrentUserRealTime(),
            initialData: List<User>.empty(growable: true))
      ],
      child: Column(
        children: [UserDataListener(), Expanded(child: this)],
      ),
    );
  }
}
