const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
exports.myFunctionName = functions.firestore
    .document('/users/{wildcard}').onWrite((change, context) => {
        var data = change.after.data();
        if (data.isactive) {
            admin.firestore().collection('tokens').where('uid', 'in', data.friends).get().then(doc => {
                var tokens = [];
                doc.docs.forEach(c => {
                    var e = c.data();
                    tokens.push(e.token);
                })
              
                    const payload = {
                        notification: {
                            title: data.name + " IN DANGER",
                            body: "YOUR FRIEND IS IN DANGER!!!!",
                            sound: "default"
                        },
                        data: {
                            uid: data.uid,
                            click_action: "FLUTTER_NOTIFICATION_CLICK",
                        }
                    };
                    console.log(tokens);
                    admin.messaging().sendToDevice(tokens, payload);

                
                return;
            }
            ).catch(r => { console.log(r) });
        }

    });


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
