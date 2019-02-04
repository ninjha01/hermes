var apn = require('apn');

var options = {
  token: {
    key: "./components/Notifications/AuthKey_LRS6977R74.p8",
    keyId: "LRS6977R74",
    teamId: "H4V63CJ3CM",
  },
  production: false
};

var apnProvider = new apn.Provider(options);

var  deviceTokens = ["e2e6ee1fc4dcbe65cfb100562ff625d584965d898051d5c463b3a0d986c87cbf"]

var note = new apn.Notification();

note.expiry = Math.floor(Date.now() / 1000) + 3600; // Expires 1 hour from now.
note.badge = 3;
note.sound = "ping.aiff";
note.alert = "\uD83D\uDCE7 \u2709 You have a new message";
note.payload = {'messageFrom': 'John Appleseed'};
note.topic = "com.nishant.hermes"


var promise = apnProvider.send(note, deviceTokens).then((result) => {
    console.log(result.failed)
});
