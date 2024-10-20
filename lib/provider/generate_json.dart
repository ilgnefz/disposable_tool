import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// import 'package:path/path.dart' as path;

class GenerateJsonProvider extends ChangeNotifier {
  final TextEditingController _originalText = TextEditingController();
  TextEditingController get originalText => _originalText;

  final TextEditingController _jsonText = TextEditingController();
  TextEditingController get jsonText => _jsonText;

  final int _splitLength = 0;
  int get splitLength => _splitLength;

  GenerateJsonProvider() {
    _originalText.addListener(() {
      format();
      notifyListeners();
    });
  }

  final List<String> _keyList = [];
  List<String> get keyList => _keyList;
  addKey(int index, String key) {
    if (index + 1 > _keyList.length) {
      _keyList.add(key);
    } else {
      _keyList[index] = key;
    }
    notifyListeners();
  }

  int _keyNum = 1;
  int get keyNum => _keyNum;
  increment() {
    _keyNum++;
    notifyListeners();
  }

  reduce() {
    if (_keyNum > 1) _keyNum--;
    notifyListeners();
  }

  upload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      _originalText.text = await file.readAsString();
      notifyListeners();
      format();
    }
  }

  export() async {
    String? outputFile =
        await FilePicker.platform.saveFile(fileName: 'newFile.json');
    if (outputFile != null) {
      File file = File(outputFile);
      await file.writeAsString(jsonText.text);
      await file.create();
    }
  }

  format() {
    if (_originalText.text.isEmpty) return _jsonText.clear();
    String content = _originalText.text;
    late List<String> jsonList;
    if (content.contains('\r\n')) {
      jsonList = content.split('\r\n');
    } else if (content.contains('\n')) {
      jsonList = content.split('\n');
    } else {
      jsonList = [content];
    }
    String value = '{\r\n  "data": [';
    for (String v in jsonList) {
      List<String> valueList = v.contains('　') ? v.split('　') : v.split(' ');
      value += '{';
      for (int i = 0; i < valueList.length; i++) {
        if (_keyList.length < i + 1) _keyList.add('Key$i');
        value += '\r\n    "${_keyList[i]}": "${valueList[i]}"';
        bool isLast = i == valueList.length - 1;
        // Custom JSON Content Start
        if (isLast) {
          value += ',\r\n    "audio": "${valueList.last}.mp3"';
        }
        // End
        value += isLast ? '\r\n  }' : ',';
      }
      int index = jsonList.indexOf(v);
      if (index != jsonList.length - 1) value += ',';
    }
    jsonText.text = '$value]\r\n}';
  }
}
