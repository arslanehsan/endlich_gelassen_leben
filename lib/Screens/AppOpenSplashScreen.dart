import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lpat/Screens/LoginScreen.dart';
import 'package:lpat/Screens/SignupScreen.dart';
import 'package:lpat/Utils/Colors.dart';
import 'package:lpat/Utils/UtilWidgets.dart';

class AppOpenSplashScreen extends StatefulWidget {
  @override
  _AppOpenSplashScreenState createState() => _AppOpenSplashScreenState();
}

class _AppOpenSplashScreenState extends State<AppOpenSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(top: 20, bottom: 5),
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('images/splash_screen.jpg'),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'images/logo.png',
                height: 103,
              ),
              const SizedBox(
                height: 15,
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
                height: 20,
              ),
              Image.asset(
                'images/splash_image.png',
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: BlueButtonView(
                  // label: 'Sign In',
                  label: 'Einloggen',
                  loading: false,
                  context: context,
                  function: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              RichText(
                text: TextSpan(
                    text: 'Noch keinen Zugang? ',
                    style: const TextStyle(
                      color: darkBlueColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text: 'Zugang beantragen',
                        style: const TextStyle(
                          color: redColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignupScreen(),
                                ),
                              ),
                      )
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
