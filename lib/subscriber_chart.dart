import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_complete_guide/subscriber_series.dart';

class SubscriberChart extends StatelessWidget {
  final List<SpeedChart> data;

  SubscriberChart({@required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<SpeedChart, String>> series = [
      charts.Series(
        id: "Subscribers",
        data: data,
        domainFn: (SpeedChart series, _) => series.idCount,
        measureFn: (SpeedChart series, _) => series.speed,
        colorFn: (SpeedChart series, _) => series.barColor,
      )
    ];

    return Container(
      height: 400,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                "Geschwindigkeiten",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Expanded(
                child: charts.BarChart(series, animate: true),
              )
            ],
          ),
        ),
      ),
    );
  }
}