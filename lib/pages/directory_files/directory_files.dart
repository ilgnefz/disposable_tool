import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:pinyin/pinyin.dart';

class DirectoryFiles extends StatefulWidget {
  const DirectoryFiles({super.key});

  @override
  State<DirectoryFiles> createState() => _DirectoryFilesState();
}

class _DirectoryFilesState extends State<DirectoryFiles> {
  String filesName = '';

  void getFiles() async {
    String? dir = await FilePicker.platform.getDirectoryPath();
    if (dir == null) return;
    //   获取文件夹下所有子文件的名称
    List<String> files = await Directory(dir)
        .list()
        .map((e) => path.basenameWithoutExtension(e.path))
        .toList();
    // 按名称排序files
    // files.sort((a, b) =>
    //     PinyinHelper.getPinyinE(a).compareTo(PinyinHelper.getPinyinE(b)));
    // customSort(files);
    files.sort((a, b) => a.compareTo(b));
    filesName = files.join('\n');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: getFiles,
              child: const Text('选择文件夹'),
            ),
            const SizedBox(height: 24),
            if (filesName != '')
              Expanded(
                  child: SingleChildScrollView(
                      child: SelectionArea(child: Text(filesName)))),
          ],
        ),
      ),
    );
  }
}

// void customSort(List<String> list) {
//   int n = list.length;
//   for (int i = 0; i < n - 1; i++) {
//     for (int j = i + 1; j < n; j++) {
//       bool shouldSwap = false;
//       int minLength =
//           list[i].length < list[j].length ? list[i].length : list[j].length;
//       for (int k = 0; k < minLength; k++) {
//         if (list[i].codeUnitAt(k) > list[j].codeUnitAt(k)) {
//           shouldSwap = true;
//           break;
//         } else if (list[i].codeUnitAt(k) < list[j].codeUnitAt(k)) {
//           break;
//         }
//       }
//       if (shouldSwap || (list[i].length > list[j].length)) {
//         String temp = list[i];
//         list[i] = list[j];
//         list[j] = temp;
//       }
//     }
//   }
// }
