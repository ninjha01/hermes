import React, { Component } from 'react';

import { withFirebase } from '../Firebase';

import ExerciseChangeForm from '../ExerciseChangeForm';

class ExercisePage extends Component {
    constructor(props) {
	super(props);

	this.state = {
	    loading: false,
	    exercises: [],
	    editing: null
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

    exerciseDisplayList = (exercises) => (
	    <ul>
	    {exercises.map(exercise => (
		    <li key={exercise.uid}>
		    <span><strong>ID:</strong> {exercise.uid}</span>
		    <br></br>
		    <span><strong>Title:</strong> {exercise.title}</span>
		    <br></br>
		    <span><strong>Instructions:</strong> {exercise.instructions}</span>
		    <br></br>
		    <span><strong>Equipment:</strong> {exercise.equipment}</span>
		    <br></br>
		    <span><strong>Reps:</strong> {exercise.reps}</span>
		    <br></br>
		    <span><strong>Sets:</strong> {exercise.sets}</span>
		    <br></br>
		    <input onClick={() => this.setState({editing: exercise})} type="button" value="Update"/>
	    	    </li>
	    ))}
	</ul>
    );

    render() {
	const { exercises, loading, editing } = this.state;
	const exerciseDisplayList = this.exerciseDisplayList(exercises);
	//if not editing display all
	if (editing === null) {
	    return (
		    <div>
		    <h1>Exercise</h1>
		    {loading && <div>Loading ...</div>}
		    <div>
		    {exerciseDisplayList}
		    </div>
		    <hr />
		    </div>
	    );
	    // else display the editing form
	} else {
	    return(
		    <div>
		    <h1>{editing.title}</h1>
		    <ExerciseChangeForm exercise={editing} />
		    <input onClick={() => this.setState({editing: null})} type="button" value="Done"/>
		    </div>
	    )
	}
    }
}

export default withFirebase(ExercisePage);
