import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:unesco_mobile_app/overlay/bloc/overlay_bloc.dart';
import 'package:unesco_mobile_app/overlay/bloc/overlay_event.dart';
import 'package:unesco_mobile_app/overlay/bloc/overlay_state.dart';

class OverlayScreen extends StatefulWidget {
  const OverlayScreen({super.key});

  @override
  State<OverlayScreen> createState() => _OverlayScreenState();
}

class _OverlayScreenState extends State<OverlayScreen> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OverLayBloc, OverLayState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            //state.isExpaned! ? context.read<OverLayBloc>().add(ShrinkOverLay()) : context.read<OverLayBloc>().add(ExpandOverLay());
            // setState(() {
            //   expanded = !expanded; // toggle expand/collapse
            // });
            context.read<OverLayBloc>().add(DisplayOverLay());
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: state.isExpaned! ? 200 : 100,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(30),
            ),
            child:
                state.isExpaned!
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.mic, color: Colors.white),
                          onPressed: () {
                            // trigger speech-to-text
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.white),
                          onPressed: () {
                            // trigger AI search
                          },
                        ),
                      ],
                    )
                    : const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }
}
