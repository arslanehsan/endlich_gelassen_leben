import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lpat/Firebase/FirebaseDatabaseService.dart';
import 'package:lpat/Firebase/FirebaseStorageService.dart';
import 'package:lpat/Objects/CustomerObject.dart';
import 'package:lpat/Screens/AppOpenSplashScreen.dart';
import 'package:lpat/Screens/WebViewScreen.dart';
import 'package:lpat/Utils/Colors.dart';
import 'package:lpat/Utils/Global.dart';
import 'package:lpat/Utils/UtilWidgets.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  CustomerObject customerObject = customer;

  bool buttonLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 80,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: customerObject != null
                          ? customerObject.customerImage != null
                              ? FileImage(customerObject.customerImage)
                              : customerObject.customerImageName != null
                                  ? NetworkImage(
                                      customerObject.customerImageName)
                                  : const AssetImage('images/default_user.png')
                          : const AssetImage('images/default_user.png'),
                    ),
                    borderRadius: BorderRadius.circular(55),
                    color: lightGrayColor,
                  ),
                  width: 110,
                  height: 110,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () => pickImage(),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: grayColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: buttonLoading
                          ? const CircularProgressIndicator(
                              strokeWidth: 3.0,
                              valueColor: AlwaysStoppedAnimation(
                                grayColor,
                              ),
                            )
                          : const Icon(
                              Icons.edit,
                              color: grayColor,
                              size: 30,
                            ),
                    ),
                  ),
                ),
              ],
            ),
            // Image.asset(
            //   'images/default_user.png',
            //   width: 130,
            // ),
            const SizedBox(
              height: 15,
            ),
            Text(
              customer != null ? customer.userName : '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF0B1222),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Divider(
              thickness: 2,
              color: Color(0x20000000),
            ),
            const SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () async => {
                // await FirebaseDatabaseHelper().addNewCustomerData(
                //   userUdid: '1213213',
                //   clickBy: ClickBy.ByHome,
                //   amount: 600,
                // )
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WebViewScreen(
                      link: 'https://www.endlich-gelassen-leben.de/impressum',
                    ),
                  ),
                ),
              },
              child: Container(
                color: Colors.transparent,
                child: _singleOptionView(
                  title: 'Rechtliches',
                  image: 'images/guideline.png',
                ),
              ),
            ),
            GestureDetector(
              onTap: () => {
                print('m called'),
                launchUrl(
                  Uri(
                    scheme: 'mailto',
                    path: supportEmail,
                    queryParameters: {
                      "subject": "Mein Feedback zur App Endlich Gelassen Leben"
                    },
                  ),
                )
                // (Uri(
                // scheme: 'mailto',
                // path: supportEmail,
                // queryParameters: {'subject': 'Rate Your Qr Scan Application'},
                // ),
              },
              child: Container(
                color: Colors.transparent,
                child: _singleOptionView(
                  title: 'Nachricht an uns senden',
                  image: 'images/guideline.png',
                ),
              ),
            ),
            GestureDetector(
              onTap: () => {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    // <-- SEE HERE
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30.0),
                    ),
                  ),
                  builder: (context) {
                    return showBottomSheetView();
                  },
                ),
              },
              child: _singleOptionView(
                title: 'App teilen',
                image: 'images/share.png',
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Divider(
              thickness: 2,
              color: Color(0x20000000),
            ),
            const SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () => showLogoutAlertDialog(context),
              child: Container(
                color: Colors.transparent,
                child: Row(
                  children: [
                    Image.asset(
                      'images/logout.png',
                      width: 24,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text(
                      'Ausloggen',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF0B1222),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _singleOptionView({@required String title, image}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                image,
                width: 24,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF0B1222),
                ),
              ),
            ],
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Color(0x30000000),
            size: 15,
          )
        ],
      ),
    );
  }

  Future<void> _updateProfilePicture(File image) async {
    try {
      if (image != null) {
        setState(() {
          buttonLoading = true;
        });

        // _refresh();s
        FirebaseStorageService()
            .addCustomerImageToStorage(customerObject.customerUID, image);

        await FirebaseDatabaseService()
            .editCustomerProfilePicture(customerObject, image)
            .then((done) => {
                  if (done)
                    {
                      setState(() {
                        customer.customerImage = image;
                        customerObject.customerImage = image;
                      })
                      // Navigator.pushAndRemoveUntil(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => HomeScreen(),
                      //   ),
                      //   ModalRoute.withName('/'),
                      // ),
                    }
                });
      }
    } on PlatformException catch (e) {
      showNormalToast(msg: e.message);
    } catch (e) {
      showNormalToast(
          msg:
              'The connection failed because the device is not connected to the internet');
    } finally {
      setState(() {
        buttonLoading = false;
      });
    }
  }

  Future<void> pickImage() async {
    File image;
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 400, maxWidth: 400);
    if (pickedFile != null) {
      image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    if (image != null) {
      // setState(() {
      //   customerObject.customerImage = image;
      // });
      _updateProfilePicture(image);
    }
  }

  showLogoutAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: _logoutDialogView(),
          );
        });
  }

  _logoutDialogView() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: pureWhiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "Du willst Dich ausloggen?",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: pureBlackColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(
            height: 0.5,
            thickness: 0.5,
            color: pureBlackColor,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => {
                      FirebaseAuth.instance.signOut().then((value) => {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AppOpenSplashScreen(),
                              ),
                              ModalRoute.withName('/'),
                            ),
                          }),
                    },
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      child: const Text(
                        "Ja.",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: pureBlackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(
                  thickness: 0.5,
                  color: pureBlackColor,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      child: const Text(
                        "Nein.",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: pureBlackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
