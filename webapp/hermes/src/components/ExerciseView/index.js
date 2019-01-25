import React, { Component } from 'react';

class ExerciseView extends Component {
    constructor(props) {
	super(props);
	this.state = {...props.exercise}
    }

    render() {
	const exercise = this.state;
	return (
	    <li key={exercise.uid}>
	    <span><strong>ID: </strong>{exercise.uid}</span>
	    <br></br>
	    <span><strong>Title: </strong>{exercise.title}</span>
	    <br></br>
	    <span><strong>Instructions: </strong>{exercise.instructions}</span>
	    <br></br>
	    <span><strong>Equipment: </strong>{exercise.equipment}</span>
	    <br></br>
	    <span><strong>Reps: </strong>{exercise.reps}</span>
	    <br></br>
	    <span><strong>Sets: </strong>{exercise.sets}</span>
	    <br></br>
	    {exercise.startDateTime && <span><strong>Date Assigned: </strong>
		{exercise.startDateTime}<br></br></span>}
	    {exercise.completed && <span><strong>Completed: </strong>
		True<br></br></span>}
	    </li>
	);
    }
}
export default ExerciseView;
