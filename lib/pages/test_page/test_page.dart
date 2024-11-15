import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String videoPath = '';

  late VideoPlayerController _controller;

  void addVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      videoPath = file.path;
      _controller = VideoPlayerController.file(File(videoPath))
        ..initialize().then((_) {
          // _controller.play();
        });
      setState(() {});
    }
  }

  void playToggle() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          if (videoPath != '')
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                children: [
                  VideoPlayer(_controller),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: playToggle,
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause_circle_filled_outlined
                            : Icons.play_circle_outlined,
                        size: 50,
                      ),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ElevatedButton(
            onPressed: addVideo,
            child: const Text('选择视频'),
          ),
        ],
      ),
    );
  }
}
