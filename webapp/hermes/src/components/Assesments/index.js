import React, { Component } from 'react';

import { withFirebase } from '../Firebase';

import AssesmentChangeForm from '../AssesmentChangeForm';
import AssesmentView from '../AssesmentView';

class AssesmentPage extends Component {
    constructor(props) {
	super(props);

	this.state = {
	    loading: false,
	    assesments: [],
	    editing: null
	};
	this.notifications = new Notifications();
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
		loading: false,
	    });
	});
    }

    componentWillUnmount() {
	this.props.firebase.assesments().off();
    }

    assesmentDisplayList = (assesments) => (
	    <ul>
	    {assesments.map(assesment => (
		    <li key={assesment.uid}>
		    <span>
		    <AssesmentView assesment={assesment} />
		    <input onClick={() => this.setState({editing: assesment})} type="button" value="Update"/>
		   // <input onClick={this.sendNotification} type="button" value="Send Notification"/>
		    </span>
		    </li>
	    ))}
	</ul>
    );

    sendNotification = () => {
	console.log("Clicked")
    }
    
    
    render() {
	const { assesments, loading, editing } = this.state;
	const assesmentDisplayList = this.assesmentDisplayList(assesments);
	//if not editing display all
	if (editing === null) {
	    return (
		    <div>
		    <h1>Assesment</h1>
		    {loading && <div>Loading ...</div>}
		    <div>
		    {assesmentDisplayList}
		</div>
		    <hr />
		    </div>
	    );
	    // else display the editing form
	} else {
	    return(
		    <div>
		    <h1>{editing.title}</h1>
		    <AssesmentChangeForm assesment={editing} />
		    <input onClick={() => this.setState({editing: null})} type="button" value="Done"/>
		    </div>
	    )
	}
    }
}

export default withFirebase(AssesmentPage);
