import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/presentation/screens/main_screen.dart';
import 'package:samvaad/presentation/viewmodels/user_detail_view_model.dart';

@RoutePage()
class MainScreenWrapperScreen extends StatelessWidget
    implements AutoRouteWrapper {
  const MainScreenWrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScreen();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => UserDetailsViewModel.instance),
        StreamProvider<List<Object>>(
            create: (context) =>
                UserDetailsViewModel.instance.getParticipantAndGroup(),
            initialData: List<Object>.empty(growable: true)),
        StreamProvider<List<User>>(
            create: (context) => UserDetailsViewModel.instance
                .setUserWhoKnowCurrentUserRealTime(),
            initialData: List<User>.empty(growable: true))
      ],
      child: this,
    );
  }
}
