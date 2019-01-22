import React, { Component } from 'react';

import { withFirebase } from '../Firebase';

import UserView from '../UserView';

class UserPage extends Component {
    constructor(props) {
	super(props);

	this.state = {
	    loading: false,
	    users: [],
	    editing: null
	};
    }

    componentDidMount() {
	this.setState({ loading: true });

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
	this.props.firebase.users().off();
    }

    userDisplayList = (users) => (
	    <ul>
	    {users.map(user => (
		    <li key={user.uid}>
		    <span><strong>ID:</strong> {user.uid}</span>
		    <br></br>
		    <span><strong>Email:</strong> {user.email}</span>
		    <br></br>
		    <input onClick={() => this.setState({editing: user})} type="button" value="View"/>
	    	    </li>
	    ))}
	</ul>
    );


    render() {
	const { users, loading, editing } = this.state;
	const userDisplayList = this.userDisplayList(users);
	if (editing === null) {
	    return (
		    <div>
		    <h1>Users</h1>
		    {loading && <div>Loading ...</div>}
		    <div>
		    {userDisplayList}
		    </div>
		    <hr />
		    </div>
	    );
	} else {
	    return(
		    <div>
		    <h1>{editing.title}</h1>
		    <UserView user={editing} />
		    <input onClick={() => this.setState({editing: null})} type="button" value="Done"/>
		    </div>
	    )
	}
    }
}

export default withFirebase(UserPage);
