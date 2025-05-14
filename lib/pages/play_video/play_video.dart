import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class PlayVideo extends StatefulWidget {
  const PlayVideo({super.key});

  @override
  State<PlayVideo> createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  late final player = Player();
  late final controller = VideoController(player);
  String videoPath = '';

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void _dragDone(DropDoneDetails detail) async {
    videoPath = detail.files.last.path;
    player.open(Media(videoPath), play: false);
    final screenShot = await player.screenshot();
    // print(screenShot);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget upload = const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.ondemand_video_rounded, size: 60, color: Colors.blue),
        SizedBox(height: 8),
        Text(
          '拖动视频打开',
          style: TextStyle(fontSize: 24, color: Colors.blue),
        ),
      ],
    );

    Widget view = SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 9.0 / 16.0,
      // Use [Video] widget to display video output.
      child: Video(controller: controller),
    );

    return DropTarget(
      onDragDone: _dragDone,
      child: Center(child: videoPath.isEmpty ? upload : view),
    );
  }
}
