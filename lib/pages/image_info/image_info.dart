import 'dart:io';
import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:disposable_tool/utils/generate_assets.dart';
import 'package:exif/exif.dart';
import 'package:flutter/material.dart';

class ImageInfoPage extends StatefulWidget {
  const ImageInfoPage({super.key});

  @override
  State<ImageInfoPage> createState() => _ImageInfoPageState();
}

class _ImageInfoPageState extends State<ImageInfoPage> {
  XFile? file;
  String? image;
  Map<String, IfdTag>? imageData;

  onDrag(detail) async {
    List<XFile> files = detail.fileList;
    file = files.single;
    image = file!.path;
    setState(() {});

    debugPrint('路径: ${file!.path}');
    debugPrint('名称: ${file!.name}');
    debugPrint('mimeType: ${file!.mimeType}');
    debugPrint('hashCode: ${file.hashCode}');
    debugPrint('string: ${file.toString()}');
    debugPrint('长度: ${await file!.length()}');
    debugPrint('上次修改: ${await file!.lastModified()}');
    FileSystemEntity imageFile = File(image!);
    debugPrint('path: ${imageFile.path}');
    debugPrint('parent: ${imageFile.parent}');
    debugPrint('uri: ${imageFile.uri}');
    debugPrint('absolute: ${imageFile.absolute}');
    debugPrint('isAbsolute: ${imageFile.isAbsolute}');
    debugPrint('hashCode: ${imageFile.hashCode}');
    debugPrint('runtimeType: ${imageFile.runtimeType}');
    debugPrint('toString: ${imageFile.toString()}');
    debugPrint('type: ${imageFile.statSync().type}');
    debugPrint('accessed: ${imageFile.statSync().accessed}');
    debugPrint('size: ${imageFile.statSync().size}');
    debugPrint('changed: ${imageFile.statSync().changed}');
    debugPrint('mode: ${imageFile.statSync().mode}');
    debugPrint('modified: ${imageFile.statSync().modified}');
    debugPrint('modeString: ${imageFile.statSync().modeString()}');
    debugPrint('hashCode: ${imageFile.resolveSymbolicLinksSync().hashCode}');
    debugPrint('length: ${imageFile.resolveSymbolicLinksSync().length}');
    debugPrint(
        'isNotEmpty: ${imageFile.resolveSymbolicLinksSync().isNotEmpty}');
    debugPrint('isEmpty: ${imageFile.resolveSymbolicLinksSync().isEmpty}');
    debugPrint(
        'characters: ${imageFile.resolveSymbolicLinksSync().characters}');
    debugPrint('codeUnits: ${imageFile.resolveSymbolicLinksSync().codeUnits}');
    debugPrint('runes: ${imageFile.resolveSymbolicLinksSync().runes}');
    debugPrint(
        'runtimeType: ${imageFile.resolveSymbolicLinksSync().runtimeType}');
    debugPrint('toString: ${imageFile.resolveSymbolicLinksSync().toString()}');
    debugPrint(
        'capitalize: ${imageFile.resolveSymbolicLinksSync().capitalize}');
    debugPrint('路径: ${imageFile.resolveSymbolicLinksSync().characters}');
    final fileBytes = File(image!).readAsBytesSync();
    imageData = await readExifFromBytes(fileBytes);
    if (imageData!.isEmpty) {
      debugPrint("No EXIF information found");
      return;
    }
    if (imageData!.containsKey('JPEGThumbnail')) {
      debugPrint('File has JPEG thumbnail');
      imageData!.remove('JPEGThumbnail');
    }
    if (imageData!.containsKey('TIFFThumbnail')) {
      debugPrint('File has TIFF thumbnail');
      imageData!.remove('TIFFThumbnail');
    }
    for (final entry in imageData!.entries) {
      debugPrint("${entry.key}: ${entry.value}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            Container(
              width: 320,
              padding: const EdgeInsets.all(12),
              child: ListView(
                children: [
                  SimpleText('名称', file == null ? '' : file!.name),
                  SimpleText('文件路径', image ?? '暂无'),
                  SimpleText('mimeType', file == null ? '' : file!.mimeType),
                  SimpleText(
                      'HashCode', file == null ? '' : File(image!).hashCode),
                  SimpleText(
                      '类型', file == null ? '' : File(image!).statSync().type),
                  SimpleText(
                      '大小',
                      file == null
                          ? ''
                          : '${File(image!).statSync().size / 1024} KB'),
                  SimpleText('访问时间',
                      file == null ? '' : File(image!).statSync().accessed),
                  SimpleText('创建时间',
                      file == null ? '' : File(image!).statSync().changed),
                  SimpleText('修改时间',
                      file == null ? '' : File(image!).statSync().modified),
                  SimpleText(
                      '图片宽', file == null ? '' : File(image!).statSync().type),
                  if (imageData != null && imageData!.isNotEmpty) ...[
                    SimpleText('图片宽', imageData!['Image ImageWidth']),
                    SimpleText('图片高', imageData!['Image ImageLength']),
                    SimpleText('设备型号', imageData!['Image Model']),
                    SimpleText('相机厂商', imageData!['Image Make']),
                    SimpleText('Exif偏移量', imageData!['Image ExifOffset']),
                    SimpleText('图片取向', imageData!['Image Orientation']),
                    SimpleText('拍摄时间', imageData!['Image DateTime']),
                    SimpleText('白平衡', imageData!['EXIF WhiteBalance']),
                    SimpleText('ISO 感光度', imageData!['EXIF ISOSpeedRatings']),
                    SimpleText('焦距', '${imageData!['EXIF FocalLength']} mm'),
                    SimpleText('曝光时间', imageData!['EXIF ExposureTime']),
                    SimpleText('闪光灯', imageData!['EXIF Flash']),
                    SimpleText('光源', imageData!['EXIF LightSource']),
                    SimpleText('光圈值', 'F ${imageData!['EXIF FNumber']}'),
                  ]
                ],
              ),
            ),
            Expanded(
              child: ColoredBox(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: DropTarget(
                    onDragDone: (detail) => onDrag(detail),
                    child: image == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_rounded,
                                size: 88,
                                color: Theme.of(context).primaryColor,
                              ),
                              const Text('拖动图片到这里',
                                  style: TextStyle(fontSize: 24)),
                            ],
                          )
                        : Image.file(
                            File(image!),
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleText extends StatelessWidget {
  const SimpleText(this.title, this.value, {super.key});

  final String title;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 80,
              alignment: Alignment.centerRight,
              child: Text('$title: ')),
          Expanded(child: Text(value.toString())),
        ],
      ),
    );
  }
}
