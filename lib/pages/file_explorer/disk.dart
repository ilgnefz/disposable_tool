import 'package:flutter/material.dart';
import 'package:universal_disk_space/universal_disk_space.dart';

class DiskPage extends StatefulWidget {
  const DiskPage({super.key});

  @override
  State<DiskPage> createState() => _DiskPageState();
}

class _DiskPageState extends State<DiskPage> {
  final List<Disk> _diskList = [];

  getDiskInfo() async {
    final diskSpace = DiskSpace();
    await diskSpace.scan();
    var disks = diskSpace.disks;
    _diskList.addAll(disks);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: Wrap(
          spacing: 24,
          children: List.generate(
            _diskList.length,
            (index) => Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.computer,
                  color: Colors.blue,
                  size: 48,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_diskList[index].mountPath),
                    SizedBox(
                      height: 16,
                      width: 240,
                      child: LinearProgressIndicator(
                        value: _diskList[index].availableSpace /
                            _diskList[index].totalSize,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
