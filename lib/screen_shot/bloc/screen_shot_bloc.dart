import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unesco_mobile_app/screen_shot/bloc/screen_shot_event.dart';
import 'package:unesco_mobile_app/screen_shot/bloc/screen_shot_state.dart';
import 'package:unesco_mobile_app/services/screen_shot_service.dart';

class ScreenShotBloc extends Bloc<ScreenShotEvent, ScreenShotState> {
  ScreenShotService screenShotService = ScreenShotService();
  ScreenShotBloc() : super(ScreenShotState()) {
    on<TakeScreenShot>((event, emit) async {
      try {
        await ScreenShotService.takeScreenshot();
      } catch (e) {
        print("error on screen shot bloc: $e");
      }
    });
  }
}
