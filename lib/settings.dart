

import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'http-requests.dart';
class Settings {
  double dir = 0;
  int edge = 0;
  String unit = '';
  int mode  = 0;
  int calibration = 0;
  String name = '';
  double date = 0;
  double battery = 0;

  Settings(this.dir, this.edge, this.unit, this.mode, this.calibration, this.name, this.date, this.battery);

  factory Settings.fromJson(dynamic json) {
    return Settings(json['dir'] as double, json['edge'] as int, json['unit'] as String, json['mode'] as int, json['calibration'] as int, json['name'] as String, json['date'] as double, json['battery'] as double);
  }
}

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({Key key}) : super(key: key);
  @override
  SettingsPage createState() => SettingsPage();
}

class SettingsPage extends State<SettingsWidget> with AutomaticKeepAliveClientMixin<SettingsWidget> {
  final HttpService httpService = HttpService();

  final addressController = TextEditingController(text: 'http://localhost:3000/');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          future: httpService.getSpeedsSettings(),
          builder: (BuildContext context, AsyncSnapshot<Settings> snapshot) {
            Settings settings = snapshot.data;
            if (settings == null) {
              return CircularProgressIndicator();
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 120,
                        ),
                        Container(
                          width: 470,
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            controller: addressController,
                            cursorColor: Colors.black,
                            autovalidateMode: AutovalidateMode.always,
                            validator: (url) {
                              if (!isURL(url)) {
                                return "Bitte geben Sie eine gültige IP-Adresse ein!";
                              } else {
                              return null;
                              }
                            },
                            decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.green[700]),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.green[700]),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.green[700]),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.green[700]),
                                ),
                                labelText: 'Arduino IP Address: '),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.green[700],
                          ),
                          child: IconButton(
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            icon: Icon(Icons.check),
                            iconSize: 20,
                            color: Colors.white,
                            onPressed: () =>
                                httpService.updateUrl(addressController.text),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 120,
                          padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                          child: Text(
                            'Messung:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: 250,
                          decoration: new BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(10)),
                              color: Colors.green[700]),
                          child: ListTile(
                            title: const Text(
                              'Geschwindigkeit',
                              style: TextStyle(color: Colors.white),
                            ),
                            enabled: settings?.mode == 0,
                            leading: Radio<int>(
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.transparent),
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              activeColor: Colors.white,
                              value: 0,
                              groupValue: settings?.mode,
                              onChanged: (int value) {
                                setState(() {
                                  httpService.updateMode(value);
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: 250,
                          decoration: new BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(10.0)),
                              color: Colors.green[700]),
                          child: ListTile(
                            title: const Text(
                              'Rundenzeit',
                              style: TextStyle(color: Colors.white),
                            ),
                            enabled: settings?.mode == 1,
                            leading: Radio<int>(
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.transparent),
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              activeColor: Colors.white,
                              value: 1,
                              groupValue: settings?.mode,
                              onChanged: (int value) {
                                setState(() {
                                  httpService.updateMode(value);
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 120,
                          padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                          child: Text(
                            'Richtung:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: 250,
                          decoration: new BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(10)),
                              color: Colors.green[700]),
                          child: ListTile(
                            title: const Text(
                              'S1->S2',
                              style: TextStyle(color: Colors.white),
                            ),
                            enabled: settings?.dir == 0,
                            leading: Radio<double>(
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.transparent),
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              activeColor: Colors.white,
                              value: 0,
                              groupValue: settings?.dir,
                              onChanged: (double value) {
                                setState(() {
                                  httpService.updateDirection(value);
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: 250,
                          decoration: new BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(10.0)),
                              color: Colors.green[700]),
                          child: ListTile(
                            title: const Text(
                              'S2->S1',
                              style: TextStyle(color: Colors.white),
                            ),
                            enabled: settings?.dir == 1,
                            leading: Radio<double>(
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.transparent),
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              activeColor: Colors.white,
                              value: 1,
                              groupValue: settings?.dir,
                              onChanged: (double value) {
                                setState(() {
                                  httpService.updateDirection(value);
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 120,
                          child: Row(children: <Widget>[
                            Text(
                              'Betriebsart:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Tooltip(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green[700],
                              ),
                              padding: const EdgeInsets.all(8.0),
                              textStyle: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                              message:
                                  'Reflektor: Zum Messen wird der mitgelieferte Reflektor gegenüber der Lichtschranke aufgebaut; \n \nFolie: Zum Messen wird eine Reflektorfolie am zu messenden Fzg. verwendet',
                              child: new Icon(Icons.info,
                                  color: Colors.green[700]),
                            ),
                          ]),
                        ),
                        Container(
                          width: 250,
                          decoration: new BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(10)),
                              color: Colors.green[700]),
                          child: ListTile(
                            title: const Text(
                              'HIGH',
                              style: TextStyle(color: Colors.white),
                            ),
                            enabled: settings?.edge == 0,
                            leading: Radio<int>(
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.transparent),
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              activeColor: Colors.white,
                              value: 0,
                              groupValue: settings?.edge,
                              onChanged: (int value) {
                                setState(() {
                                  httpService.updateEdge(value);
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: 250,
                          decoration: new BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(10.0)),
                              color: Colors.green[700]),
                          child: ListTile(
                            title: const Text(
                              'LOW',
                              style: TextStyle(color: Colors.white),
                            ),
                            enabled: settings?.edge == 1,
                            leading: Radio<int>(
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.transparent),
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              activeColor: Colors.white,
                              value: 1,
                              groupValue: settings?.edge,
                              onChanged: (int value) {
                                setState(() {
                                  httpService.updateEdge(value);
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 120,
                          padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                          child: Text(
                            'Einheit:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: 250,
                          decoration: new BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(10)),
                              color: Colors.green[700]),
                          child: ListTile(
                            title: const Text(
                              'km/h',
                              style: TextStyle(color: Colors.white),
                            ),
                            enabled: settings?.unit == 'km/h',
                            leading: Radio<String>(
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.transparent),
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              activeColor: Colors.white,
                              value: 'km/h',
                              groupValue: settings?.unit,
                              onChanged: (String value) {
                                setState(() {
                                  settings?.unit = value;
                                  httpService.updateUnit(value);
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: 250,
                          decoration: new BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(10.0)),
                              color: Colors.green[700]),
                          child: ListTile(
                            title: const Text(
                              'm/s',
                              style: TextStyle(color: Colors.white),
                            ),
                            enabled: settings?.unit == 'm/s',
                            leading: Radio<String>(
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.transparent),
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              activeColor: Colors.white,
                              value: 'm/s',
                              groupValue: settings?.unit,
                              onChanged: (String value) {
                                setState(() {
                                  settings?.unit = value;
                                  httpService.updateUnit(value);
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 120,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green[700],
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                                primary: Colors.white,
                                padding: EdgeInsets.all(10)),
                            child: Text(
                              'ZEIT SYNCHRONISIEREN',
                              style: TextStyle(fontSize: 15),
                            ),
                            onPressed: () => httpService.timeSync(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ],
            );
          },
        ));
  }

  @override
bool get wantKeepAlive => true;
}
