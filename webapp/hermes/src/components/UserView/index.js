import React, { Component } from 'react';

import { withFirebase } from '../Firebase';

import ExerciseView from '../ExerciseView';
import AssesmentView from '../AssesmentView';

class UserView extends Component {
    constructor(props) {
	super(props)
	
	this.state = { ...props.user };
	this.state.exercises = [];
	this.populateExercises(this.state.exerciseData)
	this.state.assesments = [];
	this.populateAssesments(this.state.assesmentData)
    }

    onChange = event => {
	this.setState({ [event.target.name]: event.target.value });
    };

    populateExercises = (exerciseData) => {
	var exercises = [];
	try {
	    Object.values(exerciseData).map(exerciseDatum =>
		this.props.firebase.exercises()
		    .child(exerciseDatum.eid).on('value', snapshot => {
			const exerciseObject = snapshot.val();
			Object.assign(exerciseObject, exerciseDatum);
			exerciseObject["uid"] = snapshot.key;
			exercises.push(exerciseObject);
			this.setState({exercises:exercises});
		    })
	    )
	} catch {
	    console.log("User has no exerciseData")
	}
    }

    populateAssesments = (assesmentData) => {
	var assesments = [];
	try {
	    Object.values(assesmentData).map(assesmentDatum =>
		this.props.firebase.assesments()
		    .child(assesmentDatum.eid).on('value', snapshot => {
			const assesmentObject = snapshot.val();
			Object.assign(assesmentObject, assesmentDatum);
			assesments.push(assesmentObject);
			this.setState({assesments:assesments});
		    })
	    )
	} catch {
	    console.log("User has no assesmentData")
	}
    }
    
    
    render() {
	const user = this.state;
	return (
	    <div>
	    <span><strong>ID:</strong> {user.uid}</span>
	    <br></br>
	    <span><strong>Email:</strong> {user.email}</span>
	    <br></br>
	    <span><strong>deviceToken:</strong> {user.deviceToken}</span>
	    <br></br>
	    <details>
	    <summary><strong>Exercises:</strong></summary>
	    <ul>
	    {Object.values(user.exercises).map(exercise => (
		<ExerciseView exercise={exercise} />
	    ))}
	    </ul>
	    </details>
	    <details>
	    <summary><strong>Assesments:</strong></summary>
	    <ul>
	    {Object.values(user.assesments).map(assesment => (
		<AssesmentView values={{assesment: assesment, fromUser: true}} />
	    ))}
	    </ul>
	    </details>
	    </div>		
	);
    }
}

export default withFirebase(UserView);

