import React, { Component } from 'react';

import { withFirebase } from '../Firebase';
import ExerciseChangeForm from '../ExerciseChangeForm';

class ExercisePage extends Component {
    constructor(props) {
	super(props);

	this.state = {
	    loading: false,
	    exercises: [],
	};
    }

    componentDidMount() {
	this.setState({ loading: true });

	this.props.firebase.exercises().on('value', snapshot => {
	    const exercisesObject = snapshot.val();

	    const exercisesList = Object.keys(exercisesObject).map(key => ({
		...exercisesObject[key],
		uid: key,
	    }));
	    
	    this.setState({
		exercises: exercisesList,
		loading: false,
	    });
	});
    }

    componentWillUnmount() {
	this.props.firebase.exercises().off();
    }    
    
    render() {
	const { exercises, loading } = this.state;
	return (
		<div>
		<h1>Exercise</h1>
		{loading && <div>Loading ...</div>}
		<div>
		<ExerciseList exercises={exercises} />
		</div>
		<hr />
		<p>Create an Exercise </p>
		</div>
	);
    }
}

//Exercise Display
const ExerciseList = ({ exercises }) => (
	<ul>
	{exercises.map(exercise => (
		<li key={exercise.uid}>
		<span>
		<strong>ID:</strong> {exercise.uid}
		<br></br>
		</span>
		<span>
		<ExerciseChangeForm exercise={exercise} />
	    </span>
		
	    </li>
	))}
    </ul>
);

export default withFirebase(ExercisePage);
