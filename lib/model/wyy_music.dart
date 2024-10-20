import 'package:disposable_tool/utils/format.dart';

class WYYSongs {
  List<WYYSong> songs;

  WYYSongs({required this.songs});

  factory WYYSongs.fromJson(Map<String, dynamic> json) => WYYSongs(
      songs: List<WYYSong>.from(json['songs'].map((e) => WYYSong.fromJson(e))));
}

class WYYSong {
  final String title;
  final List<WYYSinger> singer;
  final String publishTime;

  WYYSong({
    required this.title,
    required this.singer,
    required this.publishTime,
  });

  factory WYYSong.fromJson(Map<String, dynamic> json) => WYYSong(
        title: json['name'],
        singer:
            List<WYYSinger>.from(json['ar'].map((e) => WYYSinger.fromJson(e))),
        publishTime: formatTime(json['publishTime']),
      );
}

class WYYSinger {
  final String name;

  WYYSinger({required this.name});

  factory WYYSinger.fromJson(Map<String, dynamic> json) =>
      WYYSinger(name: json['name']);
}
