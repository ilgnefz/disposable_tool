import 'package:disposable_tool/pages/generate_json/key_form.dart';
import 'package:disposable_tool/provider/generate_json.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'text_show.dart';

class GenerateJsonPage extends StatelessWidget {
  const GenerateJsonPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GenerateJsonProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                TextShow(
                  controller: provider.originalText,
                  hintText: '输入或上传数据',
                  buttonText: '上传文件',
                  onPressed: provider.upload,
                ),
                const SizedBox(width: 12.0),
                TextShow(
                  controller: provider.jsonText,
                  hintText: '输入或上传数据',
                  buttonText: '导出JSON',
                  onPressed: provider.export,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: KeyForm(provider)),
                IconButton(
                  onPressed: provider.reduce,
                  icon: const Icon(Icons.remove),
                ),
                IconButton(
                  onPressed: provider.increment,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
