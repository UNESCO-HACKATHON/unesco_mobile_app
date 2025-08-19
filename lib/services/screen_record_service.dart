import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:permission_handler/permission_handler.dart';

class ScreenRecordService {
  bool isStarted = false;

  void requestPermissions() async {
    if (await Permission.notification.isDenied) {
      print("permission is denied");
      await Permission.notification.request();
    }

    if (await Permission.microphone.isDenied) {
      print("permisiion is deined");
      await Permission.microphone.request();
    }
  }

  Future<bool> startScreenRecording({
    required String name,
    String? titleNotification,
    String? messageNotification,
  }) async {
    requestPermissions();
    if (!isStarted) {
      isStarted = await FlutterScreenRecording.startRecordScreenAndAudio(
        name,
        titleNotification: titleNotification,
        messageNotification: messageNotification,
        
      );
    }
    return isStarted;
  }

  Future<void> stopRecording() async {
    String path = await FlutterScreenRecording.stopRecordScreen;
    print(path);
    isStarted = false;
  }
}
