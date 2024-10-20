import 'dart:io';
import 'package:disposable_tool/utils/uid.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:path/path.dart' as path;

class ImageClassification extends StatefulWidget {
  const ImageClassification({super.key});

  @override
  State<ImageClassification> createState() => _ImageClassificationState();
}

class _ImageClassificationState extends State<ImageClassification> {
  List<ImageInfo> imgList = [];
  String runState = '未开始';

  void readDir() async {
    final String? dirPath = await FilePicker.platform.getDirectoryPath();
    if (dirPath != null) {
      runState = '运行中';
      setState(() {});
      List<FileSystemEntity> list = Directory(dirPath).listSync();
      for (var item in list) {
        if (item is File) {
          String name = path.basename(item.path);
          String extension = name.split('.').last;
          if (!imageType.contains(extension)) continue;
          final size = ImageSizeGetter.getSize(FileInput(File(item.path)));
          ImageOrientation orientation = ImageOrientation.other;
          if (size.width > size.height) {
            orientation = ImageOrientation.horizontal;
          }
          if (size.width < size.height) {
            orientation = ImageOrientation.vertical;
          }
          String id = AppUid.uid;
          imgList.add(
            ImageInfo(
              id: id,
              name: name,
              path: item.path,
              orientation: orientation,
            ),
          );
        }
      }
      assortImage(dirPath, imgList);
    }
  }

  void assortImage(String parent, List<ImageInfo> list) {
    String horizontal = path.join(parent, '横向');
    String vertical = path.join(parent, '竖向');
    if (!Directory(horizontal).existsSync()) {
      Directory(horizontal).createSync();
    }
    if (!Directory(vertical).existsSync()) {
      Directory(vertical).createSync();
    }
    for (var item in list) {
      if (item.orientation == ImageOrientation.horizontal) {
        try {
          File(item.path).renameSync(path.join(horizontal, item.name));
        } catch (e) {
          print(e.toString());
        }
      }
      if (item.orientation == ImageOrientation.vertical) {
        try {
          File(item.path).renameSync(path.join(vertical, item.name));
        } catch (e) {
          print(e.toString());
        }
      }
    }
    runState = '任务完成';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: readDir,
                    child: const Text("添加文件夹"),
                  ),
                  const SizedBox(height: 12),
                  Text(runState),
                ],
              ),
            ),
          ),
          // Container(
          //   height: 64,
          //   color: Colors.white,
          // ),
        ],
      ),
    );
  }
}

enum ImageOrientation { horizontal, vertical, other }

class ImageInfo {
  String id;
  String name;
  String path;
  ImageOrientation orientation;

  ImageInfo({
    required this.id,
    required this.name,
    required this.path,
    required this.orientation,
  });

  @override
  String toString() {
    return 'ImageInfo{id: $id, name: $name, orientation: $orientation}';
  }
}

final List<String> imageType = [
  'ai',
  'bmp',
  'cdr',
  'dib',
  'dxf',
  'eps',
  'exif',
  'fpx',
  'gif',
  'heic',
  'jfif',
  'jpe',
  'jpeg',
  'jpg',
  'pcd',
  'pcx',
  'png',
  'psd',
  'svg',
  'tga',
  'tif',
  'tiff',
  'raw',
  'ufo',
  'webp',
];
