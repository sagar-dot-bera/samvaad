import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:samvaad/core/services/background_message_manager.dart';
import 'package:samvaad/core/services/callHandler.dart';
import 'package:samvaad/core/services/notification_handler_service.dart';
import 'package:samvaad/core/services/signaling.dart';
import 'package:samvaad/core/themes/grainy_background.dart';
import 'package:samvaad/core/utils/current_user_setting.dart';
import 'package:samvaad/core/utils/current_user_singleton.dart';
import 'package:samvaad/core/utils/hive_handler.dart';
import 'package:samvaad/core/utils/size.dart';
import 'package:samvaad/core/utils/user_records.dart';
import 'package:samvaad/core/utils/user_details_helper.dart';
import 'package:samvaad/core/utils/user_setting.dart';
import 'package:samvaad/domain/entities/call.dart';
import 'package:samvaad/domain/entities/call_log.dart';
import 'package:samvaad/domain/entities/failed_message.dart';
import 'package:samvaad/domain/entities/image.dart';
import 'package:samvaad/domain/entities/local_file.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/domain/entities/pending_message.dart';

import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/presentation/screens/message_screens/single_chat_screen.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/spacing.dart';

import 'package:samvaad/router.dart';
import 'package:samvaad/router.gr.dart';

import 'core/themes/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:samvaad/firebase_options.dart';

Future<void> handelBackgroundNotification(RemoteMessage message) async {
  NotificationHandlerService notificationHandlerService =
      NotificationHandlerService();

  notificationHandlerService.showNotification(message);
}

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(LocalImageAdapter());
  Hive.registerAdapter(LocalFileAdapter());
  Hive.registerAdapter(MessageAdapter());
  Hive.registerAdapter(CallLogAdapter());
  Hive.registerAdapter(CallAdapter());
  Hive.registerAdapter(MessageVisibilityAdapter());
  Hive.registerAdapter(PendingMessageAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(UserSettingAdapter());
  Hive.registerAdapter(UserStatusAdapter());
  Hive.registerAdapter(ExtraInfoAdapter());
  Hive.registerAdapter(FailedMessageAdapter());

  await Hive.openBox<PendingMessage>("pendingMessages");

  Hive.box<PendingMessage>("pendingMessages").clear();
  await Hive.openBox<CallLog>("call_log");

  await Hive.openBox<LocalFile>("local_data_v2");
  await Hive.box<LocalFile>("local_data_v2").clear();

  CurrentUserSetting.instance.setCurrentUser =
      await CurrentUserSetting.fetchUserSetting();

  NotificationHandlerService notificationHandlerService =
      NotificationHandlerService();
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      notificationHandlerService.notificationNavigation(message);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    notificationHandlerService.notificationNavigation(message);
  });
  notificationHandlerService.initNotifications();
  FirebaseMessaging.onBackgroundMessage(handelBackgroundNotification);
  getIt.registerSingleton<AppRouter>(AppRouter());
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
  }

  final router = getIt<AppRouter>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router.config(),
      theme: AppTheme.theme,
      builder: (context, child) {
        log("builder executed");
        return GrainyBackground(child: child!);
      },
    );
  }
}

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  bool _isUserLoggedIn = false;
  Future<void> fetchUserDetails() async {
    UserDetailsHelper getUserDetailsHelper = UserDetailsHelper();

    final user = await getUserDetailsHelper
        .getSingleUser(FirebaseAuth.instance.currentUser!.phoneNumber!);

    CurrentUser.instance.setUser = user;
    CurrentUser.instance.setContact = await getUserDetailsHelper.getContact();
    UserRecord.instance.blockedUser =
        await HiveHandler.intance.fetchRecord("blockedRecord");
    UserRecord.instance.deletedRecords =
        await HiveHandler.intance.fetchRecord("deletedRecord");
    UserRecord.instance.priyasuchi =
        await HiveHandler.intance.fetchRecord("priyasuchi");
    UserRecord.instance.markedMessage =
        await HiveHandler.intance.fetchMarkedMessage("markedMessage");
    UserRecord.instance.oldNumber =
        await HiveHandler.intance.fetchMarkedMessage("oldNumber");

    log("number of blocked user ${UserRecord.instance.blockedUser.entries}");
    log("deleted chat ${UserRecord.instance.deletedRecords.entries}");
    log("priyasuchi ${UserRecord.instance.priyasuchi.entries}");
    log("number of marked message ${UserRecord.instance.markedMessage.entries}");
    log("Number of contact fetched is ${CurrentUser.instance.currentUserContacts!.length}");
  }

  Future<void> setUserIfLoggedIn() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await fetchUserDetails();
      UserDetailsHelper getUserDetailsHelper = UserDetailsHelper();

      await getUserDetailsHelper.setFcmTokken();
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    if (FirebaseAuth.instance.currentUser != null) {
      log("setting user login status");
      _isUserLoggedIn = true;
      //setCurrentUser();

      UserDetailsHelper.intance.updateUserStatus(UserStatus(
          isOnline: true,
          isTyping: false,
          lastSeenTimeStamp: DateTime.now().toIso8601String()));
    } else {
      _isUserLoggedIn = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (FirebaseAuth.instance.currentUser != null) {
      if (state == AppLifecycleState.detached) {
        Signaling.instance.removeListners();
        log("app detached");
        log("user login status $_isUserLoggedIn");
        FlutterBackgroundService().invoke("stopService");
        log("is service running ${BackgroundMessageManager.instance.isRunning}");
        if (_isUserLoggedIn) {
          UserDetailsHelper.intance.updateUserStatus(UserStatus(
              isOnline: false,
              lastSeenTimeStamp: DateTime.now().toIso8601String()));
        }
      } else if (state == AppLifecycleState.resumed) {
        CallHandler.instance.initializeCall();
        BackgroundMessageManager.instance.startService();
        log("app resumed");
        log("user login status $_isUserLoggedIn");
        log("is service running ${BackgroundMessageManager.instance.isRunning}");
        if (_isUserLoggedIn) {
          UserDetailsHelper.intance.updateUserStatus(UserStatus(
              isOnline: true,
              isTyping: false,
              lastSeenTimeStamp: DateTime.now().toIso8601String()));
        }
      } else if (state == AppLifecycleState.inactive) {
        log("app inactive");
        log("user login status $_isUserLoggedIn");
        Signaling.instance.removeListners();
        FlutterBackgroundService().invoke("stopService");
        log("is service running ${BackgroundMessageManager.instance.isRunning}");
        if (_isUserLoggedIn) {
          UserDetailsHelper.intance.updateUserStatus(UserStatus(
              isOnline: false,
              isTyping: false,
              lastSeenTimeStamp: DateTime.now().toIso8601String()));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FutureBuilder(
              future: setUserIfLoggedIn(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (_isUserLoggedIn) {
                    Timer(Duration(seconds: 3), () {
                      context.router.replaceAll([const MainRoute()]);
                    });
                  } else {
                    Timer(Duration(seconds: 3), () {
                      context.router.replaceAll([const StartOnbordingRoute()]);
                    });
                  }
                }

                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AppSpacingLarge(),
                    Lottie.asset(
                        "lib/assets/animation/loading_animation_two.json",
                        height: SizeOf.intance.getWidth(context, 0.60),
                        width: SizeOf.intance.getWidth(context, 0.60)),
                    AppSpacingLarge(),
                    AppSpacingLarge(),
                    AppSpacingMedium(),
                    AppSpacingMedium(),
                    TitleLarge(text: "Samvaad")
                  ],
                );
              })),
    );
  }
}

class AppPreview extends StatelessWidget {
  const AppPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(child: ChatScreen()),
    ));
  }
}
