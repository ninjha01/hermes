import app from 'firebase/app';

const config = {
    apiKey: "AIzaSyAGLKg2FKcZPuVNKwns-PSlTMQkpaiWqLU",
    authDomain: "hermes-91802.firebaseapp.com",
    databaseURL: "https://hermes-91802.firebaseio.com",
    projectId: "hermes-91802",
    storageBucket: "hermes-91802.appspot.com",
    messagingSenderId: "245832035755"
};

class Firebase {
    constructor() {
	app.initializeApp(config);
    }
}

export default Firebase;
