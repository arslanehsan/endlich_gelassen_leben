import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lpat/Objects/AudioFileObject.dart';
import 'package:lpat/Objects/CustomerObject.dart';
import 'package:lpat/Objects/NotificationObject.dart';

class FirebaseDatabaseService {
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  Future<bool> addNewCustomer({@required CustomerObject customer}) async {
    DatabaseReference dbf = firebaseDatabase.ref();
    final User currentUser = FirebaseAuth.instance.currentUser;
    String customerUID = currentUser.uid;
    String token = await FirebaseMessaging.instance.getToken();
    try {
      Map<String, dynamic> customerData = {
        'customerUID': customerUID,
        'userName': customer.userName,
        'customerEmail': customer.customerEmail,
        'receiveNotifications': customer.receiveNotifications,
        'customerImageName': 'default.png',
        'deviceToken': token,
      };

      await dbf.child('Users').child(customerUID).set(customerData);

      return true;
    } catch (e) {
      print("Here");
      print(e);
      return false;
    }
  }

  Future<CustomerObject> getSingleCustomer() async {
    try {
      CustomerObject customer;

      DatabaseReference dbf = firebaseDatabase
          .ref()
          .child('Users')
          .child(FirebaseAuth.instance.currentUser.uid);

      await dbf.once().then((snapshot) {
        Map<dynamic, dynamic> values = snapshot.snapshot.value;

        customer = CustomerObject(
          customerUID: values['customerUID'],
          userName: values['userName'],
          customerEmail: values['customerEmail'],
          customerImageName: values['customerImageName'],
        );
      });
      return customer;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> editCustomerProfilePicture(
      CustomerObject customerObject, File image) async {
    DatabaseReference dbf = firebaseDatabase.ref();

    String imageName = customerObject.customerImageName != 'default.png'
        ? '${customerObject.customerUID}.${image.path.split('/').last.split('.').last}'
        : 'default.png';
    try {
      Map<String, dynamic> customerData = {
        'customerImageName': imageName,
      };

      final User currentUser = FirebaseAuth.instance.currentUser;

      String customerUID = currentUser.uid;
      await dbf.child('Users').child(customerUID).update(customerData);

      return true;
    } catch (e) {
//      print("Here");
      print(e);
      return false;
    }
  }

  Future<AudioFileObject> getAudioFile() async {
    try {
      AudioFileObject audio;

      DatabaseReference dbf = firebaseDatabase.ref().child('AudioFile');

      await dbf.once().then((snapshot) {
        Map<dynamic, dynamic> values = snapshot.snapshot.value;
        print(values);
        audio = AudioFileObject(
          details: values['details'],
          displayName: values['displayName'],
          subTitle: values['subTitle'],
          soundFileName: values['soundFileName'],
          fileName: values['fileName'],
          location: values['location'],
        );
      });
      return audio;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> getNotification() async {
    try {
      bool notification;
      final User currentUser = FirebaseAuth.instance.currentUser;
      String customerUID = currentUser.uid;

      DatabaseReference dbf =
          firebaseDatabase.ref().child('Users').child(customerUID);

      await dbf.once().then((snapshot) {
        Map<dynamic, dynamic> values = snapshot.snapshot.value;
        notification = values['receiveNotifications'];
      });
      return notification;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> editCustomerNotification({@required bool notification}) async {
    DatabaseReference dbf = firebaseDatabase.ref();
    final User currentUser = FirebaseAuth.instance.currentUser;
    String customerUID = currentUser.uid;
    String token = await FirebaseMessaging.instance.getToken();

    try {
      Map<String, dynamic> customerData = {
        'receiveNotifications': notification,
        'deviceToken': token,
      };

      await dbf.child('Users').child(customerUID).update(customerData);

      return true;
    } catch (e) {
      print("Here");
      print(e);
      return false;
    }
  }

  Future<List<NotificationObject>> getNotificationsList() async {
    List<NotificationObject> notificationsData = [];
    DatabaseReference dbf = firebaseDatabase.ref().child('Notifications');

    await dbf.once().then((snapshot) {
      print(snapshot.snapshot.value);
      Map<dynamic, dynamic> value = snapshot.snapshot.value;
      value.forEach((key, values) {
        NotificationObject favouriteItem = NotificationObject(
          id: key,
          imageName: values['imageName'],
          date: values['date'],
          title: values['title'],
        );
        notificationsData.add(favouriteItem);
//
      });
    });

    return notificationsData;
  }

  Future<String> getShareMessage() async {
    try {
      String message;

      DatabaseReference dbf = firebaseDatabase.ref().child('Settings');

      await dbf.once().then((snapshot) {
        Map<dynamic, dynamic> values = snapshot.snapshot.value;
        message = values['shareMessage'];
      });
      return message;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
