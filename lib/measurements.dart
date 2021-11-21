import 'package:json_annotation/json_annotation.dart';
import 'settings.dart';
part 'measurements.g.dart';

@JsonSerializable(explicitToJson: true)
class Measurements {
  Settings settings;

  Measurements(this.settings);

  factory Measurements.fromJson(Map<String, dynamic> json) => _$MeasurementsFromJson(json);
  Map<String, dynamic> toJson() => _$MeasurementsToJson(this);
}