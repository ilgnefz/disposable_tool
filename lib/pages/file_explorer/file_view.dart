import 'dart:io';

import 'package:disposable_tool/provider/file_explorer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageView extends StatelessWidget {
  const ImageView(this.file, {super.key});

  final FileSystemEntity file;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FileExplorerProvider>(context);
    // Size screenSize = MediaQuery.of(context).size;
    return Stack(
      fit: StackFit.expand,
      children: [
        InteractiveViewer(
          child: InkWell(
            onTap: () => provider.closeViewFile(context),
            child: Image.file(
              File(provider.currentViewFile!.path),
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => provider.previousImage(file),
            color: Colors.white,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded),
            onPressed: () => provider.nextImage(file),
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
