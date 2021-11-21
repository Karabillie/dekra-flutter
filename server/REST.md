# Lichtschranke
## Einstellungen
|Feld|Wert|
|:-|:-|
|dir|0,1,2|
|unit|"km/h", "m/s"|
|mode|0,1|
|name|String|
|edge|0,1|
|date|unix zeit in ms (an Zeitzone anpassen)|
Alle Felder sind optional. Reihenfolge ist egal.  
Beispiel: POST **URL**/settings
*Alternative 1*
```
"unit":"m/s",
"dir":1,
"time":123413123
```
*Alternative 2*
```json
"body":{
  "unit":"m/s",
  "dir":1,
  "time":123413123
}
```
Die zwei Alternativen kommen von den Unterschiedlichen Verfahren von HTTP Requests in Swift und Python. Siehe Requests.py und Xcode App.
Response: Status: 200, Content type: application/json
```json
{
    "dir": 0, //0: S1->S2, 1:S1<-S2, 2: Auto
    "edge": 1, //0: LOW, 1: HIGH
    "unit": "km/h", 
    "mode": 0, //0: Geschwindigkeit, 1:Runden
    "calibration": 1.0,
    "name": "Default",
    "date":1234134123, //Unix in lokaler Zeit in ms
    "battery": 79 //Akkustand in %
}
```
## Wert abfragen
Beispiel für Geschwindigkeitsmessung: GET **IP**/time
Response: Status: 200, Content type: application/json
```json
{
  "settings": {
    "dir": 0,
    "edge": 0,
    "unit": "m/s",
    "mode": 0,
    "calibration": 1,
    "name": "Default",
    "date": 1630491265000,
    "battery": 45
  },
  "speeds": [
    {
      "speed": 7.019641,
      "time": 256.4234,
      "date": 1630491244000,
      "dir": 0,
      "edge": 0,
      "calibration": 1.0  // 1.0 kann als 1 übertragen werden
    },
    {
      "speed": 7.041276,
      "time": 255.6355,
      "date": 1630491242000,
      "dir": 0,
      "edge": 0,
      "calibration": 1.0
    },
    {
      "speed": 6.511385,
      "time": 276.4389,
      "date": 1630491240000,
      "dir": 0,
      "edge": 0,
      "calibration": 1.0
    }
  ],
  "laps": [
    {
      "time": 276.4389,
      "date": 1630491240000,
      "dir": 0,
      "edge": 0,
      "calibration": 1.0
    }
  ]
}
```
Das Feld settings ist non-optional und die beiden Arrays "speeds" und "laps" optional.
Diese Art der Response, mit verschachtelten JSONs, war bei der Deserialisierung mit Swift am einfachsten.  
Bei dem Feld *calibration* kann es passieren, dass eine 1.0 als 1 angezeigt wird.  
Rundenzeiten sind im ESP32 Programm noch nicht vollständig implementiert, werden aber wie oben dargestellt gesendet.