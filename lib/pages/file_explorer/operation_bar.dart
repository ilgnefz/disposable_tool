import 'package:disposable_tool/provider/file_explorer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OperationBar extends StatelessWidget {
  const OperationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FileExplorerProvider>(
      builder: (_, provider, child) {
        return Column(
          children: [
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('整理文件'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('复制文件夹'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('粘贴文件夹'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('移动文件夹'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  iconSize: 20,
                  onPressed: provider.isDisable ? null : provider.previousPath,
                  icon: const Icon(Icons.arrow_upward_rounded),
                ),
                Expanded(
                  child: Tooltip(
                    message: provider.currentPath,
                    child: Text(
                      provider.currentPath,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                IconButton(
                  iconSize: 20,
                  tooltip: '查看隐藏文件',
                  onPressed: provider.switchHiddenFile,
                  icon: Icon(
                    provider.showHiddenFile
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
                IconButton(
                  iconSize: 20,
                  onPressed: provider.switchShowStyle,
                  icon: Icon(provider.showStyle
                      ? Icons.menu_rounded
                      : Icons.grid_view_rounded),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
