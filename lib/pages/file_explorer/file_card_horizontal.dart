import 'dart:io';

import 'package:disposable_tool/pages/file_explorer/file_show_type.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class FileTypeCardHorizontal extends StatelessWidget {
  const FileTypeCardHorizontal({
    required this.fileList,
    required this.onDoubleTap,
    super.key,
  });

  final List<FileSystemEntity> fileList;
  final void Function(BuildContext context, FileSystemEntity value) onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: ScrollController(),
      itemCount: fileList.length,
      itemBuilder: (context, index) {
        FileSystemEntity file = fileList[index];
        // bool isHiddenFile = path.basename(file.path).startsWith('.') || path.basename(file.path).startsWith('\$');
        return InkWell(
          onTap: () {},
          onDoubleTap: () => onDoubleTap(context, fileList[index]),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: Row(
              children: [
                FileShowType(file: file, size: 32),
                const SizedBox(width: 8),
                Text(path.basename(file.path)),
              ],
            ),
          ),
        );
      },
    );
  }
}
