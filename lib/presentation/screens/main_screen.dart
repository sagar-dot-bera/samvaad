// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:samvaad/core/services/background_message_manager.dart';
import 'package:samvaad/core/services/callHandler.dart';
import 'package:samvaad/core/services/rington_plyer.dart';
import 'package:samvaad/core/services/userStatus.dart';
import 'package:samvaad/core/utils/audio_loader.dart';
import 'package:samvaad/core/utils/current_user_singleton.dart';
import 'package:samvaad/core/utils/user_details_helper.dart';
import 'package:samvaad/presentation/screens/data_listener.dart';
import 'package:samvaad/presentation/viewmodels/user_detail_view_model.dart';
import 'package:samvaad/router.gr.dart';
import 'package:samvaad/domain/entities/user.dart' as my_app;

@RoutePage()
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  UserStatusService userStatusService = UserStatusService();
  AppLifecycleState? appLifecycleState;
  bool isListnerSet = false;

  @override
  void initState() {
    log("call receiver set");
    super.initState();
    RingtonPlayer.intance.setAudioPlyer();
    CallHandler.instance.initializeCall();
    BackgroundMessageManager.instance.initService();
    AudioLoader.intance.preloadAudio();
    setUserIfLoggedIn();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (isListnerSet) return;
    isListnerSet = true;
    if (FirebaseAuth.instance.currentUser != null) {
      if (state == AppLifecycleState.detached) {
        log("app detached from system");
        userStatusService.exeSetOffline();
        FlutterBackgroundService().invoke("stopService");
      } else if (state == AppLifecycleState.resumed) {
        log("app resumed setting user status to online");
        log("is service running ${BackgroundMessageManager.instance.isRunning}");
        userStatusService.exeSetOnline();
        BackgroundMessageManager.instance.startService();
      }
    }
  }

  Future<bool> fetchUserDetails() async {
    UserDetailsHelper getUserDetailsHelper = UserDetailsHelper();

    final user = await getUserDetailsHelper
        .getSingleUser(FirebaseAuth.instance.currentUser!.phoneNumber!);

    CurrentUser.instance.setUser = user;
    CurrentUser.instance.setContact = await getUserDetailsHelper.getContact();
    log("Number of contact fetched is ${CurrentUser.instance.currentUserContacts!.length}");
    return true;
  }

  Future<bool> setUserIfLoggedIn() async {
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
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => UserDetailsViewModel.instance),
        StreamProvider<List<Object>>(
            create: (context) =>
                UserDetailsViewModel.instance.getParticipantAndGroup(),
            initialData: List<Object>.empty(growable: true)),
        StreamProvider<List<my_app.User>>(
          create: (context) {
            log("new value returend from user list");
            return UserDetailsViewModel.instance
                .setUserWhoKnowCurrentUserRealTime();
          },
          initialData: List<my_app.User>.empty(growable: true),
        ),
      ],
      child: Column(
        children: [
          DataListener(),
          Expanded(
            child: AutoTabsRouter(
              routes: const [
                MessageWrapperRoute(),
                ContactHostRoute(),
                CallManagerWrapperRoute(),
                MyProfileWrapperRoute()
              ],
              transitionBuilder: (context, child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
              builder: (context, child) {
                final tabsRouter = AutoTabsRouter.of(context);

                bool showBottomNavBar = true;

                final hideNavBarScreenList = [
                  NewMessage.name,
                  SelectContact.name,
                  AudioCall.name,
                  AudioCallWrapperRoute.name,
                  ImagePreviewRoute.name,
                  ChatSettingRoute.name,
                  ChangeWallpaperPreviewRoute.name,
                  MyProfileRoute.name,
                  DemoRoute.name,
                  SendVideoRoute.name,
                  VideoPlayerRoute.name,
                  SendContactRoute.name,
                  ViewImageRoute.name,
                  ViewPdfRoute.name,
                  SendFileRoute.name,
                  SendAudioRoute.name,
                  NewGroupRoute.name,
                  CreateNewGroupeRoute.name,
                  SingelChatRouteWrapperRoute.name,
                  GroupChatChangeNotifierWrapperRoute.name,
                  NotificationRoute.name,
                  PickSoundRoute.name,
                  FrequentlyAskedQuestionRoute.name,
                  FAQAnswerRoute.name,
                  PrivacyPolicyRoute.name,
                  InviteFriendRoute.name,
                  StorageSetting.name,
                  GroupRoute.name,
                  AddToContactRoute.name,
                  MarkedMessageRoute.name,
                  LocationViewRoute.name,
                  ChangeNumberRoute.name,
                  UpdatingNumberAndDataRoute.name,
                  PhoneAuthRouteWrapper.name,
                  VerifyPhoneNumber.name,
                  VerificationCodeRoute.name,
                  VerificationRouteWrapper.name,
                  VerificationCodeWrapperRoute.name,
                  UserInfoRoute.name
                ];

                if (hideNavBarScreenList.contains(context.topRouteMatch.name)) {
                  log("hiding bottom app bar");
                  showBottomNavBar = false;
                } else {
                  log("${tabsRouter.current.path}");
                  log("not executed");
                }
                return Scaffold(
                    body: child,
                    bottomNavigationBar: showBottomNavBar
                        ? BottomNavigationBar(
                            currentIndex: tabsRouter.activeIndex,
                            onTap: (value) {
                              tabsRouter.setActiveIndex(value);
                            },
                            type: BottomNavigationBarType.fixed,
                            items: const [
                              BottomNavigationBarItem(
                                  icon: Icon(
                                    Remix.message_3_line,
                                  ),
                                  label: "Messages"),
                              BottomNavigationBarItem(
                                  icon: Icon(Remix.user_line),
                                  label: "Contacts"),
                              BottomNavigationBarItem(
                                  icon: Icon(Remix.phone_line), label: "Calls"),
                              BottomNavigationBarItem(
                                  icon: Icon(Remix.profile_line),
                                  label: "Profile")
                            ],
                          )
                        : SizedBox(
                            height: 0,
                            width: 0,
                          ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
