import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class Speeds {
  double date = 0;
  double time = 0;
  int dir = 0;
  int edge = 0;
  int calibration = 0;
  int mode = 0;
  double speed = 0;

  Speeds(this.date, this.time, this.dir, this.edge, this.calibration, this.mode, this.speed);
}