// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gameData.dart';

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
      currentLevelMoves: (fields[2] as List).cast<int>(),
      levelGrid: (fields[1] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, LevelsDb obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.currentLevel)
      ..writeByte(1)
      ..write(obj.levelGrid)
      ..writeByte(2)
      ..write(obj.currentLevelMoves);
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
