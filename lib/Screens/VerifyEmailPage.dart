import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lpat/Firebase/FirebaseDatabaseService.dart';
import 'package:lpat/Objects/CustomerObject.dart';
import 'package:lpat/Screens/AppOpenSplashScreen.dart';
import 'package:lpat/Screens/HomeScreen.dart';
import 'package:lpat/Utils/Colors.dart';
import 'package:lpat/Utils/Global.dart';
import 'package:lpat/Utils/UtilWidgets.dart';

class VerifyEmailPage extends StatefulWidget {
  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool verifiedEmail = false;

  CustomerObject customer;
  Future<void> getCustomerData() async {
    CustomerObject customerData =
        await FirebaseDatabaseService().getSingleCustomer();
    if (customerData != null) {
      setState(() {
        customer = customerData;
      });
    }
  }

  @override
  initState() {
    super.initState();
    getCustomerData();
    verifiedEmail = FirebaseAuth.instance.currentUser.emailVerified;
  }

  @override
  Widget build(BuildContext context) => verifiedEmail
      ? HomeScreen()
      : Scaffold(
          body: Stack(
            children: [
              backgroundView(),
              _bodyView(),
            ],
          ),
        );

  Widget _bodyView() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              Image.asset(
                'images/logo.png',
                height: 103,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Endlich Gelassen Leben',
                style: TextStyle(
                  color: pureBlackColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'LEBEN GEHT EINFACHER',
                style: TextStyle(
                  color: pureBlackColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              const Text(
                'Bitte bestätige Deine  E-Mail-Adresse',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: pureBlackColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Hallo ${customer != null ? customer.userName : ''}! Klicke bitte auf Button unten, Du erhältst dann eine E-Mail zur Bestätigung Deiner E-Mail-Adresse. Nach Bestätigung Deiner E-Mail-Adresse kannst Du Dich einloggen und unsere App nutzen.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF0B1222),
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: BlueButtonView(
                  label: 'E-Mail-Adresse bestätigen',
                  loading: false,
                  context: context,
                  function: sendVerifyEmail,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendVerifyEmail() async {
    try {
      if (FirebaseAuth.instance.currentUser.emailVerified) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
          ModalRoute.withName('/'),
        );
      } else {
        final User user = FirebaseAuth.instance.currentUser;
        await user.sendEmailVerification();
        FirebaseAuth.instance.signOut().then((value) => {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => AppOpenSplashScreen(),
                ),
                ModalRoute.withName('/'),
              ),
            });
      }
    } catch (e) {
      print(e.toString());
      showNormalToast(msg: e.toString());
    }
  }
}
