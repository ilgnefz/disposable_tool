import 'dart:convert';
import 'dart:io';

import 'package:disposable_tool/model/my_music.dart';
import 'package:disposable_tool/model/qq_music.dart';
import 'package:disposable_tool/model/wyy_music.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ReadJsonProvider extends ChangeNotifier {
  final List<MyMusic> _mySongList = [];
  List<MyMusic> get mySongList => _mySongList;
  void addMyMusic(MyMusic value) {
    _mySongList.add(value);
    notifyListeners();
  }

  bool _sortAscending = true;
  bool get sortAscending => _sortAscending;
  void toggleSort(int columnIndex, bool ascending) {
    _sortAscending = ascending;
    if (_sortAscending) {
      _mySongList.sort((a, b) => a.publishTime.compareTo(b.publishTime));
    } else {
      _mySongList.sort((a, b) => b.publishTime.compareTo(a.publishTime));
    }
    notifyListeners();
  }

  Future<void> importJson(bool qq) async {
    List<PlatformFile> result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result.isNotEmpty) {
      File file = File(result.single.path!);
      String stringData = await file.readAsString();
      late dynamic musicList;
      if (qq) {
        QQMusicList qqMusicList = QQMusicList.fromJson(jsonDecode(stringData));
        musicList = qqMusicList.songList;
      } else {
        WYYSongs wyySongs = WYYSongs.fromJson(jsonDecode(stringData));
        musicList = wyySongs.songs;
      }
      for (var music in musicList) {
        addMyMusic(MyMusic(
          title: music.title,
          singer: music.singer.map((e) => e.name).join('/'),
          publishTime: music.publishTime,
        ));
      }
    }
  }

  Future<void> exportJson() async {
    Uri? outputFile = await FilePicker.saveFile(
      fileName: '重命名.json',
      bytes: utf8.encode(jsonEncode({'musicList': _mySongList})),
    );
    if (outputFile == null) {
      debugPrint('文件保存失败');
    }
  }
}
