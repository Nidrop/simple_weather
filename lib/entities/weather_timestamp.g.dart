// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_timestamp.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeatherTimestampAdapter extends TypeAdapter<WeatherTimestamp> {
  @override
  final int typeId = 1;

  @override
  WeatherTimestamp read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeatherTimestamp(
      time: fields[0] as DateTime,
      description: fields[1] as String,
      temperature: fields[2] as double,
      temperatureFeels: fields[3] as double,
      icon: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WeatherTimestamp obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.temperature)
      ..writeByte(3)
      ..write(obj.temperatureFeels)
      ..writeByte(4)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherTimestampAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
