import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:path/path.dart' as path;
import 'package:pinyin/pinyin.dart';

class DirectoryFiles extends StatefulWidget {
  const DirectoryFiles({super.key});

  @override
  State<DirectoryFiles> createState() => _DirectoryFilesState();
}

class _DirectoryFilesState extends State<DirectoryFiles> {
  List<String> fileList = [];
  String name = '';
  TextEditingController nameController = TextEditingController();

  void getFiles() async {
    String? dir = await FilePicker.platform.getDirectoryPath();
    if (dir == null) return;
    //   获取文件夹下所有子文件的名称
    Set<String> fileSet = await Directory(dir)
        .list()
        .map((e) => path.basenameWithoutExtension(e.path))
        .toSet();
    fileList = fileSet.toList();
    // 按名称排序files
    fileList.sort((a, b) =>
        PinyinHelper.getPinyinE(a).compareTo(PinyinHelper.getPinyinE(b)));
    // customSort(files);
    // files.sort((a, b) => a.compareTo(b));
    setState(() {});
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final String item = fileList.removeAt(oldIndex);
    fileList.insert(newIndex, item);
    setState(() {});
  }

  void copyFileName() async {
    String text = '';
    for (int i = 0; i < fileList.length; i++) {
      text += '${fileList[i]}\n';
    }
    Pasteboard.writeText(text);
    var cancel = BotToast.showText(text: "复制成功");
    await Future.delayed(const Duration(seconds: 3), () {
      cancel();
    });
  }

  void copyText() async {
    String text = '';
    for (int i = 0; i < fileList.length; i++) {
      text += '${fileList[i]}, $name${formatNum(i + 1)}\n';
    }
    Pasteboard.writeText(text);
    var cancel = BotToast.showText(text: "复制成功");
    await Future.delayed(const Duration(seconds: 3), () {
      cancel();
    });
  }

  String formatNum(int index) {
    return index < 10 ? '0$index' : '$index';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ReorderableListView.builder(
                  itemBuilder: (context, index) => Container(
                    key: ValueKey(fileList[index]),
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 48,
                    ),
                    child: Row(
                      children: [
                        Text(fileList[index]),
                        const Spacer(),
                        Text('$name${formatNum(index + 1)}'),
                        const SizedBox(width: 16),
                        CloseButton(
                          onPressed: () {
                            fileList.remove(fileList[index]);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  itemCount: fileList.length,
                  onReorder: _onReorder,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: getFiles,
                  child: const Text('选择文件夹'),
                ),
                Container(
                  width: 240,
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: nameController,
                    onChanged: (value) {
                      name = value;
                      setState(() {});
                    },
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration.collapsed(
                      hintText: '输入新文件名',
                      hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ),
                ElevatedButton(
                  onPressed: copyFileName,
                  child: const Text('复制文件名'),
                ),
                ElevatedButton(
                  onPressed: copyText,
                  child: const Text('复制新旧文本'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
