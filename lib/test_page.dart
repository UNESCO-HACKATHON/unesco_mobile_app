
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:unesco_mobile_app/screen_record/bloc/screen_record_bloc.dart';
import 'package:unesco_mobile_app/screen_record/bloc/screen_record_event.dart';
import 'package:unesco_mobile_app/screen_record/bloc/screen_record_state.dart';

class TestPage extends StatelessWidget {
  // final _receivePort = ReceivePort();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plugin example app')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                context.read<ScreenRecordBloc>().add(StartRecording());
              },
              child: Text("Start recording"),
            ),
            TextButton(
              onPressed: () {
                context.read<ScreenRecordBloc>().add(StopRecording());
              },
              child: Text("Stop recording"),
            ),
            BlocBuilder<ScreenRecordBloc, ScreenRecordState>(
              builder: (context, state) {
                if (state.isRecording) {
                  return Text("Recording.....");
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
