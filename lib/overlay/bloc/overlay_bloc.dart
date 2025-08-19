import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:unesco_mobile_app/overlay/bloc/overlay_event.dart';
import 'package:unesco_mobile_app/overlay/bloc/overlay_state.dart';

class OverLayBloc extends Bloc<OverlayEvent, OverLayState> {
  OverLayBloc() : super(OverLayState(height: 100)) {
    on<DisplayOverLay>((event, emit) async {
      final bool status = await FlutterOverlayWindow.isPermissionGranted();

      if (!status) {
        await FlutterOverlayWindow.requestPermission();
      }

      await FlutterOverlayWindow.showOverlay(
        height: state.isExpaned! ? 200 : 100,
        width: 80,
        enableDrag: true,
        overlayTitle: "AI Tracking",
        overlayContent: "Monitoring...",
        visibility: NotificationVisibility.visibilityPublic,
        flag: OverlayFlag.defaultFlag,
        alignment: OverlayAlignment.center,
      );
      emit(state.copyWith(isExpaned: !state.isExpaned!));
    });

    on<ExpandOverLay>((event, emit) async {
      await FlutterOverlayWindow.closeOverlay();
      await FlutterOverlayWindow.showOverlay(
        height: 200,
        width: 80,
        enableDrag: true,
        overlayTitle: "AI Tracking",
        overlayContent: "Monitoring...",
        visibility: NotificationVisibility.visibilityPublic,
        flag: OverlayFlag.defaultFlag,
        alignment: OverlayAlignment.center,
      );

      emit(state.copyWith(height: 200, isExpaned: true));
    });

    on<ShrinkOverLay>((event, emit) async{
      await FlutterOverlayWindow.closeOverlay();
      await FlutterOverlayWindow.showOverlay(
        height: 200,
        width: 80,
        enableDrag: true,
        overlayTitle: "AI Tracking",
        overlayContent: "Monitoring...",
        visibility: NotificationVisibility.visibilityPublic,
        flag: OverlayFlag.defaultFlag,
        alignment: OverlayAlignment.center,
      );

      emit(state.copyWith(height: 200, isExpaned: false));
    });

    on<CloseOverLay>((event, emit) async {
      await FlutterOverlayWindow.closeOverlay();
    });
  }
}
