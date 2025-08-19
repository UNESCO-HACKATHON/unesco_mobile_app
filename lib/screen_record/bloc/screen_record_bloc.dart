import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unesco_mobile_app/screen_record/bloc/screen_record_event.dart';
import 'package:unesco_mobile_app/screen_record/bloc/screen_record_state.dart';
import 'package:unesco_mobile_app/services/screen_record_service.dart';

class ScreenRecordBloc extends Bloc<ScreenRecordEvent, ScreenRecordState> {
  ScreenRecordService recordService = ScreenRecordService();
  ScreenRecordBloc() : super(ScreenRecordState(isRecording: false)) {
    on<StartRecording>((event, emit) async {
      try {
        final start = await recordService.startScreenRecording(
          name: "test_video",
          titleNotification: "Scanning the content",
        );
        if (start) {
          emit(ScreenRecordState(isRecording: true));

          // Wait 2 seconds and stop
          await Future.delayed(Duration(seconds: 2));
          await recordService.stopRecording();

          emit(ScreenRecordState(isRecording: false));
        }

        emit(ScreenRecordState(isRecording: false, error: "Not recording"));
      } catch (e) {
        print("e");
      }
    });

    on<StopRecording>((event, emit) async {
      await recordService.stopRecording();
    });
  }
}
