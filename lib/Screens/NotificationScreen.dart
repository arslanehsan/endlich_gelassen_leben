import 'package:flutter/material.dart';
import 'package:lpat/Firebase/FirebaseDatabaseService.dart';
import 'package:lpat/Firebase/FirebaseStorageService.dart';
import 'package:lpat/Objects/NotificationObject.dart';
import 'package:lpat/Utils/Colors.dart';
import 'package:lpat/Utils/Global.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool notification = false;
  List<NotificationObject> listNotifications = [];

  Future<void> getNotification() async {
    bool active = await FirebaseDatabaseService().getNotification();
    if (active != null) {
      setState(() {
        notification = active;
      });
    }
  }

  Future<void> getNotificationsList() async {
    List<NotificationObject> listNotificationsData =
        await FirebaseDatabaseService().getNotificationsList();
    if (listNotificationsData != null) {
      setState(() {
        listNotifications = listNotificationsData;
      });
    }
  }

  DateTime now = DateTime.now();

  @override
  initState() {
    super.initState();
    getNotification();
    getNotificationsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            headingView(),
            const Divider(
              thickness: 2,
              color: Color(0x20000000),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: listNotifications.length,
                  itemBuilder: (context, index) {
                    return _singleNotification(
                      notification: listNotifications[index],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _singleNotification({@required NotificationObject notification}) {
    return FutureBuilder(
        future: FirebaseStorageService()
            .getNotificationImage(notification.imageName),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return GestureDetector(
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  width: 1,
                  color: Color(0x10000000),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: snapshot.hasData
                            ? NetworkImage(snapshot.data)
                            : const AssetImage(
                                'images/default_notification.png'),
                      ),
                      // borderRadius: BorderRadius.circular(55),
                    ),
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        notification.title,
                        style: const TextStyle(
                          color: pureBlackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        notification.date,
                        style: const TextStyle(
                          color: pureBlackColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w200,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget headingView() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'An/Aus',
                style: TextStyle(
                  color: pureBlackColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Nachrichten erhalten',
                style: TextStyle(
                  color: pureBlackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => {changeNotificationStatus()},
            child: Container(
              color: Colors.transparent,
              child: Image.asset(
                notification
                    ? 'images/switch_active.png'
                    : 'images/switch_inactive.png',
                width: 47,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> changeNotificationStatus() {
    try {
      FirebaseDatabaseService()
          .editCustomerNotification(notification: !notification)
          .then((value) => {
                if (value)
                  {
                    showNormalToast(
                        msg:
                            '${notification ? 'eingeschaltet' : 'ausgeschaltet'}'),
                    setState(() {
                      notification = !notification;
                    }),
                  }
              });
    } catch (e) {
      print(e.toString());
    }
  }
}
