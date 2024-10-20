import 'package:disposable_tool/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:universal_disk_space/universal_disk_space.dart';

class DiskCardVertical extends StatelessWidget {
  const DiskCardVertical({
    required this.diskList,
    required this.onTap,
    super.key,
  });

  final List<Disk> diskList;
  final void Function(String value) onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(diskList.length, (index) {
        return InkWell(
          onTap: () => onTap(diskList[index].devicePath),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: Row(
              children: [
                const Icon(Icons.computer_rounded,
                    size: 48, color: Colors.blue),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${diskList[index].devicePath} ${formatDiskSize(diskList[index].availableSpace)}可用，共${formatDiskSize(diskList[index].totalSize)}',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      width: 240,
                      height: 12,
                      child: LinearProgressIndicator(
                        value: diskList[index].usedSpace /
                            diskList[index].totalSize,
                        color: (diskList[index].usedSpace /
                                    diskList[index].totalSize) >
                                .8
                            ? Colors.red
                            : Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
