import 'package:unesco_mobile_app/overlay/bloc/overlay_bloc.dart';

abstract class OverlayEvent {}


class DisplayOverLay extends OverlayEvent {}

class CloseOverLay extends OverlayEvent {}

class ExpandOverLay extends OverlayEvent {}

class ShrinkOverLay extends OverlayEvent {}