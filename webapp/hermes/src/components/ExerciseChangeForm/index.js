import React, { Component } from 'react';

import { withFirebase } from '../Firebase';

class ExerciseChangeForm extends Component {
    constructor(props) {
	super(props);

	this.state = { ...props.exercise };
	this.error = null;
    }

    onSubmit = event => {
	const fields =  {"title": this.state.title,
		   "equipment": this.state.equipment,
		   "instructions": this.state.instructions,
		   "primaryVideoFilename": this.state.primaryVideoFilename,
		   "reps": this.state.reps,
		   "sets": this.state.sets }
	
	this.props.firebase
	    .doUpdateExerciseByKey(this.state.uid, fields)
	    .catch(error => {
		this.setState({ error: error });
	    });

	event.preventDefault();
    };

    onChange = event => {
	this.setState({ [event.target.name]: event.target.value });
    };

    render() {
	const [title, error ] = [this.state.title, this.state.error];

	//TODO: Validate
	const isInvalid = false;

	return (
		<form onSubmit={this.onSubmit}>
		<input
	    name="title"
	    value={title}
	    onChange={this.onChange}
	    type="text"
	    placeholder="Title"
		/>
		<button disabled={isInvalid} type="submit">
		Update Exercise
	    </button>
		
	    {error && <p>{error.message}</p>}
	    </form>
	);
    }
}

export default withFirebase(ExerciseChangeForm);
