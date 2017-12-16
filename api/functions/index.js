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
        } else {
            dict.billingName = null
        }
        if (billingZipCode) {
            dict.billingZipCode = billingZipCode;
        } else {
            dict.billingZipCode = null
        }
        if (billingCity) {
            dict.billingCity = billingCity;
        } else {
            dict.billingCity = null
        }
        if (billingAddress) {
            dict.billingAddress = billingAddress;
        } else {
            dict.billingAddress = null
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


exports.events = functions.https.onRequest((req, res) => {
    return admin.database().ref('events').once('value', (snapshot) => {
        var elements = snapshot.val();
        Object.keys(elements).forEach(function(key) {
            elements[key]['eventId'] = key;
            if (elements[key]['availableTickets']) {
                var tickets = elements[key]['availableTickets']
                Object.keys(tickets).forEach(function(ticketId) {
                    tickets[ticketId]['ticketId'] = ticketId;
                });
                var ticketValues = Object.keys(tickets).map(function(key) {
                    return tickets[key];
                });
                elements[key]['availableTickets'] = ticketValues;
            }
        });
        var elementValues = Object.keys(elements).map(function(key) {
            return elements[key];
        });
        res.send(elementValues);
    });
});

exports.places = functions.https.onRequest((req, res) => {
    return admin.database().ref('places').once('value', (snapshot) => {
        var elements = snapshot.val();
        Object.keys(elements).forEach(function(key) {
            elements[key]['placeId'] = key;
        });
        var elementValues = Object.keys(elements).map(function(key) {
            return elements[key];
        });
        res.send(elementValues);
    });
});

exports.purchaseTicket = functions.https.onRequest((req, res) => {
    

    var userId = req.url.split('/')[1]
    var authToken = req.get('Auth-Token');
    var ticket = req.body;
    var ticketId = ticket.ticketId;
  
    
    return admin.database().ref('users/' + userId + '/userData').once('value', (snapshot) => {
        var userData = snapshot.val();
        if (snapshot.val() && snapshot.val().authToken == authToken) {
            userData.userId = userId;
  
            admin.database().ref('users/' + userId + '/userData/tickets').once('value', (snapshot) => {
                var ticketSnap = snapshot.val()
                if (ticketSnap) {
                    ticket.ticketId = null;
                    ticketSnap[ticketId] = ticket;
                }
                admin.database().ref('users/' + userId + '/userData/tickets').update(ticketSnap);
  
                admin.database().ref('users/' + userId + '/userData').once('value', (snap) => {
                  res.send(snap.val());
                });
            });
  
            
        } else {
            let errors = {}
            errors.message = "Forbidden access."
            res.status(403);
            res.send(errors);
        }
    });
  });

