const express = require("express");
const app = express();
const bodyParser = require('body-parser');
const cors = require("cors")
const route = 3000;

// import firebase-admin package
const admin = require('firebase-admin');

// import service account file (helps to know the firebase project details)
const serviceAccount = require("./service_accountConfig.json");


// Import Firebase to Store Doc 

const firebase = require("firebase");
// Required for side-effects
require("firebase/firestore");

// Intialize the firebase-admin project/account
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

app.use(cors());
var jsonParser = bodyParser.json()


// Route 
app.get('/', (req, res) => {
    res.send('Hello World')
});


// Db Init 
const firebaseConfig = {
    apiKey: "AIzaSyDOzy-UnSo9IzDw6aw7_EvGypQ-KxFqV8o",
    authDomain: "sysbin-main-c346a.firebaseapp.com",
    projectId: "sysbin-main-c346a",
    storageBucket: "sysbin-main-c346a.appspot.com",
    messagingSenderId: "964998854402",
    appId: "1:964998854402:web:df31087a68d4ecc1aab41b",
    measurementId: "G-9396XNWX3X"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);
const db = firebase.firestore();


app.post("/createUser", jsonParser, (req, res) => {
    console.log(req.body);
    const { email: recEmail, username: recUsername, password: recPassword, isAdmin } = req.body;


    res.sendStatus(200)
    try {
        admin.auth().createUser({
            email: recEmail,
            emailVerified: false,
            password: recPassword,
            displayName: recUsername

        }).then((userRecord) => {
            console.log('User Created Successfully')

            db.collection("usersLogin").doc(`${userRecord.uid}`).set({
                email: recEmail,
                name: recUsername,

                role: isAdmin ? "admin" : "user",

            }).then((docRef) => {
                console.log("Document written ");
            })
                .catch((error) => {
                    console.error("Error adding document: ", error);
                });

        })
    } catch (error) {
        console.log('Error creating new user:', error);

    }


});

app.post("/updateUser", jsonParser, (req, res) => {
    console.log(req.body);
    const { email: recEmail, username: recUsername, password: recPassword, isAdmin, uid } = req.body;


    let objToSend;
    if (recPassword != "" || recPassword.length != 0) {
        objToSend = {
            email: recEmail,
            emailVerified: false,
            password: recPassword,
            displayName: recUsername

        };
    } else {
        objToSend = {
            email: recEmail,
            emailVerified: false,
            displayName: recUsername

        };

    }



    try {
        admin.auth().updateUser(uid, objToSend).then((userRecord) => {
            console.log('User Updated Successfully')

            db.collection("usersLogin").doc(`${userRecord.uid}`).set({
                email: recEmail,
                name: recUsername,
                role: isAdmin ? "admin" : "user",

            }).then((docRef) => {
                console.log("Document written ");
            })
                .catch((error) => {
                    console.error("Error adding document: ", error);
                });

        });
        res.sendStatus(200)
    } catch (error) {
        console.log('Error creating new user:', error);

    }


});

app.post("/deleteUser", jsonParser, (req, res) => {
    console.log(req.body);
    const { id: recId, } = req.body;


    res.sendStatus(200)
    try {
        admin.auth().deleteUser(recId).then((userRecord) => {
            console.log('User Created Successfully')

            db.collection("usersLogin").doc(recId).delete().then((docRef) => {
                console.log("Document written ");
            })
                .catch((error) => {
                    console.error("Error adding document: ", error);
                });

        })
    } catch (error) {
        console.log('Error creating new user:', error);

    }


});



app.listen(3000, () => {
    console.log('Server is running ')
})