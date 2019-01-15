import React from 'react';
import { BrowserRouter as Router,
	 Route,
       } from 'react-router-dom';

import Navigation from '../Navigation';
import LandingPage from '../Landing';
import UserPage from '../Users';
import ExercisePage from '../Exercises';
import AssesmentPage from '../Assesments';

import * as ROUTES from '../../constants/routes';

const App = () => (
	<Router>
	<div>
	<Navigation/>
	<Route exact path={ROUTES.LANDING} component={LandingPage} />
	<Route path={ROUTES.USERS} component={UserPage} />
	<Route path={ROUTES.EXERCISES} component={ExercisePage} />
	<Route path={ROUTES.ASSESMENTS} component={AssesmentPage} />
	</div>
	</Router>
);

export default App;
