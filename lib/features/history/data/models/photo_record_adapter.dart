import 'package:hive/hive.dart';
import 'photo_record.dart';

class PhotoRecordAdapter extends TypeAdapter<PhotoRecord> {
  @override
  final int typeId = 0;

  @override
  PhotoRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return PhotoRecord(
      id: fields[0] as String,
      countryCode: fields[1] as String,
      documentId: fields[2] as String,
      createdAt: fields[3] as DateTime,
      thumbnailPath: fields[4] as String,
      originalPath: fields[5] as String,
      exportedPath: fields[6] as String?,
      qualityScore: fields[7] as int,
      validationResults: (fields[8] as Map).cast<String, bool>(),
    );
  }

  @override
  void write(BinaryWriter writer, PhotoRecord obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.countryCode)
      ..writeByte(2)
      ..write(obj.documentId)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.thumbnailPath)
      ..writeByte(5)
      ..write(obj.originalPath)
      ..writeByte(6)
      ..write(obj.exportedPath)
      ..writeByte(7)
      ..write(obj.qualityScore)
      ..writeByte(8)
      ..write(obj.validationResults);
  }
}
