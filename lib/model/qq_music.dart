class QQMusicList {
  final List<QQMusic> songList;

  QQMusicList({required this.songList});

  factory QQMusicList.fromJson(Map<String, dynamic> json) => QQMusicList(
      songList:
          List<QQMusic>.from(json['songlist'].map((e) => QQMusic.fromJson(e))));
}

class QQMusic {
  final String title;
  final String publishTime;
  final List<Singer> singer;

  QQMusic(
      {required this.title, required this.publishTime, required this.singer});

  factory QQMusic.fromJson(Map<String, dynamic> json) => QQMusic(
        title: json['title'],
        singer:
            List<Singer>.from(json['singer'].map((e) => Singer.fromJson(e))),
        publishTime: json['time_public'],
      );
}

class Singer {
  final String name;

  Singer({required this.name});

  factory Singer.fromJson(Map<String, dynamic> json) =>
      Singer(name: json['name']);
}
