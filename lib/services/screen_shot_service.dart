import 'package:flutter/services.dart';

class ScreenShotService {
  static const platform = MethodChannel('screenshot_channel');

  static Future<void> takeScreenshot() async {
    print("On service \n onServier /n on sercie");
    try {
      print("Retrun path");
      final path = await platform.invokeMethod('takeScreenshot');
      print("path........................................$path"); // Will show "Screenshot code runs here" for now
    } catch (e) {
      print("Error: $e");
    }
  }
}
