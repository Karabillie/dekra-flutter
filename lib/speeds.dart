import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/subscriber_chart.dart';
import 'package:flutter_complete_guide/speeds_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'http-requests.dart';

class Speeds {
  int date = 0;
  double time = 0;
  int dir = 0;
  int edge = 0;
  int calibration = 0;
  int mode = 0;
  double speed = 0;

  Speeds(this.date, this.time, this.dir, this.edge, this.calibration, this.mode,
      this.speed);

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'time': time,
      'dir': dir,
      'edge': edge,
      'calibration': calibration,
      'mode': mode,
      'speed': speed,
    };
  }

  factory Speeds.fromJson(dynamic json) {
    return Speeds(
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

class SpeedsPage extends State<SpeedsWidget>
    with AutomaticKeepAliveClientMixin<SpeedsWidget> {
  final HttpService httpService = HttpService();
  List<Speeds> speeds = [];
  Map<String, SpeedChart> speedValues = {};
  var idCount = 0;
  var unitSpeed;
  var speedBox;
  var speedText = 0.0;

  double formatSpeed(Speeds speedItem, String unit) {
    var speed = speedItem.speed;
    if (unit == 'm/s') {
      speed = speedItem.speed / 3.6;
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
    speedBox = Hive.openBox('database1');
    return Scaffold(
        body: StreamBuilder(
            stream: Stream.periodic(Duration(seconds: 2))
                .asyncMap((event) => httpService.getSpeeds()),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<Speeds> speedsSnapshot = snapshot.data;
              unitSpeed = httpService.speedSettings?.unit;
              if (snapshot.data == null || unitSpeed == null) {
                return CircularProgressIndicator();
              }
              if (snapshot.data != [] &&
                  httpService.speedSettings?.unit != null) {
                for (var i = 0; i < speedsSnapshot?.length; i++) {
                  if (speedValues.length == 6) {
                    speedValues = {};
                  }
                  speeds.add(speedsSnapshot[i]);
                  print(speedBox);
                  // speedBox.put(speedsSnapshot[i].speed, speedsSnapshot[i].date, speedsSnapshot[i].dir, speedsSnapshot[i].edge, speedsSnapshot[i].mode, speedsSnapshot[i].calibration);
                  speedValues.putIfAbsent(
                      idCount.toString(),
                      () => SpeedChart(
                          idCount.toString(),
                          formatSpeed(speedsSnapshot[i], unitSpeed),
                          charts.ColorUtil.fromDartColor(Colors.green)));
                  idCount = idCount + 1;
                }
              }

              if (speedsSnapshot.length != 0 && unitSpeed != 0) {
                speedText = formatSpeed(
                    speedsSnapshot[speedsSnapshot.length - 1], unitSpeed);
              }

              return Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text('Geschwindigkeit: ', style: TextStyle(fontSize: 25)),
                            ),
                            Container(
                              child: Text('${speedText} ${unitSpeed}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 35)),
                            ),
                          ],
                        )),
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
                                  subtitle: Text(
                                      '${formatSpeed(_speedItem, unitSpeed)} ${unitSpeed}')),
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

  @override
  bool get wantKeepAlive => true;
}
