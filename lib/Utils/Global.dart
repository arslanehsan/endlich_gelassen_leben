import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lpat/Objects/BotoomMenuItem.dart';
import 'package:lpat/Objects/CustomerObject.dart';

String shareMessage = '';
CustomerObject customer;
String supportEmail = 'wbpaterok@gmail.com, info@paterok.de';
String appName = 'Endlich Gelassen Leben';

void showNormalToast({@required String msg}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
//          timeInSecForIos: 1,
      backgroundColor: Color(0xff666666),
      textColor: Colors.white,
      fontSize: 16.0);
}

List<BottomMenuItem> bottomItems = [
  BottomMenuItem(
    label: 'Home',
    image: 'images/home.png',
    imageInactive: 'images/home_inactive.png',
  ),
  BottomMenuItem(
    label: 'Nachrichten',
    image: 'images/notification.png',
    imageInactive: 'images/notification_inactive.png',
  ),
  BottomMenuItem(
    label: 'Einstellungen',
    image: 'images/setting.png',
    imageInactive: 'images/setting_inactive.png',
  ),
];

class EmptyScreen extends StatefulWidget {
  @override
  _EmptyScreenState createState() => _EmptyScreenState();
}

class _EmptyScreenState extends State<EmptyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyView(),
    );
  }

  Widget _bodyView() {}
}

String formatDuration(Duration d) {
  var seconds = d.inSeconds;
  final days = seconds ~/ Duration.secondsPerDay;
  seconds -= days * Duration.secondsPerDay;
  final hours = seconds ~/ Duration.secondsPerHour;
  seconds -= hours * Duration.secondsPerHour;
  final minutes = seconds ~/ Duration.secondsPerMinute;
  seconds -= minutes * Duration.secondsPerMinute;

  final List<String> tokens = [];
  if (days != 0) {
    tokens.add('${days}d');
  }
  if (tokens.isNotEmpty || hours != 0) {
    tokens.add('${hours}h');
  }
  if (tokens.isNotEmpty || minutes != 0) {
    tokens.add('${minutes}m');
  }
  tokens.add('${seconds}s');

  return tokens.join(':');
}
