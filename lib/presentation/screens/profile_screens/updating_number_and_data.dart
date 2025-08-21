import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/core/utils/current_user_singleton.dart';
import 'package:samvaad/core/utils/user_records.dart';
import 'package:samvaad/main.dart';
import 'package:samvaad/presentation/viewmodels/profile_handler_view_model.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/router.dart';
import 'package:samvaad/router.gr.dart';

@RoutePage()
class UpdatingNumberAndDataScreen extends StatefulWidget {
  const UpdatingNumberAndDataScreen({super.key});

  @override
  State<UpdatingNumberAndDataScreen> createState() =>
      _UpdatingNumberAndDataScreenState();
}

class _UpdatingNumberAndDataScreenState
    extends State<UpdatingNumberAndDataScreen> {
  bool isUpdateDone = false;
  @override
  void initState() {
    super.initState();
    Provider.of<ProfileHandlerViewModel>(context, listen: false)
        .changeMobileNumber(FirebaseAuth.instance.currentUser!.phoneNumber!,
            CurrentUser.instance.currentUser!.phoneNo!)
        .whenComplete(() {
      setState(() {
        setState(() {
          isUpdateDone = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeadlineMedium(text: "Updating number"),
      ),
      body: Center(
          child: isUpdateDone
              ? TextButton(
                  onPressed: () async {
                    await UserRecord.instance.addNumberToOldNumberList(
                        CurrentUser.instance.currentUser!.phoneNo!);
                    getIt<AppRouter>().replaceAll([MainRoute()]);
                  },
                  child: Text("Done"))
              : CircularProgressIndicator()),
    );
  }
}
