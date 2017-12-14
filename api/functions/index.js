var functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);


exports.editProfile = functions.https.onRequest((req, res) => {
    response.send("Test");
});