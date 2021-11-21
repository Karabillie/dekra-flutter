const PRESCALER = 2.0;  //Prescaler für Hardware-Timer

const { s } = require('cluster');
const express = require('express')
const Measurement = require('./measurement');

const lastSpeeds = []; //  = new Measurement();
const lastLaps = [];

const settings = {
    dir: 0,         //0: S1->S2, 1:S1<-S2, 2: Auto
    edge: 1,        //0: LOW, 1: HIGH
    unit: "km/h",   // km/h, m/s
    mode: 0,        //0: Geschwindigkeit, 1:Runden
    calibration: 1.0,
    name: '',       
    date: 0,        //Unix timesatmp der lokalen Zeit in ms
    battery: 85     //Akkustand in %
};

const port = 3000

const app = express()
// parse application/json
app.use('/', function (req, res, next) {
    var requestOrigin = req.headers.origin;
    if (Array.isArray(requestOrigin)) {
        requestOrigin = requestOrigin[0];
    }
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Content-Type");
    res.header("Access-Control-Allow-Methods", "GET, POST, PUT, OPTIONS");
    next();
});
app.use(express.json());
app.use(express.raw());

function newMeasurement() {
    console.log('New Measurement!');
    let difference = 100000 * Math.random(); // (endTime - startTime);
    if (settings.mode === 0) {//  !lapTimes //Geschwindigkeit
      let duration = difference / PRESCALER; //µs
      let measurement = new Measurement().speedMeasurement(duration, settings);
      console.log("New Speed saved");
      lastSpeeds.unshift(measurement);
      while(lastSpeeds.length > 5) {
        lastSpeeds.pop();
      }
    } else if (settings.mode === 1) {  //Rundenzeit
      let duration = Math.random() * 1000 * 100000; //µs
      let measurement = new Measurement().lapMeasurement(duration, settings);
      console.log("New Lap Time saved");
      lastLaps.unshift(measurement);
      while(lastLaps.length > 5) {
        lastLaps.pop();
      }
    }
    // settings.newValueAvailable = true;
}

setInterval(newMeasurement, 10000);


app.post('/settings', (req, res) => {
    console.log('POST ' + req.originalUrl + ' Body:');
    const newSettings = typeof req.body === 'string' ? JSON.parse(req.body) : req.body;
    console.log(newSettings);

    if (newSettings.dir !== undefined) {
        settings.dir = newSettings.dir;
    }
    if (newSettings.edge !== undefined) {
        settings.edge = newSettings.edge;
    }
    if (newSettings.unit !== undefined) {
        settings.unit = newSettings.unit;
    }
    if (newSettings.mode !== undefined) {
        settings.mode = newSettings.mode;
    }
    if (newSettings.name !== undefined) {
        settings.name = newSettings.name;
    }
    if (newSettings.time !== undefined) {
        // this synchronizes the time between App and ESP32
        // we do nothing here
    }
    settings.date = new Date().getTime();
    console.log('response:')
    console.log(settings);
    res.header("Access-Control-Allow-Origin", "*");
    res.send(settings);
});

app.get('/time', (req, res) => {
    console.log(req.originalUrl);
    var lapTimes = settings.mode === 1;
    var newValue = false;
    var response = {
        settings: settings
    }    
    if(!lapTimes) {
        if (lastSpeeds.length > 0) {
            response.speeds = [];
            for(let i = 0; i < lastSpeeds.length; ++i) {
                if(!lastSpeeds[i].getSync()){
                    newValue = true;
                    response.speeds.push(lastSpeeds[i].send());
                    lastSpeeds[i].setSync(); 
                }
            }
        }
    } else{
        if (lastLaps.length > 0) {
            response.laps = [];
            for(let i = 0; i < lastLaps.length; ++i) {
                if(!lastLaps[i].getSync()) {
                    newValue = true;
                    response.laps.push(lastLaps[i].send());
                    lastLaps[i].setSync();
                }
            }
        }
    }
    console.log(response);
    res.send(response)
})

app.use(function (error, req, res, next) {
    console.log(`Error: ${req.originalUrl} , ${error} `);
    next();
});

app.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`)
})