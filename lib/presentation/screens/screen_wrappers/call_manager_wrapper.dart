import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/data/repositories_impl/call_manager_repository_impl.dart';
import 'package:samvaad/domain/use_case/call_manager_use_case.dart';
import 'package:samvaad/presentation/screens/call_screens/call_main_screen.dart';
import 'package:samvaad/presentation/viewmodels/call_manager_view_model.dart';

@RoutePage()
class CallManagerWrapperScreen extends StatelessWidget
    implements AutoRouteWrapper {
  const CallManagerWrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CallMainScreen();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CallManagerViewModel(
          callManagerUseCase: CallManagerUseCase(
              callManagerRepository: CallManagerRepositoryImpl())),
      child: this,
    );
  }
}
