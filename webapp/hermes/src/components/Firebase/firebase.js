import app from 'firebase/app';
import 'firebase/auth';
import 'firebase/database';
import 'firebase/storage';

const config = {
    apiKey: process.env.REACT_APP_API_KEY,
    authDomain: process.env.REACT_APP_AUTH_DOMAIN,
    databaseURL: process.env.REACT_APP_DATABASE_URL,
    projectId: process.env.REACT_APP_PROJECT_ID,
    storageBucket: process.env.REACT_APP_STORAGE_BUCKET,
    messagingSenderId: process.env.REACT_APP_MESSAGING_SENDER_ID,
};

class Firebase {
    constructor() {
	app.initializeApp(config);
	this.auth = app.auth();
	this.db = app.database();
	this.storage = app.storage();
    }

    
    // *** Auth API ***

    doCreateUserWithEmailAndPassword = (email, password) =>
	this.auth.createUserWithEmailAndPassword(email, password);

    doSignInWithEmailAndPassword = (email, password) =>
	this.auth.signInWithEmailAndPassword(email, password);

    doSignOut = () => this.auth.signOut();

    doPasswordReset = email => this.auth.sendPasswordResetEmail(email);

    doPasswordUpdate = password =>
	this.auth.currentUser.updatePassword(password);

    // *** User API ***
    users = () => this.db.ref('users');
    user = uid => this.db.ref("users/" + uid);

    assignExerciseToUser = (exerciseID, userID, startDateTime, endDateTime) => {
	const userExerciseDataChild = this.user(userID).child('exerciseData').push()
	userExerciseDataChild.update({eid: exerciseID,
				      startDateTime: startDateTime,
				      endDateTime: endDateTime,
				      completed: false})
    }

    assignAssesmentToUser = (assesmentID, userID) => {
	const userAssesmentDataChild = this.user(userID).child('assesmentData').push()
	var assesment = null
	var questions = {};
	var painSites = {};
	this.assesments().child(assesmentID).on('value', snapshot => {
	    assesment = snapshot.val();
	    assesment.questions.map(question => {
		questions[question] = "null";
		return null;
	    });
	    assesment.painSites.map(site => {
		painSites[site] = "null";
		return null;
	    });
	    userAssesmentDataChild.update({aid: assesmentID,
					   questions: questions,
					   painSites: painSites,					  
					   completed: false})

	});
    } 
    
    // *** Exercise API ***
    exercises = () => this.db.ref('exercises');
    exerciseVideoRef = () => this.storage.ref('exercise_videos/')
    
    doUpdateExerciseByID = (id, values) =>
	this.db.ref('exercises/' + id).update(values);
    
    getExerciseVideoUrl = (id) =>
	this.exerciseVideoRef().child(id).getDownloadURL()

    // *** Assesments API ***
    assesments = () => this.db.ref('assesments');
    doUpdateAssesmentByID = (id, values) =>
	this.db.ref('assesments/' + id).update(values);

    // *** Notifications API ***
    sendNotification = (fcmToken, title, body) => {
	console.log(fcmToken, title, body)
	var key = 'AAAAOTy7Las:APA91bFPBWu6-tp83OSMzWEIno-HPDVT5Y7TV9SHTV9RAUgIzjEmnVxzkp0qUmS0IBJ6UJMZZaoeYE2jbqkaTkqyzwPQC4fSuCgUaf9AVLRbIFECBO1XWWA-Th7nHDimrpiEF4iUHdBd';
	var notification = {
	    'title': title,
	    'body': body,
	    'icon': 'firebase-logo.png',
	    'click_action': 'http://localhost:8081'
	};
	var to = fcmToken;
	fetch('https://fcm.googleapis.com/fcm/send', {
	    'method': 'POST',
	    'headers': {
		'Authorization': 'key=' + key,
		'Content-Type': 'application/json'
	    },
	    'body': JSON.stringify({
		'notification': notification,
		'to': to
	    })
	}).then(function(response) {
	    console.log(response);
	}).catch(function(error) {
	    console.error(error);
	})
    }
}

export default Firebase;
