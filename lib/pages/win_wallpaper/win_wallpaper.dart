import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:win32/win32.dart';

class WinWallpaper extends StatefulWidget {
  const WinWallpaper({super.key});

  @override
  State<WinWallpaper> createState() => _WinWallpaperState();
}

class _WinWallpaperState extends State<WinWallpaper> {
  late DesktopWallpaper wallpaper;

  String current = '';
  String image = '';

  void printWallpaper() {
    final pathPtr = calloc<Pointer<Utf16>>();

    try {
      final hr = wallpaper.getWallpaper(nullptr, pathPtr);

      switch (hr) {
        case S_OK:
          final path = pathPtr.value.toDartString();
          if (path.isNotEmpty) current = path;
          print(path.isEmpty
              ? 'No wallpaper is set.'
              : 'Wallpaper path is: $path');

        case S_FALSE:
          print('Different monitors are displaying different wallpapers, or a '
              'slideshow is running.');

        default:
          throw WindowsException(hr);
      }
    } finally {
      free(pathPtr);
    }
  }

  void printBackgroundColor() {
    final colorPtr = calloc<COLORREF>();

    try {
      final hr = wallpaper.getBackgroundColor(colorPtr);

      if (SUCCEEDED(hr)) {
        final color = colorPtr.value;
        print('Background color is: RGB(${GetRValue(color)}, '
            '${GetGValue(color)}, ${GetBValue(color)})');
      } else {
        throw WindowsException(hr);
      }
    } finally {
      free(colorPtr);
    }
  }

  void result() {
    final hr = CoInitializeEx(
        nullptr, COINIT_APARTMENTTHREADED | COINIT_DISABLE_OLE1DDE);
    if (FAILED(hr)) throw WindowsException(hr);

    wallpaper = DesktopWallpaper.createInstance();

    printWallpaper();
    printBackgroundColor();
    setState(() {});
  }

  void selectImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      image = file.path;
      setState(() {});
    }
  }

  void setWallpaper(String path) {
    wallpaper = DesktopWallpaper.createInstance();

    wallpaper.setWallpaper(nullptr, path.toNativeUtf16());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: result,
              child: const Text('获取'),
            ),
            TextButton(
              onPressed: selectImage,
              child: const Text('选择图片'),
            ),
            TextButton(
              onPressed: image == '' ? null : () => setWallpaper(image),
              child: const Text('设置壁纸'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              width: double.maxFinite,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double width = constraints.maxWidth / 2;
                  return Row(
                    children: [
                      if (current != '')
                        ShowImage(image: current, name: '当前', width: width),
                      if (image != '')
                        ShowImage(image: image, name: '选中', width: width),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShowImage extends StatelessWidget {
  const ShowImage({
    super.key,
    required this.image,
    required this.name,
    required this.width,
  });

  final String image;
  final String name;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Image.file(File(image)), Text(name)],
      ),
    );
  }
}
