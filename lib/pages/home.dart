import 'package:disposable_tool/pages/file_directory/file_explorer.dart';
import 'package:disposable_tool/pages/read_json/read_json.dart';
import 'package:disposable_tool/provider/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<Widget> _pages = [const ReadJsonDataPage(), const FileExplorerPage()];
List<String> _title = ['获取歌曲数据', '文件浏览'];

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: _pages.length,
              itemBuilder: (context, index) =>
                  AppOption(index: index, title: _title[index]),
              separatorBuilder: (BuildContext context, int index) =>
                  Container(height: 1, color: const Color(0xFFF5F5F5)),
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
    Key? key,
  }) : super(key: key);

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
