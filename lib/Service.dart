import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

final String serverToken =
    'add your server token or id here';
final FirebaseMessaging fcm = new FirebaseMessaging();
final url = 'https://fcm.googleapis.com/fcm/send';

Future<Map<String, dynamic>> sendNotificationMessage(
    String token, String body, String title) async {
  await fcm.requestNotificationPermissions(const IosNotificationSettings(
      sound: true, badge: true, alert: true, provisional: false));
  await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken'
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{'body': '$body', 'title': '$title'},
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'to': '$token',
      },
    ),
  );

  final Completer<Map<String, dynamic>> completer =
      Completer<Map<String, dynamic>>();
  fcm.configure(onMessage: (Map<String, dynamic> message) async {
    completer.complete(message);
  });
  return completer.future;
}
