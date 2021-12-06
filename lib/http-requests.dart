import 'settings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'measurements.dart';
import 'speeds.dart';
import 'dart:async';
class HttpService {
  String url = "http://localhost:3000/";
  final StreamController<List<Speeds>> _speedController = StreamController<List<Speeds>>();
  Stream<List<Speeds>> get speedController => _speedController.stream;

  Future<Settings> getSpeedsSettings() async {
    var response = await http.get(Uri.parse(url + 'time'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      var decodedData = Measurements.fromJson(jsonDecode(response.body));
      var settings = decodedData.settings;
      return settings;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load settings');
    }
  }

  Future getSpeeds() async {
    var response = await http.get(Uri.parse(url + 'time'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      var speedObjsJson = jsonDecode(response.body)['speeds'] as List;
      List<Speeds> speedsObjs =
          speedObjsJson.map((speedJson) => Speeds.fromJson(speedJson)).toList();
      return speedsObjs;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load settings');
    }
  }

  Stream<List<Speeds>> get controllerSpeedList async* {
   yield await getSpeeds();
  }

  void httpPost(String body) async {
    var response = await http.post(Uri.parse(url + 'settings'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      print(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load settings');
    }
  }

  void timeSync() async {
    var date = (DateTime.now().millisecondsSinceEpoch).toInt();
    return await httpPost(jsonEncode({
      'time': date.toString(),
    }));
  }

  void updateMode(int mode) async {
    return await httpPost(jsonEncode({
      'mode': mode,
    }));
  }

  void updateDirection(double direction) async {
    return await httpPost(jsonEncode({
      'dir': direction,
    }));
  }

  void updateEdge(int edge) async {
    return await httpPost(jsonEncode({
      'edge': edge,
    }));
  }

  void updateUnit(String unit) async {
    return await httpPost(jsonEncode({
      'unit': unit.toString(),
    }));
  }

  void updateUrl(String urlApi) {
    url = urlApi;
  }
}
