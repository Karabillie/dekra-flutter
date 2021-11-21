// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
      (json['dir'] as num).toDouble(),
      json['edge'] as int,
      json['unit'] as String,
      json['mode'] as int,
      json['calibration'] as int,
      json['name'] as String,
      (json['date'] as num).toDouble(),
      (json['battery'] as num).toDouble(),
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'dir': instance.dir,
      'edge': instance.edge,
      'unit': instance.unit,
      'mode': instance.mode,
      'calibration': instance.calibration,
      'name': instance.name,
      'date': instance.date,
      'battery': instance.battery,
    };
