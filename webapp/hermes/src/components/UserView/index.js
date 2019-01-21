import React, { Component } from 'react';

import { withFirebase } from '../Firebase';

import ExerciseView from '../ExerciseView';

class UserView extends Component {
    constructor(props) {
	super(props)
	
	this.state = { ...props.user };
    }

    onChange = event => {
	this.setState({ [event.target.name]: event.target.value });
    };

    render() {
	const user = this.state;
	console.log(user.exercises);
	user.exercises.forEach(exercise => (
	    console.log(exercise)
	));
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
		<br></br>
		<span><strong>Assesments:</strong> Assesments here </span>
		<br></br>
		</div>		
	);
    }
}

export default withFirebase(UserView);
