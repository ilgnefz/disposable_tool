import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class FileCard extends StatelessWidget {
  const FileCard({Key? key, required this.file, required this.onTap})
      : super(key: key);

  final FileSystemEntity file;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: ShowType(file)),
            const SizedBox(width: 8),
            Text(
              path.basename(file.path),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class ShowType extends StatelessWidget {
  const ShowType(this.file, {Key? key}) : super(key: key);

  final FileSystemEntity file;
  final Color _fileColor = const Color(0xfff7d774);

  @override
  Widget build(BuildContext context) {
    if (file.statSync().type == FileSystemEntityType.directory) {
      return Icon(Icons.folder, size: 100, color: _fileColor);
    } else {
      if (['.jpg', '.png', '.gif', '.jpeg']
          .contains(path.extension(file.path).toLowerCase())) {
        return Image.file(File(file.path), fit: BoxFit.contain);
      }
      if (['.avi', '.mp4', '.mkv', '.wmv']
          .contains(path.extension(file.path).toLowerCase())) {
        return Icon(Icons.video_file,
            size: 100, color: Colors.grey.withOpacity(.4));
      }
      if (['.mp3', '.flac', '.m4a']
          .contains(path.extension(file.path).toLowerCase())) {
        return Icon(Icons.audio_file,
            size: 100, color: Colors.grey.withOpacity(.4));
      }
      return Icon(Icons.insert_drive_file_rounded,
          size: 100, color: Colors.grey.withOpacity(.4));
    }
  }
}
