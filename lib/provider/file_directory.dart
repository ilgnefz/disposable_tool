import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class FileDirectoryProvider extends ChangeNotifier {
  String? _dir;
  String? get dir => _dir;
  setDir([String? dir]) async {
    if (_dir == null) {
      _dir = await FilePicker.platform.getDirectoryPath();
      if (_dir != null) {
        addFile();
      }
    } else {
      _dir = dir;
      addFile();
    }
    notifyListeners();
  }

  final String _dirPathText = '当前未选择任何文件夹';
  String get dirPathText => _dir == null ? _dirPathText : '当前位置: $_dir';

  final List<FileSystemEntity> _files = [];
  List<FileSystemEntity> get files => _files;
  addFile() {
    _files.clear();
    Directory directory = Directory(_dir!);
    _files.addAll(directory.listSync());
    notifyListeners();
  }

  previousFiles() {
    if (_dir != null) {
      String dir = path.dirname(_dir!);
      // String rootDir = path.rootPrefix(_dir!);
      // print(dir);
      // print(rootDir);
      // if (dir != rootDir) {
      //   setDir(dir);
      // } else {
      //   _isRoot = true;
      // }
      setDir(dir);
      notifyListeners();
    }
  }

  bool _isRoot = false;
  bool get isRoot => _isRoot;
  setIsRoot(bool flag) {
    _isRoot = flag;
    notifyListeners();
  }

  // bool get showButton => true;
  // bool get showButton => _dir == null || _isRoot;

  showMenu() async {
    print('日你妈');
  }

  organizeFiles([String? tempDir]) {
    Directory dir = Directory(_dir!);
    List<FileSystemEntity> files = dir.listSync();
    if (files.isEmpty) return;
    // 如果只有一个文件并且为文件夹
    if (files.length == 1 &&
        files.single.statSync().type == FileSystemEntityType.directory) {
      organizeFiles(files.single.path);
    } else {
      // 如果有多个文件并且有文件夹和文件
      for (var i = 0; i < files.length; i++) {
        // 如果是文件就跳过，是文件夹就继续打开

      }
    }
  }
}
