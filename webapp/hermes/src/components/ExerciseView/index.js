import React, { Component } from 'react';

class ExerciseView extends Component {
    constructor(props) {
	super(props);
	this.state = {...props.exercise}
	console.log(this.state);
    }

    render() {
	const exercise = this.state;
	return (
		<li key={exercise.id}>
		<span><strong>ID:</strong> {exercise.id}</span>
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
		</li>
	);
    }
}
export default ExerciseView;
