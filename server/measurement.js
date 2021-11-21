/**
 * Module exports.
 * @public
 */
 const DISTANCE = 0.5;   //Distanz zwischen Lichtschranken
 const MICRO = 1000000;  //1s in us
 
 var dateFormat = require('dateformat');

 module.exports = Measurement;

 /**
 * Create a new Measurement object.
 *
 * @public
 */
function Measurement () {
    
    /**
     * Time in ms
     */
    this.time = 20000;

    /**
     * Date
     */
    this.date = new Date();

    /**
     * Speed
     */
    this.speed = 1;

    /**
     * Speed
     */
    this.sync = false;

    /**
     * Mode 0 => Speed, 1 => Laps
     */
    this.mode = 0;

    /**
     * Settings
     */
    this.settings = {
        edge: 0,
        calibration: 1.0,
        // Direction: 0 => S1->S2, 1 => S2->S1, 2 => Auto
        dir: 0,
        // Mode: true => Labs, false => Speed
        mode: false,
        name: ""
    }
}

Measurement.prototype.printTime = function (date) {
    return dateFormat(date, "yyyy/m/d hh:MM:ss");
}

Measurement.prototype.speedMeasurement = function (time, settings) {
    this.time = parseInt(time);
    this.date = new Date();
    this.settings = settings;
    this.speed = DISTANCE / (time / MICRO); // in m/s
    this.mode = 0;
    this.sync = false;
    console.log(this.printTime(this.date));
    console.log(" ");
    var string = "Zeit(ms): " + String(time / 1000, 3) + 
        " , Geschwindigkeit [km/h]: " + String(this.speed, 4) + 
        " , (km/h): " + String(this.speed * 3.6, 4) + "\n";      
    console.log(string);
    return this;
}

// lapMeasurement(double time)
Measurement.prototype.lapMeasurement = function (time, settings) {
    this.time = time;
    this.date = new Date();
    this.sync = false;
    this.settings = settings;
    this.mode = 1;
    console.log(this.printTime(this.date));
    console.log(" ");
    var string = "Rundenzeit [ms]: " + String(time / 1000, 3);
    console.log(string);
    return this; 
}

Measurement.prototype.send = function () {

    var data = {
        date: this.getDate().getTime(),
        time: this.getTimeMS(),
        dir: this.getDirection(),
        edge: this.getEdge(),
        calibration: this.getCalibration(),
        mode: this.mode
    } 
    if (this.mode == 0) {
        data.speed = DISTANCE / (this.getTimeMS() / 1000) * 3.6;
    }
    return data;
}

// double measurement::getTimeMS()
Measurement.prototype.getTimeMS = function () {
    return this.time / 1000;
}

// DateTime measurement::getDate()
Measurement.prototype.getDate = function () {
    return this.date;
}

// byte measurement::getSync()
Measurement.prototype.getSync = function () {
    return this.sync ? 1 : 0;
}

// byte measurement::getSync()
Measurement.prototype.setSync = function () {
    this.sync = true;
}

// double speedMeasurement::getSpeed()
Measurement.prototype.getSpeed = function () {
    return this.speed;
}

// byte measurement::getDirection()
Measurement.prototype.getDirection = function () {
    return this.settings.dir;
}

// byte measurement::getMode()
Measurement.prototype.getMode = function () {
    return this.settings.mode ? 1 : 0;
}

// double measurement::getCalibration()
Measurement.prototype.getCalibration = function () {
    return this.settings.calibration;
}

// double measurement::getCalibration()
Measurement.prototype.getEdge = function () {
    return this.settings.edge;
}
