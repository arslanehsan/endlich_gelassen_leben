import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpat/Utils/Colors.dart';
import 'package:lpat/Utils/CustomInputStyles.dart';
import 'package:lpat/Utils/Global.dart';
import 'package:lpat/Utils/UtilWidgets.dart';

class CustomerForgotPasswordScreen extends StatefulWidget {
  @override
  _CustomerForgotPasswordScreenState createState() =>
      _CustomerForgotPasswordScreenState();
}

class _CustomerForgotPasswordScreenState
    extends State<CustomerForgotPasswordScreen> {
  static String id = 'forgot-password';

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool buttonLoading = false;
  GlobalKey<FormState> _forgotPassFormKey = GlobalKey<FormState>();

  String _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          backgroundView(),
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.close,
                            size: 30,
                            color: pureBlackColor,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'images/logo.png',
                        height: 200,
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    const Text(
                      ' Passwort vergessen',
                      style: TextStyle(
                        color: pureBlackColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    // Text(
                    //   'Welcome',
                    //   style: TextStyle(
                    //     fontSize: 28,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Text(
                    //   'Sign in to continue',
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //     color: darkOrangeColor,
                    //     fontWeight: FontWeight.w400,
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 30,
                    // ),
                    Container(
//              padding: EdgeInsets.only(top: 50),
                      child: Stack(
                        children: [
                          formArea(context),
                          LogInBtn(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget formArea(BuildContext context) {
    return Form(
      key: _forgotPassFormKey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
        decoration: BoxDecoration(
          color: pureWhiteColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5.0, // has the effect of softening the shadow
              spreadRadius: 1.0, // has the effect of extending the
              offset: Offset(0, 0), // shadow
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              maxLines: 1,
              obscureText: false,
              style:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
              autofocus: false,
              maxLength: 30,
              keyboardType: TextInputType.emailAddress,
              decoration: buildCustomInputWithoutLable(hintText: 'E-Mail'),
              validator: (value) =>
                  value.isEmpty ? 'Bitte gib Deine E-Mail-Adresse ein!' : null,
              onSaved: (value) => _email = value.trim(),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget LogInBtn() {
    return Container(
      height: 210,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              sendForgotMail();
            },
            child: Container(
              height: 40,
              // width: 200,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                vertical: 5,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: darkBlueColor,
              ),
              child: buttonLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3.0,
                          valueColor: AlwaysStoppedAnimation(
                            Colors.white,
                          ),
                        ),
                      ),
                    )
                  : const Text(
                      'Wiederherstellungs-E-Mail senden',
                      style: TextStyle(
                        fontSize: 18,
                        color: pureWhiteColor,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  Future<void> sendForgotMail() async {
    try {
      if (_forgotPassFormKey.currentState.validate()) {
        _forgotPassFormKey.currentState.save();
        setState(() {
          buttonLoading = true;
        });
        if (_email != null && _email.length > 2) {
          await _firebaseAuth
              .sendPasswordResetEmail(email: _email)
              .then((value) => {
                    showNormalToast(
                        msg: 'Sie haben eine E-Mail mit Details erhalten.'),
                    setState(() {
                      buttonLoading = false;
                    }),
                    Navigator.pop(context),
                  });
        }
      }
    } on PlatformException catch (e) {
      print(e.message);
      setState(() {
        buttonLoading = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        buttonLoading = false;
      });
    } finally {
      setState(() {
        buttonLoading = false;
      });
    }
  }

  Future<void> resetPassword(String email) async {}
}
