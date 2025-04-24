import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:pinyin/pinyin.dart';
import 'package:uuid/uuid.dart';

class FolderDiff extends StatefulWidget {
  const FolderDiff({super.key});

  @override
  State<FolderDiff> createState() => _FolderDiffState();
}

class _FolderDiffState extends State<FolderDiff> {
  bool isLoading = false;
  List<EasyDiff> folders1 = [], folders2 = [];
  final uuid = const Uuid();

  void addFolder(List<EasyDiff> list) async {
    list.clear();
    String? dir = await FilePicker.platform.getDirectoryPath();
    if (dir != null) {
      isLoading = true;
      setState(() {});
      final files = await Directory(dir).list().toList();
      files.sort((a, b) => PinyinHelper.getPinyinE(a.path)
          .compareTo(PinyinHelper.getPinyinE(b.path)));
      for (var file in files) {
        String id = uuid.v4();
        String name = path.basename(file.path);
        list.add(
            EasyDiff(id: id, name: name, filePath: file.path, unique: true));
      }
      setState(() {});
    }
    diff();
    isLoading = false;
    setState(() {});
  }

  void diff() {
    for (var folder1 in folders1) {
      for (var folder2 in folders2) {
        if (folder1.name == folder2.name) {
          folder1.unique = false;
          folder2.unique = false;
        }
      }
    }
    setState(() {});
  }

  void deleteNotUnique(List<EasyDiff> list) async {
    // list.removeWhere((element) {
    //   return !element.unique;
    // });

    for (var file in list) {
      if (!file.unique) {
        try {
          await File(file.filePath).delete();
        } catch (e) {
          print(e);
        }
      }
    }
    list.removeWhere((element) {
      return !element.unique;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleFileList(
                  files: folders1,
                  onAddFile: () => addFolder(folders1),
                  onDeleteFile: () => deleteNotUnique(folders1),
                ),
                SingleFileList(
                  files: folders2,
                  onAddFile: () => addFolder(folders2),
                  onDeleteFile: () => deleteNotUnique(folders2),
                ),
              ],
            ),
    );
  }
}

class SingleFileList extends StatelessWidget {
  const SingleFileList({
    super.key,
    required this.files,
    required this.onAddFile,
    required this.onDeleteFile,
  });

  final List<EasyDiff> files;
  final VoidCallback onAddFile;
  final VoidCallback onDeleteFile;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text('共 ${files.length} 个文件'),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, index) {
                  EasyDiff file = files[index];
                  return Container(
                    key: ValueKey(file.id),
                    height: 32,
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      file.name,
                      style: TextStyle(
                        color: file.unique ? Colors.blue : Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
            ),
          ),
          Row(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: onAddFile, child: const Text('设置文件夹')),
              ElevatedButton(
                  onPressed: onDeleteFile, child: const Text('删除不唯一')),
            ],
          ),
        ],
      ),
    );
  }
}

class EasyDiff {
  String id;
  String name;
  String filePath;
  bool unique;

  EasyDiff({
    required this.id,
    required this.name,
    required this.filePath,
    required this.unique,
  });
}
