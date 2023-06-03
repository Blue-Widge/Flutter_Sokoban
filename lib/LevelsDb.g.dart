// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LevelsDb.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LevelsDbAdapter extends TypeAdapter<LevelsDb> {
  @override
  final int typeId = 1;

  @override
  LevelsDb read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LevelsDb(
      currentLevel: fields[0] as int,
      previousBlocsGrids: (fields[1] as List)
          .map((dynamic e) => (e as List)
              .map((dynamic e) => (e as List).cast<Entity>())
              .toList())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, LevelsDb obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.currentLevel)
      ..writeByte(1)
      ..write(obj.previousBlocsGrids);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelsDbAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
