import React, { Component } from 'react';

import AssignExercisesPage from '../AssignExercises';
import AssignAssesmentsPage from '../AssignAssesments';

import { withFirebase } from '../Firebase';

class AssignPage extends Component {

    render() {
	return (
	    <div>
	    <AssignExercisesPage />
	    <br></br>
	    <AssignAssesmentsPage />
	    </div>	    
	)
    }
}

export default withFirebase(AssignPage);
