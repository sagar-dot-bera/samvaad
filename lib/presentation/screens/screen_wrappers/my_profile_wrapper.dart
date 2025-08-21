import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/data/datasources/remote/upload_profile_data_to_firebase.dart';
import 'package:samvaad/data/repositories_impl/user_profile_handler_details_repository.dart';
import 'package:samvaad/domain/use_case/user_profile_handler_use_case.dart';
import 'package:samvaad/presentation/screens/profile_screens/my_profile_screen.dart';
import 'package:samvaad/presentation/screens/profile_screens/profile_main_screen.dart';
import 'package:samvaad/presentation/screens/profile_screens/profile_screen.dart';
import 'package:samvaad/presentation/viewmodels/profile_handler_view_model.dart';

@RoutePage()
class MyProfileWrapperScreen extends StatelessWidget
    implements AutoRouteWrapper {
  const MyProfileWrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileMainScreen();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileHandlerViewModel(
          setupUserProfileDetailsUseCase: ProfileDetailHandlerUseCase(
              setUpProfileDetailsRepository:
                  ProfileDetailsHandlerRepositoryImpl(
                      profileDataHandler: HandelProfileDataToFirebase(
                          firestore: FirebaseFirestore.instance,
                          firebaseStorage: FirebaseStorage.instance)))),
      child: this,
    );
  }
}
