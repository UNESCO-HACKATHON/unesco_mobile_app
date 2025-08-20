import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unesco_mobile_app/screen_record/bloc/screen_record_bloc.dart';
import 'package:unesco_mobile_app/screen_shot/bloc/screen_shot_bloc.dart';
import 'package:unesco_mobile_app/services/screen_record_service.dart';
import 'package:unesco_mobile_app/test_page.dart';

void main() {
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ScreenShotBloc>(create: (_)=>ScreenShotBloc()),
        BlocProvider<ScreenRecordBloc>(create: (_) => ScreenRecordBloc()),
      ],

      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TestPage());
  }
}
