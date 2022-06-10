import 'package:disposable_tool/pages/file_directory/file_card.dart';
import 'package:disposable_tool/provider/file_directory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FileExplorerPage extends StatelessWidget {
  const FileExplorerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Consumer<FileDirectoryProvider>(
            builder: (_, provider, child) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => provider.showMenu(),
                        child: const Text('前往首页'),
                      ),
                      ElevatedButton(
                        onPressed: provider.organizeFiles,
                        child: const Text('整理文件'),
                      ),
                      ElevatedButton(
                        onPressed: provider.setDir,
                        child: const Text('选择文件夹'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: provider.previousFiles,
                          icon: const Icon(Icons.arrow_upward_rounded)),
                      Expanded(
                        child: Text(
                          provider.dirPathText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Consumer<FileDirectoryProvider>(
                  builder: (_, provider, child) {
                    return GridView.count(
                      controller: ScrollController(),
                      childAspectRatio: 3 / 4,
                      crossAxisCount: (constraints.maxWidth / 150).floor(),
                      mainAxisSpacing: 8,
                      children: provider.files.map((file) {
                        return FileCard(
                            file: file,
                            onTap: () => provider.setDir(file.path));
                      }).toList(),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
