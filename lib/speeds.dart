import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import 'http-requests.dart';

class Speeds {
  double date = 0;
  double time = 0;
  int dir = 0;
  int edge = 0;
  int calibration = 0;
  int mode = 0;
  double speed = 0;

  Speeds(this.date, this.time, this.dir, this.edge, this.calibration, this.mode,
      this.speed);

  factory Speeds.fromJson(dynamic json) {
    return Speeds(
        json['date'] as double,
        json['time'] as double,
        json['dir'] as int,
        json['edge'] as int,
        json['calibration'] as int,
        json['mode'] as int,
        json['speed'] as double);
  }
}

class SpeedsWidget extends StatefulWidget {
  const SpeedsWidget({Key key}) : super(key: key);
  @override
  SpeedsPage createState() => SpeedsPage();
}

class SpeedsPage extends State<SpeedsWidget> {
  final HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: httpService.getSpeeds(),
        builder: (BuildContext context, AsyncSnapshot<List<Speeds>> snapshot) {
          List<Speeds> speeds = snapshot.data;
          return Column(
            children: List.generate(speeds.length, (index) {
              return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text('${speeds[index].speed}'),
                      subtitle: Text('${speeds[index].date}'),
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
