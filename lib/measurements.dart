import 'settings.dart';
import 'speeds.dart';
class Measurements {
  Settings settings;
  List<Speeds> speeds;

  Measurements(this.settings, this.speeds);

  factory Measurements.fromJson(dynamic json) {
    if (json['speeds'] != null) {
      var measurementObjsJson = json['speeds'] as List;
      List<Speeds> _speeds = measurementObjsJson.map((measurementJson) => Speeds.fromJson(measurementJson)).toList();

      return Measurements(
        Settings.fromJson(json['settings']),
        _speeds
      );
    } else {
      return Measurements(
        Settings.fromJson(json['settings']),
        []
      );
    }
  }
}