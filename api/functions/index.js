var functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);


exports.editProfile = functions.https.onRequest((req, res) => {
    var userId = req.get('Auth-Token')
    let billingName;
    let billingAddress;
    switch (req.get('content-type')) {
        // '{"name":"John"}'
        case 'application/json':
        billingName = req.body.billingName;
        billingAddress = req.body.billingAddress;        
        break;
    }
    res.status(200).send('Hello, World!' + userId + "   " + billingName);
  });