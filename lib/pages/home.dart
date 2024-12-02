import 'package:disposable_tool/pages/directory_files/directory_files.dart';
import 'package:disposable_tool/pages/file_name_charset/file_name_charset.dart';
import 'package:disposable_tool/pages/generate_json/generate_json.dart';
import 'package:disposable_tool/pages/image_classification/image_classification.dart';
import 'package:disposable_tool/pages/image_info/image_info.dart';
import 'package:disposable_tool/pages/read_json/read_json.dart';
import 'package:disposable_tool/pages/simple_tree/simple_tree.dart';
import 'package:disposable_tool/pages/test_page/test_page.dart';
import 'package:disposable_tool/pages/win_wallpaper/win_wallpaper.dart';
import 'package:disposable_tool/provider/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'file_explorer/file_explorer.dart';

List<Widget> _pages = [
  const ReadJsonDataPage(),
  const FileExplorerPage(),
  const ImageInfoPage(),
  const GenerateJsonPage(),
  const ImageClassification(),
  const WinWallpaper(),
  const SimpleTreeTest(),
  const DirectoryFiles(),
  const FileNameCharset(),
  const TestPage(),
];
List<String> _title = [
  '获取歌曲数据',
  '文件浏览',
  '图片信息',
  '生成JSON',
  '图片分类',
  '设置壁纸',
  '简单树结构',
  '获取文件名称',
  '文件名编码',
  '测试'
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: ColoredBox(
              color: Colors.white,
              child: ListView.builder(
                itemCount: _pages.length,
                itemBuilder: (context, index) =>
                    AppOption(index: index, title: _title[index]),
                // separatorBuilder: (BuildContext context, int index) =>
                //     Container(height: 1, color: const Color(0xFFF5F5F5)),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Consumer<AppProvider>(
              builder: (_, provider, child) {
                return IndexedStack(
                  index: provider.currentIndex,
                  children: _pages,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AppOption extends StatelessWidget {
  const AppOption({
    required this.index,
    required this.title,
    super.key,
  });

  final int index;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (_, provider, child) {
        bool selected = index == provider.currentIndex;
        return InkWell(
          onTap: () => provider.setCurrentIndex(index),
          child: Container(
            height: 48,
            color: selected ? Colors.blue.withOpacity(.2) : Colors.transparent,
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(color: selected ? Colors.blue : Colors.black),
            ),
          ),
        );
      },
    );
  }
}
