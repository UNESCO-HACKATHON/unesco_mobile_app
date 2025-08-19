import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:unesco_mobile_app/overlay/bloc/overlay_bloc.dart';
import 'package:unesco_mobile_app/overlay/bloc/overlay_event.dart';
import 'package:unesco_mobile_app/overlay/bloc/overlay_state.dart';

class TestPage extends StatefulWidget {
  static const String _kPortNameOverlay = 'OVERLAY';
  static const String _kPortNameHome = 'UI';

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  // final _receivePort = ReceivePort();

  // SendPort? homePort;

  // String? latestMessageFromOverlay;

  // @override
  // void initState() {
  //   super.initState();
  //   if (homePort != null) return;
  //   final res = IsolateNameServer.registerPortWithName(
  //     _receivePort.sendPort,
  //     TestPage._kPortNameHome,
  //   );

  //   _receivePort.listen((message) {
  //     print("message from OVERLAY: $message");
  //     setState(() {
  //       latestMessageFromOverlay = 'Latest Message From Overlay: $message';
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plugin example app')),
      body: Center(
        child: BlocBuilder<OverLayBloc, OverLayState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    context.read<OverLayBloc>().add(DisplayOverLay());
                  },
                  child: Text("Display"),
                ),
                TextButton(
                  onPressed: () {
                    context.read<OverLayBloc>().add(CloseOverLay());
                  },
                  child: Text("Close over lay"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
