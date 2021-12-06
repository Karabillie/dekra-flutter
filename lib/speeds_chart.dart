
import 'package:charts_flutter/flutter.dart' as charts;

class SpeedChart {
  final String idCount;
  double speed;
  final charts.Color barColor;

  SpeedChart(this.idCount, this.speed, this.barColor);
}