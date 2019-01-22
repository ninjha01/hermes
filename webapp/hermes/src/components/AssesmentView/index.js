import React, { Component } from 'react';

class AssesmentView extends Component {
    constructor(props) {
	super(props);
	this.state = {...props.values}
	console.log(this.state)
    }

    render() {
	const assesment = this.state.assesment;
	const fromUser = this.state.fromUser;
	if (fromUser) {
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
		<details>
		<summary><strong>Pain Sites:</strong></summary>
		<ul>
		{Object.keys(assesment.painSites).map((site, painBool) =>
		    <span>
		    <strong>{site}: </strong>
		    {JSON.stringify(assesment.painSites[site])}
		    <br></br>
		    </span>
		)}
		</ul>
		</details>		
		</li>
	    );
	} else {
	    return(
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
		</li>
	    );	    
	}
    }
}
export default AssesmentView;
