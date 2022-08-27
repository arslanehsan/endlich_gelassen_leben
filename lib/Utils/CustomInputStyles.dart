import 'package:flutter/material.dart';

import 'Colors.dart';

InputDecoration buildCustomInput(
    {@required String hintText, @required String labelText}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
    hintText: hintText,
    hintStyle:
        const TextStyle(color: dullFontColor, fontWeight: FontWeight.bold),
    labelText: labelText,
    labelStyle: const TextStyle(color: pureBlackColor),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: pureBlackColor, width: 1.0),
    ),
    border: const OutlineInputBorder(
      borderSide: BorderSide(color: pureBlackColor, width: 1.0),
    ),
  );
}

InputDecoration buildCustomInputWithoutLable({@required String hintText}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
    hintText: hintText,
    counterText: '',
    // counterStyle: const TextStyle(fontSize: 0),
    hintStyle:
        const TextStyle(color: dullFontColor, fontWeight: FontWeight.normal),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: dullFontColor, width: 0.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: dullFontColor, width: 0.5),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: dullFontColor, width: 0.5),
    ),
  );
}

InputDecoration buildCustomInput1({@required String hintText}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    hintText: hintText,
    labelStyle: const TextStyle(color: pureBlackColor),
    border: const OutlineInputBorder(borderSide: BorderSide.none),
    // focusedBorder: OutlineInputBorder(
    //   borderSide: BorderSide(color: pureBlackColor, width: 1.0),
    // ),
    // border: OutlineInputBorder().
    // OutlineInputBorder(
    //   borderSide: BorderSide(color: pureBlackColor, width: 1.0),
    // ),
  );
}
