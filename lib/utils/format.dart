String formatTime(int time) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
  return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
}

String formatDiskSize(int byte) {
  final List<String> unitList = ['Byte', 'KB', 'MB', 'GB', 'TB'];
  int count = 0;
  while (byte.toString().length >= 4) {
    byte = (byte / 1024).floor();
    count++;
  }
  return '$byte${unitList[count]}';
}
