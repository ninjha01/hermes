import React from 'react';
import { BrowserRouter as Router, Route } from 'react-router-dom';

import Navigation from '../Navigation';
import LandingPage from '../Landing';
import SignUpPage from '../SignUp';
import SignInPage from '../SignIn';
import PasswordForgetPage from '../PasswordForget';
import HomePage from '../Home';
import AccountPage from '../Account';

import ExercisePage from '../Exercises';
import UserPage from '../Users';
import AssignPage from '../Assign';
import AssesmentPage from '../Assesments';

import * as ROUTES from '../../constants/routes';
import { withAuthentication } from '../Session';

const App = () => (
	<Router>
	<div>
	<Navigation />

	<hr />

	<Route exact path={ROUTES.LANDING} component={LandingPage} />
	<Route exact path={ROUTES.SIGN_UP} component={SignUpPage} />
	<Route exact path={ROUTES.SIGN_IN} component={SignInPage} />
	<Route exact path={ROUTES.PASSWORD_FORGET} component={PasswordForgetPage} />
	<Route exact path={ROUTES.HOME} component={HomePage} />
	<Route exact path={ROUTES.ACCOUNT} component={AccountPage} />
	<Route exact path={ROUTES.EXERCISES} component={ExercisePage} />
	<Route exact path={ROUTES.USERS} component={UserPage} />
	<Route exact path={ROUTES.ASSIGN} component={AssignPage} />
	<Route exact path={ROUTES.ASSESMENTS} component={AssesmentPage} />
	</div>
	</Router>
);

export default withAuthentication(App);
