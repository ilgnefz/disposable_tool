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
    List<XFile> files = detail.files;
    file = files.single;
    image = file!.path;
    setState(() {});

    print('路径: ${file!.path}');
    print('名称: ${file!.name}');
    print('mimeType: ${file!.mimeType}');
    print('hashCode: ${file.hashCode}');
    print('string: ${file.toString()}');
    print('长度: ${await file!.length()}');
    print('上次修改: ${await file!.lastModified()}');
    FileSystemEntity imageFile = File(image!);
    print('path: ${imageFile.path}');
    print('parent: ${imageFile.parent}');
    print('uri: ${imageFile.uri}');
    print('absolute: ${imageFile.absolute}');
    print('isAbsolute: ${imageFile.isAbsolute}');
    print('hashCode: ${imageFile.hashCode}');
    print('runtimeType: ${imageFile.runtimeType}');
    print('toString: ${imageFile.toString()}');
    print('type: ${imageFile.statSync().type}');
    print('accessed: ${imageFile.statSync().accessed}');
    print('size: ${imageFile.statSync().size}');
    print('changed: ${imageFile.statSync().changed}');
    print('mode: ${imageFile.statSync().mode}');
    print('modified: ${imageFile.statSync().modified}');
    print('modeString: ${imageFile.statSync().modeString()}');
    print('hashCode: ${imageFile.resolveSymbolicLinksSync().hashCode}');
    print('length: ${imageFile.resolveSymbolicLinksSync().length}');
    print('isNotEmpty: ${imageFile.resolveSymbolicLinksSync().isNotEmpty}');
    print('isEmpty: ${imageFile.resolveSymbolicLinksSync().isEmpty}');
    print('characters: ${imageFile.resolveSymbolicLinksSync().characters}');
    print('codeUnits: ${imageFile.resolveSymbolicLinksSync().codeUnits}');
    print('runes: ${imageFile.resolveSymbolicLinksSync().runes}');
    print('runtimeType: ${imageFile.resolveSymbolicLinksSync().runtimeType}');
    print('toString: ${imageFile.resolveSymbolicLinksSync().toString()}');
    print('capitalize: ${imageFile.resolveSymbolicLinksSync().capitalize}');
    print('路径: ${imageFile.resolveSymbolicLinksSync().characters}');
    final fileBytes = File(image!).readAsBytesSync();
    imageData = await readExifFromBytes(fileBytes);
    if (imageData!.isEmpty) {
      print("No EXIF information found");
      return;
    }
    if (imageData!.containsKey('JPEGThumbnail')) {
      print('File has JPEG thumbnail');
      imageData!.remove('JPEGThumbnail');
    }
    if (imageData!.containsKey('TIFFThumbnail')) {
      print('File has TIFF thumbnail');
      imageData!.remove('TIFFThumbnail');
    }
    for (final entry in imageData!.entries) {
      print("${entry.key}: ${entry.value}");
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
