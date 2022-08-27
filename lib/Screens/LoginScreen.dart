import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpat/Firebase/PhoneAuthService.dart';
import 'package:lpat/Objects/LoginUserObject.dart';
import 'package:lpat/Screens/CustomerForgotPasswordScreen.dart';
import 'package:lpat/Screens/SignupScreen.dart';
import 'package:lpat/Screens/VerifyEmailPage.dart';
import 'package:lpat/Utils/Colors.dart';
import 'package:lpat/Utils/CustomInputStyles.dart';
import 'package:lpat/Utils/Global.dart';
import 'package:lpat/Utils/UtilWidgets.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  LoginUserObject loginUserObject = LoginUserObject();
  bool agreeTerms = false,
      notification = false,
      buttonLoading = false,
      showPas = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          backgroundView(),
          _bodyView(),
        ],
      ),
    );
  }

  Widget _bodyView() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: _loginFormKey,
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
                  'Einloggen',
                  // 'Sign In',
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
                  keyboardType: TextInputType.emailAddress,
                  decoration: buildCustomInputWithoutLable(
                      hintText: 'E-Mail-Adresse...'),
                  validator: (value) => value.isEmpty
                      ? ' Bitte gib Deine E-Mail-Adresse ein!'
                      : null,
                  onSaved: (value) => loginUserObject.email = value.trim(),
                ),
                const SizedBox(
                  height: 30,
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
                              loginUserObject.password = value.trim(),
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
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.transparent,
                    child: const Text(
                      'Passwort vergessen?',
                      // 'Forgot Password?',
                      style: TextStyle(
                        color: pureBlackColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                BlueButtonView(
                  label: 'Einloggen',
                  loading: buttonLoading,
                  context: context,
                  function: loginUser,
                ),
                const SizedBox(
                  height: 25,
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
                            ..onTap = () => Navigator.pushReplacement(
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
      ),
    );
  }

  Future<void> loginUser() async {
    try {
      if (!buttonLoading) {
        if (_loginFormKey.currentState.validate()) {
          _loginFormKey.currentState.save();
          setState(() {
            buttonLoading = true;
          });

          await FirebaseAuthService()
              .loginUser(loginUserObject)
              .then((customer) => {
                    if (customer != null)
                      {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VerifyEmailPage(),
                            ),
                            ModalRoute.withName('/')),
                      }
                    else
                      {
                        showNormalToast(
                            msg: 'Falsche E-Mail, oder falsches Passwort'),
                      }
                  });
        }
      } else {
        showNormalToast(msg: 'Please Wait!');
      }
    } on PlatformException catch (e) {
      showNormalToast(msg: e.message);
    } catch (e) {
      showNormalToast(msg: e.toString());
    } finally {
      setState(() {
        buttonLoading = false;
      });
    }
  }
}
