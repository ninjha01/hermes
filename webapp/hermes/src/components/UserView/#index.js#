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
    }

    onChange = event => {
	this.setState({ [event.target.name]: event.target.value });
    };

    populateExercises = (exerciseData) => {
	var exercises = [];
	exerciseData.map(exerciseDatum =>
	    this.props.firebase.exercises()
		.child(exerciseDatum.id).on('value', snapshot => {
		    const exerciseObject = snapshot.val();
		    Object.assign(exerciseObject, exerciseDatum);
		    exercises.push(exerciseObject);
		    this.setState({exercises:exercises});
		})
	)
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
	    {user.exercises.map(exercise => (
		<span>
		<ExerciseView exercise={exercise} />
		</span>
	    ))}
	    </ul>
	    </details>
	    <details>
	    <summary><strong>Assesments:</strong></summary>
	    <ul>
	    {user.assesments.map(assesment => (
		<span>
		<AssesmentView values={{assesment: assesment, fromUser: true}} />
		</span>
	    ))}
	    </ul>
	    </details>
	    </div>		
	);
    }
}

export default withFirebase(UserView);
