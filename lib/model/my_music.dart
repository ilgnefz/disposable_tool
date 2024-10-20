class MyMusic {
  String title;
  String singer;
  String publishTime;

  MyMusic({
    required this.title,
    required this.singer,
    required this.publishTime,
  });

  Map<String, dynamic> toJson() =>
      {'title': title, 'singer': singer, 'publishTime': publishTime};
}
