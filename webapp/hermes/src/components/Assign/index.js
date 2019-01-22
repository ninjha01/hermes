import React, { Component } from 'react';
import { withFirebase } from '../Firebase';

class AssignPage extends Component {
    constructor(props) {
	super(props);
	this.state = {...props};
    }

    render() {
	return (
		<div>
		<h1>Assign</h1>
		</div>
	)
    }
}

export default withFirebase(AssignPage);
