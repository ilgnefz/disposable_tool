import 'dart:io';

import 'package:disposable_tool/pages/file_explorer/file_view.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:universal_disk_space/universal_disk_space.dart';

class FileExplorerProvider extends ChangeNotifier {
  /// 获取电脑所有磁盘
  final List<Disk> _diskList = [];
  List<Disk> get diskList => _diskList;
  getDiskInfo() async {
    final diskSpace = DiskSpace();
    await diskSpace.scan();
    var disks = diskSpace.disks;
    _diskList.clear();
    _diskList.addAll(disks);
    notifyListeners();
  }

  /// 文件显示的模式
  bool _showStyle = false;
  bool get showStyle => _showStyle;
  switchShowStyle() {
    _showStyle = !_showStyle;
    notifyListeners();
  }

  /// 获取当前路径并读取路径下的所有文件
  String? _currentPath;
  String get currentPath => _currentPath ?? '此电脑';
  setCurrentPath(String? value) {
    _currentPath = value;
    loadAllFile();
    notifyListeners();
  }

  /// 是否禁用上一层按钮
  bool get isDisable => _currentPath == null;

  /// 返回上一层
  previousPath() {
    String dirPath = path.dirname(_currentPath!);
    if (dirPath == '.' || dirPath == _currentPath) {
      setCurrentPath(null);
    } else {
      setCurrentPath(dirPath);
    }
    notifyListeners();
  }

  /// 是否查看隐藏文件
  bool _showHiddenFile = false;
  bool get showHiddenFile => _showHiddenFile;
  switchHiddenFile() {
    _showHiddenFile = !_showHiddenFile;
    notifyListeners();
  }

  /// 文件列表
  final List<FileSystemEntity> _fileList = [];
  List<FileSystemEntity> get fileList => _fileList;
  addAllFile(List<FileSystemEntity> value) {
    _fileList.addAll(value);
  }

  /// 获取文件夹（磁盘）下的所有文件
  loadAllFile() {
    List<FileSystemEntity> onlyDirectory = [];
    List<FileSystemEntity> onlyFile = [];
    // List<FileSystemEntity> onlyHidden = [];
    List<FileSystemEntity> onlyUnknown = [];
    if (_currentPath != null) {
      Directory directory = Directory(_currentPath!);
      List<FileSystemEntity> allFile = directory.listSync();
      for (var value in allFile) {
        if (value.statSync().type == FileSystemEntityType.directory) {
          onlyDirectory.add(value);
        } else if (value.statSync().type == FileSystemEntityType.file) {
          onlyFile.add(value);
        } else {
          onlyUnknown.add(value);
        }
      }
      _fileList.clear();
      onlyDirectory.addAll(onlyFile);
      _fileList.addAll(onlyDirectory);
    }
  }

  /// 文件分类
  final List<String> imageExtension = [
    '.jpg',
    '.png',
    '.gif',
    '.jpeg',
    '.jfif',
    '.webp'
  ];
  final List<String> videoExtension = ['.avi', '.mp4', '.mkv', '.wmv'];
  final List<String> audioExtension = ['.mp3', '.flac', '.m4a'];

  /// 当前预览文件的路径
  FileSystemEntity? _currentViewFile;
  FileSystemEntity? get currentViewFile => _currentViewFile;
  setCurrentViewFile(FileSystemEntity? value, [BuildContext? context]) {
    _currentViewFile = value;
    notifyListeners();
    if (context != null) openViewFiles(context);
  }

  /// 上一张图和下一张图
  final List<FileSystemEntity> _onlyImage = [];
  List<FileSystemEntity> get onlyImage => _onlyImage;
  setImageList() {
    for (var file in fileList) {
      if (imageExtension.contains(path.extension(file.path))) {
        _onlyImage.add(file);
      }
    }
    notifyListeners();
  }

  previousImage(FileSystemEntity file) {
    int index = _onlyImage.indexOf(_currentViewFile!);
    if (index > 0) {
      _currentViewFile = _onlyImage[index - 1];
    } else if (index == 0) {
      _currentViewFile = _onlyImage[_onlyImage.length - 1];
    }
    notifyListeners();
  }

  nextImage(FileSystemEntity file) {
    int index = _onlyImage.indexOf(_currentViewFile!);
    if (index < _onlyImage.length) {
      _currentViewFile = _onlyImage[index + 1];
    } else if (index == _onlyImage.length) {
      _currentViewFile = _onlyImage[0];
    }
    notifyListeners();
  }

  /// 查看文件
  openViewFiles(BuildContext context) {
    String fileExtension = path.extension(_currentViewFile!.path).toLowerCase();
    bool isImage = imageExtension.contains(fileExtension);
    // bool isVideo = videoExtension.contains(fileExtension);
    // bool isAudio = audioExtension.contains(fileExtension);
    if (isImage) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            child: ImageView(_currentViewFile!),
          );
        },
      );
    }
  }

  /// 关闭查看的文件
  closeViewFile(BuildContext context) {
    Navigator.of(context).pop();
    Future.delayed(const Duration(milliseconds: 300), () {
      setCurrentViewFile(null);
    });
  }

  /// 打开文件夹或查看文件
  open(BuildContext context, FileSystemEntity file) {
    bool isDir = file.statSync().type == FileSystemEntityType.directory;
    if (isDir) {
      setCurrentPath(file.path);
    } else {
      setImageList();
      setCurrentViewFile(file, context);
    }
  }

  /// 选中文件或文件夹
  String? _selectedPath;
  String? get selectedPath => _selectedPath;
  selected(FileSystemEntity file) {
    _selectedPath = file.path;
    notifyListeners();
  }
}
