import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpat/Utils/Colors.dart';
import 'package:lpat/Utils/Global.dart';
import 'package:social_share/social_share.dart';

Widget BlueButtonView({
  @required String label,
  @required bool loading,
  @required BuildContext context,
  @required Function function,
}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
    child: Material(
      //Wrap with Material
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
      elevation: 18.0,
      color: darkBlueColor,
      clipBehavior: Clip.antiAlias, // Add This
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        height: 50,
        color: darkBlueColor,
        onPressed: function,
        child: loading
            ? const CircularProgressIndicator(
                color: pureWhiteColor,
              )
            : Text(
                label,
                style: const TextStyle(
                  color: pureWhiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    ),
  );
  //   Container(
  //   height: 50,
  //   decoration: BoxDecoration(
  //     color: darkBlueColor,
  //     borderRadius: BorderRadius.circular(6),
  //   ),
  //   alignment: Alignment.center,
  //   child: loading
  //       ? const CircularProgressIndicator(
  //           color: pureWhiteColor,
  //         )
  //       : Text(
  //           label,
  //           style: const TextStyle(
  //             color: pureWhiteColor,
  //             fontSize: 14,
  //             fontWeight: FontWeight.w700,
  //           ),
  //         ),
  // );
}

Widget showNeedHelpButton(
    {@required String label, @required Function function}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
    child: Material(
      //Wrap with Material
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
      elevation: 10.0,
      color: pureBlackColor,
      clipBehavior: Clip.antiAlias, // Add This
      child: MaterialButton(
        minWidth: 140.0,
        height: 40,
        color: pureBlackColor,
        onPressed: function,
        child: Text(
          label,
          style: const TextStyle(fontSize: 14.0, color: Colors.white),
        ),
      ),
    ),
  );
}

Widget backgroundView() {
  return SizedBox(
    // height: MediaQuery.of(context).size.height,
    // width: MediaQuery.of(context).size.width,
    child: Stack(
      children: [
        Column(
          children: [
            Container(
              height: 310,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  'images/top_background.png',
                ),
              )),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget showBottomSheetView() {
  return SafeArea(
    child: Container(
      height: 350,
      padding: const EdgeInsets.only(left: 35, right: 35, top: 30),
      child: Column(
        children: [
          const Text(
            'Hat Dir das gefallen?',
            style: TextStyle(
              color: Color(0xFF303A5E),
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          const Text(
            'Dann teile unsere App mit   Freunden und Familie!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF303A5E),
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Wrap(
            direction: Axis.horizontal,
            spacing: 20,
            children: [
              GestureDetector(
                onTap: () => {
                  SocialShare.shareWhatsapp(shareMessage),
                },
                child: Container(
                  color: Colors.transparent,
                  child: Image.asset(
                    'images/whatsapp.png',
                    width: 55,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => {},
                child: Container(
                  color: Colors.transparent,
                  child: Image.asset(
                    'images/instagram.png',
                    width: 55,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => {},
                child: Container(
                  color: Colors.transparent,
                  child: Image.asset(
                    'images/facebook.png',
                    width: 55,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => {
                  SocialShare.shareTwitter(shareMessage),
                },
                child: Container(
                  color: Colors.transparent,
                  child: Image.asset(
                    'images/twiter.png',
                    width: 55,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Link der App kopieren',
            style: TextStyle(
              color: Color(0xFF303A5E),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                shareMessage,
                style: const TextStyle(
                  color: Color(0xFF303A5E),
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () => {
                  Clipboard.setData(
                    ClipboardData(text: shareMessage),
                  ),
                  showNormalToast(msg: 'Copied!'),
                },
                child: Container(
                  color: Colors.transparent,
                  child: Image.asset(
                    'images/copy_clip_board.png',
                    width: 24,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    ),
  );
}
