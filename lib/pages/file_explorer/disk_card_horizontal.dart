import 'package:disposable_tool/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:universal_disk_space/universal_disk_space.dart';

class DiskCardHorizontal extends StatelessWidget {
  const DiskCardHorizontal({
    required this.diskList,
    required this.onTap,
    super.key,
  });

  final List<Disk> diskList;
  final void Function(String value) onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: diskList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => onTap(diskList[index].devicePath),
          onDoubleTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
            child: Row(
              children: [
                const Icon(Icons.computer_rounded,
                    size: 32, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  '${diskList[index].devicePath} ${formatDiskSize(diskList[index].availableSpace)}可用，共${formatDiskSize(diskList[index].totalSize)}',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 240,
                  height: 16,
                  child: LinearProgressIndicator(
                    value:
                        diskList[index].usedSpace / diskList[index].totalSize,
                    color: (diskList[index].usedSpace /
                                diskList[index].totalSize) >
                            .8
                        ? Colors.red
                        : Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
