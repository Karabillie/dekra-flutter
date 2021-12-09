// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speeds.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SpeedsAdapter extends TypeAdapter<Speeds> {
  @override
  final int typeId = 1;

  @override
  Speeds read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Speeds(
      fields[0] as int,
      fields[1] as double,
      fields[2] as int,
      fields[3] as int,
      fields[4] as int,
      fields[5] as int,
      fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Speeds obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.dir)
      ..writeByte(3)
      ..write(obj.edge)
      ..writeByte(4)
      ..write(obj.calibration)
      ..writeByte(5)
      ..write(obj.mode)
      ..writeByte(6)
      ..write(obj.speed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpeedsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
