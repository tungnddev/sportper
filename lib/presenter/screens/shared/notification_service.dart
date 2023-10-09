import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sportper/presenter/screens/shared/rx_bus_service.dart';
import 'package:sportper/utils/definded/const.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._privateConstructor();

  static final NotificationService instance =
      NotificationService._privateConstructor();

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late NotificationDetails platformChannelSpecifics;

  Future init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('launcher_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: null,
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('high_importance_channel', 'High Importance Notifications',
            channelDescription: 'Sportper channel notification',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            styleInformation: BigTextStyleInformation(''),
            color: Colors.white);
    platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) async {
      RxBusService().add(RxBusName.HANDLE_FCM_NOTIFICATION,
          value: json.decode(payload ?? '{}'));
    });
    tz.initializeTimeZones();
    // tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  // Future show() async {
  //   await flutterLocalNotificationsPlugin.show(
  //       0,
  //       'plain title plain title  plain title plain title plain title plain title plain title plain title plain title plain title plain title',
  //       'plain body plain bodyplain bodyplain bodyplain bodyplain bodyplain bodyplain bodyplain bodyplain bodyplain bodyplain bodyplain bodyplain body',
  //       platformChannelSpecifics,
  //       payload: 'item x');
  // }

  Future show(String title, String body, Map<String, dynamic> payload) async {
    await flutterLocalNotificationsPlugin.show(
        Random().nextInt(100000000),
        title,
        body,
        platformChannelSpecifics,
        payload: json.encode(payload));
  }

  Future scheduleGameNotification(
      String title, String message, DateTime dateTime, String gameId) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        Random().nextInt(100000000),
        title,
        message,
        tz.TZDateTime.from(dateTime, tz.local),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: json.encode({
          NotificationParamsConst.TYPE: NotificationTypeConst.GAME_NOTIFICATION,
          NotificationParamsConst.GAME_ID: gameId
        }));
  }

  Future cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
