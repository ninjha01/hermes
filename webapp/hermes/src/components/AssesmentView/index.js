import React, { Component } from 'react';

class AssesmentView extends Component {
    constructor(props) {
	super(props);
	this.state = {...props}
    }

    render() {
	const assesment = this.state.assesment;
	
	return(
	    <span>
	    <span><strong>ID:</strong> {assesment.uid}</span>
	    <br></br>
	    <span><strong>Title:</strong> {assesment.title}</span>
	    <br></br>
	    <span><strong>Date Assigned:</strong> {assesment.dateAssigned}</span>
	    <br></br>
	    {assesment.dateCompleted &&
	     <span><strong>Date Completed:</strong> {assesment.dateCompleted}
		<br></br></span>}
	    {assesment.painScore &&
	     <span><strong>Pain Score:</strong> {assesment.painScore}
		<br></br></span>}
	    <details>
	    <summary><strong>Pain Sites:</strong></summary>
	    <ul>
	    {assesment.painSites.map((site, i) =>
		<li key={i}>
		<strong>{site}</strong>
		</li>
	    )}
	    </ul>
	    </details>
	    
	    <details>
	    <summary><strong>Questionaire:</strong></summary>
	    <ul>
	    {assesment.questions.map((question, i) =>
		<li key={i}>
		<strong>{question}</strong>
		</li>
	    )}
	    </ul>
	    </details>
	    </span>
	)
    }
}
export default AssesmentView;

