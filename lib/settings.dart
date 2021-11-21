

import 'package:json_annotation/json_annotation.dart';
part 'settings.g.dart';

@JsonSerializable(explicitToJson: true)
class Settings {
  double dir = 0;
  int edge = 0;
  String unit = '';
  int mode  = 0;
  int calibration = 0;
  String name = '';
  double date = 0;
  double battery = 0;

  Settings(this.dir, this.edge, this.unit, this.mode, this.calibration, this.name, this.date, this.battery);

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}