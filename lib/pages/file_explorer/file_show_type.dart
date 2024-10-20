import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class FileShowType extends StatelessWidget {
  const FileShowType({required this.file, required this.size, super.key});

  final FileSystemEntity file;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (file.statSync().type == FileSystemEntityType.directory) {
      return Icon(Icons.folder, size: size, color: Colors.amber);
    } else {
      if (['.jpg', '.png', '.gif', '.jpeg', '.jfif', '.webp']
          .contains(path.extension(file.path).toLowerCase())) {
        if (size < 50) {
          return Image.file(File(file.path),
              fit: BoxFit.contain, width: size, height: size);
        }
        return Image.file(File(file.path), fit: BoxFit.scaleDown);
      }
      if (['.avi', '.mp4', '.mkv', '.wmv']
          .contains(path.extension(file.path).toLowerCase())) {
        return Icon(Icons.video_file,
            size: size, color: Colors.grey.withOpacity(.4));
      }
      if (['.mp3', '.flac', '.m4a']
          .contains(path.extension(file.path).toLowerCase())) {
        return Icon(Icons.audio_file,
            size: size, color: Colors.grey.withOpacity(.4));
      }
      return Icon(Icons.insert_drive_file_rounded,
          size: size, color: Colors.grey.withOpacity(.4));
    }
  }
}
