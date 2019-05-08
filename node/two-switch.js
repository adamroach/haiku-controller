#!/usr/bin/node

console.log("Starting...");

const bigAssApi = require("BigAssFansAPI");
const fanMaster = new bigAssApi.FanMaster(1);
const fanName = 'Master Bedroom Fan';
var last = {};

function update(property) {
  return function (level) {
    level = parseInt(level);
    if (level > 0 && (level != last[property])) {
      last[property] = level;
      console.log(JSON.stringify(last));
    }
  }
}

fanMaster.onFanFullyUpdated = function(haiku){
  if (haiku.name != fanName) {
    return;
  }

  last.speed = last.speed
               || parseInt(haiku.fan.speed)
               || parseInt(haiku.fan.max);

  last.brightness = last.brightness
                    || parseInt(haiku.light.brightness)
                    || parseInt(haiku.light.max);

  console.log(JSON.stringify(last));

  haiku.light.registerUpdateCallback("brightness", update('brightness'));
  haiku.fan.registerUpdateCallback("speed", update('speed'));
  setInterval(() => haiku.light.update("brightness"), 1000);
  setInterval(() => haiku.fan.update("speed"), 1000);
};


/* ---------------------------------------------------------------------- */

const { execSync } = require('child_process');
execSync('raspi-gpio set 4 pu');
execSync('raspi-gpio set 17 pu');
execSync('raspi-gpio set 19 pu');
execSync('raspi-gpio set 26 pu');

const debounce = 20;

const Gpio = require('onoff').Gpio;
const lightOn = new Gpio(17, 'in', 'both', {debounceTimeout: debounce});
const lightOff = new Gpio(4, 'in', 'both', {debounceTimeout: debounce});
const fanOn = new Gpio(26, 'in', 'both', {debounceTimeout: debounce});
const fanOff = new Gpio(19, 'in', 'both', {debounceTimeout: debounce});

function button(device, side, err, value) {
  const haiku = fanMaster.allFans[fanName];
  if (!haiku) {
    console.log("Could not find fan.");
    return;
  }

  console.log(device + ' ' + side + ' ' + (value?"down":"up"));

  if (device === 'light') {
    if (side === 'on') {
      haiku.light.brightness = last.brightness;
    } else {
      haiku.light.brightness = 0;
    }
  } else { // fan
    if (side === 'on') {
      haiku.fan.speed = last.speed;
    } else {
      haiku.fan.speed = 0;
    }
  }
}

function listen(device, side) {
  return function(err, value) {
    button(device, side, err, value);
  };
}

lightOn.watch(listen('light','on'));
lightOff.watch(listen('light','off'));
fanOn.watch(listen('fan','on'));
fanOff.watch(listen('fan','off'));

console.log("Started.");
