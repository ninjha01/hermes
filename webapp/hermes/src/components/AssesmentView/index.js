import React, { Component } from 'react';

class AssesmentView extends Component {
    constructor(props) {
	super(props);
	this.state = {...props.assesment}
	console.log(this.state);
    }

    render() {
	const assesment = this.state;
	return (
		<li key={assesment.id}>
		<span><strong>ID:</strong> {assesment.id}</span>
		<br></br>
		<span><strong>Title:</strong> {assesment.title}</span>
		<br></br>
		<span><strong>Date Assigned:</strong> {assesment.dateAssigned}</span>
		<br></br>
		<span><strong>Date Completed:</strong> {assesment.dateCompleted}</span>
		<br></br>
		<span><strong>Pain Score:</strong> {assesment.painScore}</span>
		<br></br>
		</li>
	);
    }
}
export default AssesmentView;
