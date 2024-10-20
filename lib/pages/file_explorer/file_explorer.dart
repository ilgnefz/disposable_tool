import 'package:disposable_tool/pages/file_explorer/file_card_horizontal.dart';
import 'package:disposable_tool/provider/file_explorer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'disk_card_vertical.dart';
import 'file_card_vertical.dart';
import 'operation_bar.dart';

class FileExplorerPage extends StatefulWidget {
  const FileExplorerPage({super.key});

  @override
  State<FileExplorerPage> createState() => _FileExplorerPageState();
}

class _FileExplorerPageState extends State<FileExplorerPage> {
  @override
  initState() {
    super.initState();
    context.read<FileExplorerProvider>().getDiskInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const OperationBar(),
        Expanded(
          child: Consumer<FileExplorerProvider>(
            builder: (_, provider, child) {
              if (provider.currentPath == '此电脑') {
                if (provider.showStyle) {
                  return DiskCardVertical(
                    diskList: provider.diskList,
                    onTap: provider.setCurrentPath,
                  );
                } else {
                  return DiskCardVertical(
                    diskList: provider.diskList,
                    onTap: provider.setCurrentPath,
                  );
                }
              } else {
                if (provider.showStyle) {
                  return FileTypeCardHorizontal(
                    fileList: provider.fileList,
                    onDoubleTap: provider.open,
                  );
                } else {
                  return FileCardVertical(
                    fileList: provider.fileList,
                    onSelected: provider.selected,
                    onDoubleTap: provider.open,
                  );
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
