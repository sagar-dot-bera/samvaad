import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/data/datasources/remote/upload_profile_data_to_firebase.dart';
import 'package:samvaad/data/repositories_impl/user_profile_handler_details_repository.dart';
import 'package:samvaad/domain/use_case/user_profile_handler_use_case.dart';
import 'package:samvaad/presentation/viewmodels/profile_handler_view_model.dart';

@RoutePage()
class CreateProfileScreen extends StatelessWidget {
  const CreateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ProfileHandlerViewModel(
            setupUserProfileDetailsUseCase: ProfileDetailHandlerUseCase(
                setUpProfileDetailsRepository:
                    ProfileDetailsHandlerRepositoryImpl(
                        profileDataHandler: HandelProfileDataToFirebase(
                            firestore: FirebaseFirestore.instance,
                            firebaseStorage: FirebaseStorage.instance)))),
        child: AutoRouter());
  }
}
