import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lpat/Firebase/FirebaseDatabaseService.dart';
import 'package:lpat/Objects/CustomerObject.dart';
import 'package:lpat/Screens/LoginScreen.dart';
import 'package:lpat/Screens/VerifyEmailPage.dart';
import 'package:lpat/Screens/WebViewScreen.dart';
import 'package:lpat/Utils/Colors.dart';
import 'package:lpat/Utils/CustomInputStyles.dart';
import 'package:lpat/Utils/UtilWidgets.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();
  CustomerObject _customer = CustomerObject();
  bool agreeTerms = false, notification = false, buttonLoading = false;
  bool showPas = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [backgroundView(), _boduView()],
      ),
    );
  }

  Widget _boduView() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: _signupFormKey,
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
                  'Zugang beantragen',
                  style: TextStyle(
                    color: pureBlackColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  maxLines: 1,
                  obscureText: false,
                  style: const TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 18),
                  autofocus: false,
                  maxLength: 30,
                  keyboardType: TextInputType.name,
                  decoration:
                      buildCustomInputWithoutLable(hintText: 'Dein Vorname...'),
                  onChanged: (username) {
                    setState(() {
                      _customer.userName = username;
                    });
                  },
                  validator: (value) =>
                      value.isEmpty ? ' Bitte gib Deinen Vornamen ein!' : null,
                  onSaved: (username) => _customer.userName = username,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  maxLines: 1,
                  obscureText: false,
                  style: const TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 18),
                  autofocus: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: buildCustomInputWithoutLable(
                      hintText: 'Deine E-Mail-Adresse...'),
                  onChanged: (email) {
                    setState(() {
                      _customer.customerEmail = email;
                    });
                  },
                  validator: (value) => value.isEmpty
                      ? 'Bitte gib Deine E-Mail-Adresse ein!'
                      : null,
                  onSaved: (email) => _customer.customerEmail = email,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: dullFontColor, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          maxLines: 1,
                          obscureText: showPas,
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 18),
                          autofocus: false,
                          maxLength: 30,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 15),
                            hintText: 'Passwort...',
                            counterText: '',
                            // counterStyle: const TextStyle(fontSize: 0),
                            hintStyle: TextStyle(
                                color: dullFontColor,
                                fontWeight: FontWeight.normal),

                            border: InputBorder.none,
                          ),
                          validator: (value) => value.isEmpty
                              ? 'Bitte gib Dein Passwort ein!'
                              : null,
                          onSaved: (value) =>
                              _customer.customerPassword = value.trim(),
                        ),
                      ),
                      IconButton(
                          onPressed: () => {
                                setState(() {
                                  showPas = !showPas;
                                })
                              },
                          icon: Icon(showPas
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => {
                        setState(() {
                          if (agreeTerms) {
                            agreeTerms = false;
                          } else {
                            agreeTerms = true;
                          }
                        })
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Image.asset(
                          agreeTerms
                              ? 'images/checked.png'
                              : 'images/un_checked.png',
                          width: 18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: SizedBox(
                        child: RichText(
                          text: TextSpan(
                              text: 'AGB ',
                              style: const TextStyle(
                                color: redColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const WebViewScreen(
                                          link:
                                              'https://www.endlich-gelassen-leben.de/agb',
                                        ),
                                      ),
                                    ),
                              children: [
                                TextSpan(
                                  text: 'und ',
                                  style: const TextStyle(
                                    color: pureBlackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  recognizer: TapGestureRecognizer(),
                                ),
                                TextSpan(
                                  text: 'wichtige Anwendungshinweise ',
                                  style: const TextStyle(
                                    color: redColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const WebViewScreen(
                                              link:
                                                  'https://www.endlich-gelassen-leben.de/wichtige-anwendungshinweise',
                                            ),
                                          ),
                                        ),
                                ),
                                // TextSpan(
                                //   text: 'Conditions',
                                //   style: const TextStyle(
                                //     color: redColor,
                                //     fontSize: 16,
                                //     fontWeight: FontWeight.w400,
                                //   ),
                                //   recognizer: TapGestureRecognizer(),
                                // ),
                                TextSpan(
                                  text: 'gelesen und akzeptiert',
                                  style: const TextStyle(
                                    color: pureBlackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  recognizer: TapGestureRecognizer(),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => {
                        setState(() {
                          if (notification) {
                            notification = false;
                          } else {
                            notification = true;
                          }
                        })
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Image.asset(
                          notification
                              ? 'images/checked.png'
                              : 'images/un_checked.png',
                          width: 18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Über Neuigkeiten informiert bleiben',
                      style: TextStyle(
                        color: darkBlueColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                BlueButtonView(
                  label: 'Zugang beantragen',
                  loading: buttonLoading,
                  context: context,
                  function: _validateRegisterInput,
                ),
                const SizedBox(
                  height: 25,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Bereits registriert?',
                    style: const TextStyle(
                      color: darkBlueColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text: ' Einloggen',
                        style: const TextStyle(
                          color: redColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _validateRegisterInput() async {
    final FormState form = _signupFormKey.currentState;

    if (form.validate() && agreeTerms) {
      form.save();
      setState(() {
        buttonLoading = true;
      });
      try {
        UserCredential user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _customer.customerEmail,
                password: _customer.customerPassword);

        if (user != null) {
          print(user.user.uid);
          _customer.customerUID = user.user.uid;
          _customer.receiveNotifications = notification;
          await FirebaseDatabaseService()
              .addNewCustomer(customer: _customer)
              .then((dataUpdated) async => {
                    if (dataUpdated)
                      {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VerifyEmailPage(),
                            ),
                            ModalRoute.withName('/')),
                      }
                  });
        }
      } catch (error) {
        print(error.code);
        switch (error.code) {
          case "email-already-in-use":
            {
              setState(() {
                buttonLoading = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      content: Text(" Diese E-Mail wird bereits verwendet"),
                    );
                  });
            }
            break;
          case "weak-password":
            {
              setState(() {
                buttonLoading = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      content: Text(
                          "Sie können sich jetzt bei Endlich Gelassen Leben anmelden"),
                    );
                  });
            }
            break;
          // // default:
          // //   {}
        }
      } finally {
        setState(() {
          buttonLoading = false;
        });
      }
    }
  }
}
