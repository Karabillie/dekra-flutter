import 'settings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'measurements.dart';

class HttpService {
  String url = "http://localhost:3000/";

  Future<Settings> getSpeedMeasurements() async {
    var response = await http.get(Uri.parse(url + 'time'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      var decodedData = Measurements.fromJson(jsonDecode(response.body));
      var settings = decodedData.settings.toJson();
      Settings decodedSettings = Settings(
          settings['dir'],
          settings['edge'],
          settings['unit'],
          settings['mode'],
          settings['calibration'],
          settings['name'],
          settings['date'],
          settings['battery']);
      print(decodedData.settings.toJson());
      return decodedSettings;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load settings');
    }
  }

  void timeSync() async {
    print(url);
    var date = (DateTime.now().millisecondsSinceEpoch).toInt();
    var response = await http
        .post(Uri.parse(url + 'settings'), body: {'time': date.toString()});
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      print(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load settings');
    }
  }

  void updateMode(int mode) async {
    var response = await http.post(Uri.parse(url + 'settings'), body: jsonEncode({'mode': mode}));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      print(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load settings');
    }
  }

  void updateDirection(double direction) async {
    print('direction');
    print(direction.toString());
    var response = await http
        .post(Uri.parse(url + 'settings'), body: jsonEncode({'dir': direction}));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      print(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load settings');
    }
  }

  void updateEdge(int edge) async {
    print('edge');
    print(edge.toString());
    var response = await http
        .post(Uri.parse(url + 'settings'), body: jsonEncode({'edge': edge}));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      print(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load settings');
    }
  }

  void updateUnit(String unit) async {
    print('unit');
    print(unit.toString());
    var response = await http
        .post(Uri.parse(url + 'settings'), body: jsonEncode({'unit': unit}));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      print(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load settings');
    }
  }

  void updateUrl(String urlApi) {
    url = urlApi;
  }
}
