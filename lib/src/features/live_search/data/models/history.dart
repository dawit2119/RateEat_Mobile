import 'package:hive/hive.dart';

@HiveType(typeId: 3)
class History extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;
  History({
    required this.id,
    required this.title,
  });
}

class HistoryAdapter extends TypeAdapter<History> {
  @override
  final typeId = 3; // Should match the typeId in History

  @override
  History read(BinaryReader reader) {
    final id = reader.readString();
    final title = reader.readString();
    return History(id: id, title: title);
  }

  @override
  void write(BinaryWriter writer, History obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
  }
}
