import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/subscriber_chart.dart';
import 'package:flutter_complete_guide/subscriber_series.dart';
import 'dart:async';
import 'database.dart';
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
  DatabaseService databaseService = DatabaseService();
  List<Speeds> speeds = [];
  List<SpeedChart> speedValues = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: Stream.periodic(Duration(seconds: 2))
                .asyncMap((event) => httpService.getSpeeds()),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<Speeds> speedsSnapshot = snapshot.data;
              databaseService.createDatabase();
              if (snapshot.data != []) {
                for (var i = 0; i < speedsSnapshot?.length; i++) {
                  speeds.add(speedsSnapshot[i]);
                  speedValues?.add(SpeedChart(
                      idCount: i.toString(),
                      speed: speedsSnapshot[i].speed,
                      barColor: charts.ColorUtil.fromDartColor(Colors.green)));
                }
              }

              print('speedValues');
              print(speedValues);
              if (speedValues == null) {
                return CircularProgressIndicator();
              }
              return Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: speeds?.length,
                            padding: const EdgeInsets.all(20.0),
                            itemBuilder: (BuildContext context, int index) {
                              Speeds _speedItem = speeds[index];
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                child: ListTile(
                                    title: Text('${_speedItem.date}'),
                                    subtitle: Text('${_speedItem.speed}')),
                              );
                            }),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: SubscriberChart(data: speedValues),
                      ),
                    )
                  ],
                ),
              );
            }));
  }
}
