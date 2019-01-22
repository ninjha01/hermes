import React, { Component } from 'react';

class AssesmentView extends Component {
    constructor(props) {
	super(props);
	this.state = {...props.values}
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
		    <li key={site}>
		    <strong>{site}: </strong>
		    {JSON.stringify(assesment.painSites[site])}
		    <br></br>
		    </li>
		)}
		</ul>
		</details>
		<details>
		<summary><strong>Questionaire:</strong></summary>
		<ul>
		{Object.keys(assesment.questions).map((question, answer) =>
		    <li key={question}>
		    <strong>{question}: </strong>
		    {assesment.questions[question] ?  "Yes" : "No"}
		    </li>
		)}
		</ul>

		</details>
		</li>
		
	    );
	} else {
	    console.log("Hello");
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

		<details>
		<summary><strong>Pain Sites:</strong></summary>
		<ul>
		{assesment.painSites.map((site, i) =>
		    <li>
		    <strong>{site}</strong>
		    </li>
		)}
		</ul>
		</details>
		
		<details>
		<summary><strong>Questionaire:</strong></summary>
		<ul>
		{assesment.questions.map((question, i) =>
		    <li>
		    <strong>{question}</strong>
		    </li>
		)}
		</ul>
		</details>
		</li>
	    )
	}
    }
}
export default AssesmentView;

