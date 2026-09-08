import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:win32/win32.dart';

// 表示“所有显示器/当前显示器”的空监视器指针
//（DesktopWallpaper 的 CLSID 已由 win32 包作为 DesktopWallpaper 常量导出）
final _nullMonitor = PCWSTR(Pointer<Utf16>.fromAddress(0));

class WinWallpaper extends StatefulWidget {
  const WinWallpaper({super.key});

  @override
  State<WinWallpaper> createState() => _WinWallpaperState();
}

class _WinWallpaperState extends State<WinWallpaper> {
  late IDesktopWallpaper wallpaper;

  String current = '';
  String image = '';

  void debugPrintWallpaper() {
    final path = wallpaper.getWallpaper(_nullMonitor).toDartString();
    if (path.isNotEmpty) current = path;
    debugPrint(
        path.isEmpty ? 'No wallpaper is set.' : 'Wallpaper path is: $path');
  }

  void debugPrintBackgroundColor() {
    final color = wallpaper.getBackgroundColor();
    debugPrint('Background color is: RGB(${GetRValue(color)}, '
        '${GetGValue(color)}, ${GetBValue(color)})');
  }

  void result() {
    final hr =
        CoInitializeEx(COINIT_APARTMENTTHREADED | COINIT_DISABLE_OLE1DDE);
    if (FAILED(hr)) throw WindowsException(hr);

    wallpaper = createInstance<IDesktopWallpaper>(DesktopWallpaper);

    debugPrintWallpaper();
    debugPrintBackgroundColor();
    setState(() {});
  }

  void selectImage() async {
    List<PlatformFile> result = await FilePicker.pickFiles(
      type: FileType.image,
    );
    if (result.isNotEmpty) {
      File file = File(result.single.path!);
      image = file.path;
      setState(() {});
    }
  }

  void setWallpaper(String path) {
    wallpaper = createInstance<IDesktopWallpaper>(DesktopWallpaper);

    using((arena) {
      wallpaper.setWallpaper(
          _nullMonitor, PCWSTR(path.toNativeUtf16(allocator: arena)));
    });
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
        children: [Expanded(child: Image.file(File(image))), Text(name)],
      ),
    );
  }
}
