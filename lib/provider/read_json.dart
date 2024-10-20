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
  addMyMusic(MyMusic value) {
    _mySongList.add(value);
    notifyListeners();
  }

  bool _sortAscending = true;
  bool get sortAscending => _sortAscending;
  toggleSort(int columnIndex, bool ascending) {
    _sortAscending = ascending;
    if (_sortAscending) {
      _mySongList.sort((a, b) => a.publishTime.compareTo(b.publishTime));
    } else {
      _mySongList.sort((a, b) => b.publishTime.compareTo(a.publishTime));
    }
    notifyListeners();
  }

  importJson(bool qq) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result != null) {
      File file = File(result.files.single.path!);
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

  exportJson() async {
    String? outputFile = await FilePicker.platform.saveFile(
      fileName: '重命名.json',
    );
    if (outputFile != null) {
      File file = File(outputFile);
      await file.writeAsString(jsonEncode({'musicList': _mySongList}));
      await file.create();
    }
  }
}
