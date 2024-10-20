import 'package:disposable_tool/provider/read_json.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadJsonDataPage extends StatelessWidget {
  const ReadJsonDataPage({super.key});

  final TextStyle _titleStyle = const TextStyle(fontSize: 15);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReadJsonProvider>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () => provider.importJson(true),
                child: const Text('导入QQ音乐JSON'),
              ),
              TextButton(
                onPressed: () => provider.importJson(false),
                child: const Text('导入网易云音乐JSON'),
              ),
              TextButton(
                onPressed: provider.exportJson,
                child: const Text('导出JSON'),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: DataTable(
              sortColumnIndex: 2,
              sortAscending: provider.sortAscending,
              columns: [
                DataColumn(
                    label: Text(
                  '歌曲（${provider.mySongList.length}）',
                  style: _titleStyle,
                )),
                DataColumn(label: Text('歌手', style: _titleStyle)),
                DataColumn(
                  label: Text('发布日期', style: _titleStyle),
                  onSort: (columnIndex, ascending) {
                    provider.toggleSort(columnIndex, ascending);
                  },
                ),
              ],
              rows: provider.mySongList.map((e) {
                return DataRow(cells: [
                  DataCell(SelectableText(e.title)),
                  DataCell(SelectableText(e.singer)),
                  DataCell(SelectableText(e.publishTime)),
                ]);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
