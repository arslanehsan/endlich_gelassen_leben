import 'dart:io';

class CustomerObject {
  String customerUID,
      userName,
      customerPhoneNumber,
      customerEmail,
      customerPassword,
      customerImageName,
      customerAddress,
      deviceToken;
  File customerImage;
  bool receiveNotifications;

  CustomerObject({
    this.customerUID,
    this.userName,
    this.customerPhoneNumber,
    this.customerEmail,
    this.customerPassword,
    this.customerAddress,
    this.customerImageName,
    this.customerImage,
    this.deviceToken,
    this.receiveNotifications,
  });
}
