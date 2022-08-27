import 'package:lpat/Firebase/FirebaseDatabaseHelper.dart';

class AmountDetail {
  String id, amount;
  ClickBy clickBy;

  AmountDetail({
    this.id,
    this.clickBy,
    this.amount,
  });
}

class UserClickDetails {
  String userUDID;
  List<AmountDetail> amountDetailsList;
  int pressedByHome, pressedByMyOrders;
  double totalAmountByHome, totalAmountByMyOrders;

  UserClickDetails({
    this.userUDID,
    this.amountDetailsList,
    this.pressedByHome,
    this.pressedByMyOrders,
    this.totalAmountByHome,
    this.totalAmountByMyOrders,
  });
}

class AdminData {
  int pressedByHome, pressedByMyOrders;
  double totalAmountByHome, totalAmountByMyOrders;

  AdminData({
    this.pressedByHome,
    this.pressedByMyOrders,
    this.totalAmountByHome,
    this.totalAmountByMyOrders,
  });
}

//
// class UserClickByMyOrdersDetails {
//   List<AmountDetail> amountDetailsList;
//   int pressed;
//   double totalAmount;
//
//   UserClickByMyOrdersDetails({
//     this.amountDetailsList,
//     this.pressed,
//     this.totalAmount,
//   });
// }
//
// class userData {
//   UserClickByMyOrdersDetails userClickByMyOrdersDetails;
//   UserClickByHomeDetails userClickByHomeDetails;
//
//   userData({
//     this.userClickByMyOrdersDetails,
//     this.userClickByHomeDetails,
//   });
// }
