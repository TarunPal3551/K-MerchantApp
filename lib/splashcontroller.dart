import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';
import 'package:kmerchant/services/crashlytics_service.dart';
import 'package:kmerchant/services/push_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/repository.dart';
import 'helper/constants.dart';
import 'services/device_service.dart';

class SplashController extends GetxController {
  final CrashlyticsService _crashlyticsService = Get.put(CrashlyticsService());
  final PushNotificationService _pushNotificationService =
      Get.put(PushNotificationService());
  final _repository = Repository();
  final _deviceInfo = Get.put(DeviceService());

  Future handleStartUpLogic() async {
    // Register for push notifications
    //  FirebaseApp.initializeApp(Context);
    await _pushNotificationService.initialise();

    //initialize crashalytics service once.
    _crashlyticsService.initialize();

    await _deviceInfo.initialise();

    await initToken();

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      LATITUDE = value.latitude;
      LONGITUDE = value.longitude;
    });
  }

  initToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    ACCESS_TOKEN = pref.getString("token");
  }

  // Future<CheckUpdate> checkForUpdate() async {
  //   return await _repository.syncHome();
  // }

}
