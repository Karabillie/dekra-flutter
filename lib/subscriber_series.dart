
import 'package:flutter/foundation.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SpeedChart {
  final String idCount;
  final double speed;
  final charts.Color barColor;

  SpeedChart(
    {
      @required this.idCount,
      @required this.speed,
      @required this.barColor
    }
  );
}