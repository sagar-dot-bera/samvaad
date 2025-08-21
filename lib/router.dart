import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samvaad/router.gr.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@AutoRouterConfig(replaceInRouteName: "Screen|Page,Route")
class AppRouter extends RootStackRouter {
  AppRouter() : super(navigatorKey: navigatorKey);
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(
            path: '/startOnbording',
            page: StartOnbordingRoute.page,
            children: [
              AutoRoute(path: '', page: OnBordingRoute.page),
              AutoRoute(path: 'verifyNumber', page: VerifyPhoneNumber.page),
              AutoRoute(path: 'verifyCode', page: VerificationCodeRoute.page),
            ]),
        AutoRoute(page: CreateProfileRoute.page, children: [
          AutoRoute(path: '', page: SetupNameRoute.page),
          AutoRoute(path: 'addYourPhoto', page: AddYourPhoto.page),
        ]),
        AutoRoute(path: '/mainPage', page: MainRoute.page, children: [
          AutoRoute(page: MessageWrapperRoute.page, children: [
            AutoRoute(path: '', page: MessagesMainRoute.page),
            AutoRoute(path: 'addNewMessage', page: NewMessage.page),
            AutoRoute(
                path: "otherUserProfile", page: OtherUserProfileRoute.page),
            AutoRoute(
              path: 'chatScreen',
              page: SingelChatRouteWrapperRoute.page,
            ),
            AutoRoute(
              path: "groupInfoScreen",
              page: GroupRoute.page,
            ),
            AutoRoute(page: GroupChatChangeNotifierWrapperRoute.page),
            AutoRoute(path: 'imagePreview', page: ImagePreviewRoute.page),
            AutoRoute(path: 'videoPreview', page: SendVideoRoute.page),
            AutoRoute(path: 'filePreview', page: SendFileRoute.page),
            AutoRoute(path: 'videoPlayer', page: VideoPlayerRoute.page),
            AutoRoute(path: 'newGroupScreen', page: NewGroupRoute.page),
            AutoRoute(
                path: 'createGroupScreen', page: CreateNewGroupeRoute.page),
            AutoRoute(path: "contactPreview", page: SendContactRoute.page),
            AutoRoute(path: "viewImage", page: ViewImageRoute.page),
            AutoRoute(path: "ViewPdf", page: ViewPdfRoute.page),
            AutoRoute(path: "LocationLocator", page: LocationViewRoute.page),
            AutoRoute(path: "audioPreview", page: SendAudioRoute.page),
            AutoRoute(path: "markedMessage", page: MarkedMessageRoute.page),
            AutoRoute(path: "userInfoScreen", page: UserInfoRoute.page),
            AutoRoute(path: "forwardMessageScreen", page: ForwardMessage.page),
            AutoRoute(path: "audioCallRoute", page: AudioCallWrapperRoute.page)
          ]),
          AutoRoute(
              path: 'callContact',
              page: CallManagerWrapperRoute.page,
              children: [
                AutoRoute(path: '', page: CallRoute.page),
                AutoRoute(path: 'selectContact', page: SelectContact.page),
                AutoRoute(path: 'audioCall', page: AudioCallWrapperRoute.page)
              ]),
          AutoRoute(page: MyProfileWrapperRoute.page, children: [
            AutoRoute(path: '', page: ProfileRoute.page),
            AutoRoute(path: 'myProfile', page: MyProfileRoute.page),
            AutoRoute(path: "notification", page: NotificationRoute.page),
            AutoRoute(path: 'chatSetting', page: ChatSettingRoute.page),
            AutoRoute(path: "storageSetting", page: StorageSetting.page),
            AutoRoute(path: "pickSound", page: PickSoundRoute.page),
            AutoRoute(path: "FAQs", page: FrequentlyAskedQuestionRoute.page),
            AutoRoute(path: "FAQanswer", page: FAQAnswerRoute.page),
            AutoRoute(path: "Privacypolicy", page: PrivacyPolicyRoute.page),
            AutoRoute(path: "changeNumber", page: ChangeNumberRoute.page),
            AutoRoute(
                path: "phoneVerficationRoute",
                page: VerificationRouteWrapper.page),
            AutoRoute(
                path: "verificationCode",
                page: VerificationCodeWrapperRoute.page),
            AutoRoute(
                path: "updatingNumberAndData",
                page: UpdatingNumberAndDataRoute.page),
            AutoRoute(
                path: "authWrapper",
                page: PhoneAuthRouteWrapper.page,
                children: [
                  AutoRoute(path: "", page: ChangeNumberRoute.page),
                  AutoRoute(
                      path: "verifyPhoneNumber", page: VerifyPhoneNumber.page),
                  AutoRoute(
                      path: "verificationCode",
                      page: VerificationCodeRoute.page),
                  AutoRoute(
                      path: "updatingNumberAndData",
                      page: UpdatingNumberAndDataRoute.page),
                ],
                maintainState: true),
            AutoRoute(
                path: "changeWallpaperPreview",
                page: ChangeWallpaperPreviewRoute.page),
          ]),
          AutoRoute(path: 'contact', page: ContactHostRoute.page, children: [
            AutoRoute(path: '', page: ContactRoute.page),
            AutoRoute(
              path: 'chatScreen',
              page: SingelChatRouteWrapperRoute.page,
            ),
            AutoRoute(path: "invite", page: InviteFriendRoute.page),
            AutoRoute(path: "addContact", page: AddToContactRoute.page)
          ]),
        ]),
      ];
}
