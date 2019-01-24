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
    // *** Exercise API ***
    exercises = () => this.db.ref('exercises');
    exerciseVideoRef = () => this.storage.ref('exercise_videos/')
    
    doUpdateExerciseByID = (id, values) =>
	this.db.ref('exercises/' + id).update(values);
    
    getExerciseVideoUrl = (id) =>
	this.exerciseVideoRef().child(id).getDownloadURL()


}

export default Firebase;
