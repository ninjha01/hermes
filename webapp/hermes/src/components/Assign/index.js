import React, { Component } from 'react';
import Select from 'react-select';

import Calendar from '../Calendar';

import { withFirebase } from '../Firebase';

class AssignPage extends Component {
    constructor(props) {
	super(props);
	this.state = {
	    loading: false,
	    users: [],
	    exercises: [],
	    selectedExercises: [],
	    selectedUsers: []
	}
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
	    });
	});
	this.props.firebase.users().on('value', snapshot => {
	    const usersObject = snapshot.val();

	    const usersList = Object.keys(usersObject).map(key => ({
		...usersObject[key],
		uid: key,
	    }));
	    
	    this.setState({
		users: usersList,
		loading: false,
	    });
	});
    }

    componentWillUnmount() {
	this.props.firebase.exercises().off();
	this.props.firebase.users().off();
    }

    
    handleExerciseChange = (selection) => {
	this.setState({ selectedExercises: selection });
    }

    handleUserChange = (selection) => {
	this.setState({ selectedUsers: selection });
    }

    
    render() {
	const [loading, exerciseSelection, userSelection,
	       exercises, users] = [this.state.loading,
				    this.state.exerciseSelection,
				    this.state.userSelection,
				    this.state.exercises,
				    this.state.users];
	if(loading) {
	    return (
		<div>
		<h1>Assign</h1>
		<div>Loading ...</div>
		</div>
	    )
	} else {
	    console.log(exercises.map((e) => ({label: e.title, value: e})));
	    return (
		<div>
		<h1>Assign</h1>
		
		<div>
		<h2>Select Exercises</h2>
		<Select
		placeholder="Exercises..."
		value={exerciseSelection}
		onChange={this.handleExerciseChange}
		options={exercises.map((e) => ({label: e.title, value: e}))}
		isMulti={true}
		isSearchable={true}
		closeMenuOnSelect={false}
		hasSelectAll={true}
		/>
		</div>
		
		<div>
		<h2>Select Users</h2>
		<Select
		placeholder="Users..."
		value={userSelection}
		onChange={this.handleUserChange}
		options={users.map((u) => ({label: u.email, value: u}))}
		isMulti={true}
		isSearchable={true}
		closeMenuOnSelect={false}
		/>
		</div>
				
		<div>
		<h2>Select Dates</h2>
		<Calendar />
		</div>
		
		<br></br>
		<input onClick={() => null} type="button" value="Assign"/>
		</div>	    
	    )
	}
    }
}

export default withFirebase(AssignPage);
