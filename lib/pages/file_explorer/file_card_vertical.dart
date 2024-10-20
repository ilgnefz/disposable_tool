import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import 'file_show_type.dart';

class FileCardVertical extends StatelessWidget {
  const FileCardVertical(
      {required this.fileList,
      required this.onDoubleTap,
      super.key,
      required this.onSelected});

  final List<FileSystemEntity> fileList;
  final void Function(FileSystemEntity value) onSelected;
  final void Function(BuildContext context, FileSystemEntity value) onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return GridView.count(
          controller: ScrollController(),
          childAspectRatio: 5 / 6,
          crossAxisCount: (constraints.maxWidth / 150).floor(),
          children: fileList.map((file) {
            return InkWell(
              onTap: () => onSelected(file),
              onDoubleTap: () => onDoubleTap(context, file),
              child: Container(
                width: 140,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: FileShowType(file: file, size: 100)),
                    Text(
                      path.basename(file.path),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
