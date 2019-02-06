import React, { Component } from 'react';
import Select from 'react-select';

import { withFirebase } from '../Firebase';

const INITIAL_STATE = {
    loading: false,
    assesmentSelection: null,
    userSelection: [],
    dates: [],
}

class AssignAssesmentsPage extends Component {
    constructor(props) {
	super(props);
	this.state = {...INITIAL_STATE};
	this.state.assesments = [];
	this.state.users = [];
    }

    componentDidMount() {
	this.setState({ loading: true });
	this.props.firebase.assesments().on('value', snapshot => {
	    const assesmentsObject = snapshot.val();
	    const assesmentsList = Object.keys(assesmentsObject).map(key => ({
		...assesmentsObject[key],
		uid: key,
	    }));
	    this.setState({
		assesments: assesmentsList,
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
	this.props.firebase.assesments().off();
	this.props.firebase.users().off();
    }
    
    handleAssesmentChange = (selection) => 
	this.setState({ assesmentSelection: selection });

    handleUserChange = (selection) => 
	this.setState({ userSelection: selection });

    handleAssignAssesmentsButton = () => {
	this.setState({loading: true})

	const [users, assesment] = [this.state.userSelection,
				     this.state.assesmentSelection]

	const isValid = this.state.assesmentSelection !== null &&
	      this.state.userSelection.length > 0
	
	if(isValid) {	    
	    this.assignAssesmentToUsers(assesment, users)
		.then(() =>
		      this.setState({...INITIAL_STATE}));
	} else {
	    this.setState({loading: false});
	    this.setState({error: {message: "You must pick at least 1 User, 1 Assesments, and a Start and End date."}});
	}
    }

    assignAssesmentToUsers = (assesmentWrapper, userWrappers) => {
	var promises = []
	userWrappers.map(userWrapper => {
	    promises.push(this.props.firebase
			  .assignAssesmentToUser(assesmentWrapper.value.uid,
						 userWrapper.value.uid));
	    this.props.firebase.sendNotification(userWrapper.value.fcmToken, "You have a new Assesment!", assesmentWrapper.value.title)
	    return null;
	})
	return Promise.all(promises)
    }


    
    render() {
	const [loading, assesmentSelection, userSelection,
	       assesments, users, error] = [this.state.loading,
					    this.state.assesmentSelection,
					    this.state.userSelection,
					    this.state.assesments,
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

		{error && <p> <font color="red">{error.message}</font></p>}
		
		    <h1>Assign Assesments</h1>

		    <div>
		    <h2>Select Assesments</h2>
		    <Select
		placeholder="Assesments..."
		value={assesmentSelection}
		onChange={this.handleAssesmentChange}
		options={assesments.map((e) => ({label: e.title, value: e}))}
		isSearchable={true}
		closeMenuOnSelect={true}
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

		    <br></br>
		    
		    <input onClick={this.handleAssignAssesmentsButton} type="button" value="Assign"/>
		    </div>
	    )
	}
    }
}

export default withFirebase(AssignAssesmentsPage);
