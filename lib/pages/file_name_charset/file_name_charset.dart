import 'dart:io';

import 'package:disposable_tool/model/name_charset.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_charset/fl_charset.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class FileNameCharset extends StatefulWidget {
  const FileNameCharset({super.key});

  @override
  State<FileNameCharset> createState() => _FileNameCharsetState();
}

class _FileNameCharsetState extends State<FileNameCharset> {
  List<NameCharset> fileList = [];

  void getFiles() async {
    fileList.clear();
    String? dir = await FilePicker.platform.getDirectoryPath();
    if (dir == null) return;
    print('开始......');
    // 获取文件夹下的所有子文件夹
    List<FileSystemEntity> parentDirList =
        await Directory(dir).list().where((e) => e is Directory).toList();
    List<FileSystemEntity> childrenDir = [];
    for (final parentDir in parentDirList) {
      List<FileSystemEntity> children = await Directory(parentDir.path)
          .list(recursive: true)
          .where((e) => e is Directory)
          .toList();
      //  如果子文件夹的名称只有英文或只有数字，或只由英文和数字组成就删除
      children = children
          .where(
              (e) => !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(path.basename(e.path)))
          .toList();
      childrenDir.addAll(children);
    }
    var uuid = const Uuid();
    for (final file in childrenDir) {
      String id = uuid.v1();
      String name = path.basename(file.path);
      // String newName = shiftJis.decode(gbk.encode(name));
      String parent = path.dirname(file.path);
      NameCharset nameCharset = NameCharset(
        id: id,
        name: name,
        newName: name,
        parent: parent,
      );
      fileList.add(nameCharset);
      setState(() {});
    }
    print('完成！！！');
  }

  void removeFile(NameCharset nameCharset) {
    fileList.remove(nameCharset);
    setState(() {});
  }

  void changeNewName() {
    for (final nameCharset in fileList) {
      try {
        final result = gbk.encode(nameCharset.name);
        String newName = shiftJis.decode(result);
        fileList.firstWhere((e) => e.id == nameCharset.id).newName = newName;
        setState(() {});
      } catch (e) {
        print('文件名：${nameCharset.name}');
        print('路径：${nameCharset.parent}\\${nameCharset.name}');
        print('出错了：$e');
      }
    }
  }

  void undoChangeName() {
    for (final nameCharset in fileList) {
      nameCharset.newName = nameCharset.name;
      setState(() {});
    }
  }

  void removeSameName() {
    for (int i = 0; i < fileList.length; i++) {
      NameCharset current = fileList[i];
      if (current.name == current.newName) {
        fileList.removeAt(i);
        setState(() {});
      }
    }
  }

  void renameDir() async {
    for (final nameCharset in fileList) {
      if (nameCharset.name == nameCharset.newName) continue;
      Directory dir =
          Directory(path.join(nameCharset.parent, nameCharset.name));
      Directory newDir =
          Directory(path.join(nameCharset.parent, nameCharset.newName));
      try {
        await dir.rename(newDir.path);
        final file = fileList.firstWhere((e) => e.id == nameCharset.id);
        file.name = nameCharset.newName;
        setState(() {});
      } catch (e) {
        print(e);
      }
    }
  }

  void deleteAll() {
    fileList.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: Row(
              children: [
                Expanded(child: Text('原名称 —— ${fileList.length} 个文件夹')),
                const SizedBox(width: 12),
                const Expanded(child: Text('新名称')),
                IconButton(
                  onPressed: deleteAll,
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectionArea(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    NameCharset nameCharset = fileList[index];
                    return Container(
                      padding: const EdgeInsets.only(
                          left: 12, right: 8, top: 8, bottom: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(child: Text(nameCharset.name)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              nameCharset.newName,
                              style: nameCharset.name != nameCharset.newName
                                  ? TextStyle(color: Colors.blue[400])
                                  : null,
                            ),
                          ),
                          IconButton(
                            onPressed: () => removeFile(fileList[index]),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: fileList.length,
                ),
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
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: changeNewName,
                child: const Text('转变新名称'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: undoChangeName,
                child: const Text('撤销转变'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: removeSameName,
                child: const Text('删除同名项'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: renameDir,
                child: const Text('确定更改'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
