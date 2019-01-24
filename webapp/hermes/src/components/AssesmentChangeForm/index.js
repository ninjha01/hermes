import React, { Component } from 'react';

import { withFirebase } from '../Firebase';

import LoadingSpinner from '../LoadingSpinner';

class AssesmentChangeForm extends Component {
    constructor(props) {
	super(props);
	
	this.state = { assesment: props.assesment,
		       loading: false,
		       error: null,
		     }
    }

    onSubmit = event => {
	const fields = this.state.assesment

	this.setState({loading: true})
	this.props.firebase
	    .doUpdateAssesmentByID(this.state.uid, fields)
	    .catch(error => {
		this.setState({ error: error });
	    })
	    .then(() => this.setState({loading: false}));
	event.preventDefault();
    };

    onChange = event => {
	this.setState({ [event.target.name]: event.target.value });
    };

    render() {

	const {assesment, loading, error} = this.state

	//Validate
	const isInvalid = false;
	if (loading) {
	    return (
		    <LoadingSpinner />
	    );
	}
	else {
	    return (
		<div>
		    <span>
		    <strong>Title:</strong>
		    <input name="title" value={assesment.title} onChange={this.onChange} type="text" placeholder="Title" />
		    <br></br>
		    </span>
		    {error && <p>{error.message}</p>}
		</div>
	    );
	}
    }
}
export default withFirebase(AssesmentChangeForm);
