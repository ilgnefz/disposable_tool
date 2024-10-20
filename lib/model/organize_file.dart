class OrganizeFile {
  String id;
  String name;
  String parent;
  String extension;
  DateTime createDate;
  CustomFileType type;

  OrganizeFile({
    required this.id,
    required this.name,
    required this.parent,
    required this.extension,
    required this.createDate,
    required this.type,
  });
}

enum CustomFileType {
  image('图片'),
  video('视频'),
  text('文档'),
  other('其他');

  final String name;
  const CustomFileType(this.name);
}

enum UseType {
  no('不使用'),
  all('全部使用'),
  prefix('仅前缀'),
  suffix('仅后缀');

  final String name;
  const UseType(this.name);
}
