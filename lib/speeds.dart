import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/subscriber_chart.dart';
import 'package:flutter_complete_guide/speeds_chart.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'database.dart';
import 'http-requests.dart';

class Speeds {
  String unit = '';
  int date = 0;
  double time = 0;
  int dir = 0;
  int edge = 0;
  int calibration = 0;
  int mode = 0;
  double speed = 0;

  Speeds(this.unit, this.date, this.time, this.dir, this.edge, this.calibration, this.mode,
      this.speed);

  factory Speeds.fromJson(dynamic json) {
    return Speeds(
        json['unit'] as String,
        json['date'] as int,
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
  Map<String, SpeedChart> speedValues = {};
  var idCount = 0;

  double formatSpeed(Speeds speedItem, String unit) {
    var speed = speedItem.speed;
    if (unit == 'm/s') {
      speed = speedItem.speed  / 3.6;
    }
    num mod = pow(10.0, 2);
    return ((speed * mod).round().toDouble() / mod);
  }

  String formatDate(int speedDate) {
    var date = new DateTime.fromMicrosecondsSinceEpoch(speedDate * 1000);
    var formattedDate = DateFormat(
            'MM/dd/yyyy, HH:mm:ss', Localizations.localeOf(context).toString())
        .format(date);
    return formattedDate;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: Stream.periodic(Duration(seconds: 2))
                .asyncMap((event) => httpService.getSpeeds()),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<Speeds> speedsSnapshot = snapshot.data;
              // databaseService.createDatabase();
              if (snapshot.data == null) {
                return CircularProgressIndicator();
              }
              if (snapshot.data != []) {
                for (var i = 0; i < speedsSnapshot?.length; i++) {
                  if (speedValues.length == 6) {
                    speedValues = {};
                  }
                  speeds.add(speedsSnapshot[i]);
                  speedValues.putIfAbsent(
                      idCount.toString(),
                      () => SpeedChart(
                          idCount.toString(),
                          formatSpeed(speedsSnapshot[i]),
                          charts.ColorUtil.fromDartColor(Colors.green)));
                  idCount = idCount + 1;
                }
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
                        child: ListView.separated(
                          reverse: true,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: speeds?.length,
                          padding: const EdgeInsets.all(20.0),
                          itemBuilder: (BuildContext context, int index) {
                            Speeds _speedItem = speeds[index];
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              child: ListTile(
                                  leading: Text(
                                    '${index + 1}.',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  title: Text('${formatDate(_speedItem.date)}'),
                                  subtitle: Text('${formatSpeed(_speedItem, httpService.speedSettings.unit)} ${httpService.speedSettings.unit}')),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                        ),
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
