var functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);


exports.editProfile = functions.https.onRequest((req, res) => {
    var userId = req.get('Auth-Token')
    let billingName;
    let billingAddress;
    var dict = {};
    switch (req.get('content-type')) {
        case 'application/json':
        billingName = req.body.billingName;
        billingAddress = req.body.billingAddress;
        if (billingName) {
            dict.billingName = billingName;
        } 
        if (billingAddress) {
            dict.billingAddress = billingAddress;
        }   
        break;
    }
    return admin.database().ref('users/' + userId + '/userData').once('value', (snapshot) => {
        if (snapshot.val()) {
            admin.database().ref('users/' + userId + '/userData').update(dict);

        admin.database().ref('users/' + userId + '/userData').once('value', (snapshot) => {
            var userData = snapshot.val();
            res.send(userData);
            
         });
        } else {
            let errors = {}
            errors.message = "Forbidden access."
            res.status(403);
            res.send(errors);
        }
    });
  });
