class NameCharset {
  String id;
  String name;
  String newName;
  String parent;

  NameCharset({
    required this.id,
    required this.name,
    required this.newName,
    required this.parent,
  });

  @override
  String toString() {
    return 'NameCharset{id: $id, name: $name, newName: $newName, parent: $parent}';
  }
}
