import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lpat/Objects/UserClickDetails.dart';

enum ClickBy { ByHome, ByMyOrderds }

class FirebaseDatabaseHelper {
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  Future<bool> addNewCustomerData({
    @required String userUdid,
    @required ClickBy clickBy,
    @required double amount,
  }) async {
    DatabaseReference dbf = firebaseDatabase.ref();
    bool done = false;
    try {
      AdminData adminData = await getAdminData();
      print('m called 1');
      await getSingleCustomerData(userUdid: userUdid)
          .then((customerDataValues) async {
        if (customerDataValues == null) {
          print('m called 2');
          Map<String, dynamic> customerData = {
            'userUDID': userUdid,
            'pressedByHome': clickBy == ClickBy.ByHome ? 1 : 0,
            'pressedByMyOrders': clickBy == ClickBy.ByMyOrderds ? 1 : 0,
            'totalAmountByHome': clickBy == ClickBy.ByHome ? amount : 0,
            'totalAmountByMyOrders':
                clickBy == ClickBy.ByMyOrderds ? amount : 0,
          };

          await dbf
              .child('Test')
              .child('Details')
              .child(userUdid)
              .set(customerData)
              .then((value) async {
            print('m called 4');
            Map<String, dynamic> customerDetailsData = {
              'clickBy': clickBy == ClickBy.ByHome ? 'ByHome' : 'ByMyOrders',
              'amount': amount,
            };
            await dbf
                .child('Test')
                .child('Details')
                .child(userUdid)
                .child('Details')
                .push()
                .set(customerDetailsData)
                .then((value1) async {
              if (adminData == null) {
                print('m called 5');
                Map<String, dynamic> adminDetailsData = {
                  'pressedByHome': clickBy == ClickBy.ByHome ? 1 : 0,
                  'pressedByMyOrders': clickBy == ClickBy.ByMyOrderds ? 1 : 0,
                  'totalAmountByHome': clickBy == ClickBy.ByHome ? amount : 0,
                  'totalAmountByMyOrders':
                      clickBy == ClickBy.ByMyOrderds ? amount : 0,
                };
                await dbf.child('Test').child('Admin').set(adminDetailsData);
              } else {
                print('m called 6');
                Map<String, dynamic> adminDetailsData = {
                  'pressedByHome': clickBy == ClickBy.ByHome
                      ? adminData.pressedByHome + 1
                      : adminData.pressedByHome,
                  'pressedByMyOrders': clickBy == ClickBy.ByMyOrderds
                      ? adminData.pressedByMyOrders + 1
                      : adminData.pressedByMyOrders,
                  'totalAmountByHome': clickBy == ClickBy.ByHome
                      ? adminData.totalAmountByHome + amount
                      : adminData.totalAmountByHome,
                  'totalAmountByMyOrders': clickBy == ClickBy.ByMyOrderds
                      ? adminData.totalAmountByMyOrders + amount
                      : adminData.totalAmountByMyOrders,
                };
                await dbf.child('Test').child('Admin').update(adminDetailsData);
              }
            });
          });
        } else {
          print('m called 3');
          Map<String, dynamic> customerData = {
            'pressedByHome': clickBy == ClickBy.ByHome
                ? customerDataValues.pressedByHome + 1
                : customerDataValues.pressedByHome,
            'pressedByMyOrders': clickBy == ClickBy.ByMyOrderds
                ? customerDataValues.pressedByMyOrders + 1
                : customerDataValues.pressedByMyOrders,
            'totalAmountByHome': clickBy == ClickBy.ByHome
                ? customerDataValues.totalAmountByHome + amount
                : customerDataValues.totalAmountByHome,
            'totalAmountByMyOrders': clickBy == ClickBy.ByMyOrderds
                ? customerDataValues.totalAmountByMyOrders + amount
                : customerDataValues.totalAmountByMyOrders,
          };

          await dbf
              .child('Test')
              .child('Details')
              .child(userUdid)
              .update(customerData)
              .then((value) async {
            Map<String, dynamic> customerDetailsData = {
              'clickBy': clickBy == ClickBy.ByHome ? 'ByHome' : 'ByMyOrders',
              'amount': amount,
            };
            await dbf
                .child('Test')
                .child('Details')
                .child(userUdid)
                .child('Details')
                .push()
                .set(customerDetailsData)
                .then((value1) async {
              if (adminData == null) {
                print('m called 5');
                Map<String, dynamic> adminDetailsData = {
                  'pressedByHome': clickBy == ClickBy.ByHome ? 1 : 0,
                  'pressedByMyOrders': clickBy == ClickBy.ByMyOrderds ? 1 : 0,
                  'totalAmountByHome': clickBy == ClickBy.ByHome ? amount : 0,
                  'totalAmountByMyOrders':
                      clickBy == ClickBy.ByMyOrderds ? amount : 0,
                };
                await dbf.child('Test').child('Admin').set(adminDetailsData);
              } else {
                print('m called 6');
                Map<String, dynamic> adminDetailsData = {
                  'pressedByHome': clickBy == ClickBy.ByHome
                      ? adminData.pressedByHome + 1
                      : adminData.pressedByHome,
                  'pressedByMyOrders': clickBy == ClickBy.ByMyOrderds
                      ? adminData.pressedByMyOrders + 1
                      : adminData.pressedByMyOrders,
                  'totalAmountByHome': clickBy == ClickBy.ByHome
                      ? adminData.totalAmountByHome + amount
                      : adminData.totalAmountByHome,
                  'totalAmountByMyOrders': clickBy == ClickBy.ByMyOrderds
                      ? adminData.totalAmountByMyOrders + amount
                      : adminData.totalAmountByMyOrders,
                };
                await dbf.child('Test').child('Admin').update(adminDetailsData);
              }
            });
          });
        }
      });

      return done;
    } catch (e) {
      print(e);
      return done;
    }
  }

  Future<UserClickDetails> getSingleCustomerData({
    @required String userUdid,
  }) async {
    try {
      UserClickDetails userData;

      DatabaseReference dbf =
          firebaseDatabase.ref().child('Test').child('Details').child(userUdid);

      await dbf.once().then((snapshot) {
        if (snapshot.snapshot.value != null) {
          Map<dynamic, dynamic> values = snapshot.snapshot.value;
          userData = UserClickDetails(
            userUDID: values['userUDID'],
            pressedByHome: int.parse(
              values['pressedByHome'].toString(),
            ),
            pressedByMyOrders: int.parse(
              values['pressedByMyOrders'].toString(),
            ),
            totalAmountByHome: double.parse(
              values['totalAmountByHome'].toString(),
            ),
            totalAmountByMyOrders: double.parse(
              values['totalAmountByMyOrders'].toString(),
            ),
          );
        }
      });
      return userData;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<AdminData> getAdminData() async {
    try {
      AdminData adminData;

      DatabaseReference dbf =
          firebaseDatabase.ref().child('Test').child('Admin');

      await dbf.once().then((snapshot) {
        Map<dynamic, dynamic> values = snapshot.snapshot.value;
        if (values != null) {
          adminData = AdminData(
            pressedByHome: int.parse(values['pressedByHome'].toString()),
            pressedByMyOrders:
                int.parse(values['pressedByMyOrders'].toString()),
            totalAmountByHome:
                double.parse(values['totalAmountByHome'].toString()),
            totalAmountByMyOrders:
                double.parse(values['totalAmountByMyOrders'].toString()),
          );
        }
      });
      return adminData;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
