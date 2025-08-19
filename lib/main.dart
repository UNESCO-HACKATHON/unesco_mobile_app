import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unesco_mobile_app/overlay/bloc/overlay_bloc.dart';
import 'package:unesco_mobile_app/overlay/overlay_screen.dart';
import 'package:unesco_mobile_app/test_page.dart';

void main() {
  runApp(BlocProvider(create: (_) => OverLayBloc(), child: const MyApp()));
}

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    BlocProvider(
      create: (_) => OverLayBloc(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: OverlayScreen(),
      ),
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
