import React, { Component } from 'react';
import Select from 'react-select';

import Calendar from '../Calendar';
import {datesBetween, formatDateTime} from '../Utils';

import { withFirebase } from '../Firebase';

const INITIAL_STATE = {
    loading: false,
    exerciseSelection: [],
    userSelection: [],
    dates: [],
}

class AssignPage extends Component {
    constructor(props) {
	super(props);
	this.state = {...INITIAL_STATE};
	this.state.exercises = [];
	this.state.users = [];
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

    handleDateChange = (dates) => 
	this.setState({dates: dates});

    handleExerciseChange = (selection) => 
	this.setState({ exerciseSelection: selection });

    handleUserChange = (selection) => 
	this.setState({ userSelection: selection });

    handleAssignButton = () => {
	this.setState({loading: true})

	const [users, exercises, dates] = [this.state.userSelection,
					   this.state.exerciseSelection,
					   this.state.dates];
	const isValid = this.state.exerciseSelection.length > 0 &&
	      this.state.userSelection.length > 0 &&
	      Object.keys(this.state.dates).length > 0
	
	if(isValid) {	    
	    this.assignExercisesToUsers(exercises, users, dates)
		.then(() =>
		      this.setState({...INITIAL_STATE})
		     );
	} else {
	    this.setState({loading: false})
	    this.setState({error: {message: "You must pick at least 1 User, 1 Exercises, and a Start and End date."}});
	}
    }

    assignExercisesToUsers = (exercises, users, dates) => {
	dates = datesBetween(dates.startDate.toDate(), dates.endDate.toDate());
	var promises = []
	users.map(user => {
	    exercises.map(exercise => {
		dates.map(date => {
		    const startDateTime = new Date(date.valueOf());
		    startDateTime.setHours(0)
		    const endDateTime = new Date(date.valueOf());
		    endDateTime.setHours(23)
		    promises.push(this.props.firebase
				  .assignExerciseToUser(exercise.value.uid,
							user.value.uid,
							formatDateTime(startDateTime),
							formatDateTime(endDateTime)));
		    return null;
		})
		return null;
	    })
	    return null;
	})
	return Promise.all(promises)
    }
    
    render() {
	const [loading, exerciseSelection, userSelection,
	       exercises, users, error] = [this.state.loading,
					   this.state.exerciseSelection,
					   this.state.userSelection,
					   this.state.exercises,
					   this.state.users,
					   this.state.error,];
	if(loading) {
	    return (
		    <div>
		    <h1>Assign</h1>
		    <div>Loading ...</div>
		    </div>
	    )
	} else {
	    return (
		    <div>
		    <h1>Assign</h1>
		    {error && <p> <font color="red">{error.message}</font></p>}
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
		    <Calendar
		onChange={this.handleDateChange}
		    />
		    </div>
		    
		    <br></br>
		    <input onClick={this.handleAssignButton} type="button" value="Assign"/>
		    </div>	    
	    )
	}
    }
}

export default withFirebase(AssignPage);
