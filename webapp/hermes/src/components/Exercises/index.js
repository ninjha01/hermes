import React, { Component } from 'react';

import { withFirebase } from '../Firebase';

import ExerciseChangeForm from '../ExerciseChangeForm';
import ExerciseView from '../ExerciseView';

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
		    <span>
		    <ExerciseView exercise={exercise} />
		    <input onClick={() => this.setState({editing: exercise})} type="button" value="Update"/>
		    </span>
	    ))}
	</ul>
    );

    render() {
	const { exercises, loading, editing } = this.state;
	console.log(exercises);
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
