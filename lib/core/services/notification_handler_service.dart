import 'dart:convert';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:samvaad/core/utils/app_enums.dart';
import 'package:samvaad/domain/entities/call.dart';
import 'package:samvaad/domain/entities/rtc_request.dart';

import 'package:samvaad/domain/entities/user.dart' as my_app;
import 'package:samvaad/router.dart';
import 'package:samvaad/router.gr.dart';

class NotificationHandlerService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initNotifications() {
    var androidSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initSettings = InitializationSettings(android: androidSettings);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
      log("did receive response invoked");
      if (response.actionId == "ANSWER") {
        log("Answer button pressed");
        String offerId = response.payload!;

        final offerMap = await FirebaseFirestore.instance
            .collection('call_central')
            .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
            .collection("offers")
            .doc(offerId)
            .get();
        log("offer sent by user $offerMap");

        final offer = RtcRequestAndResult.fromJson(offerMap.data()!);
        my_app.User user = my_app.User(
            phoneNo: "+918808899099", userName: "jhon", profilePhotoUrl: "");
        Call caller = Call(
            withUser: user,
            callType: CallType.incoming,
            timeStamp: DateTime.now().toString());

        navigatorKey.currentContext?.navigateTo(
            AudioCallWrapperRoute(withUser: caller, offerFromCaller: offer));
        log("offer ${offer.fromUser}");
      } else if (response.actionId == "DECLINE") {
        log("Declaine button pressed");
      }
    });
  }

  void createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'samvaad_call_notification',
      'High Priority Notifications',
      description:
          'This channel is used for showing notification for samvaad app',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> notificationNavigation(RemoteMessage newMessage) async {
    try {
      log("navigation from notification invoked");
      if (newMessage.data.containsKey("screen")) {
        String screenName = newMessage.data["screen"] as String;

        if (screenName == "/chatScreen") {
          log("navigating to chat screen");
          log("sender detail ${newMessage.data["senderDetail"]}");
          my_app.User user =
              my_app.User.fromJson(jsonDecode(newMessage.data["senderDetail"]));
          navigatorKey.currentContext
              ?.pushRoute(SingelChatRouteWrapperRoute(userWithDetails: user));
        } else if (screenName == "/callScreen") {
          showNotification(newMessage);
        }
      }
    } catch (e) {
      log("Error in navigating to screen $e");
    }
  }

  void showNotification(RemoteMessage message) async {
    var androidDetails = const AndroidNotificationDetails(
      'samvaad_call_notification',
      'High Priority Notification',
      importance: Importance.max,
      priority: Priority.max,
      timeoutAfter: 60000,
      autoCancel: false,
      actions: [
        AndroidNotificationAction('ANSWER', 'Answer',
            showsUserInterface: true, titleColor: Colors.green),
        AndroidNotificationAction('DECLINE', 'Decline', titleColor: Colors.red),
      ],
    );

    var notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      message.data['senderName'], // Notification title from FCM
      message.data['offerFrom'], // Notification body from FCM
      notificationDetails,
      payload: message.data['offerId'], // Pass action (button click handling)
    );
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    showNotification(message);
  }
}
