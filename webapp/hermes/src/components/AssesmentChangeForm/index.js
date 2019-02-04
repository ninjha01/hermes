import React, { Component } from 'react';

import { withFirebase } from '../Firebase';

import LoadingSpinner from '../LoadingSpinner';

class AssesmentChangeForm extends Component {
    constructor(props) {
	super(props);
	this.state = { assesment: props.assesment,
		       loading: false,
		       error: null, }
    }

    onSubmit = event => {
	const fields = this.state.assesment

	this.setState({loading: true})
	this.props.firebase
			   .doUpdateAssesmentByID(fields.uid, fields)
			   .catch(error => {
			       this.setState({ error: error });
			   })
			   .then(() => this.setState({loading: false}));
	event.preventDefault();
    };

    updateTitle = (event) => {
	const assesment = Object.assign({}, this.state.assesment)
	assesment.title = event.target.value
	this.setState({ assesment: assesment })
    }

    updatePainSite = (event) => {
	const assesment = Object.assign({}, this.state.assesment)
	assesment.painSites[event.target.name] = event.target.value
	this.setState({ assesment: assesment })
    }

     updateQuestion = (event) => {
	const assesment = Object.assign({}, this.state.assesment)
	assesment.questions[event.target.name] = event.target.value
	this.setState({ assesment: assesment })
    }

    render() {
	const [assesment, loading, error] = [this.state.assesment, this.state.loading,
					     this.state.error]

	//Validate
	//const isInvalid = false;
	if (loading) {
	    return (
		<LoadingSpinner />
	    );
	}
	else {
	    return (
		<form onSubmit={this.onSubmit}>
		<span>
		<strong>Title:</strong>
		<input name="title" value={assesment.title} onChange={this.updateTitle} type="text" placeholder="Title" />
		<br></br>
		<strong>Pain Sites:</strong>
		<ul>
		{assesment.painSites.map((site, i) => (
		    <li key={i}>
		    <input name={`${i}`} value={assesment.painSites[i]}
		    onChange={this.updatePainSite} type="text"
		    placeholder="site" />
		    </li>))}
		</ul>
		<br></br>
		<ul>
		{assesment.questions.map((site, i) => (
		    <li key={i}>
		    <input name={`${i}`} value={assesment.questions[i]}
		    onChange={this.updateQuestion} type="text"
		    placeholder="site" />
		    </li>))}
		</ul>
		</span>
		<input value="Update" type="submit" />
		{error && <p>{error.message}</p>}
		</form>
	    );
	}
    }
}
export default withFirebase(AssesmentChangeForm);
