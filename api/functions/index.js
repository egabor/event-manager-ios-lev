var functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);


exports.editProfile = functions.https.onRequest((req, res) => {
    var userId = req.get('UserId')
    var authToken = req.get('Auth-Token');
    let billingName;
    let billingZipCode;
    let billingCity;
    let billingAddress;
    
    var dict = {};
    switch (req.get('content-type')) {
        case 'application/json':
        billingName = req.body.billingName;
        billingZipCode = req.body.billingZipCode;
        billingCity = req.body.billingCity;
        billingAddress = req.body.billingAddress;
        if (billingName) {
            dict.billingName = billingName;
        } 
        if (billingZipCode) {
            dict.billingZipCode = billingZipCode;
        } 
        if (billingCity) {
            dict.billingCity = billingCity;
        } 
        if (billingAddress) {
            dict.billingAddress = billingAddress;
        }   
        break;
    }
    return admin.database().ref('users/' + userId + '/userData').once('value', (snapshot) => {
        if (snapshot.val() && snapshot.val().authToken == authToken) {
            admin.database().ref('users/' + userId + '/userData').update(dict);

            admin.database().ref('users/' + userId + '/userData').once('value', (snapshot) => {
                var userData = snapshot.val();
                userData.userId = userId;
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


  exports.users = functions.https.onRequest((req, res) => {
      console.log(req.url.split('/')[1]);

    var urlUserId = req.url.split('/')[1]
    var userId = ''
    var authToken = req.get('Auth-Token');

    if (urlUserId == 'me') {
        userId = req.get('UserId');
    } else if (urlUserId) {
        userId = urlUserId;
    }

    
    return admin.database().ref('users/' + userId + '/userData').once('value', (snapshot) => {
        var userData = snapshot.val();
        if (snapshot.val() && snapshot.val().authToken == authToken) {
            userData.userId = userId;
            if (urlUserId != 'me') {
                userData.authToken = null;
            }
            res.send(userData);
        } else {
            let errors = {}
            errors.message = "Forbidden access."
            res.status(403);
            res.send(errors);
        }
    });
  });
