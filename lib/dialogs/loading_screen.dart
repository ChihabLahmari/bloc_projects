import 'dart:async';

import 'package:flutter/material.dart';
import 'package:testing_bloc_course/dialogs/loading_screen_controller.dart';

class LoadingScreen {
  // signleton pattern
  LoadingScreen._sharedinstance();
  static final LoadingScreen _shared = LoadingScreen._sharedinstance();
  factory LoadingScreen.instance() => _shared;

  // loading screen internally can manage it's own state
  LoadingScreenController? _controller;
  void show({
    required BuildContext context,
    required String text,
  }) {
    if (_controller?.update(text) ?? false) {
      return;
    }
    _controller = _showOverLay(
      context: context,
      text: text,
    );
  }

  void hide() {
    _controller?.close();
    _controller = null;
  }

  LoadingScreenController _showOverLay({
    required BuildContext context,
    required String text,
  }) {
    final streamText = StreamController<String>();
    streamText.add(text);

    // get the size
    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: size.height * 0.8,
                maxWidth: size.width * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      StreamBuilder<String>(
                        stream: streamText.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data!,
                              textAlign: TextAlign.center,
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        streamText.close();
        overlay.remove();
        return true;
      },
      update: (text) {
        streamText.add(text);
        return true;
      },
    );
  }
}
